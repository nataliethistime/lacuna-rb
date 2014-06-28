# encoding: utf-8

require 'lacuna_util/task'
require 'lacuna_util/logger'

class MakeHalls < LacunaUtil::Task
    # Array of the 4 recipes used to make Halls of Vrbansk
    RECIPES = [
        %w( goethite halite     gypsum       trona     ),
        %w( gold     anthracite uraninite    bauxite   ),
        %w( kerogen  methane    sulfur       zircon    ),
        %w( monazite fluorite   beryl        magnetite ),
        %w( rutile   chromite   chalcopyrite galena    ),
    ]

    def args

    end

    def _run(args, config)
        total = 0

        Lacuna::Empire.planets.each do |id, name|
            Logger.log "Checking on #{name}"
            buildings = Lacuna::Body.get_buildings(id)['buildings']
            archaeology = Lacuna::Body.find_building(buildings, 'Archaeology Ministry')
            next if archaeology.nil?
            inventory = Lacuna::Archaeology.get_inventory(archaeology['id'])

            made = 0

            RECIPES.each do |recipe|
                numbers = recipe.collect { |item| inventory[item] || 0 }
                number = numbers.sort.first
                list = recipe.map { |item| item.capitalize }.join ', '

                next if number ==  0

                Logger.log "Making #{number} halls with #{list}"

                # Note: there is a limit of 5000 plans made per request.
                #   I'll fix this 'issue' when it actually becomes one. :)
                #   For the moment just run the script as many times as you
                #   need to make all the halls.
                rs = Lacuna::Archaeology.assemble_glyphs(archaeology['id'], recipe, number)
                made += rs['quantity']
            end

            if made > 0
                Logger.log "Made #{made} Halls on #{name}"
                total += made
            end
        end

        if total > 0
            Logger.log "Finished making #{total} Halls of Vrbansk"
        end
    end
end

LacunaUtil.register_task MakeHalls
