# encoding: utf-8

module Lacuna
    class Extras
        class Archaeology < Lacuna::Module
            def self.get_inventory(id)
                glyphs = Lacuna::Archaeology.get_glyph_summary(id)['glyphs']
                inventory = {}
                glyphs.each do |glyph|
                    inventory[glyph['name']] = glyph['quantity'].to_i
                end
                inventory
            end
        end
    end
end
