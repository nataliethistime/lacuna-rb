# encoding: utf-8

module Lacuna
    class Extras
        class Buildings < Lacuna::Module

            # Return the class for the provided building url.
            # Note: if we request /archaeology, Lacuna::Archaeology is already,
            #   however, I am too lazy to avoid this duplication. Due to the fact
            #   that when using this method, most likely all you want to do is
            #   upgrade or downgrade (which obviously doesn't need the Extras).
            def self.url2class(url)
                new_class = Class.new Lacuna::Module
                new_class.instance_variable_set('@module_name', url.split('/').last)
                new_class
            end

            def self.is_glyph?(url)
                url = url.split('/').last
                is = false
                self.glyphs.each do |glyph|
                    if glyph.downcase == url
                        is = true
                        break
                    end
                end
                is
            end

            def self.glyphs
                %W[
                    AlgaePond
                    AmalgusMeadow
                    BeeldebanNest
                    BlackHoleGenerator
                    CitadelOfKnope
                    CrashedShipSite
                    DentonBrambles
                    EssentiaVein
                    GeoThermalVent
                    GratchsGauntlet
                    GreatBallOfJunk
                    HallsOfVrbansk
                    InterDimensionalRift
                    JunkHengeSculpture
                    KalavianRuins
                    KasternsKeep
                    Lake
                    Lagoon
                    Lapis
                    LapisForest
                    LibraryOfJith
                    MalcudField
                    MassadsHenge
                    MetalJunkArches
                    NaturalSpring
                    OracleOfAnid
                    PantheonOfHagness
                    PyramidJunkSculpture
                    Ravine
                    RockyOutcrop
                    Sand
                    SpaceJunkPark
                    TempleOfTheDrajilites
                    TheDillonForge
                    Volcano
                ]
            end
            def self.types

                self.glyphs + %w[
                    Algae
                    Apple
                    AtmosphericEvaporator
                    Beach
                    Bean
                    Beeldeban
                    Bread
                    Burger
                    Capitol
                    Cheese
                    Chip
                    Cider
                    CloakingLab
                    Corn
                    CornMeal
                    Crater
                    Dairy
                    Denton
                    DeployedBleeder
                    Development
                    DistributionCenter
                    Embassy
                    EnergyReserve
                    Entertainment
                    Espionage
                    Fission
                    Fissure
                    FoodReserve
                    Fusion
                    GasGiantLab
                    GasGiantPlatform
                    GeneticsLab
                    Geo
                    Grove
                    Hydrocarbon
                    Intelligence
                    IntelTraining
                    LostCityOfTyleon
                    LuxuryHousing
                    Malcud
                    MayhemTraining
                    MercenariesGuild
                    Mine
                    MiningMinistry
                    MissionCommand
                    MunitionsLab
                    Network19
                    Observatory
                    OreRefinery
                    OreStorage
                    Oversight
                    Pancake
                    Park
                    Pie
                    PilotTraining
                    PlanetaryCommand
                    PoliticsTraining
                    Potato
                    Propulsion
                    SAW
                    Security
                    Shake
                    Shipyard
                    Singularity
                    Soup
                    SpacePort
                    SpaceStationLab
                    Stockpile
                    SubspaceSupplyDepot
                    SupplyPod
                    Syrup
                    TerraformingLab
                    TerraformingPlatform
                    TheftTraining
                    ThemePark
                    Trade
                    Transporter
                    University
                    WasteDigester
                    WasteEnergy
                    WasteExchanger
                    WasteRecycling
                    WasteSequestration
                    WasteTreatment
                    WaterProduction
                    WaterPurification
                    WaterReclamation
                    WaterStorage
                    Wheat
                ]
            end
        end
    end
end
