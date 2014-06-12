# encoding: utf-8

module Lacuna
    class Extras
        class Body < Lacuna::Module
            def self.find_building(buildings, name)
                match = self.find_buildings(buildings, name)

                unless match.nil?
                    match.first
                else
                    nil
                end
            end

            def self.find_buildings(buildings, name)
                matches = buildings.select do |id, building|
                    # Save the id for later
                    buildings[id]['id'] = id
                    building['name'] == name
                end.values

                if matches.size > 0
                    matches.sort_by { |match| match['level'].to_i }
                else
                    nil
                end
            end
        end
    end
end
