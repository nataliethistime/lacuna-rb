# encoding: utf-8

module Lacuna
    class Extras
        class Body < Lacuna::Module
            def self.find_highest_building(buildings, name)
                Array(self.find_buildings(buildings, name)).reverse.first
            end

            def self.find_building(buildings, name)
                Array(self.find_buildings(buildings, name)).first
            end

            def self.find_buildings(buildings, name)
                matches = buildings.select do |id, building|
                    # Save the id for later
                    buildings[id]['id'] = id
                    building['name'] == name
                end.values

                Array(matches).sort_by { |match| match['level'].to_i }
            end
        end
    end
end
