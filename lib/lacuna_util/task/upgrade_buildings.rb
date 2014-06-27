# encoding: utf-8

require 'optparse'

require 'lacuna_util/task'

class UpgradeBuildings < LacunaUtil::Task

    def args
        args = {
            :dry_run => false,
            :skip    => '',
            :max_time => 5 * 24 * 60 * 60, # 5 days
        }

        OptionParser.new do |opts|

            opts.on("-d", "--dry_run", "Run, showing actions, but not changing anything.") do
                args[:dry_run] = true
            end

            opts.on("-s", "--skip PLANET", "Skip one planet.") do |name|
                args[:skip] = name.to_s
            end

            opts.on("-m", "--max-time TIME", "Max build time (seconds).") do |time|
                args[:max_time] = time.to_i
            end

        end.parse!

        args
    end

    def _run(args, config)
        Lacuna::Empire.planets.each do |id, name|

            # Give the screen some space..
            print "\n\n"

            if name == args[:skip]
                puts "Skipping #{name} according to command line option..."
                next
            end

            catch :planet do
                puts "Looking on #{name} for buildings to upgrade."
                buildings = Lacuna::Body.get_buildings(id)['buildings']

                UPGRADES.each do |upgrade|
                    builds = Lacuna::Body.find_buildings(buildings, upgrade[:name])
                    next if builds.nil?

                    builds.each do |build|
                        if upgrade[:level] > build['level'].to_i &&
                            build['pending_build'].nil?
                            to_upgrade = Lacuna::Buildings.url2class(build['url'])

                            # Do the dirty work
                            to_level = build['level'].to_i + 1
                            puts "Upgrading #{build['name']} to #{to_level}!"
                            next if args[:dry_run]
                            rv = to_upgrade.upgrade build['id']

                            unless rv['building'].nil?
                                # I guess log down the  building upgrade???
                            else
                                # Handle the multiple errors here!
                                if rv['message'] =~ /no room left in the build queue/
                                    # Move to the next planet.
                                    throw :planet
                                else
                                    puts 'Unknown Error'
                                    p rv
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    UPGRADES = [

        #####################
        ### Essentials!!! ###
        #####################

        {
            :name  => 'Oversight Ministry',
            :level => 30,
        },
        {
            :name  => 'Archaeology Ministry',
            :level => 30,
        },
        {
            :name  => 'Development Ministry',
            :level => 30,
        },
        {
            :name  => 'Trade Ministry',
            :level => 30,
        },
        {
            :name  => 'Subspace Transporter',
            :level => 30,
        },
        {
            :name  => 'Planetary Command Center',
            :level => 30,
        },

        #########################
        ### Space Station Lab ###
        #########################

        {
            :name  => 'Space Station Lab (A)',
            :level => 20,
        },
        {
            :name  => 'Space Station Lab (B)',
            :level => 20,
        },
        {
            :name  => 'Space Station Lab (C)',
            :level => 20,
        },
        {
            :name  => 'Space Station Lab (D)',
            :level => 20,
        },

        #################
        ### Tyleon!!! ###
        #################

        {
            :name  => 'Lost City of Tyleon (A)',
            :level => 30,
        },
        {
            :name  => 'Lost City of Tyleon (B)',
            :level => 30,
        },
        {
            :name  => 'Lost City of Tyleon (C)',
            :level => 30,
        },
        {
            :name  => 'Lost City of Tyleon (D)',
            :level => 30,
        },
        {
            :name  => 'Lost City of Tyleon (E)',
            :level => 30,
        },
        {
            :name  => 'Lost City of Tyleon (F)',
            :level => 30,
        },
        {
            :name  => 'Lost City of Tyleon (G)',
            :level => 30,
        },
        {
            :name  => 'Lost City of Tyleon (H)',
            :level => 30,
        },
        {
            :name  => 'Lost City of Tyleon (I)',
            :level => 30,
        },

        ################
        ### Spies!!! ###
        ################

        {
            :name  => 'Intelligence Ministry',
            :level => 30,
        },
        {
            :name  => 'Security Ministry',
            :level => 30,
        },
        {
            :name  => 'Espionage Ministry',
            :level => 30,
        },
        {
            :name  => 'Intel Training',
            :level => 30,
        },
        {
            :name  => 'Mayhem Training',
            :level => 30,
        },
        {
            :name  => 'Politics Training',
            :level => 30,
        },
        {
            :name  => 'Theft Training',
            :level => 30,
        },

        ################
        ### Ships!!! ###
        ################

        {
            :name  => 'Shipyard',
            :level => 30,
        },
        {
            :name  => 'Propulsion System Factory',
            :level => 30,
        },
        {
            :name  => 'Cloaking Lab',
            :level => 30,
        },
        {
            :name  => 'Observatory',
            :level => 30,
        },
        {
            :name  => 'Terraforming Lab',
            :level => 30,
        },
        {
            :name  => 'Gas Giant Lab',
            :level => 30,
        },
        {
            :name  => 'Pilot Training Facility',
            :level => 30,
        },
        {
            :name  => 'Munitions Lab',
            :level => 30,
        },
        {
            :name  => 'Embassy',
            :level => 30,
        },
        {
            :name  => 'Waste Sequestration Well',
            :level => 30,
        },

        #######################
        ### All The Rest!!! ###
        #######################

        {
            :name  => 'Shield Against Weapons',
            :level => 30,
        },
        {
            :name => 'Mission Command',
            :level => 30,
        },
        {
            :name => 'Entertainment District',
            :level => 30,
        },
        { ## Not sure why I have one of these, but oh well, upgrade it!
            :name => 'Luxury Housing',
            :level => 30,
        },
        {
            :name  => 'Food Reserve',
            :level => 30,
        },
        {
            :name  => 'Ore Storage Tanks',
            :level => 30,
        },
        {
            :name  => 'Water Storage Tank',
            :level => 30,
        },
        {
            :name  => 'Energy Reserve',
            :level => 30,
        },
        {
            :name  => 'Space Port',
            :level => 28,
        },
    ]
end

LacunaUtil.register_task UpgradeBuildings
