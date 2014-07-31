# encoding: utf-8

require 'optparse'

require 'lacuna_util/task'
require 'lacuna_util/logger'

require 'terminal-table'

class UpgradeBuildings < LacunaUtil::Task

    def initialize
        Logger.debug 'test'
        super

        # The array of successful upgrades. Used to generate a pretty table at the end.
        @successful_upgrades = []
    end

    def args
        values = {
            :dry_run => false,
            :skip    => [],
            :max_time => 2 * 24 * 60 * 60, # 2 days
            :planet => nil,
        }

        OptionParser.new do |opts|

            opts.on("-d", "--dry_run", "Run, showing actions, but not changing anything.") do
                values[:dry_run] = true
            end

            opts.on("-s", "--skip PLANET", "Skip a planet.") do |name|
                values[:skip] << name.to_s
            end

            opts.on("-p", "--planet PLANET", "Upgrade buildings on one planet.") do |name|
                values[:planet] = name.to_s
            end

            opts.on("-m", "--max-time TIME", "Max build time (seconds).") do |time|
                values[:max_time] = time.to_i
            end

        end.parse!

        values
    end

    def _run(args, config)

        if @args[:planet].nil?
            Lacuna::Empire.planets.each do |id, name|
                self.upgrade_buildings_on_planet(id, name)
            end
        else
            planets = Lacuna::Empire.planets
            name = @args[:planet]
            id = planets.invert[name]
            self.upgrade_buildings_on_planet(id, name)
        end

        self.print_upgrades_table
    end

    def get_build_queue_time(buildings)
        times = []
        buildings.each do |id, building|
            unless building['pending_build'].nil?
                times << building['pending_build']['seconds_remaining'].to_i
            end
        end

        # The last item in the queue will include the times of all the other builds.
        times.sort.last || 0
    end

    def upgrade_buildings_on_planet(id, name)
        # Give the screen some space..
        print "\n\n"

        if @args[:skip].include? name
            Logger.log "Skipping #{name} according to command line option..."
            return
        end

        catch :planet do
            Logger.log "Looking on #{name} for buildings to upgrade."
            buildings = Lacuna::Body.get_buildings(id)['buildings']

            # Save total build queue time for later.
            queue_time = self.get_build_queue_time(buildings)

            UPGRADES.each do |upgrade|
                builds = Lacuna::Body.find_buildings(buildings, upgrade[:name])
                next if builds.nil?

                # find_buildings returns the buildings sorted. We want to
                # upgrade the lower levels first. So, reverse the list.
                builds = builds.reverse

                builds.each do |build|
                    next unless upgrade[:level] > build['level'].to_i
                    next unless build['pending_build'].nil?

                    # Make sure the queue isn't too full. Note: in dry-run,
                    # this check doesn't occur.
                    if queue_time >= args[:max_time] && !args[:dry_run]
                        Logger.log "Build queue full enough."
                        throw :planet
                    end

                    # Do the dirty work
                    to_level = build['level'].to_i + 1
                    Logger.log "Upgrading #{build['name']} to #{to_level}!"

                    if args[:dry_run]
                        @successful_upgrades << {
                            :level => to_level,
                            :planet => name,
                            :name => upgrade[:name],
                        }
                        next
                    end

                    begin
                        to_upgrade = Lacuna::Buildings.url2class(build['url'])
                        rv = to_upgrade.upgrade build['id']

                        # Time remaining includes the time for all builds before
                        # this one. (All of them).
                        queue_time = rv['building']['pending_build']['seconds_remaining'].to_i

                        @successful_upgrades << {
                            :level => to_level,
                            :planet => name,
                            :name => upgrade[:name],
                        }

                    rescue Lacuna::RPCException => e

                        if e.message =~ /There\'s no room left in the build queue\./i
                            # Move to the next planet.
                            Logger.error "No room left in the build queue here."
                            throw :planet
                        elsif e.message =~ /not enough \S+ in storage to build this\./i
                            # Try a different upgrade on this planet.
                            Logger.error "Cannot afford this upgrade."
                            next
                        elsif e.message =~ /\S+ is currently offline\.|you must repair this building/i
                            # damaged buildings
                            Logger.error "There are damaged buildings on #{name}"
                            throw :planet
                        else
                            raise Lacuna::TaskException, e.object
                        end
                    end
                end
            end
        end
    end

    def print_upgrades_table
        # Sort out all the data so it can be put into a table.
        @successful_upgrades.sort_by! { |obj| obj.values_at(:planet, :name, :level) }

        table = Terminal::Table.new

        if @args[:dry_run]
            table.title = 'Possible Upgrades (DRY RUN)'
        else
            table.title = 'Upgrades in Progress'
        end

        table.headings = %w(Planet Name Level)

        last_checked_name = (@successful_upgrades.first || {})[:planet]
        @successful_upgrades.each do |upgrade|
            if upgrade[:planet] != last_checked_name
                table.add_separator
                last_checked_name = upgrade[:planet]
            end

            table.add_row upgrade.values_at(:planet, :name, :level)
        end

        table.add_separator
        table.add_row ['TOTAL', '', @successful_upgrades.size]

        # Finally, draw the table to the terminal.
        Logger.log_raw table.to_s
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

        ###############
        ### Defense ###
        ###############

        {
            :name  => 'Shield Against Weapons',
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

        ################
        ### Ships!!! ###
        ################

        {
            :name  => 'Shipyard',
            :level => 30,
        },
        {
            :name  => 'Trade Ministry',
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
            :name  => 'Planetary Command Center',
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
            :name => 'Mission Command',
            :level => 30,
        },
        {
            :name => 'Entertainment District',
            :level => 30,
        },
        {
            :name  => 'Subspace Transporter',
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
            :name  => 'Development Ministry',
            :level => 30,
        },
        {
            :name  => 'Space Port',
            :level => 28,
        },
    ]
end

LacunaUtil.register_task UpgradeBuildings
