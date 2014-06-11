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

            # The list of all the buildings this client can interact with.
            def self.types
                %w[
                    Algae
                    AlgaePond
                    AmalgusMeadow
                    Apple
                    AtmosphericEvaporator
                    Beach
                    Bean
                    Beeldeban
                    BeeldebanNest
                    BlackHoleGenerator
                    Bread
                    Burger
                    Capitol
                    Cheese
                    Chip
                    Cider
                    CitadelOfKnope
                    CloakingLab
                    Corn
                    CornMeal
                    CrashedShipSite
                    Crater
                    Dairy
                    Denton
                    DentonBrambles
                    DeployedBleeder
                    Development
                    DistributionCenter
                    Embassy
                    EnergyReserve
                    Entertainment
                    Espionage
                    EssentiaVein
                    Fission
                    Fissure
                    FoodReserve
                    Fusion
                    GasGiantLab
                    GasGiantPlatform
                    GeneticsLab
                    Geo
                    GeoThermalVent
                    GratchsGauntlet
                    GreatBallOfJunk
                    Grove
                    HallsOfVrbansk
                    Hydrocarbon
                    Intelligence
                    IntelTraining
                    InterDimensionalRift
                    JunkHengeSculpture
                    KalavianRuins
                    KasternsKeep
                    Lake
                    Lagoon
                    Lapis
                    LapisForest
                    LibraryOfJith
                    LostCityOfTyleon
                    LuxuryHousing
                    Malcud
                    MalcudField
                    MassadsHenge
                    MayhemTraining
                    MercenariesGuild
                    MetalJunkArches
                    Mine
                    MiningMinistry
                    MissionCommand
                    MunitionsLab
                    NaturalSpring
                    Network19
                    Observatory
                    OracleOfAnid
                    OreRefinery
                    OreStorage
                    Oversight
                    Pancake
                    PantheonOfHagness
                    Park
                    Pie
                    PilotTraining
                    PlanetaryCommand
                    PoliticsTraining
                    Potato
                    Propulsion
                    PyramidJunkSculpture
                    Ravine
                    RockyOutcrop
                    Sand
                    SAW
                    Security
                    Shake
                    Shipyard
                    Singularity
                    Soup
                    SpaceJunkPark
                    SpacePort
                    SpaceStationLab
                    Stockpile
                    SubspaceSupplyDepot
                    SupplyPod
                    Syrup
                    TempleOfTheDrajilites
                    TerraformingLab
                    TerraformingPlatform
                    TheDillonForge
                    TheftTraining
                    ThemePark
                    Trade
                    Transporter
                    University
                    Volcano
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
