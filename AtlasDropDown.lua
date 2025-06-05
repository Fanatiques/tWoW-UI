--[[

	Atlas, a World of Warcraft instance map browser
	Email me at m4r3lk4@gmail.com

	This file is part of Atlas.

	Atlas is free software; you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation; either version 2 of the License, or
	(at your option) any later version.

	Atlas is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with Atlas; if not, write to the Free Software
	Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA

--]]
local GREN = "|cff66cc33"

Atlas_DropDownLayouts_Order = {
	[1] = ATLAS_DDL_CONTINENT,
	[2] = ATLAS_DDL_PARTYSIZE,
	[3] = ATLAS_DDL_TYPE,
	[ATLAS_DDL_CONTINENT] = {
		[1] = ATLAS_DDL_CONTINENT_EASTERN,
		[2] = ATLAS_DDL_CONTINENT_KALIMDOR,
		[3] = ATLAS_DDL_WORLDBOSSES,
		[4] = GREN .. ATLAS_DDL_TYPE_ENTRANCE,
		[5] = GREN .. ATLAS_DDL_BGS,
		[6] = GREN .. ATLAS_DDL_DUNGEON_LOCATIONS,
		[7] = GREN .. ATLAS_DDL_FLIGHT_PATHS,
		[8] = ATLAS_DDL_TRANSPORT_ROUTES,
	},
	[ATLAS_DDL_PARTYSIZE] = {
		[1] = ATLAS_DDL_PARTYSIZE_5,
		[2] = ATLAS_DDL_PARTYSIZE_10,
		[3] = ATLAS_DDL_PARTYSIZE_20,
		[4] = ATLAS_DDL_PARTYSIZE_40,
		[5] = ATLAS_DDL_WORLDBOSSES,
		[6] = GREN .. ATLAS_DDL_TYPE_ENTRANCE,
		[7] = GREN .. ATLAS_DDL_BGS,
		[8] = GREN .. ATLAS_DDL_DUNGEON_LOCATIONS,
		[9] = GREN .. ATLAS_DDL_FLIGHT_PATHS,
		[10] = ATLAS_DDL_TRANSPORT_ROUTES,
	},
	[ATLAS_DDL_TYPE] = {
		[1] = ATLAS_DDL_TYPE_DUNGEONS,
		[2] = ATLAS_DDL_TYPE_RAIDS,
		[3] = ATLAS_DDL_WORLDBOSSES,
		[4] = GREN .. ATLAS_DDL_TYPE_ENTRANCE,
		[5] = GREN .. ATLAS_DDL_BGS,
		[6] = GREN .. ATLAS_DDL_DUNGEON_LOCATIONS,
		[7] = GREN .. ATLAS_DDL_FLIGHT_PATHS,
		[8] = ATLAS_DDL_TRANSPORT_ROUTES,
	},
	[ATLAS_DDL_ALL] = {
		[1] = ATLAS_DDL_ALL_MENU,
		[2] = ATLAS_DDL_WORLDBOSSES,
		[3] = GREN .. ATLAS_DDL_TYPE_ENTRANCE,
		[4] = GREN .. ATLAS_DDL_BGS,
		[5] = GREN .. ATLAS_DDL_DUNGEON_LOCATIONS,
		[6] = GREN .. ATLAS_DDL_FLIGHT_PATHS,
	},
};

