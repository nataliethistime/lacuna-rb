# encoding: utf-8

module Lacuna
    class Extras
        class Body < Lacuna::Module
            def self.find_building(buildings, name)
                building = buildings.select do |id, building|
                    # Save the id for later
                    buildings[id]['id'] = id
                    building['name'] == name
                end
                # Grab the first item in the hash.
                building = building[building.keys[0]]
                building
            end
        end
    end
end
