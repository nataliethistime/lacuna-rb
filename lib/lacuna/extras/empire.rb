# encoding: utf-8

module Lacuna
    class Extras
        class Empire < Lacuna::Module
            # TODO: make this a sorted by name list!
            def self.planets
                planets = Lacuna::Empire.get_status['empire']['planets']
                planets.select { |id, name| !name.match /^(S|Z)ASS/ }
            end
        end
    end
end