Atlas_DropDownLayouts = {
	[ATLAS_DDL_CONTINENT] = {
		[ATLAS_DDL_CONTINENT_EASTERN] = {
			"BlackrockDepths",
			"BlackrockSpireLower",
			"BlackrockSpireUpper",
			"BlackwingLair",
			"Gnomeregan",
			"GilneasCity", -- TurtleWOW 1.17.0
			"HateforgeQuarry", -- TurtleWOW
			"KarazhanCrypt", -- TurtleWOW
			"LowerKara", -- -- TurtleWOW 1.17.0
            "UpperKara",
			"MoltenCore",
			"Naxxramas",
			"Scholomance",
			"ShadowfangKeep",
			"SMArmory",
			"SMCathedral",
			"SMGraveyard",
			"SMLibrary",
			"Stratholme",
			"StormwindVault", -- TurtleWOW
			"TheDeadmines",
			"TheStockade",
			"TheSunkenTemple",
			"Uldaman",
			"ZulGurub",
		},
		[ATLAS_DDL_CONTINENT_KALIMDOR] = {
			"BlackfathomDeeps",
			"CavernsOfTimeBlackMorass", -- TurtleWOW
			"TheCrescentGrove", -- TurtleWOW
			"DireMaulEast",
			"DireMaulNorth",
			"DireMaulWest",
			"EmeraldSanctum", -- TurtleWOW 1.17.0
			"Maraudon",
			"OnyxiasLair",
			"RagefireChasm",
			"RazorfenDowns",
			"RazorfenKraul",
			"TheRuinsofAhnQiraj",
			"TheTempleofAhnQiraj",
			"WailingCaverns",
			"ZulFarrak",
		},
		[ATLAS_DDL_WORLDBOSSES] = {
			"Azuregos",
			"FourDragons",
			"LordKazzak",
			"Nerubian",
			"Reaver",
			"Ostarius",
			"Concavius",
			"CowKing",
			"Clackora"
		},
		[GREN .. ATLAS_DDL_TYPE_ENTRANCE] = {
			"BlackfathomDeepsEnt",
			"BlackrockMountainEnt",
			"DireMaulEnt",
			"GnomereganEnt",
			"MaraudonEnt",
			"SMEnt",
			"TheDeadminesEnt",
			"TheSunkenTempleEnt",
			"UldamanEnt",
			"WailingCavernsEnt",
		},
		[GREN .. ATLAS_DDL_BGS] = {
			"AlteracValleyNorth",
			"AlteracValleySouth",
			"ArathiBasin",
			"WarsongGulch",
		},
		[GREN .. ATLAS_DDL_DUNGEON_LOCATIONS] = {
			"DLEast",
			"DLWest",
		},
		[GREN .. ATLAS_DDL_FLIGHT_PATHS] = {
			"FPAllianceEast",
			"FPAllianceWest",
			"FPHordeEast",
			"FPHordeWest",
		},
		[ATLAS_DDL_TRANSPORT_ROUTES] = {
			"TransportRoutes"
		},
	},
	[ATLAS_DDL_PARTYSIZE] = {
		[ATLAS_DDL_PARTYSIZE_5] = {
			"CavernsOfTimeBlackMorass", -- TurtleWOW
			"BlackrockDepths",
			"TheCrescentGrove", --TurtleWOW
			"DireMaulEast",
			"DireMaulEnt",
			"DireMaulNorth",
			"DireMaulWest",
			"GilneasCity", -- TurtleWOW 1.17.0
			"HateforgeQuarry", -- TurtleWOW
			"Scholomance",
			"Stratholme",
			"BlackrockSpireLower",
			"Gnomeregan",
			"KarazhanCrypt", -- TurtleWOW
			"Maraudon",
			"TheDeadmines",
			"RagefireChasm",
			"RazorfenDowns",
			"RazorfenKraul",
			"ShadowfangKeep",
			"SMArmory",
			"SMCathedral",
			"SMGraveyard",
			"SMLibrary",
			"StormwindVault", --TurtleWOW
			"TheStockade",
			"TheSunkenTemple",
			"Uldaman",
			"WailingCaverns",
			"ZulFarrak",
		},
		[ATLAS_DDL_PARTYSIZE_10] = {
			"BlackrockSpireLower",
			"BlackrockSpireUpper",
			"LowerKara", -- -- TurtleWOW 1.17.0
		},
		[ATLAS_DDL_PARTYSIZE_20] = {
			"TheRuinsofAhnQiraj",
			"ZulGurub",
		},
		[ATLAS_DDL_PARTYSIZE_40] = {
			"BlackwingLair",
			"EmeraldSanctum", -- TurtleWOW 1.17.0
			"MoltenCore",
			"Naxxramas",
			"OnyxiasLair",
			"TheTempleofAhnQiraj",
            "UpperKara",
		},
		[ATLAS_DDL_WORLDBOSSES] = {
			"Azuregos",
			"FourDragons",
			"LordKazzak",
			"Nerubian",
			"Reaver",
			"Ostarius",
			"Concavius",
			"CowKing",
			"Clackora"
		},
		[GREN .. ATLAS_DDL_TYPE_ENTRANCE] = {
			"BlackfathomDeepsEnt",
			"BlackrockMountainEnt",
			"DireMaulEnt",
			"GnomereganEnt",
			"MaraudonEnt",
			"SMEnt",
			"TheDeadminesEnt",
			"TheSunkenTempleEnt",
			"UldamanEnt",
			"WailingCavernsEnt",
		},
		[GREN .. ATLAS_DDL_BGS] = {
			"AlteracValleyNorth",
			"AlteracValleySouth",
			"ArathiBasin",
			"WarsongGulch",
		},
		[GREN .. ATLAS_DDL_DUNGEON_LOCATIONS] = {
			"DLEast",
			"DLWest",
		},
		[GREN .. ATLAS_DDL_FLIGHT_PATHS] = {
			"FPAllianceEast",
			"FPAllianceWest",
			"FPHordeEast",
			"FPHordeWest",
		},
		[ATLAS_DDL_TRANSPORT_ROUTES] = {
			"TransportRoutes"
		},
	},
	[ATLAS_DDL_TYPE] = {
		[ATLAS_DDL_TYPE_DUNGEONS] = {
			"BlackfathomDeeps",
			"CavernsOfTimeBlackMorass", -- TurtleWOW
			"BlackrockDepths",
			"BlackrockSpireLower",
			"BlackrockSpireUpper",
			"TheCrescentGrove", -- TurtleWOW
			"DireMaulEast",
			"DireMaulNorth",
			"DireMaulWest",
			"Gnomeregan",
			"GilneasCity", -- TurtleWOW 1.17.0
			"HateforgeQuarry", -- TurtleWOW
			"KarazhanCrypt", -- TurtleWOW
			"Maraudon",
			"TheDeadmines",
			"RagefireChasm",
			"RazorfenDowns",
			"RazorfenKraul",
			"Scholomance",
			"ShadowfangKeep",
			"SMArmory",
			"SMCathedral",
			"SMGraveyard",
			"SMLibrary",
			"StormwindVault", --TurtleWOW
			"Stratholme",
			"TheStockade",
			"TheSunkenTemple",
			"Uldaman",
			"WailingCaverns",
			"ZulFarrak",
		},
		[ATLAS_DDL_TYPE_RAIDS] = {
			"BlackwingLair",
			"EmeraldSanctum", -- TurtleWOW 1.17.0
			"LowerKara", -- -- TurtleWOW 1.17.0
            "UpperKara",
			"MoltenCore",
			"Naxxramas",
			"OnyxiasLair",
			"TheRuinsofAhnQiraj",
			"TheTempleofAhnQiraj",
			"ZulGurub",
		},
		[ATLAS_DDL_WORLDBOSSES] = {
			"Azuregos",
			"FourDragons",
			"LordKazzak",
			"Nerubian",
			"Reaver",
			"Ostarius",
			"Concavius",
			"CowKing",
			"Clackora"
		},
		[GREN .. ATLAS_DDL_TYPE_ENTRANCE] = {
			"BlackfathomDeepsEnt",
			"BlackrockMountainEnt",
			"DireMaulEnt",
			"GnomereganEnt",
			"MaraudonEnt",
			"SMEnt",
			"TheDeadminesEnt",
			"TheSunkenTempleEnt",
			"UldamanEnt",
			"WailingCavernsEnt",
		},
		[GREN .. ATLAS_DDL_BGS] = {
			"AlteracValleyNorth",
			"AlteracValleySouth",
			"ArathiBasin",
			"WarsongGulch",
		},
		[GREN .. ATLAS_DDL_DUNGEON_LOCATIONS] = {
			"DLEast",
			"DLWest",
		},
		[GREN .. ATLAS_DDL_FLIGHT_PATHS] = {
			"FPAllianceEast",
			"FPAllianceWest",
			"FPHordeEast",
			"FPHordeWest",
		},
		[ATLAS_DDL_TRANSPORT_ROUTES] = {
			"TransportRoutes"
		},
	},
};
