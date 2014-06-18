# encoding: utf-8

require 'lacuna_util/task'

class InitStars < LacunaUtil::Task

    def args
    end

    STAR_ATTRS = LacunaUtil.db[:stars].columns.map  { |sym| sym.id2name }
    # Note there are some attributes in empire we need (See the table definition
    #   to fully understand this - it's just how the server returns the data).
    # Extra note: the image value is used to calculate the planet type.
    BODY_ATTRS = (LacunaUtil.db[:bodies].columns.map { |sym| sym.id2name }) +
        ['empire', 'image', 'station']

    def _run(args, config)

        status = Lacuna::Empire.get_status

        # TODO: this should be a command line option (eg --planet-name)
        #   but for now just use home planet.
        planet_id = status['empire']['home_planet_id']

        buildings = Lacuna::Body.get_buildings(planet_id)['buildings']
        oracle_hash = Lacuna::Body.find_building(buildings, 'Oracle of Anid')
        stars, bodies = self.get_stars_and_bodies oracle_hash['id']

        self.clear_old_data
        self.save_data(stars, bodies)

        puts "Saved #{stars.size} stars."
        puts "Saved #{bodies.size} bodies."
    end

    def get_stars_and_bodies(oracle_id)
        stars = []
        bodies = []
        seen = 0
        page = 1

        while true
            puts "Requesting page #{page}..."

            result = Lacuna::OracleOfAnid.get_probed_stars({
                :session_id  => Lacuna.session.id,
                :building_id => oracle_id,
                :page_number => page,
                :page_size   => 200, # Get the most per page to save RPC calls.
            })

            result['stars'].each do |star|
                seen += 1

                star['bodies'].each do |body|
                    body.delete_if { |key, val| !BODY_ATTRS.include? key }
                    bodies << body
                end

                # Do this after so we don't delete the bodies.
                star.delete_if { |key, val| !STAR_ATTRS.include? key }
                stars << star
            end

            # Check if this is the last page.
            if result['star_count'].to_i == seen
                break
            else
                page += 1
            end
        end

        [stars, bodies]
    end

    def clear_old_data
        LacunaUtil.db[:stars].delete
        LacunaUtil.db[:bodies].delete
    end

    def save_data(stars, bodies)
        LacunaUtil.db.transaction do
            stars_db = LacunaUtil.db[:stars]
            bodies_db = LacunaUtil.db[:bodies]

            stars.each do |star|
                stars_db.insert({
                    :id    => star['id'],
                    :name  => star['name'],
                    :color => star['color'],
                    :x     => star['x'],
                    :y     => star['y'],
                })
            end

            bodies.each do |body|
                to_insert = {
                    :id       => body['id'],
                    :name     => body['name'],
                    :x        => body['x'],
                    :y        => body['y'],
                    :size     => body['size'],
                    :orbit    => body['orbit'],
                    :type     => body['type'],
                    # p22-7 => p22, a2-6 => a2, g5-8 => g5.
                    :ore_type => body['image'].gsub(/\-\d+/, ''),
                }

                unless body['empire'].nil?
                    to_insert[:empire_id]        = body['empire']['id']
                    to_insert[:empire_name]      = body['empire']['name']
                    to_insert[:empire_alignment] = body['empire']['alignment']
                    to_insert[:occupied]         = true
                end

                unless body['station'].nil?
                    match = body['station']['name'] =~ /^(S|Z)ASS\s\S+/
                    to_insert[:enemy_seized] = match.nil?
                end

                bodies_db.insert to_insert
            end
        end
    end
end

LacunaUtil.register_task InitStars
