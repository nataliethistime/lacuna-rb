# encoding: utf-8

module Lacuna
    class Extras
        class Empire < Lacuna::Module
            def self.planets
                planets = Lacuna::Empire.get_status['status']['planets']
                planets.select { |planet| !planet.match /^(S|Z)ASS/ }
            end
        end
    end
end
