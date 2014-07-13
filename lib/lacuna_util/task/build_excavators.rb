# encoding: utf-8

require 'lacuna_util/task'
require 'lacuna_util/logger'

class BuildExcavators < LacunaUtil::Task

    # TODO: should this be a configuration file option?
    # Note: this number should not be more than 50 to avoid an issue with building
    #   more than 50 ships per request.
    TARGET = 20

    def args
    end

    def _run(args, config)

        Lacuna::Empire.planets.each do |id, name|
            Logger.log "Looking on #{name} to build Excavators."
            buildings = Lacuna::Body.get_buildings(id)['buildings']
            sp = Lacuna::Body.find_building(buildings, 'Space Port')
            next if sp.nil?

            ships = Lacuna::SpacePort.view_all_ships(sp['id'], { :no_paging => 1 })['ships']
            count = (ships.select { |ship| ship['type'] =~ /excavator/ }).size

            if count >= TARGET
                # Skip if there's enough.
                Logger.log "Already #{count} built!"
                next
            end

            build_count = TARGET - count
            Logger.log "Found #{count} Excavators."
            self.build_excavators(buildings, build_count)
        end
    end

    def build_excavators(buildings, num_to_build)
        sy = Lacuna::Body.find_highest_building(buildings, 'Shipyard')
        buildable = Lacuna::Shipyard.get_buildable(sy['id'])

        # Ensure that this planet can build an Excavator. (Requires L11 Archeology)
        if buildable['buildable']['excavator']['can'].to_i == 0
            Logger.log buildable['buildable']['excavator']['reason'][1]
            return
        end

        # Make sure the shipyard has enough slots to build the number of Excavators
        # desired. This includes Ships currently in the build queue.
        able = buildable['build_queue_max'].to_i - buildable['build_queue_used'].to_i
        num_to_build = able if num_to_build > able

        # Make sure there's enough docks on the planet to hold all the Excavators
        # that need to be built.
        num_to_build = buildable['docks_available'] if num_to_build > buildable['docks_available']

        unless num_to_build > 0
            Logger.log "Not enough Shipyard or Space Port slots to build Excavators!"
            return
        end

        # And now, let's do the deed.
        Logger.log "Building #{num_to_build} Excavators..."
        Lacuna::Shipyard.build_ship(sy['id'], 'excavator', num_to_build)
    end
end

LacunaUtil.register_task BuildExcavators
