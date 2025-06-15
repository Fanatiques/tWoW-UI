-- BLOCK 3: Query definitions
RAB_Buffs = {
	-- Special queries that aren't really buffs
	health = { name = "Health", identifiers = {}, type = "special", queryFunc = RAB_QueryHealth, ext = "hp", buffFunc = RAB_CastResurrect, description = "Sum of health versus sum of max health.", grouping = "Special" },
	alive = { name = "Alive", identifiers = {}, type = "special", queryFunc = RAB_QueryHealth, ext = "alive", buffFunc = RAB_CastResurrect, description = "Number of people alive versus total headcount.", grouping = "Special" },
	mana = { name = "Mana", identifiers = {}, type = "special", queryFunc = RAB_QueryMana, description = "Sum of current mana vs sum of max mana.", ignoreClass = "rw", grouping = "Special" },
	status = { name = "Status", identifiers = {}, type = "special", queryFunc = RAB_QueryStatus, description = "Displays buff sumary for PW:F, AI, MotW, BoK, BoS, BoW and Soulstones.", noUI = true, grouping = "Special" },
	scanunknown = { name = "Unknown Buff Scan", identifiers = {}, type = "special", queryFunc = RAB_ScanRaid, ext = "unknown", description = "Scans raid for unknown buff textures.", noUI = true, grouping = "Special" },
	scanraid = { name = "Raid Scan", identifiers = {}, type = "special", queryFunc = RAB_ScanRaid, ext = "known", description = "Scans raid and displays a report of all known buffs.", noUI = true, grouping = "Special" },
	ishere = { name = "Is Here", identifiers = {}, type = "special", queryFunc = RAB_QueryHere, description = "Displays people currently afk, offline or invisible.", grouping = "Special" },
	ctra = { name = "CTRA Version", identifiers = {}, type = "special", queryFunc = RAB_QueryCTRAVersion, description = "Displays people whose CTRA is out of date.", grouping = "Special" },
	blank = { name = "Blank", identifiers = {}, type = "special", queryFunc = RAB_QueryBlank, description = "Displays a blank bar - use as a header if you wish.", grouping = "Special" },
	onycloak = { name = "Onyxia Cloak", identifiers = {}, type = "special", queryFunc = RAB_QueryInventoryItem, ext = "15:15138", buffFunc = RAB_CastInventoryItem, description = "Checks that people are wearing their Onyxia Cloak.", grouping = "Special" },
	info = { name = "Target's (De)Buffs", identifiers = {}, type = "special", queryFunc = RAB_QueryBuffInfo, description = "Outputs buff names / textures for buffs and debuffs on your current target.", noUI = true, grouping = "Special" },
	stormwindgof = { name = "Stormwind Gift of Friendship", identifiers = { { tooltip = "Stormwind Gift of Friendship", texture = "INV_Misc_Gift_03" } }, type = "special", grouping = "Special" },
	darnassusgof = { name = "Darnassus Gift of Friendship", identifiers = { { tooltip = "Darnassus Gift of Friendship", texture = "INV_Misc_Gift_02" } }, type = "special", grouping = "Special" },
	orgrimmargof = { name = "Orgrimmar Gift of Friendship", identifiers = { { tooltip = "Orgrimmar Gift of Friendship", texture = "INV_Misc_Gift_01" } }, type = "special", grouping = "Special" },
	thunderbluffgof = { name = "Thunder Bluff Gift of Friendship", identifiers = { { tooltip = "Thunder Bluff of Friendship", texture = "INV_Misc_Gift_05" } }, type = "special", grouping = "Special" },
	incombat = { name = "In Combat", sfunc = UnitAffectingCombat, havebuff = "In Combat", missbuff = "Out of combat", invert = true, grouping = "Special" },
	pvp = { name = "PvP Enabled", sfunc = UnitIsPVP, havebuff = "PvP Enabled", missbuff = "Not PvP Enabled", invert = true, grouping = "Special" },

	-- Buffs
	ai = { name = "Arcane Intellect", identifiers = { { tooltip = "Arcane Intellect", texture = "Spell_Holy_MagicalSentry" }, { tooltip = "Arcane Brilliance", texture = "Spell_Holy_ArcaneIntellect", bigcast = "ab" } }, bigcast = "ab", bigsort = "group", bigthreshold = 3, ignoreClass = "wr", grouping = "Mage", priority = { priest = 0.5, druid = 0.5, paladin = 0.4, shaman = 0.4, warlock = 0.3 }, ctraid = 3, recast = 5 },

	dampen = { name = "Dampen Magic", identifiers = { { tooltip = "Dampen Magic", texture = "Spell_Nature_AbolishMagic" } }, grouping = "Mage", ctraid = 21, recast = 3 },
	amplify = { name = "Amplify Magic", identifiers = { { tooltip = "Amplify Magic", texture = "Spell_Holy_FlashHeal" } }, grouping = "Mage", ctraid = 20, recast = 3 },
	barrier = { name = "Ice Barrier", identifiers = { { tooltip = "Ice Barrier", texture = "Spell_Ice_Lament" } }, type = "self", grouping = "Mage", class = "Mage", invert = true },
	block = { name = "Ice Block", identifiers = { { tooltip = "Ice Block", texture = "Spell_Frost_Frost" } }, type = "self", grouping = "Mage", class = "Mage", invert = true },
	magearmor = { name = "Mage Armor", identifiers = { { tooltip = "Mage Armor", texture = "Spell_MageArmor" } }, type = "self", grouping = "Mage", class = "Mage", recast = 5 },
	frostarmor = { name = "Frost Armor", identifiers = { { tooltip = "Frost Armor", texture = "Spell_Frost_FrostArmor02" } }, type = "self", grouping = "Mage", class = "Mage", recast = 5 },
	water = { name = "Water", identifiers = { { tooltip = "Water", texture = "INV_Drink_18" } }, grouping = "Mage", queryFunc = RAB_QueryWater, buffFunc = RAB_CastWater, description = "H2O data as reported by RABuffs.", ignoreClass = "rw" },

	pwf = { name = "Fortitude", identifiers = { { tooltip = "Power Word: Fortitude", texture = "Spell_Holy_WordFortitude" }, { tooltip = "Prayer of Fortitude", texture = "Spell_Holy_PrayerOfFortitude", bigcast = "pof" } }, bigcast = "pof", bigsort = "group", bigthreshold = 2, grouping = "Priest", ctraid = 1, recast = 5 },
	sprot = { name = "Shadow Protection", identifiers = { { tooltip = "Shadow Protection", texture = "Spell_Shadow_AntiShadow" }, { tooltip = "Prayer of Shadow Protection", texture = "Spell_Holy_PrayerofShadowProtection", bigcast = "posprot" } }, bigcast = "posprot", bigsort = "group", bigthreshold = 2, grouping = "Priest", ctraid = 5, recast = 3 },
	ds = { name = "Divine Spirit", identifiers = { { tooltip = "Divine Spirit", texture = "Spell_Holy_DivineSpirit" }, { tooltip = "Prayer of Spirit", texture = "Spell_Holy_PrayerofSpirit", bigcast = "pos" } }, bigcast = "pos", bigsort = "group", bigthreshold = 2, grouping = "Priest", ctraid = 8, recast = 5 },
	pws = { name = "Power Word: Shield", identifiers = { { tooltip = "Power Word: Shield", texture = "Spell_Holy_PowerWordShield" } }, grouping = "Priest", invert = true, ctraid = 6, recast = 3 },
	fearward = { name = "Fear Ward", identifiers = { { tooltip = "Fear Ward", texture = "Spell_Holy_Excorcism" } }, grouping = "Priest", invert = true, ctraid = 10, recast = 3 },
	innerfire = { name = "Inner Fire", identifiers = { { tooltip = "Inner Fire", texture = "Spell_Holy_InnerFire" } }, type = "self", grouping = "Priest", class = "Priest", recast = 3 },
	pi = { name = "Power Infusion", identifiers = { { tooltip = "Power Infusion", texture = "Spell_Holy_PowerInfusion" } }, grouping = "Priest", ignoreClass = "wrh", priority = { priest = 0.2, druid = 0.2, mage = 0.5, warlock = 0.5 }, selfPriority = 0 },
	priestres = { name = "Resurrection", identifiers = { { tooltip = "Resurrection", texture = "Spell_Holy_Resurrection" } }, grouping = "Priest", ctraid = 22, recast = 3 },

	motw = { name = "Mark of the Wild", identifiers = { { tooltip = "Mark of the Wild", texture = "Spell_Nature_Regeneration" }, { tooltip = "Gift of the Wild", texture = "Spell_Nature_Regeneration", bigcast = "gotw" } }, bigcast = "gotw", bigsort = "group", bigthreshold = 3, grouping = "Druid", ctraid = 2, recast = 5 },
	emeraldblessing = { name = "Emerald Blessing", identifiers = { { tooltip = "Emerald Blessing", texture = "Spell_Nature_ProtectionformNature", spellId = 57108 } }, grouping = "Druid", recast = 3 },
	thorns = { name = "Thorns", identifiers = { { tooltip = "Thorns", texture = "Spell_Nature_Thorns" } }, grouping = "Druid", ctraid = 9, recast = 3 },
	clarity = { name = "Omen of Clarity", identifiers = { { tooltip = "Omen of Clarity", texture = "Spell_Nature_CrystalBall" } }, type = "self", grouping = "Druid", class = "Druid", recast = 2 },
	druidshift = {
		name = "Shapeshifted",
		identifiers = {
			{ tooltip = "Shapeshifted", texture = "Ability_Druid_TravelForm" },
			{ tooltip = "Bear Form", texture = "Ability_Racial_BearForm" },
			{ tooltip = "Cat Form", texture = "Ability_Druid_CatForm" },
			{ tooltip = "Aquatic Form", texture = "Ability_Druid_AquaticForm" }
		},
		grouping = "Druid",
		type = "dummy"
	},

	bos = { name = "Blessing of Salvation", identifiers = { { tooltip = "Blessing of Salvation", texture = "Spell_Holy_SealOfSalvation" }, { tooltip = "Greater Blessing of Salvation", texture = "Spell_Holy_GreaterBlessingofSalvation", bigcast = "gbos" } }, bigcast = "gbos", bigsort = "class", bigthreshold = 3, grouping = "Paladin", ignoreMTs = true, priority = { priest = 0.5, druid = 0.5, mage = 0.4, warlock = 0.4, paladin = 0.4 }, sort = "class", ctraid = 14, recast = 3 },
	bow = { name = "Blessing of Wisdom", identifiers = { { tooltip = "Blessing of Wisdom", texture = "Spell_Holy_SealOfWisdom" }, { tooltip = "Greater Blessing of Wisdom", texture = "Spell_Holy_GreaterBlessingofWisdom", bigcast = "gbow" } }, bigcast = "gbow", bigsort = "class", bigthreshold = 3, grouping = "Paladin", ignoreClass = "wr", priority = { priest = 0.5, druid = 0.5, mage = 0.4, warlock = 0.4, paladin = 0.4 }, sort = "class", ctraid = 12, recast = 3 },
	bok = { name = "Blessing of Kings", identifiers = { { tooltip = "Blessing of Kings", texture = "Spell_Magic_MageArmor" }, { tooltip = "Greater Blessing of Kings", texture = "Spell_Magic_GreaterBlessingofKings" } }, bigcast = "gbok", bigsort = "class", bigthreshold = 3, grouping = "Paladin", sort = "class", ctraid = 13, recast = 3 },
	bol = { name = "Blessing of Light", identifiers = { { tooltip = "Blessing of Light", texture = "Spell_Holy_PrayerOfHealing02" }, { tooltip = "Greater Blessing of Light", texture = "Spell_Holy_GreaterBlessingofLight" } }, bigcast = "gbol", bigsort = "class", bigthreshold = 3, grouping = "Paladin", sort = "class", ctraid = 15, recast = 3 },
	bom = { name = "Blessing of Might", identifiers = { { tooltip = "Blessing of Might", texture = "Spell_Holy_FistOfJustice" }, { tooltip = "Greater Blessing of Might", texture = "Spell_Holy_GreaterBlessingofKings" } }, bigcast = "gbom", bigsort = "class", bigthreshold = 3, grouping = "Paladin", ignoreClass = "mplh", sort = "class", ctraid = 11, recast = 3 },
	bosanc = { name = "Blessing of Sanctuary", identifiers = { { tooltip = "Blessing of Sanctuary", texture = "Spell_Nature_LightningShield" }, { tooltip = "Greater Blessing of Sanctuary", texture = "Spell_Holy_GreaterBlessingofSanctuary" } }, bigcast = "gbosanc", bigsort = "class", bigthreshold = 3, grouping = "Paladin", sort = "class", ctraid = 16, recast = 3 },
	bop = { name = "Blessing of Protection", identifiers = { { tooltip = "Blessing of Protection", texture = "Spell_Holy_SealOfProtection" } }, grouping = "Paladin", unique = true },
	command = { name = "Seal of Command", identifiers = { { tooltip = "Seal of Command", texture = "Ability_Warrior_InnerRage" } }, type = "self", grouping = "Paladin", class = "Paladin" },
	devotion = { name = "Devotion Aura", identifiers = { { tooltip = "Devotion Aura", texture = "Spell_Holy_DevotionAura" } }, grouping = "Paladin", type = "aura" },
	concentration = { name = "Concentration Aura", identifiers = { { tooltip = "Concentration Aura", texture = "Spell_Holy_MindSooth" } }, grouping = "Paladin", type = "aura" },
	fireaura = { name = "Fire Resistance Aura", identifiers = { { tooltip = "Fire Resistance Aura", texture = "Spell_Fire_SealOfFire" } }, grouping = "Paladin", type = "aura" },
	shadowaura = { name = "Shadow Resistance Aura", identifiers = { { tooltip = "Shadow Resistance Aura", texture = "Spell_Shadow_SealOfKings" } }, grouping = "Paladin", type = "aura" },
	retribution = { name = "Retribution Aura", identifiers = { { tooltip = "Retribution Aura", texture = "Spell_Holy_AuraOfLight" } }, grouping = "Paladin", type = "aura" },
	frostaura = { name = "Frost Resistance Aura", identifiers = { { tooltip = "Frost Resistance Aura", texture = "Spell_Frost_WizardMark" } }, grouping = "Paladin", type = "aura" },
	di = { name = "Divine Intervention", identifiers = { { tooltip = "Divine Intervention", texture = "Spell_Nature_TimeStop" } }, grouping = "Paladin", priority = { priest = 2, paladin = 2, druid = 1, mage = 0.5 }, selfPriority = -10 },
	paladinres = { name = "Redemption", identifiers = { { tooltip = "Redemption", texture = "Spell_Holy_Resurrection" } }, grouping = "Paladin", ctraid = 23, recast = 3 },

	shamanres = { name = "Ancestral Spirit", identifiers = { { tooltip = "Ancestral Spirit", texture = "Spell_Nature_Regenerate" } }, grouping = "Shaman", ctraid = 24, recast = 3 },

	ss = { name = "Soulstone", identifiers = { { tooltip = "Soulstone", texture = "Spell_Shadow_SoulGem" } }, grouping = "Warlock", buffFunc = RAB_CastSoulstone, priority = { priest = 2, paladin = 2, shaman = 2, druid = 1 }, selfPriority = 1.2, invert = true, unique = true, ctraid = 7, recast = 5 },
	ub = { name = "Unending Breath", identifiers = { { tooltip = "Unending Breath", texture = "Spell_Shadow_DemonBreath" } }, grouping = "Warlock", recast = 3 },
	detectinvisibility = { name = "Detect Invisibility", identifiers = { { tooltip = "Detect Invisibility", texture = "Spell_Shadow_DetectInvisibility" }, { tooltip = "Detect Lesser Invisibility", texture = "Spell_Shadow_DetectLesserInvisibility" } }, grouping = "Warlock", recast = 3 },
	demonarmor = { name = "Demon Armor", identifiers = { { tooltip = "Demon Armor", texture = "Spell_Shadow_RagingScream" } }, type = "self", grouping = "Warlock", class = "Warlock", recast = 5 },
	bloodpact = { name = "Blood Pact", identifiers = { { tooltip = "Blood Pact", texture = "Spell_Shadow_BloodBoil" } }, grouping = "Warlock", type = "aura" },
	paranoia = { name = "Paranoia", identifiers = { { tooltip = "Paranoia", texture = "Spell_Shadow_AuraOfDarkness" } }, grouping = "Warlock", invert = true, type = "aura" },
	touchofshadow = { name = "Sacrifice: Succubus", identifiers = { { tooltip = "Touch of Shadow", texture = "Spell_Shadow_PsychicScream" } }, grouping = "Warlock", class = "Warlock", type = "aura" },
	felenergy = { name = "Sacrifice: Felhunter", identifiers = { { tooltip = "Fel Energy", texture = "Spell_Shadow_PsychicScream" } }, grouping = "Warlock", class = "Warlock", type = "aura" },
	felstamina = { name = "Sacrifice: Voidwalker", identifiers = { { tooltip = "Fel Stamina", texture = "Spell_Shadow_PsychicScream" } }, grouping = "Warlock", class = "Warlock", type = "aura" },
	burningwish = { name = "Sacrifice: Imp", identifiers = { { tooltip = "Burning Wish", texture = "Spell_Shadow_PsychicScream" } }, grouping = "Warlock", class = "Warlock", type = "aura" },
	spellstone = { name = "Spellstone", identifiers = { { tooltip = "Spellstone", texture = "INV_Misc_Gem_Sapphire_01", spellId = 51694 } }, grouping = "Warlock", class = "Warlock", buffFunc = RAB_UseItem, itemId = 51933 },
	wrathstone = { name = "Wrathstone", identifiers = { { tooltip = "Wrathstone", texture = "INV_Misc_Gem_Bloodstone_02", spellId = 51700 } }, grouping = "Warlock", class = "Warlock", buffFunc = RAB_UseItem, itemId = 51935 },
	firestone = { name = "Firestone", identifiers = { { tooltip = "Firestone", texture = "INV_Ammo_FireTar", spellId = 51690 } }, grouping = "Warlock", class = "Warlock", buffFunc = RAB_UseItem, itemId = 51932 },
	felstone = { name = "Felstone", identifiers = { { tooltip = "Felstone", texture = "inv_misc_gem_felstone", spellId = 51697 } }, grouping = "Warlock", class = "Warlock", buffFunc = RAB_UseItem, itemId = 51934 },

	hawk = { name = "Aspect of the Hawk", identifiers = { { tooltip = "Aspect of the Hawk", texture = "Spell_Nature_RavenForm" } }, type = "self", grouping = "Hunter", class = "Hunter", recast = 5 },
	cheetah = { name = "Aspect of the Cheetah", identifiers = { { tooltip = "Aspect of the Cheetah", texture = "Ability_Mount_JungleTiger" } }, type = "self", grouping = "Hunter", class = "Hunter", recast = 5 },
	beast = { name = "Aspect of the Beast", identifiers = { { tooltip = "Aspect of the Beast", texture = "Ability_Mount_PinkTiger" } }, type = "self", grouping = "Hunter", class = "Hunter", recast = 5 },
	aspectwild = { name = "Aspect of the Wild", identifiers = {
		{ tooltip = "Aspect of the Wild", texture = "Spell_Nature_ProtectionformNature", spellId = 20043 },
		{ tooltip = "Aspect of the Wild", texture = "Spell_Nature_ProtectionformNature", spellId = 20190 }
	}, grouping = "Hunter", class = "Hunter", type = "aura", recast = 5 },
	pack = { name = "Aspect of the Pack", identifiers = { { tooltip = "Aspect of the Pack", texture = "Ability_Mount_WhiteTiger" } }, grouping = "Hunter", class = "Hunter", type = "aura", recast = 5 },
	monkey = { name = "Aspect of the Monkey", identifiers = { { tooltip = "Aspect of the Monkey", texture = "Ability_Hunter_AspectOfTheMonkey" } }, type = "self", grouping = "Hunter", class = "Hunter", recast = 5 },
	trueshot = { name = "True Shot Aura", identifiers = { { tooltip = "True Shot Aura", texture = "Ability_TrueShot" } }, grouping = "Hunter", type = "aura", recast = 5 },

	battleshout = { name = "Battle Shout", identifiers = { { tooltip = "Battle Shout", texture = "Ability_Warrior_BattleShout" } }, grouping = "Warrior", type = "aura", recast = 5 },

	-- Debuffs --
	frostmark = { name = "Mark of Frost", identifiers = { { tooltip = "Mark of Frost", texture = "Spell_Frost_ChainsOfIce" } }, type = "debuff", grouping = "Debuffs" },
	naturemark = { name = "Mark of Nature", identifiers = { { tooltip = "Mark of Nature", texture = "Spell_Nature_SpiritArmor" } }, type = "debuff", grouping = "Debuffs" },
	shazz = { name = "Amplify Magic [Shazzrah]", identifiers = { { tooltip = "Amplify Magic [Shazzrah]", texture = "Spell_Arcane_StarFire" } }, type = "debuff", grouping = "Debuffs" },
	cthun = { name = "Digestive Acid [C'Thun]", identifiers = { { tooltip = "Digestive Acid [C'Thun]", texture = "Ability_Creature_Disease_02" } }, type = "debuff", grouping = "Debuffs" },
	drunk = { name = "Drunk [ZG]", identifiers = { { tooltip = "Drunk [ZG]", texture = "Ability_Creature_Poison_01" } }, type = "debuff", grouping = "Debuffs" },
	dbronze = { name = "Chromaggus: Bronze", identifiers = { { tooltip = "Brood Affliction: Bronze", texture = "INV_Misc_Head_Dragon_Bronze" } }, type = "debuff", invert = true, grouping = "Debuffs" },
	dcurse = { name = "Type: Curse", identifiers = { { tooltip = "Type: Curse", texture = "Spell_Shadow_AntiShadow" }, { tooltip = "Type: Curse", texture = "Spell_Shadow_CurseOfAchimonde" } }, type = "debuff", grouping = "Debuffs" },
	dmagic = { name = "Type: Magic", identifiers = { { tooltip = "Type: Magic", texture = "Spell_Shadow_AntiShadow" }, { tooltip = "Type: Magic", texture = "Spell_Shadow_CurseOfAchimonde" } }, type = "debuff", grouping = "Debuffs" },
	ddisease = { name = "Type: Disease", identifiers = { { tooltip = "Type: Disease", texture = "Spell_Shadow_AntiShadow" }, { tooltip = "Type: Disease", texture = "Spell_Shadow_CurseOfAchimonde" } }, type = "debuff", grouping = "Debuffs" },
	dpoison = { name = "Type: Poison", identifiers = { { tooltip = "Type: Poison", texture = "Spell_Shadow_AntiShadow" }, { tooltip = "Type: Poison", texture = "Spell_Shadow_CurseOfAchimonde" } }, type = "debuff", grouping = "Debuffs" },
	dtypeless = { name = "Type: Typeless", identifiers = { { tooltip = "Type: Typeless", texture = "Spell_Shadow_AntiShadow" }, { tooltip = "Type: Typeless", texture = "Spell_Shadow_CurseOfAchimonde" } }, type = "debuff", grouping = "Debuffs" },
	dicanremove = { name = "Type: You can remove", identifiers = { { tooltip = "Type: You can remove", texture = "Spell_Shadow_AntiShadow" }, { tooltip = "Type: You can remove", texture = "Spell_Shadow_CurseOfAchimonde" } }, type = "debuff", grouping = "Debuffs" },

	-- Miscellaneous --
	zandalarbuff = { name = "Spirit of Zandalar", identifiers = { { tooltip = "Spirit of Zandalar", texture = "Ability_Creature_Poison_05" } }, grouping = "Miscellaneous", type = "special" },
	dragonslayer = { name = "Rallying Cry of the Dragonslayer", identifiers = { { tooltip = "Rallying Cry of the Dragonslayer", texture = "INV_Misc_Head_Dragon_01" } }, grouping = "Miscellaneous", type = "special" },
	fengus = { name = "Fengus' Ferocity", identifiers = { { tooltip = "Fengus' Ferocity (DM-N Tribute)", texture = "Spell_Nature_UndyingStrength" } }, grouping = "Miscellaneous", type = "special" },
	slipkik = { name = "Slip'kik's Savvy", identifiers = { { tooltip = "Slip'kik's Savvy (DM-N Tribute)", texture = "Spell_Holy_LesserHeal02" } }, grouping = "Miscellaneous", type = "special" },
	moldar = { name = "Mol'dar's Moxie", identifiers = { { tooltip = "Mol'dar's Moxie (DM-N Tribute)", texture = "Spell_Nature_MassTeleport" } }, grouping = "Miscellaneous", type = "special" },
	flag = { name = "WSG Flag", identifiers = { { tooltip = "WSG Flag", texture = "INV_BannerPVP_01" }, { tooltip = "WSG Flag", texture = "INV_BannerPVP_02" } }, grouping = "Miscellaneous", invert = true, havebuff = "Carrying Flag", missbuff = "No Flag" },
	battlestandard = { name = "Battle Standard", identifiers = { { tooltip = "Battle Standard", texture = "INV_Banner_02" }, { tooltip = "Battle Standard", texture = "INV_Banner_01" } }, grouping = "Miscellaneous", invert = true, type = "aura" },
	regen = { name = "Regenerating", identifiers = { { tooltip = "Regenerating", texture = "INV_Drink_18" }, { tooltip = "Regenerating", texture = "INV_Drink_07" }, { tooltip = "Regenerating", texture = "INV_Misc_Fork&Knife" } }, grouping = "Miscellaneous", invert = true, havebuff = "Regenerating", missbuff = "Not Regenerating" },
	hat = { name = "Admiral's Hat", identifiers = { { tooltip = "Admiral's Hat", texture = "INV_Misc_Horn_03" } }, grouping = "Miscellaneous", type = "aura" },

	anyflask = { name = "Any Flask", identifiers = {
		{ tooltip = "Supreme Power", texture = "INV_Potion_41", spellId=17628 },
		{ tooltip = "Distilled Wisdom", texture = "INV_Potion_97", spellId=17627 },
		{ tooltip = "Flask of the Titans", texture = "INV_Potion_62", spellId=17626 },
		{ tooltip = "Chromatic Resistance", texture = "INV_Potion_48", spellId=17629 }
	}, grouping = "Miscellaneous" },

	-- Protection potions --
	lessernaturepot = { name = "Nature Protection Potion", identifiers = { { tooltip = "Nature Protection", texture = "Spell_Nature_SpiritArmor", spellId = 7254 } }, grouping = "Protection", buffFunc = RAB_UseItem, itemId = 6052 },
	lessershadowpot = { name = "Shadow Protection Potion", identifiers = { { tooltip = "Shadow Protection", texture = "Spell_Shadow_RagingScream", spellId = 7242 } }, grouping = "Protection", buffFunc = RAB_UseItem, itemId = 6048 },
	lesserfirepot = { name = "Fire Protection Potion", identifiers = { { tooltip = "Fire Protection", texture = "Spell_Fire_FireArmor", spellId = 7233 } }, grouping = "Protection", buffFunc = RAB_UseItem, itemId = 6049 },
	lesserfrostpot = { name = "Frost Protection Potion", identifiers = { { tooltip = "Frost Protection", texture = "Spell_Frost_FrostArmor02", spellId = 7239 } }, grouping = "Protection", buffFunc = RAB_UseItem, itemId = 6050 },
	lesserholypot = { name = "Holy Protection Potion", identifiers = { { tooltip = "Holy Protection", texture = "Spell_Holy_BlessingOfProtection", spellId = 7245 } }, grouping = "Protection", buffFunc = RAB_UseItem, itemId = 6051 },

	arcanepot = { name = "Greater Arcane Protection Potion", identifiers = { { tooltip = "Arcane Protection", texture = "Spell_Holy_PrayerOfHealing02", spellId = 17549 } }, grouping = "Protection", buffFunc = RAB_UseItem, itemId = 13461 },
	naturepot = { name = "Greater Nature Protection Potion", identifiers = { { tooltip = "Nature Protection", texture = "Spell_Nature_SpiritArmor", spellId = 17546 } }, grouping = "Protection", buffFunc = RAB_UseItem, itemId = 13458 },
	shadowpot = { name = "Greater Shadow Protection Potion", identifiers = { { tooltip = "Shadow Protection", texture = "Spell_Shadow_RagingScream", spellId = 17548 } }, grouping = "Protection", buffFunc = RAB_UseItem, itemId = 13459 },
	firepot = { name = "Greater Fire Protection Potion", identifiers = { { tooltip = "Fire Protection", texture = "Spell_Fire_FireArmor", spellId = 17543 } }, grouping = "Protection", buffFunc = RAB_UseItem, itemId = 13457 },
	frostpot = { name = "Greater Frost Protection Potion", identifiers = { { tooltip = "Frost Protection", texture = "Spell_Frost_FrostArmor02", spellId = 17544 } }, grouping = "Protection", buffFunc = RAB_UseItem, itemId = 13456 },
	holypot = { name = "Greater Holy Protection Potion", identifiers = { { tooltip = "Holy Protection", texture = "Spell_Holy_BlessingOfProtection", spellId = 17545 } }, grouping = "Protection", buffFunc = RAB_UseItem, itemId = 13460 },

	-- HP/Mana/Utility Consumes --
	spiritofzanza = { name = "Spirit of Zanza", identifiers = { { tooltip = "Spirit of Zanza", texture = "INV_Potion_30", spellId = 24382 } }, grouping = "HP/Mana/Utility", buffFunc = RAB_UseItem, itemId = 20079 },
	sheenofzanza = { name = "Sheen of Zanza", identifiers = { { tooltip = "Sheen of Zanza", texture = "INV_Potion_29", spellId = 24417 } }, grouping = "HP/Mana/Utility", buffFunc = RAB_UseItem, itemId = 20080 },
	swiftnessofzanza = { name = "Swiftness of Zanza", identifiers = { { tooltip = "Swiftness of Zanza", texture = "INV_Potion_31", spellId = 24383 } }, grouping = "HP/Mana/Utility", buffFunc = RAB_UseItem, itemId = 20081 },
	elixirfortitude = { name = "Elixir of Fortitude", identifiers = { { tooltip = "Health II", texture = "INV_Potion_44", spellId = 3593 } }, buffFunc = RAB_UseItem, itemId = 3825 },
	trollbloodmighty = { name = "Mighty Troll's Blood Potion", identifiers = { { tooltip = "Regeneration", texture = "INV_Potion_79", spellId = 3223 } }, grouping = "HP/Mana/Utility", buffFunc = RAB_UseItem, itemId = 3826 },
	trollblood = { name = "Major Troll's Blood Potion", identifiers = { { tooltip = "Regeneration", texture = "INV_Potion_79", spellId = 24361 } }, grouping = "HP/Mana/Utility", buffFunc = RAB_UseItem, itemId = 20004 },
	lesserstoneshield = { name = "Lesser Stoneshield Potion", identifiers = { { tooltip = "Stoneshield", texture = "INV_Potion_67", spellId = 4941 } }, grouping = "HP/Mana/Utility", buffFunc = RAB_UseItem, itemId = 4623 },
	stoneshield = { name = "Greater Stoneshield Potion", identifiers = { { tooltip = "Greater Stoneshield", texture = "INV_Potion_69", spellId = 17540 } }, grouping = "HP/Mana/Utility", buffFunc = RAB_UseItem, itemId = 13455 },
	supdef = { name = "Elixir of Superior Defense", identifiers = { { tooltip = "Greater Armor", texture = "INV_Potion_86", spellId = 11348 } }, grouping = "HP/Mana/Utility", buffFunc = RAB_UseItem, itemId = 13445 },
	lungjuice = { name = "Lung Juice Cocktail", identifiers = { { tooltip = "Spirit of Boar", texture = "Spell_Nature_Purge", spellId = 10668 } }, grouping = "HP/Mana/Utility", buffFunc = RAB_UseItem, itemId = 8411 },
	mageblood = { name = "Mageblood Potion", identifiers = { { tooltip = "Mana Regeneration", texture = "INV_Potion_45", spellId = 24363 } }, grouping = "HP/Mana/Utility", buffFunc = RAB_UseItem, itemId = 20007 },
	titans = { name = "Flask of the Titans", identifiers = { { tooltip = "Flask of the Titans", texture = "INV_Potion_62", spellId = 17626 } }, grouping = "HP/Mana/Utility", buffFunc = RAB_UseItem, itemId = 13510 },
	wisdom = { name = "Flask of Distilled Wisdom", identifiers = { { tooltip = "Distilled Wisdom", texture = "INV_Potion_97", spellId = 17627 } }, grouping = "HP/Mana/Utility", buffFunc = RAB_UseItem, itemId = 13511 },
	chromaticres = { name = "Flask of Chromatic Resistance", identifiers = { { tooltip = "Chromatic Resistance", texture = "INV_Potion_48", spellId = 17629 } }, grouping = "HP/Mana/Utility", buffFunc = RAB_UseItem, itemId = 13513 },
	giftarthas = { name = "Gift of Arthas", identifiers = { { tooltip = "Gift of Arthas", texture = "Spell_Shadow_FingerOfDeath", spellId = 11371 } }, grouping = "HP/Mana/Utility", buffFunc = RAB_UseItem, itemId = 9088 },
	frozenrune = { name = "Frozen Rune", identifiers = { { tooltip = "Fire Protection", texture = "Spell_Fire_MasterOfElements", spellId = 29432 } }, grouping = "HP/Mana/Utility", buffFunc = RAB_UseItem, itemId = 22682 },
	magicresistancepotion = { name = "Magic Resistance Potion", identifiers = { { tooltip = "Resistance", texture = "INV_Potion_08", spellId = 11364 } }, grouping = "HP/Mana/Utility", buffFunc = RAB_UseItem, itemId = 9036 },
	restorativepotion = { name = "Restorative Potion", identifiers = { { tooltip = "Restoration", texture = "Spell_Holy_DispelMagic", spellId = 11359 } }, grouping = "HP/Mana/Utility", buffFunc = RAB_UseItem, itemId = 9030 },
	invisibilitypotion = { name = "Invisibility Potion", identifiers = { { tooltip = "Invisibility", texture = "INV_Potion_18", spellId = 11392 } }, grouping = "HP/Mana/Utility", buffFunc = RAB_UseItem, itemId = 9172 },
	lesserinvisibilitypotion = { name = "Lesser Invisibility Potion", identifiers = { { tooltip = "Lesser Invisibility", texture = "INV_Potion_18", spellId = 3680 } }, grouping = "HP/Mana/Utility", buffFunc = RAB_UseItem, itemId = 3823 },
	livingactionpotion = { name = "Living Action Potion", identifiers = { { tooltip = "Living Free Action", texture = "INV_Potion_07", spellId = 24364 } }, grouping = "HP/Mana/Utility", buffFunc = RAB_UseItem, itemId = 20008 },
	swiftnesspotion = { name = "Swiftness Potion", identifiers = { { tooltip = "Speed", texture = "Ability_Kick", spellId = 2379 } }, grouping = "HP/Mana/Utility", buffFunc = RAB_UseItem, itemId = 2459 },

	agilscroll = { name = "Scroll of Agility IV", identifiers = { { tooltip = "Agility", texture = "Spell_Holy_BlessingOfAgility", spellId = 12174 } }, grouping = "HP/Mana/Utility", buffFunc = RAB_UseItem, itemId = 10309, useOn = 'player' },
	protscroll = { name = "Scroll of Protection IV", identifiers = { { tooltip = "Armor", texture = "Ability_Warrior_DefensiveStance", spellId = 12175 } }, grouping = "HP/Mana/Utility", buffFunc = RAB_UseItem, itemId = 10305, useOn = 'player' },
	-- protscrollone = { name = "Scroll of Protection", identifiers = { { tooltip = "Armor", texture = "Ability_Warrior_DefensiveStance", spellId = 8091 } }, grouping = "HP/Mana/Utility", buffFunc = RAB_UseItem, itemId = 3013, useOn = 'player' },
	intscroll = { name = "Scroll of Intellect IV", identifiers = { { tooltip = "Intellect", texture = "Spell_Holy_MagicalSentry", spellId = 12176 } }, grouping = "HP/Mana/Utility", buffFunc = RAB_UseItem, itemId = 10308, useOn = 'player' },
	spirscroll = { name = "Scroll of Spirit IV", identifiers = { { tooltip = "Spirit", texture = "Spell_Shadow_BurningSpirit", spellId = 12177 } }, grouping = "HP/Mana/Utility", buffFunc = RAB_UseItem, itemId = 10306, useOn = 'player' },
	stamscroll = { name = "Scroll of Stamina IV", identifiers = { { tooltip = "Stamina", texture = "Spell_Nature_UnyeildingStamina", spellId = 12178 } }, grouping = "HP/Mana/Utility", buffFunc = RAB_UseItem, itemId = 10307, useOn = 'player' },
	strscroll = { name = "Scroll of Strength IV", identifiers = { { tooltip = "Strength", texture = "Spell_Nature_Strength", spellId = 12179 } }, grouping = "HP/Mana/Utility", buffFunc = RAB_UseItem, itemId = 10310, useOn = 'player' },

	-- Spell Consumes --
	flask = { name = "Flask of Supreme Power", identifiers = { { tooltip = "Supreme Power", texture = "INV_Potion_41", spellId = 17628 } }, buffFunc = RAB_UseItem, itemId = 13512, grouping = "Spell" },
	greaterarcane = { name = "Greater Arcane Elixir", identifiers = { { tooltip = "Greater Arcane Elixir", texture = "INV_Potion_25", spellId = 17539 } }, buffFunc = RAB_UseItem, itemId = 13454, grouping = "Spell" },
	greaterfirepower = { name = "Elixir of Greater Firepower", identifiers = { { tooltip = "Greater Firepower", texture = "INV_Potion_60", spellId = 26276 } }, buffFunc = RAB_UseItem, itemId = 21546, grouping = "Spell" },
	greaternaturepower = { name = "Elixir of Greater Nature Power", identifiers = { { tooltip = "Greater Nature Power", texture = "Spell_Nature_SpiritArmor", spellId = 45988 } }, buffFunc = RAB_UseItem, itemId = 50237, grouping = "Spell" },
	shadowpower = { name = "Elixir of Shadow Power", identifiers = { { tooltip = "Shadow Power", texture = "INV_Potion_46", spellId = 11474 } }, buffFunc = RAB_UseItem, itemId = 9264, grouping = "Spell" },
	frostpower = { name = "Elixir of Frost Power", identifiers = { { tooltip = "Frost Power", texture = "INV_Potion_03", spellId = 21920 } }, buffFunc = RAB_UseItem, itemId = 17708, grouping = "Spell" },
	arcaneelixir = { name = "Arcane Elixir", identifiers = { { tooltip = "Arcane Elixir", texture = "INV_Potion_30", spellId = 11390 } }, buffFunc = RAB_UseItem, itemId = 9155, grouping = "Spell" },
	firepowerelixir = { name = "Elixir of Firepower", identifiers = { { tooltip = "Fire Power", texture = "INV_Potion_60", spellId = 7844 } }, buffFunc = RAB_UseItem, itemId = 6373, grouping = "Spell" },
	dreamshard = { name = "Dreamshard Elixir", identifiers = { { tooltip = "Dreamshard Elixir", texture = "INV_Potion_25", spellId = 45427 } }, buffFunc = RAB_UseItem, itemId = 61224, grouping = "Spell" },
	dreamtonic = { name = "Dreamtonic", identifiers = { { tooltip = "Dreamtonic", texture = "INV_Potion_30", spellId = 45489 } }, buffFunc = RAB_UseItem, itemId = 61423, grouping = "Spell" },
	cerebralcortex = { name = "Cerebral Cortex Compound", identifiers = { { tooltip = "Infallible Mind", texture = "Spell_Ice_Lament", spellId = 10692 } }, buffFunc = RAB_UseItem, itemId = 8423, grouping = "Spell" },

	-- Melee Consumes --
	giants = { name = "Elixir of Giants", identifiers = { { tooltip = "Elixir of the Giants", texture = "INV_Potion_61", spellId = 11405 } }, grouping = "Melee", buffFunc = RAB_UseItem, itemId = 9206 },
	mongoose = { name = "Elixir of the Mongoose", identifiers = { { tooltip = "Elixir of the Mongoose", texture = "INV_Potion_32", spellId = 17538 } }, grouping = "Melee", buffFunc = RAB_UseItem, itemId = 13452 },
	agilityelixir = { name = "Elixir of Agility", identifiers = { { tooltip = "Agility", texture = "INV_Potion_93", spellId = 11328 } }, grouping = "Melee", buffFunc = RAB_UseItem, itemId = 8949 },
	greateragilityelixir = { name = "Elixir of Greater Agility", identifiers = { { tooltip = "Greater Agility", texture = "INV_Potion_93", spellId = 11334 } }, grouping = "Melee", buffFunc = RAB_UseItem, itemId = 9187 },
	firewater = { name = "Winterfall Firewater", identifiers = { { tooltip = "Winterfall Firewater", texture = "INV_Potion_92", spellId = 17038 } }, grouping = "Melee", buffFunc = RAB_UseItem, itemId = 12820 },
	jujupower = { name = "Juju Power", identifiers = { { tooltip = "Juju Power", texture = "INV_Misc_MonsterScales_11", spellId = 16323 } }, grouping = "Melee", buffFunc = RAB_UseItem, itemId = 12451, useOn = 'player' },
	jujumight = { name = "Juju Might", identifiers = { { tooltip = "Juju Might", texture = "INV_Misc_MonsterScales_07", spellId = 16329 } }, grouping = "Melee", buffFunc = RAB_UseItem, itemId = 12460, useOn = 'player' },
	jujuchill = { name = "Juju Chill", identifiers = { { tooltip = "Juju Chill", texture = "INV_Misc_MonsterScales_09", spellId = 16325 } }, grouping = "Melee", buffFunc = RAB_UseItem, itemId = 12457, useOn = 'player' },
	jujuflurry = { name = "Juju Flurry", identifiers = { { tooltip = "Juju Flurry", texture = "INV_Misc_MonsterScales_17", spellId = 16322 } }, grouping = "Melee", buffFunc = RAB_UseItem, itemId = 12450, useOn = 'player' },
	jujuescape = { name = "Juju Escape", identifiers = { { tooltip = "Juju Escape", texture = "INV_Misc_MonsterScales_17", spellId = 16321 } }, grouping = "Melee", buffFunc = RAB_UseItem, itemId = 12459, useOn = 'player' },
	jujuember = { name = "Juju Ember", identifiers = { { tooltip = "Juju Ember", texture = "INV_Misc_MonsterScales_15", spellId = 16326 } }, grouping = "Melee", buffFunc = RAB_UseItem, itemId = 12455, useOn = 'player' },
	jujuguile = { name = "Juju Guile", identifiers = { { tooltip = "Juju Guile", texture = "INV_Misc_MonsterScales_13", spellId = 16327 }, { tooltip = "Juju Guile", texture = "INV_Potion_92" } }, grouping = "Melee", buffFunc = RAB_UseItem, itemId = 12458, useOn = 'player' },
	bogling = { name = "Bogling Root", identifiers = { { tooltip = "Fury of the Bogling", texture = "Spell_Nature_Strength", spellId = 5665 } }, buffFunc = RAB_UseItem, itemId = 5206 },
	roids = { name = "R.O.I.D.S.", identifiers = { { tooltip = "Rage of Ages", texture = "Spell_Nature_Strength", spellId = 10667 } }, grouping = "Melee", buffFunc = RAB_UseItem, itemId = 8410 },
	scorpok = { name = "Ground Scorpok Assay", identifiers = { { tooltip = "Strike of the Scorpok", texture = "Spell_Nature_ForceOfNature", spellId = 10669 } }, buffFunc = RAB_UseItem, itemId = 8412 },
	oilofimmolation = { name = "Oil of Immolation", identifiers = { { tooltip = "Fire Shield", texture = "Spell_Fire_Immolation", spellId = 11350 } }, grouping = "Melee", buffFunc = RAB_UseItem, itemId = 8956 },

	anyagi = { name = "Mongoose/Greater Agility", identifiers = { { tooltip = "Elixir of the Mongoose", texture = "INV_Potion_32", spellId = 17538 }, { tooltip = "Elixir of Greater Agility", texture = "INV_Potion_94" } }, grouping = "Melee" },

	-- Weapon consumes --
	brillmanaoil = { grouping = "Weapon", name = "Brilliant Mana Oil", identifiers = {}, type = "wepbuffonly", buffFunc = RAB_UseItem, itemId = 20748, useOn = 'weapon' },
	brillmanaoiloh = { grouping = "Weapon", name = "Brilliant Mana Oil (offhand)", identifiers = {}, type = "wepbuffonly", buffFunc = RAB_UseItem, itemId = 20748, useOn = 'weaponOH' },

	lessermanaoil = { grouping = "Weapon", name = "Lesser Mana Oil", identifiers = {}, type = "wepbuffonly", buffFunc = RAB_UseItem, itemId = 20747, useOn = 'weapon' },
	lessermanaoiloh = { grouping = "Weapon", name = "Lesser Mana Oil (offhand)", identifiers = {}, type = "wepbuffonly", buffFunc = RAB_UseItem, itemId = 20747, useOn = 'weaponOH' },

	blessedwizardoil = { grouping = "Weapon", name = "Blessed Wizard Oil", identifiers = {}, type = "wepbuffonly", buffFunc = RAB_UseItem, itemId = 23123, useOn = 'weapon' },
	blessedwizardoiloh = { grouping = "Weapon", name = "Blessed Wizard Oil (offhand)", identifiers = {}, type = "wepbuffonly", buffFunc = RAB_UseItem, itemId = 23123, useOn = 'weaponOH' },

	brilliantwizardoil = { grouping = "Weapon", name = "Brilliant Wizard Oil", identifiers = {}, type = "wepbuffonly", buffFunc = RAB_UseItem, itemId = 20749, useOn = 'weapon' },
	brilliantwizardoiloh = { grouping = "Weapon", name = "Brilliant Wizard Oil (offhand)", identifiers = {}, type = "wepbuffonly", buffFunc = RAB_UseItem, itemId = 20749, useOn = 'weaponOH' },

	wizardoil = { grouping = "Weapon", name = "Wizard Oil", identifiers = {}, type = "wepbuffonly", buffFunc = RAB_UseItem, itemId = 20750, useOn = 'weapon' },
	wizardoiloh = { grouping = "Weapon", name = "Wizard Oil (offhand)", identifiers = {}, type = "wepbuffonly", buffFunc = RAB_UseItem, itemId = 20750, useOn = 'weaponOH' },

	shadowoil = { grouping = "Weapon", name = "Shadow Oil", identifiers = {}, type = "wepbuffonly", buffFunc = RAB_UseItem, itemId = 3824, useOn = 'weapon' },
	shadowoiloh = { grouping = "Weapon", name = "Shadow Oil (offhand)", identifiers = {}, type = "wepbuffonly", buffFunc = RAB_UseItem, itemId = 3824, useOn = 'weaponOH' },

	frostoil = { grouping = "Weapon", name = "Frost Oil", identifiers = {}, type = "wepbuffonly", buffFunc = RAB_UseItem, itemId = 3829, useOn = 'weapon' },
	frostoiloh = { grouping = "Weapon", name = "Frost Oil (offhand)", identifiers = {}, type = "wepbuffonly", buffFunc = RAB_UseItem, itemId = 3829, useOn = 'weaponOH' },

	consecratedstone = { grouping = "Weapon", name = "Consecrated Sharpening Stone", identifiers = {}, type = "wepbuffonly", buffFunc = RAB_UseItem, itemId = 23122, useOn = 'weapon' },
	consecratedstoneoh = { grouping = "Weapon", name = "Consecrated Sharpening Stone (offhand)", identifiers = {}, type = "wepbuffonly", buffFunc = RAB_UseItem, itemId = 23122, useOn = 'weaponOH' },

	denseweightstone = { grouping = "Weapon", name = "Dense Weightstone", identifiers = {}, type = "wepbuffonly", buffFunc = RAB_UseItem, itemId = 12643, useOn = 'weapon' },
	denseweightstoneoh = { grouping = "Weapon", name = "Dense Weightstone (offhand)", identifiers = {}, type = "wepbuffonly", buffFunc = RAB_UseItem, itemId = 12643, useOn = 'weaponOH' },

	densesharpeningstone = { grouping = "Weapon", name = "Dense Sharpening Stone", identifiers = {}, type = "wepbuffonly", buffFunc = RAB_UseItem, itemId = 12404, useOn = 'weapon' },
	densesharpeningstoneoh = { grouping = "Weapon", name = "Dense Sharpening Stone (offhand)", identifiers = {}, type = "wepbuffonly", buffFunc = RAB_UseItem, itemId = 12404, useOn = 'weaponOH' },

	elementalsharpeningstone = { grouping = "Weapon", name = "Elemental Sharpening Stone", identifiers = {}, type = "wepbuffonly", buffFunc = RAB_UseItem, itemId = 18262, useOn = 'weapon' },
	elementalsharpeningstoneoh = { grouping = "Weapon", name = "Elemental Sharpening Stone (offhand)", identifiers = {}, type = "wepbuffonly", buffFunc = RAB_UseItem, itemId = 18262, useOn = 'weaponOH' },

	--Deadly Poison V 20844
	deadlypoison = {grouping = "Poisons", name = "Deadly Poison", identifiers = {}, type = "wepbuffonly", buffFunc = RAB_UseItem, itemId = 20844, useOn = 'weapon' },
	deadlypoisonoh = {grouping = "Poisons", name = "Deadly Poison (offhand)", identifiers = {}, type = "wepbuffonly", buffFunc = RAB_UseItem, itemId = 20844, useOn = 'weaponOH' },

	--Instant Poison VI 8928
	instantpoison = {grouping = "Poisons", name = "Instant Poison", identifiers = {}, type = "wepbuffonly", buffFunc = RAB_UseItem, itemId = 8928, useOn = 'weapon' },
	instantpoisonoh = {grouping = "Poisons", name = "Instant Poison (offhand)", identifiers = {}, type = "wepbuffonly", buffFunc = RAB_UseItem, itemId = 8928, useOn = 'weaponOH' },

	--Mind-numbing Poison III 9186
	mindnumbingpoison = {grouping = "Poisons", name = "Mind-numbing Poison", identifiers = {}, type = "wepbuffonly", buffFunc = RAB_UseItem, itemId = 9186, useOn = 'weapon' },
	mindnumbingpoisonoh = {grouping = "Poisons", name = "Mind-numbing Poison (offhand)", identifiers = {}, type = "wepbuffonly", buffFunc = RAB_UseItem, itemId = 9186, useOn = 'weaponOH' },

	--Wound Poison IV 10922
	woundpoison = {grouping = "Poisons", name = "Wound Poison", identifiers = {}, type = "wepbuffonly", buffFunc = RAB_UseItem, itemId = 10922, useOn = 'weapon' },
	woundpoisonoh = {grouping = "Poisons", name = "Wound Poison (offhand)", identifiers = {}, type = "wepbuffonly", buffFunc = RAB_UseItem, itemId = 10922, useOn = 'weaponOH' },

	--Crippling Poison II 3776
	cripplingpoison = {grouping = "Poisons", name = "Crippling Poison", identifiers = {}, type = "wepbuffonly", buffFunc = RAB_UseItem, itemId = 3776, useOn = 'weapon' },
	cripplingpoisonoh = {grouping = "Poisons", name = "Crippling Poison (offhand)", identifiers = {}, type = "wepbuffonly", buffFunc = RAB_UseItem, itemId = 3776, useOn = 'weaponOH' },

	--Corrosive Poison II 47409
	corrosivepoison = {grouping = "Poisons", name = "Corrosive Poison", identifiers = {}, type = "wepbuffonly", buffFunc = RAB_UseItem, itemId = 47409, useOn = 'weapon' },
	corrosivepoisonoh = {grouping = "Poisons", name = "Corrosive Poison (offhand)", identifiers = {}, type = "wepbuffonly", buffFunc = RAB_UseItem, itemId = 47409, useOn = 'weaponOH' },

	-- Food/drink
	blessedsunfruit = { name = "Blessed Sunfruit", identifiers = { { tooltip = "Blessed Sunfruit", texture = "Spell_Misc_Food", spellId = 18125 } }, grouping = "Food/Drink", buffFunc = RAB_UseItem, itemId = 13810 },
	blessedsunfruitjuice = { name = "Blessed Sunfruit Juice", identifiers = { { tooltip = "Blessed Sunfruit Juice", texture = "Spell_Holy_LayOnHands", spellId = 18141 } }, grouping = "Food/Drink", buffFunc = RAB_UseItem, itemId = 13813 },
	nightfinsoup = { name = "Nightfin Soup", identifiers = { { tooltip = "Mana Regeneration", texture = "Spell_Nature_ManaRegenTotem", spellId = 18194 } }, grouping = "Food/Drink", buffFunc = RAB_UseItem, itemId = 13931 },
	herbalsalad = { name = "Herbal Salad", identifiers = { { tooltip = "Increased Healing Bonus", texture = "Spell_Nature_HealingWay", spellId = 49553 } }, grouping = "Food/Drink", buffFunc = RAB_UseItem, itemId = 83309 },
	sagefish = { name = "Sagefish Delight", identifiers = { { tooltip = "Mana Regeneration", texture = "inv_misc_fish_21", spellId = 25889 } }, grouping = "Food/Drink", buffFunc = RAB_UseItem, itemId = 21217 },
	mushroomstam = { name = "Hardened Mushroom", identifiers = { { tooltip = "Increased Stamina", texture = "INV_Boots_Plate_03", spellId = 25661 } }, grouping = "Food/Drink", buffFunc = RAB_UseItem, itemId = 51717 },
	mushroomstr = { name = "Power Mushroom", identifiers = { { tooltip = "Well Fed", texture = "Spell_Misc_Food", spellId = 24799 } }, grouping = "Food/Drink", buffFunc = RAB_UseItem, itemId = 51720 },
	desertdumpling = { name = "Smoked Desert Dumpling", identifiers = { { tooltip = "Well Fed", texture = "Spell_Misc_Food", spellId = 24799 } }, grouping = "Food/Drink", buffFunc = RAB_UseItem, itemId = 20452 },
	tenderwolf = { name = "Tender Wolf Steak", identifiers = { { tooltip = "Well Fed", texture = "Spell_Misc_Food", spellId = 19710 } }, grouping = "Food/Drink", buffFunc = RAB_UseItem, itemId = 18045 },
	juicystripedmelonstam = { name = "Juicy Striped Melon (stam)", identifiers = { { tooltip = "Well Fed", texture = "Spell_Misc_Food", spellId = 19710 } }, grouping = "Food/Drink", buffFunc = RAB_UseItem, itemId = 51712 },
	gilneashotstew = { name = "Gilneas Hot Stew", identifiers = { { tooltip = "Well Fed", texture = "Spell_Misc_Food", spellId = 45628 } }, grouping = "Food/Drink", buffFunc = RAB_UseItem, itemId = 84041 },
	sweetmountainberry = { name = "Sweet Mountain Berry", identifiers = { { tooltip = "Increased Agility", texture = "INV_Gauntlets_19", spellId = 18192 } }, grouping = "Food/Drink", buffFunc = RAB_UseItem, itemId = 51711 },
	telabimmedley = { name = "Danonzo's Tel'Abim Medley", identifiers = { { tooltip = "Well Fed", texture = "Spell_Misc_Food", spellId = 57046 } }, grouping = "Food/Drink", buffFunc = RAB_UseItem, itemId = 60978 },
	telabimdelight = { name = "Danonzo's Tel'Abim Delight", identifiers = { { tooltip = "Well Fed", texture = "Spell_Misc_Food", spellId = 57044 } }, grouping = "Food/Drink", buffFunc = RAB_UseItem, itemId = 60977 },
	telabimsurprise = { name = "Danonzo's Tel'Abim Surprise", identifiers = { { tooltip = "Well Fed", texture = "Spell_Misc_Food", spellId = 57042 } }, grouping = "Food/Drink", buffFunc = RAB_UseItem, itemId = 60976 },
	tuber = { name = "Runn Tum Tuber Surprise", identifiers = { { tooltip = "Increased Intellect", texture = "INV_Misc_Organ_03", spellId = 22730 } }, grouping = "Food/Drink", buffFunc = RAB_UseItem, itemId = 18254 },
	juicystripedmelonint = { name = "Juicy Striped Melon (int)", identifiers = { { tooltip = "Increased Intellect", texture = "INV_Misc_Organ_03", spellId = 22730 } }, grouping = "Food/Drink", buffFunc = RAB_UseItem, itemId = 51718 },
	squid = { name = "Grilled Squid", identifiers = { { tooltip = "Increased Agility", texture = "INV_Gauntlets_19", spellId = 18192 } }, grouping = "Food/Drink", buffFunc = RAB_UseItem, itemId = 13928 },
	dragonbreathchili = { name = "Dragonbreath Chili", identifiers = { { tooltip = "Dragonbreath Chili", texture = "Spell_Fire_Incinerate", spellId = 15852 } }, grouping = "Food/Drink", buffFunc = RAB_UseItem, itemId = 12217 },
	merlotblue = { name = "Medivh's Merlot Blue", identifiers = {
		{ tooltip = "Increased Intellect", texture = "INV_Drink_04", spellId = 57107 },
		{ tooltip = "Rumsey Rum Black Label", texture = "INV_Drink_04", spellId = 25804 }, -- doesn't stack with rum
	}, grouping = "Food/Drink", buffFunc = RAB_UseItem, itemId = 61175 },
	merlot = { name = "Medivh's Merlot", identifiers = {
		{ tooltip = "Increased Stamina", texture = "INV_Drink_04", spellId = 57106 },
		{ tooltip = "Rumsey Rum Black Label", texture = "INV_Drink_04", spellId = 25804 }, -- doesn't stack with rum
	}, grouping = "Food/Drink", buffFunc = RAB_UseItem, itemId = 61174 },
	rumseyrum = { name = "Rumsey Rum Black Label", identifiers = {
		{ tooltip = "Rumsey Rum Black Label", texture = "INV_Drink_04", spellId = 25804 },
		{ tooltip = "Increased Stamina", texture = "INV_Drink_04", spellId = 57106 }, -- doesn't stack with merlot
		{ tooltip = "Increased Intellect", texture = "INV_Drink_04", spellId = 57107 }, -- doesn't stack with merlot blue
	}, grouping = "Food/Drink", buffFunc = RAB_UseItem, itemId = 21151 },
	gordokgreengrog = { name = "Gordok Green Grog", identifiers = { { tooltip = "Gordok Green Grog", texture = "INV_Drink_03", spellId = 22789 } }, grouping = "Food/Drink", buffFunc = RAB_UseItem, itemId = 18269 },

	wellfed = { name = "Well Fed", identifiers = { { tooltip = "Well Fed", texture = "Spell_Misc_Food" } }, grouping = "Food/Drink" },
	anyfood = { name = "Any Food", identifiers = {
		{ tooltip = "Well Fed", texture = "Spell_Misc_Food" },
		{ tooltip = "Increased Stamina", texture = "INV_Boots_Plate_03" },
		{ tooltip = "Mana Regeneration", texture = "Spell_Nature_ManaRegenTotem" },
		{ tooltip = "Increased Agility", texture = "INV_Gauntlets_19" },
		{ tooltip = "Increased Intellect", texture = "INV_Misc_Organ_03" }
	}, grouping = "Food/Drink" },
};
