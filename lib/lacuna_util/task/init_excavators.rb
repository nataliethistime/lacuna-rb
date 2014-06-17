# encoding: utf-8

require 'lacuna_util/task'

class InitExcavators < LacunaUtil::Task

    def args
    end

    def _run(args, config)
        # Delete old data
        LacunaUtil.db[:excavator_locations].delete

        Lacuna::Empire.planets.each do |id, name|
            puts "Looking for Excavators servicing #{name}"

            buildings = Lacuna::Body.get_buildings(id)['buildings']
            arch = Lacuna::Body.find_building(buildings, 'Archaeology Ministry')
            next if arch.nil?

            excavators = Lacuna::Archaeology.view_excavators(arch['id'])['excavators']

            LacunaUtil.db.transaction do
                excavators.each do |excavator|
                    LacunaUtil.db[:excavator_locations].insert({
                        :id        => excavator['body']['id'],
                        :name      => excavator['body']['name'],
                        :x         => excavator['body']['x'],
                        :y         => excavator['body']['y'],
                        # p22-7 => p22, a2-6 => a2, g5-8 => g5
                        :ore_type  => excavator['body']['image'].gsub(/\-\d+/, ''),
                    })
                end
            end
        end
    end
end

LacunaUtil.register_task InitExcavators
