# encoding: utf-8

require 'lacuna_util/task'
require 'lacuna_util/logger'

class RepairPlanet < LacunaUtil::Task

    def args
        args = {
            :planet => '',
        }

        OptionParser.new do |opts|
            opts.on("-p", "--planet PLANET", "Planet to repair buildings on.") do |name|
                args[:planet] = name
            end
        end.parse!

        args
    end

    def _run(args, config)
        if args[:planet] == ''
            Logger.log "No planet specified."
            return
        end

        Lacuna::Empire.planets.each do |id, name|
            next unless name == args[:planet]
            Logger.log "Repairing buildings on #{args[:planet]}"

            to_repair = []

            buildings = Lacuna::Body.get_buildings(id)['buildings']
            buildings.each do |id, building|
                unless building['efficiency'].to_i == 100
                    to_repair << id
                end
            end

            if to_repair.size > 0
                repaired = Lacuna::Body.repair_list(id, to_repair)['buildings']
                Logger.log "Done. Refresh planet in-game to see results."
            else
                Logger.log "No damaged buildings!"
            end
        end
    end
end

LacunaUtil.register_task RepairPlanet
