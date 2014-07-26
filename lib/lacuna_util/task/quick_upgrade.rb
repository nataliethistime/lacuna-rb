# encoding: utf-8

require 'lacuna_util/task'
require 'lacuna_util/logger'


class QuickUpgrade < LacunaUtil::Task

    def args
        values = {
            :dry_run => false,
            :planet => nil,
            :wait => 0,
        }

        OptionParser.new do |opts|

            opts.on("-d", "--dry_run", "Run, showing actions, but not changing anything.") do
                values[:dry_run] = true
            end

            opts.on("-p", "--planet PLANET", "Planet to upgrade buildings on.") do |name|
                values[:planet] = name.to_s
            end

            opts.on("-w", "--wait TIME", "Time to wait between runs.") do |time|
                values[:wait] = time.to_i
            end

        end.parse!

        values
    end

    def _run(args, config)

        if @args[:planet].nil?
            Logger.error 'Please specify planet'
            return
        else
            # Let the fun begin.
            planets = Lacuna::Empire.planets
            name = @args[:planet]
            id = planets.invert[name]

            while true
                Logger.log "Upgrading buildings on #{name}"
                buildings = Lacuna::Body.get_buildings(id)['buildings']
                self.do_upgrading buildings

                if @args[:wait] == 0
                    Logger.log 'Finished single run'
                    break
                else
                    time = @args[:wait]
                    print "\n"
                    puts "Sleeping #{time} seconds before running again."
                    sleep time
                    print "\n\n"
                end
            end
        end
    end

    def do_upgrading(buildings)

        # Get an array of buildings we can sort and mess with
        buildings = self.process_buildings buildings

        buildings.each do |building|
            # self.upgrade returns false to break out of the loop.
            break if self.upgrade(building) == false
        end
    end

    def process_buildings(buildings)
        arr = []

        # Make into an array and add the id in the right place.
        buildings.each do |id, attributes|
            attributes['id'] = id
            arr << attributes
        end

        arr.sort_by { |building| building['level'].to_i }
    end

    def upgrade(building)
        level = building['level'].to_i
        up_level = level + 1

        return if level == 30 # max level
        return if building['url'] == '/spaceport' && level == 28 # too much energy
        return if level == 0 || !building['pending_build'].nil? # under construction
        return if Lacuna::Buildings.is_glyph? building['url']

        # platforms
        return if building['url'] == '/gasgiantplatform'
        return if building['url'] == '/terraformingplatform'

        Logger.log "Upgrading #{building['name']} to level #{up_level}."
        to_do = Lacuna::Buildings.url2class(building['url'])

        # Now we just do the upgrade and hope...
        begin
            to_do.upgrade building['id']
        rescue Lacuna::RPCException => e
            if e.message =~ /There\'s no room left in the build queue\./i
                # Move to the next planet.
                Logger.error "No room left in the build queue here."
                return false
            end
        end
    end
end

LacunaUtil.register_task QuickUpgrade
