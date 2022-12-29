local capabilities = require("command.capabilities")

local airframe_f14b = {
    stores = "F-14/B",
    capabilities = {
        [capabilities.CAP] = 100,
        [capabilities.GCI] = 100,
        [capabilities.AirPatrol] = 100,
        [capabilities.CAS] = 70
    },
    loadouts = {
        [capabilities.CAP] = "F-14/B CAP",
        [capabilities.AirPatrol] = "F-14/B CAP",
    }
}

local airframe_f18c = {
    stores = "F/A-18C",
    capabilities = {
        [capabilities.CAP] = 70,
        [capabilities.AirPatrol] = 60,
        [capabilities.CAS] = 75,
        [capabilities.SEAD] = 80,
        [capabilities.Strike] = 70
    },
    loadouts = {
        [capabilities.CAP] = "F/A-18C CAP",
        [capabilities.AirPatrol] = "F/A-18C CAP",
    }
}

local airframe_f4 = {
    stores = "F-4E",
    capabilities = {
        [capabilities.CAP] = 75,
        [capabilities.GCI] = 90,
        [capabilities.AirPatrol] = 70,
        [capabilities.SEAD] = 75,
        [capabilities.Strike] = 80
    },
    loadouts = {
        [capabilities.CAP] = "F-4E CAP",
        [capabilities.AirPatrol] = "F-4E CAP",
    }
}

local airframe_f15c = {
    stores = "F-15C",
    capabilities = {
        [capabilities.CAP] = 75,
        [capabilities.GCI] = 90,
        [capabilities.AirPatrol] = 70,
        [capabilities.SEAD] = 75,
        [capabilities.Strike] = 80
    },
    loadouts = {
        [capabilities.CAP] = "F-15C CAP",
        [capabilities.AirPatrol] = "F-15C CAP",
    }
}

local airframe_e2 = {
    stores = "E-2D",
    capabilities = {
        [capabilities.AWACS] = 90
    },
    loadouts = {
        [capabilities.AWACS] = "E-2D AWACS"
    }
}

local airframe_e3 = {
    stores = "E-3A",
    capabilities = {
        [capabilities.AWACS] = 100,
        [capabilities.HAAWACS] = 100
    },
    loadouts = {
        [capabilities.AWACS] = "E-3A AWACS"
    }
}

return {
    callsigns = {
        "Victory",
        "Sting",
        "Bullet",
        "Ripper",
        "Camelot",
        "Beef",
        "Fist",
        "Mace",
        "Felix",
        "Gypsy",
        "Joker",
        "Inferno",
        "Lion",
        "Checkmate",
        "Chippy",
        "Dragon",
        "Knight",
        "Ugly",
        "Diamond",
        "Taproom",
        "Falcon",
        "Gunstar",
        "Wildcat",
        "Judge",
        "Jury",
        "Fury",
        "Vulture",
        "Raven",
        "Hawk",
        "Canyon",
        "Bell",
        "Colt",
        "Pontiac",
        "Ford",
        "Enfield",
        "Talon",
        "Wyvern",
        "Sword",
        "Spear",
        "Corsair",
        "Phantom",
        "Skypole",
        "Empire",
        "Kittyhawk"
    },
    navy = {
        wings = {
             {
                squadrons = {
                    {
                        airframe = airframe_f18c,
                        count = 8,
                        livery = "VFA-113"
                    },
                    {
                        airframe = airframe_f18c,
                        count = 8,
                        livery = "VFA-37"
                    },
                    {
                        airframe = airframe_f14b,
                        count = 12,
                        livery = "VF-103 Jolly Rogers Hi Viz"
                    },
                }
            }
        }
    },
    airforce = {
        wings = {
            {
                squadrons = {
                    {
                        airframe = airframe_f4,
                        count= 12,
                    },
                    {
                        airframe = airframe_f15c,
                        count= 16,
                        livery = "12th Fighter SQN (AK)"
                    }
                }
            }
        }
    }
}