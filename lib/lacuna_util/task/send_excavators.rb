# encoding: utf-8

require 'optparse'

require 'lacuna_util/task'

class SendExcavators < LacunaUtil::Task

    def args
        args = {
            :dry_run => false,
        }
        OptionParser.new do |opts|
            opts.on("-d", "--dry_run", "Run, showing actions, but not changing anything.") do
                args[:dry_run] = true
            end
        end.parse!
        args
    end

    def _run(args, config)
        # Get a list of body ids and subtract from that the ids that are excavated.
        to_excavate = {}
        viable_bodies = LacunaUtil.db[:bodies].where({
            :ore_type     => 'p35',
            :occupied     => false,
            :enemy_seized => false,
        })
        viable_bodies.each do |body|
            to_excavate[body[:id]] = body
        end

        # Remove all the bodies that we know for certain already have an Excavator
        # assigned to.
        LacunaUtil.db[:excavator_locations].all.each do |excav|
            to_excavate.reject! { |key| key == excav[:id] }
        end

        Lacuna::Empire.planets.each do |id, name|
            puts "Looking on #{name} to send Excavators"
            buildings = Lacuna::Body.get_buildings(id)['buildings']
            arch = Lacuna::Body.find_building(buildings, 'Archaeology Ministry')
            next unless arch['level'].to_i >= 11

            # Determine the number of excavators that need to be sent from this
            # Archaeology Ministry.
            excavators = Lacuna::Archaeology.view_excavators(arch['id'])
            foo = excavators['travelling'].to_i + excavators['excavators'].size
            to_send = excavators['max_excavators'].to_i - foo
            next unless to_send > 0
            puts "Attempting to send #{to_send} Excavators..."

            to_send.times do
                x = excavators['status']['body']['x'].to_i
                y = excavators['status']['body']['y'].to_i
                target = self.find_closest(to_excavate.values, x, y)

                if target.nil?
                    puts "No more valid bodies to send Excavators to!"

                    # Note: should this be an exit?
                    break
                end

                # So the next trick here is to see if we can send an excavator
                # to the body and get a ship id out of the same deal.
                ships = Lacuna::SpacePort.get_ships_for(id, {
                    :body_id => target[:id],
                })

                available = ships['available']
                available.select! { |ship| ship['type'] =~ /excavator/ }
                available.sort_by! { |ship| ship['speed'].to_i }
                ship = available.first

                if ship.nil?
                    # Attempt to find a reason, if there isn't one, there isn't
                    # an Excavator. If there is one, show that.
                    unavailable = ships['unavailable']
                    unavailable.select! do |ship|
                        ship['ship']['type'] =~ /excavator/
                    end
                    ship = unavailable.first

                    if ship.nil?
                        puts "No Excavators to send!"
                    else
                        reason = ship['reason'][1]
                        # if reason =~ /in the jurisdiction of the space station/
                        #     puts "#{target[:name]} is seized!"
                        #     return
                        if reason
                            puts "Unknown Excavator error!"
                            puts reason
                        end
                    end

                    # How should this be handled? Next ship or next planet?
                    return
                end

                puts "Sending Excavator to #{target[:name]}"
                unless args[:dry_run]
                    rv = Lacuna::SpacePort.send_ship(ship['id'], {
                        :body_id => target[:id]
                    })
                end

                # Remove this target from to_excavate list so it doesn't we don't
                # recursively attempt to send Excavators to it.
                to_excavate.reject! { |key| key == target[:id] }
            end
        end
    end

    # Find the closest body to coordinates x and y in the given list of bodies.
    def find_closest(bodies, x, y)
        bodies.map! do |body|
            body[:distance] = self.distance(x, y, body[:x], body[:y])
            body
        end
        bodies.sort_by { |body| body[:distance] }.first
    end

    def distance(x1, y1, x2, y2)
        # Indented for clarity. :)
        Math.sqrt(
            ( (x2 - x1) ** 2 ) + ( (y2 - y1) ** 2 )
        )
    end
end

LacunaUtil.register_task SendExcavators
