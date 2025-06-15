
SOTA_CONFIG_UseGuildNotes = 0
SOTA_CONFIG_MinimumBidStrategy = 1
SOTA_CONFIG_DKPStringLength = 5
SOTA_CONFIG_MinimumDKPPenalty = 50
SOTA_CONFIG_BossDKP = {
	[1] = {
		[1] = "20Mans",
		[2] = 400,
	},
	[2] = {
		[1] = "MoltenCore",
		[2] = 600,
	},
	[3] = {
		[1] = "Onyxia",
		[2] = 400,
	},
	[4] = {
		[1] = "BlackwingLair",
		[2] = 400,
	},
	[5] = {
		[1] = "AQ40",
		[2] = 400,
	},
	[6] = {
		[1] = "Naxxramas",
		[2] = 400,
	},
	[7] = {
		[1] = "WorldBosses",
		[2] = 400,
	},
}
SOTA_CONFIG_AuctionTime = 25
SOTA_CONFIG_AuctionExtension = 8
SOTA_CONFIG_EnableOSBidding = 1
SOTA_CONFIG_EnableZoneCheck = 1
SOTA_CONFIG_EnableOnlineCheck = 1
SOTA_CONFIG_DisableDashboard = 0
SOTA_HISTORY_DKP = {
}
SOTA_CONFIG_Messages = {
	[1] = {
		[1] = "OnAuctionOpened",
		[2] = 1,
		[3] = "Auction open for $i",
	},
	[2] = {
		[1] = "OnAnnounceBid",
		[2] = 2,
		[3] = "/w $s bid <your bid>",
	},
	[3] = {
		[1] = "OnAnnounceMinBid",
		[2] = 2,
		[3] = "Minimum bid: $m DKP",
	},
	[4] = {
		[1] = "On10SecondsLeft",
		[2] = 2,
		[3] = "10 seconds left for $i",
	},
	[5] = {
		[1] = "On9SecondsLeft",
		[2] = 2,
		[3] = "9 seconds left",
	},
	[6] = {
		[1] = "On8SecondsLeft",
		[2] = 0,
		[3] = "8 seconds left",
	},
	[7] = {
		[1] = "On7SecondsLeft",
		[2] = 0,
		[3] = "7 seconds left",
	},
	[8] = {
		[1] = "On6SecondsLeft",
		[2] = 0,
		[3] = "6 seconds left",
	},
	[9] = {
		[1] = "On5SecondsLeft",
		[2] = 0,
		[3] = "5 seconds left",
	},
	[10] = {
		[1] = "On4SecondsLeft",
		[2] = 0,
		[3] = "4 seconds left",
	},
	[11] = {
		[1] = "On3SecondsLeft",
		[2] = 2,
		[3] = "3 seconds left",
	},
	[12] = {
		[1] = "On2SecondsLeft",
		[2] = 2,
		[3] = "2 seconds left",
	},
	[13] = {
		[1] = "On1SecondLeft",
		[2] = 2,
		[3] = "1 second left",
	},
	[14] = {
		[1] = "OnMainspecBid",
		[2] = 1,
		[3] = "$b ($r) is bidding $d DKP for $i",
	},
	[15] = {
		[1] = "OnOffspecBid",
		[2] = 1,
		[3] = "$b is bidding $d Off-spec for $i",
	},
	[16] = {
		[1] = "OnMainspecMaxBid",
		[2] = 1,
		[3] = "$b ($r) went all in ($d DKP) for $i",
	},
	[17] = {
		[1] = "OnOffspecMaxBid",
		[2] = 1,
		[3] = "$b went all in ($d) Off-spec for $i",
	},
	[18] = {
		[1] = "OnComplete",
		[2] = 2,
		[3] = "$i sold to $b for $d DKP.",
	},
	[19] = {
		[1] = "OnPause",
		[2] = 2,
		[3] = "Auction has been Paused",
	},
	[20] = {
		[1] = "OnResume",
		[2] = 2,
		[3] = "Auction has been Resumed",
	},
	[21] = {
		[1] = "OnEnd",
		[2] = 1,
		[3] = "Auction for $i is over",
	},
	[22] = {
		[1] = "OnCancel",
		[2] = 1,
		[3] = "Auction was Cancelled",
	},
	[23] = {
		[1] = "OnDKPAddedPlayer",
		[2] = 1,
		[3] = "$d DKP was added to $b",
	},
	[24] = {
		[1] = "OnDKPAddedRaid",
		[2] = 1,
		[3] = "$d DKP was added to all players in raid",
	},
	[25] = {
		[1] = "OnDKPAddedRange",
		[2] = 1,
		[3] = "$d DKP has been added for $1 players in range.",
	},
	[26] = {
		[1] = "OnDKPAddedQueue",
		[2] = 1,
		[3] = "$d DKP has been added for $1 players in range (incl $2 in queue).",
	},
	[27] = {
		[1] = "OnDKPSubtractedPlayer",
		[2] = 1,
		[3] = "$d DKP was subtracted from $b",
	},
	[28] = {
		[1] = "OnDKPSubtractedRaid",
		[2] = 1,
		[3] = "$d DKP was subtracted from all players in raid",
	},
	[29] = {
		[1] = "OnDKPSubtractedPercent",
		[2] = 1,
		[3] = "$1 % ($d DKP) was subtracted from $b",
	},
	[30] = {
		[1] = "OnDKPShared",
		[2] = 1,
		[3] = "$1 DKP was shared ($d DKP per player)",
	},
	[31] = {
		[1] = "OnDKPSharedQueue",
		[2] = 1,
		[3] = "$1 DKP was shared ($d DKP per player plus $2 in queue)",
	},
	[32] = {
		[1] = "OnDKPSharedRange",
		[2] = 1,
		[3] = "$1 DKP was shared for $2 players in range ($d DKP per player)",
	},
	[33] = {
		[1] = "OnDKPSharedRangeQueue",
		[2] = 1,
		[3] = "$1 DKP was shared for $2 players in range ($d DKP per player, incl $3 in queue)",
	},
	[34] = {
		[1] = "OnDKPReplaced",
		[2] = 1,
		[3] = "$1 was replaced with $2 ($d DKP)",
	},
}
SOTA_CONFIG_VersionNumber = 1
SOTA_CONFIG_VersionDate = "2024/11/07 22:07:48"
