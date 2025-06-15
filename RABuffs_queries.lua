-- RABuffs_data.lua
--  Dictionary between RABuffs_core.lua and user -- provides core-information for queriable effects.
-- Version 0.10.1
-- BLOCK 1: Query functions
-- BLOCK 2: Casting functions
-- BLOCK 3: Query definitions


RAB_PendingRes = {}; --Name=expire;
RAB_BuffTimers = {}; -- Name.query = expire;

function RAB_ShouldRecast(unit, buffKey, isbuffed)
	local bkey = UnitName(unit) .. "." .. buffKey;
	if (RAB_BuffTimers[bkey] ~= nil and RAB_BuffTimers[bkey] > GetTime() and RAB_Buffs[buffKey].recast ~= nil) then
		if (isbuffed) then
			fadetime = RAB_BuffTimers[bkey] - GetTime();
			if (fadetime < RAB_Buffs[buffKey].recast * 60) then
				return true, fadetime;
			end
			return false, fadetime;
		else
			RAB_BuffTimers[bkey] = 0;
		end
	end
	return false;
end

function RAB_ResetRecastTimer(unit, userData, castType)
	local i, u, g, m;
	if (castType == nil) then
		RAB_BuffTimers[UnitName(unit) .. "." .. userData.buffKey] = 0;
	elseif (castType == "group") then
		for i, u, g in RAB_GroupMembers(userData) do
			if (UnitIsUnit(unit, u)) then
				m = g;
				break ;
			end
		end
		for i, u, g in RAB_GroupMembers(userData) do
			if (g == m) then
				RAB_BuffTimers[UnitName(u) .. "." .. userData.buffKey] = 0;
			end
		end
	elseif (castType == "class") then
		m = RAB_UnitClass(unit);
		for i, u, g in RAB_GroupMembers(userData) do
			if (RAB_UnitClass(u) == m) then
				RAB_BuffTimers[UnitName(u) .. "." .. userData.buffKey] = 0;
			end
		end
	end
end

-- BLOCK 1: Query functions
function RAB_CollectPlayerWeaponBuffs(buffData)
	local results = {}

	-- if it's for a weapon, no need to scan everything
	if buffData.useOn == 'weapon' or buffData.useOn == 'weaponOH' then
		-- there can be 0 1 2 weapons
		for i, slotName in { 'MainHandSlot', 'SecondaryHandSlot' } do
			local slotId = GetInventorySlotInfo(slotName);
			local itemLink = GetInventoryItemLink('player', slotId);
			if itemLink then
				results[slotName] = { name = slotName, texture = 'nomatch1234', buffed = 0 }
			end
		end

		local mh, mhtime, mhcharge, oh, ohtime, ohcharge = GetWeaponEnchantInfo()
		-- RAB_Print(string.format("%s %s %s %s %s %s", tostring(mh), tostring(mhtime), tostring(mhcharge), tostring(oh), tostring(ohtime), tostring(ohcharge)))
		if mh and results['MainHandSlot'] then
			results['MainHandSlot']['buffed'] = 1
		end
		if oh and results['SecondaryHandSlot'] then
			results['SecondaryHandSlot']['buffed'] = 1
		end

		return results
	end

	return results
end

-- Uses either the buff name or a combination of the tooltip and texture to identify the buff
function RAB_GetBuffKeys(buffData)
	local keys = {}
	-- if there are identifiers, use those
	if buffData.identifiers then
		for _, identifier in ipairs(buffData.identifiers) do
			table.insert(keys, identifier.tooltip .. identifier.texture)
		end
	else
		-- otherwise use name
		table.insert(keys, buffData.name)
	end

	return keys
end

function RAB_WeaponIsBuffed(weaponBuffs, buffData)
	local buffed = 0

	-- custom handling for weapon enchants
	if buffData.useOn == 'weapon' then
		buffed = 1
		local slotName = 'MainHandSlot'
		if weaponBuffs[slotName] == nil then
			buffed = 0
		end                                        -- no wep, thus not buffed
		if weaponBuffs[slotName] ~= nil and weaponBuffs[slotName]['buffed'] == 0 then
			buffed = 0
		end -- wep with no buff on it
		return buffed
	end
	if buffData.useOn == 'weaponOH' then
		buffed = 1
		local slotName = 'SecondaryHandSlot'
		if weaponBuffs[slotName] == nil then
			buffed = 0
		end                                        -- no wep, thus not buffed
		if weaponBuffs[slotName] ~= nil and weaponBuffs[slotName]['buffed'] == 0 then
			buffed = 0
		end -- wep with no buff on it
		return buffed
	end

	return buffed
end

function RAB_DefaultQueryHandler(userData, needraw, needtxt)
	local buffData = RAB_Buffs[userData.buffKey]
	local buffed, fading, total, misc, txthead, hashead, txt, hastxt, invert, raw, rawsort, rawgroup = 0, 0, 0, "", "",
	"", "", "", (buffData.invert ~= nil);
	local buffname = buffData.name;
	local i, u, key, val, group, isbuffed;
	local hasSpecialFunc = buffData.sfunc ~= nil
	local sfunc = buffData.sfunc

	if (hasSpecialFunc == false) then
		if (buffData.type ~= "debuff") then
			sfunc = isUnitBuffUp;
		else
			sfunc = isUnitDebuffUp;
		end
	end

	if (needraw or needtxt) then
		raw = {};
		rawsort = "group";
		rawgroup = sRAB_Core_GroupFormat;
	end

	if buffData.useOn == 'weapon' or buffData.useOn == 'weaponOH' then
		local buffs = RAB_CollectPlayerWeaponBuffs(buffData)
		buffed = RAB_WeaponIsBuffed(buffs, buffData)
		total = 1
	else
		for i, u, group in RAB_GroupMembers(userData) do
			local appl, fadetime, isFading = 0;
			if (RAB_IsEligible(u, userData)) then
				isbuffed = false;

				if hasSpecialFunc then
					if sfunc(u) then
						isbuffed = true
					end
				else
					-- check all identifiers
					for _, identifier in ipairs(buffData.identifiers) do
						if (sfunc(u, identifier)) then
							isbuffed = true
							_, appl = sfunc(u, identifier);
							break ;
						end
					end
				end

				isFading, fadetime = RAB_ShouldRecast(u, userData.buffKey, isbuffed);
				fading = fading + (isFading and 1 or 0);

				if (needraw or needtxt) then
					tinsert(raw,
							{
								unit = u,
								name = UnitName(u) .. ((appl ~= nil and appl > 1) and " [" .. appl .. "]" or ""),
								class = RAB_UnitClass(u),
								group = group,
								buffed = isbuffed,
								fade = fadetime
							});
				end

				if (buffData.unique == nil or (buffData.unique == true and RAB_UnitClass(u) == buffData.class)) then
					total = total + 1;
				end

				buffed = buffed + (isbuffed and 1 or 0);
			end
		end
	end

	if (not (needraw or needtxt)) then
		return buffed, fading, total, "";
	end

	if (total > 1 and UnitInRaid("player") and (needraw or needtxt)) then
		if (buffData.sort == "class") then
			rawsort = "class";
			rawgroup = "%s";
			table.sort(raw, function(a, b)
				return a.class < b.class
			end);
		else
			table.sort(raw, function(a, b)
				return a.group < b.group
			end);
		end
	end

	txthead = ((buffData.missbuff ~= nil) and buffData.missbuff or string.format(sRAB_BuffOutput_MissingOn, buffname)) ..
			":";
	hashead = ((buffData.havebuff ~= nil) and buffData.havebuff or string.format(sRAB_BuffOutput_IsOn, buffname)) ..
			":";

	if (table.getn(raw) > 0) then
		local ub, bb, uc, bc, ident = "", "", 0, 0, false;

		for i = 1, table.getn(raw) do
			if (ident ~= raw[i][rawsort] and ident ~= false) then
				if (uc == 0) then
					if (bc > 1) then
						hastxt = hastxt ..
								(hastxt ~= "" and ", " or "") ..
								(rawsort == "group" and sRAB_BuffOutput_Group or "") ..
								ident .. (rawsort == "class" and "s" or "") .. " [" .. bc .. "]";
					else
						hastxt = hastxt .. (hastxt ~= "" and ", " or "") .. bb;
					end
				elseif (bc == 0) then
					if (uc > 1) then
						txt = txt ..
								(txt ~= "" and ", " or "") ..
								(rawsort == "group" and sRAB_BuffOutput_Group or "") ..
								ident .. (rawsort == "class" and "s" or "") .. " [" .. uc .. "]";
					else
						txt = txt .. (txt ~= "" and ", " or "") .. ub;
					end
				else
					hastxt = hastxt .. (hastxt ~= "" and ", " or "") .. bb;
					txt = txt .. (txt ~= "" and ", " or "") .. ub;
				end
				ub, bb, uc, bc = "", "", 0, 0;
			end

			ident = raw[i][rawsort];

			if (raw[i].buffed) then
				bc = bc + 1;
				bb = bb ..
						((bb ~= "") and ", " or "") .. raw[i].name .. " [" .. raw[i].class .. "; G" .. raw[i].group .. "]";
			else
				uc = uc + 1;
				ub = ub ..
						((ub ~= "") and ", " or "") .. raw[i].name .. " [" .. raw[i].class .. "; G" .. raw[i].group .. "]";
			end
		end

		if (uc == 0) then
			hastxt = hastxt ..
					(hastxt ~= "" and ", " or "") ..
					(rawsort == "group" and sRAB_BuffOutput_Group or "") ..
					ident .. (rawsort == "class" and "s" or "") .. " [" .. bc .. "]";
		elseif (bc == 0) then
			txt = txt ..
					(txt ~= "" and ", " or "") ..
					(rawsort == "group" and sRAB_BuffOutput_Group or "") ..
					ident .. (rawsort == "class" and "s" or "") .. " [" .. uc .. "]";
		else
			hastxt = hastxt .. (hastxt ~= "" and ", " or "") .. bb;
			txt = txt .. (txt ~= "" and ", " or "") .. ub;
		end

		if (buffed == total and total > 0) then
			txt = string.format(sRAB_BuffOutput_EveryoneHas, buffData.name);
			hastxt = txt;
		elseif (buffed > 0) then
			txt = txthead .. " [" .. (total - buffed) .. " / " .. total .. "] " .. txt .. ".";
			hastxt = hashead .. " [" .. buffed .. " / " .. total .. "] " .. hastxt .. ".";
		else
			txt = string.format(sRAB_BuffOutput_EveryoneMissing, buffData.name);
			hastxt = txt;
		end
	else
		txt = buffData.name .. ": not applicable.";
		hastxt = buffData.name .. ": not applicable.";
	end

	return buffed, fading, total, misc, txthead, hashead, txt, hastxt, invert, raw, rawsort, rawgroup;
end

function RAB_QueryStatus(userData)
	-- Overview.
	local out, buffed, total = "", 0, 0;

	-- copy userData
	local data = {}
	for k, v in pairs(userData) do
		data[k] = v
	end

	local buffsToCheck = {
		"ai",
		"pwf",
		"motw",
		"bos",
		"bok",
		"bow",
	}

	for _, buff in ipairs(buffsToCheck) do
		data.buffKey = buff
		buffed, _, total = RAB_CallRaidBuffCheck(data, false, false);
		out = out .. buff .. ": " .. buffed .. "/" .. total .. ", ";
	end

	-- handle ss separately
	data.buffKey = "ss"
	buffed, _, total = RAB_CallRaidBuffCheck(data, false, false);
	out = out .. buffed .. " ss.";

	return 1, 0, 1, "", "", "", out, out;
end

function RAB_QueryBlank()
	return 0, 0, 0, "";
end

function RAB_QueryBuffInfo()
	local buffs, debuffs, i, buff, bn = "", "", 1;
	if (not UnitExists("target")) then
		return 0, 0, 0, "", "", "", sRAB_BuffOutput_BuffInfo_NoTarget, sRAB_BuffOutput_BuffInfo_NoTarget, false;
	end
	while (UnitBuff("target", i)) do
		buff = RAB_TextureToBuff(UnitBuff("target", i));
		if (bn ~= nil) then
			b = "[" .. RAB_Buffs[bn].name .. "]";
		end
		buffs = buffs .. (buffs == "" and "" or ", ") .. b;
		i = i + 1;
	end
	i = 1;
	while (UnitDebuff("target", i)) do
		b = string.sub(UnitDebuff("target", i), 17);
		debuffs = debuffs .. (debuffs == "" and "" or ", ") .. b;
		i = i + 1;
	end
	local text = string.format(sRAB_BuffOutput_BuffInfo_General, UnitName("target"),
			(buffs == "" and sRAB_BuffOutput_BuffInfo_None or buffs),
			(debuffs == "" and sRAB_BuffOutput_BuffInfo_None or debuffs));
	return 0, 0, 0, "", "", "", text, text;
end

function RAB_QueryHere(userData, needraw, needtxt)
	local buffed, total, misc, txthead, hashead, txt, hastxt, invert, raw, rawsort = 0, 0, "",
	sRAB_BuffOutput_Here_NotHere, sRAB_BuffOutput_Here_Here, sRAB_BuffOutput_Here_NotHere .. " ",
	sRAB_BuffOutput_Here_Here .. " ", false, nil, "append";
	if (needraw) then
		raw = {};
	end
	local inraid = UnitInRaid("player");
	local myzone = "noraid";
	local zone, group;

	if (inraid) then
		for i = 1, 40 do
			if (UnitIsUnit("raid" .. i, "player")) then
				_, _, group, _, _, _, myzone = GetRaidRosterInfo(i);
			end
		end
	end

	local isbuffed, append;
	for i, u, group in RAB_GroupMembers(userData) do
		if (inraid) then
			_, _, group, _, _, _, zone = GetRaidRosterInfo(i);
			zone = tostring(zone);
			group = tonumber(group);
		else
			zone = sRAB_BuffOutput_Here_OK;
			group = 1;
		end
		total = total + 1;
		append = "";
		isbuffed = false;
		if (inraid and RAB_CTRA_IsAFK(UnitName(u))) then
			if (needtxt) then
				txt = txt .. UnitName(u) .. " [" .. sRAB_BuffOutput_Here_AFK .. "], ";
			end
			if (needraw) then
				zone = sRAB_BuffOutput_Here_AFK;
			end
		elseif (not UnitIsConnected(u)) then
			if (needtxt) then
				txt = txt .. UnitName(u) .. " [" .. sRAB_BuffOutput_Here_OFF .. "], ";
			end
			if (needraw) then
				zone = sRAB_BuffOutput_Here_OFF;
			end
		elseif (inraid and (zone ~= myzone and not UnitIsVisible(u))) then
			if (needtxt) then
				txt = txt .. UnitName(u) .. " [" .. zone .. "], ";
			end
		elseif (not UnitIsVisible(u)) then
			if (needtxt) then
				txt = txt .. UnitName(u) .. " [" .. sRAB_BuffOutput_Here_OOS .. "], ";
			end
			if (needraw) then
				zone = sRAB_BuffOutput_Here_OOS;
			end
		else
			if (needtxt) then
				hastxt = hastxt .. UnitName(u) .. ", ";
			end
			buffed = buffed + 1;
			isbuffed = true;
		end
		--		if (UnitInRaid("player")) then append = " [" .. group .. "]"; end
		if (needraw) then
			tinsert(raw,
					{
						name = UnitName(u),
						class = RAB_UnitClass(u),
						group = group,
						buffed = false,
						unit = u,
						append = append,
						buffed = isbuffed,
						zone = zone
					});
		end
	end
	if (total > 1 and needraw and UnitInRaid("player")) then
		table.sort(raw, function(a, b)
			return a.zone < b.zone
		end);
	end
	if (needtxt) then
		if (buffed == total) then
			txt = sRAB_BuffOutput_Here_Everyone;
			hastxt = sRAB_BuffOutput_Here_Everyone;
		else
			txt = strsub(txt, 1, -3) .. ".";
			hastxt = strsub(hastxt, 1, -3) .. ".";
		end
	end
	return buffed, 0, total, misc, txthead, hashead, txt, hastxt, invert, raw, "zone", "%s";
end

function RAB_QueryCTRAVersion(userData, needraw, needtxt)
	local buffed, total, misc, txthead, hashead, txt, hastxt, invert, raw, rawsort = 0, 0, "",
	sRAB_BuffOutput_CTRA_OutOfDate, sRAB_BuffOutput_CTRA_Recent, sRAB_BuffOutput_CTRA_OutOfDate .. " ",
	sRAB_BuffOutput_CTRA_Recent .. " ", false;
	if (needraw) then
		raw = {};
		rawsort = "group";
	end
	if (RAB_CTRA_ResponsibleHandler ~= "CTRA") then
		return 0, 0, 0, sRAB_BuffOutput_CTRA_NoCTRA, "", "", sRAB_BuffOutput_CTRA_NoCTRA, sRAB_BuffOutput_CTRA_NoCTRA;
	end
	local i, pv, isbuffed = 1, RAB_CTRA_GetVersion(UnitName("player"));

	if (not UnitInRaid("player")) then
		txt = sRAB_BuffOutput_CTRA_NotInRaid;
		hastxt = txt;
	else
		for i, u, group in RAB_GroupMembers(userData) do
			local cv = RAB_CTRA_GetVersion(UnitName(u));
			if (cv) then
				total = total + 1;
				isbuffed = false;
				append = "";
				if (cv >= pv) then
					isbuffed = true;
					buffed = buffed + 1;
					hastxt = hastxt .. UnitName(u) .. ", ";
				else
					txt = txt .. UnitName(u) .. " [" .. cv .. "], ";
				end
				if (needraw) then
					tinsert(raw,
							{
								name = UnitName(u),
								class = RAB_UnitClass(u),
								group = group,
								buffed = isbuffed,
								unit = u,
								version = cv
							});
				end
			end
		end
		if (total > 1 and UnitInRaid("player") and needraw) then
			table.sort(raw, function(a, b)
				return a.version < b.version
			end);
		end
		if (needtxt) then
			if (buffed == total) then
				txt = sRAB_BuffOutput_CTRA_Everyone;
				hastxt = sRAB_BuffOutput_CTRA_Everyone;
			else
				txt = strsub(txt, 1, -3) .. ".";
				hastxt = strsub(hastxt, 1, -3) .. ".";
			end
		end
	end
	return buffed, 0, total, misc, txthead, hashead, txt, hastxt, invert, raw, "version", "%s";
end

function RAB_ScanRaid(userData)
	local scanwhat = RAB_Buffs[userData.buffKey].ext;
	local out, oc, buff, texture = "", {};
	for i, u, group in RAB_GroupMembers(userData) do
		local j = 1;
		while (UnitBuff(u, j)) do
			buff = RAB_TextureToBuff(UnitBuff(u, j));
			if (buff ~= nil and scanwhat == "known") then
				oc[buff] = (oc[buff] ~= nil and oc[buff] or 0) + 1;
			elseif (buff == nil and scanwhat == "unknown") then
				texture = RAB_SanitizeTexture(UnitBuff(u, j));
				oc[texture] = (oc[texture] ~= nil and oc[texture] or 0) + 1;
			end
			j = j + 1;
		end
	end
	for key, val in oc do
		out = (out == "" and "" or (out .. ", ")) ..
				"[" .. (scanwhat == "known" and RAB_Buffs[userData.buffKey].name or key) .. "]x" .. val;
	end

	out = (scanwhat == "known" and "B" or "Unknown b") .. "uffs: " .. (out == "" and "none" or out) .. ".";
	return 1, 1, "", "", "", out, out;
end

function RAB_QueryHealth(userData, needraw, needtxt)
	local type = RAB_Buffs[userData.buffKey].ext;
	local buffed, fading, total, misc, txthead, hashead, txt, hastxt, invert, raw, rawsort = 0, 0, 0, "",
	sRAB_BuffOutput_Health_Dead, sRAB_BuffOutput_Health_Alive, "", "", false;
	local i, hp_cur, hp_max, hp_alive, hp_dead, hp_deadtext, hp_alivetext = 0, 0, 0, 0, 0, "", "";
	if (needraw) then
		raw = {};
	end
	local group, uinfo, u, isbuffed, append;

	for i, u, group in RAB_GroupMembers(userData) do
		total = total + 1;
		append = "";
		isbuffed = false;
		if (RAB_UnitIsDead(u)) then
			hp_dead = hp_dead + 1;
			hp_deadtext = (hp_dead == 1 and "" or (hp_deadtext .. ", ")) .. UnitName(u);
		else
			hp_alive = hp_alive + 1;
			hp_alivetext = (hp_alive == 1 and "" or (hp_alivetext .. ", ")) .. UnitName(u);
			hp_cur = hp_cur + UnitHealth(u);
			hp_max = hp_max + UnitHealthMax(u);
			buffed = buffed + 1;
			isbuffed = true;
			if (UnitHealth(u) / UnitHealthMax(u) < 0.15) then
				fading = fading + 1;
			end
		end
		if (needraw) then
			tinsert(raw,
					{
						name = UnitName(u),
						class = RAB_UnitClass(u),
						group = group,
						buffed = isbuffed,
						unit = u,
						append = append
					});
		end
	end
	if (total > 1 and UnitInRaid("player") and needraw) then
		table.sort(raw, function(a, b)
			return a.group < b.group
		end);
	end
	if (hp_dead > 0) then
		misc = string.format(sRAB_BuffOutput_Health_Misc, hp_dead);
	end

	if (type == "hp") then
		buffed = hp_cur;
		total = hp_max;
		fading = 0;
	end
	if (needtxt) then
		if (hp_dead > 0) then
			if (hp_alive > 0) then
				txt = string.format(sRAB_BuffOutput_Health_Default, hp_cur, hp_max,
						floor(hp_cur * 100 / (hp_max > 0 and hp_max or 1)),
						string.format(sRAB_BuffOutput_Health_DeadPart, hp_dead, hp_deadtext));
				hastxt = string.format(sRAB_BuffOutput_Health_Default, hp_cur, hp_max,
						floor(hp_cur * 100 / (hp_max > 0 and hp_max or 1)),
						string.format(sRAB_BuffOutput_Health_AlivePart, hp_alive, hp_alivetext));
			else
				repl.txt = sRAB_BuffOutput_Health_EveryoneDead;
				repl.hastxt = sRAB_BuffOutput_Health_EveryoneDead;
			end
		else
			txt = string.format(sRAB_BuffOutput_Health_Default, hp_cur, hp_max,
					floor(hp_cur * 100 / (hp_max > 0 and hp_max or 1)), ".");
			hastxt = txt;
		end
	end
	return buffed, fading, total, misc, txthead, hashead, txt, hastxt, invert, raw, "group", sRAB_Core_GroupFormat;
end

function RAB_QueryInventoryItem(userData, needraw, needtxt)
	local _, _, slot, match = string.find(RAB_Buffs[userData.buffKey].ext, "(%d+):(%d+)");
	slot, match = tonumber(slot), tonumber(match);
	local itemName = GetItemInfo(match);
	if (itemName == nil) then
		itemName = string.format(sRAB_BuffOutput_Item_Unknown, match);
	end

	local buffed, total, misc, txthead, hashead, txt, hastxt, invert, raw, rawsort = 0, 0, "",
	string.format(sRAB_BuffOutput_Item_Missing, itemName), string.format(sRAB_BuffOutput_Item_Have, itemName), "", "",
	false;
	if (needraw) then
		raw = {};
	end
	local i, u, group, isbuffed, item;

	for i, u, group in RAB_GroupMembers(userData) do
		if (CheckInteractDistance(u, 1) and GetInventoryItemLink(u, slot)) then
			total = total + 1;
			isbuffed = false;
			_, _, item = string.find(tostring(GetInventoryItemLink(u, slot)), "item:(%d+):");
			if (tonumber(item) == match) then
				isbuffed = true;
				buffed = buffed + 1;
				hastxt = hastxt .. UnitName(u) .. ", ";
			else
				txt = txt .. UnitName(u) .. ", ";
			end
			if (needraw) then
				tinsert(raw,
						{
							name = UnitName(u),
							class = RAB_UnitClass(u),
							group = group,
							buffed = isbuffed,
							unit = u,
							append = append
						});
			end
		end
	end
	if (total > 1 and UnitInRaid("player") and needraw) then
		table.sort(raw, function(a, b)
			return a.group < b.group
		end);
	end

	if (needtxt) then
		if (buffed == total) then
			txt = string.format(sRAB_BuffOutput_Item_Everyone, itemName);
			hastxt = string.format(sRAB_BuffOutput_Item_Everyone, itemName);
		elseif (buffed > 0) then
			txt = txthead .. " " .. strsub(txt, 1, -3) .. ".";
			hastxt = hashead .. " " .. strsub(hastxt, 1, -3) .. ".";
		else
			txt = string.format(sRAB_BuffOutput_Item_NoOne, itemName);
			hastxt = string.format(sRAB_BuffOutput_Item_NoOne, itemName);
		end
	end
	return buffed, 0, total, misc, txthead, hashead, txt, hastxt, invert, raw, "group", sRAB_Core_GroupFormat;
end

function RAB_QueryMana(userData, needraw, needtxt)
	local buffed, fading, total, misc, txthead, hashead, txt, hastxt, invert, raw, rawsort = 0, 0, 0, "",
	sRAB_BuffOutput_Mana_OutOfMana, sRAB_BuffOutput_Mana_Fine, "", "", false;
	local mana_max, mana_cur, mana_dead, mana_oom, mana_oomt = 0, 0, 0, 0, "";
	if (needraw) then
		raw = {};
	end
	local group, u, i, isbuffed, append = 0, "", 0;

	for i, u, group in RAB_GroupMembers(userData) do
		if (UnitPowerType(u) == 0) then
			total = total + 1;
			isbuffed = false;
			append = "";
			if (RAB_UnitIsDead(u)) then
				mana_dead = mana_dead + 1;
				append = sRAB_BuffOutput_Mana_DeadAppend;
			else
				mana_cur = mana_cur + UnitMana(u);
				mana_max = mana_max + UnitManaMax(u);
				if (UnitMana(u) < UnitManaMax(u) * 0.15) then
					mana_oom = mana_oom + 1;
					append = " (" .. UnitMana(u) .. " mana)";
				else
					append = " (" .. floor(UnitMana(u) * 100 / UnitManaMax(u)) .. "%)";
					isbuffed = true;
					if (UnitMana(u) < UnitManaMax(u) * 0.25) then
						fading = fading + UnitMana(u);
					end
				end
			end
			if (needraw) then
				tinsert(raw,
						{
							name = UnitName(u),
							class = RAB_UnitClass(u),
							group = group,
							buffed = isbuffed,
							unit = u,
							append = append
						});
			end
		end
	end
	if (total > 1 and UnitInRaid("player") and needraw) then
		table.sort(raw, function(a, b)
			return a.group < b.group
		end);
	end
	buffed, total = mana_cur, mana_max;

	if (mana_oom > 0 or mana_dead > 0) then
		misc = " (" .. mana_oom .. " oom; " .. mana_dead .. " dead)";
		misc = string.gsub(string.gsub(misc, "; 0 dead", ""), "0 oom; ", "");
	end

	if (needtxt) then
		txt = "Mana: " ..
				mana_cur ..
				" / " ..
				mana_max ..
				" (" ..
				(mana_max > 0 and floor(mana_cur * 100 / mana_max) or "0") ..
				"%); " .. mana_oom .. " oom; " .. mana_dead .. " dead.";
		txt = string.gsub(string.gsub(txt, "; 0 oom", ""), "; 0 dead", "");
		hastxt = txt;
	end
	return buffed, fading, total, misc, txthead, hashead, txt, hastxt, invert, raw, "group", sRAB_Core_GroupFormat;
end

function RAB_QueryWater(userData, needraw, needtxt)
	local buffed, total, misc, txthead, hashead, txt, hastxt, invert, raw, rawsort = 0, 0, "", sRAB_BuffOutput_Water_Out,
	sRAB_BuffOutput_Water_Have, sRAB_BuffOutput_Water_Out .. " ", sRAB_BuffOutput_Water_Have .. " ", false;
	if (needraw) then
		raw = {};
	end

	local isbuffed, append;
	for i, u, group in RAB_GroupMembers(userData) do
		if (UnitIsUnit(u, "player")) then
			RAB_BuffTimers[UnitName(u) .. ".h2oc"] = RAB_CountItems(8079);
		end
		if (RAB_BuffTimers[UnitName(u) .. ".h2oc"] ~= nil) then
			total = total + 1;
			append = " [" .. RAB_BuffTimers[UnitName(u) .. ".h2oc"] .. "]";
			isbuffed = false;
			isbuffed = (RAB_BuffTimers[UnitName(u) .. ".h2oc"] > 3);
			if (needtxt and isbuffed) then
				hastxt = hastxt .. UnitName(u) .. " [" .. RAB_BuffTimers[UnitName(u) .. ".h2oc"] .. "], ";
			elseif (needtxt and not isbuffed) then
				txt = txt .. UnitName(u) .. " [" .. RAB_BuffTimers[UnitName(u) .. ".h2oc"] .. "], ";
			end
			if (isbuffed) then
				buffed = buffed + 1;
			end
			if (needraw) then
				tinsert(raw,
						{
							name = UnitName(u),
							class = RAB_UnitClass(u),
							group = group,
							unit = u,
							append = append,
							buffed = isbuffed
						});
			end
		end
	end
	if (total > 1 and needraw and UnitInRaid("player")) then
		table.sort(raw, function(a, b)
			return a.group < b.group
		end);
	end
	if (needtxt) then
		if (buffed == total) then
			txt = sRAB_BuffOutput_Water_Everyone;
			hastxt = sRAB_BuffOutput_Water_Everyone;
		else
			txt = strsub(txt, 1, -3) .. ".";
			hastxt = strsub(hastxt, 1, -3) .. ".";
		end
	end
	return buffed, 0, total, misc, txthead, hashead, txt, hastxt, invert, raw, rawsort, false;
end

function RAB_QueryDebuff(userData, needraw, needtxt)
	local btype = RAB_Buffs[bkey].ext
	local bText = getglobal("sRAB_BuffOutput_Debuff_" ..
			(btype == "" and "Typeless" or (btype == "SELF" and "Curable" or btype)));

	local buffed, total, misc, txthead, hashead, txt, hastxt, invert, raw, rawsort = 0, 0, "",
	string.format(sRAB_BuffOutput_Debuff_NotHave, bText), string.format(sRAB_BuffOutput_Debuff_Have, bText), "", "",
	true;
	if (needraw) then
		raw = {};
	end
	local i, u, group, j, isbuffed, item;
	local f = (btype == "SELF") and 1 or 0;
	for i, u, group in RAB_GroupMembers(userData) do
		if (not RAB_UnitIsDead(u)) then
			total = total + 1;
			j, isbuffed = 1, false;
			while (UnitDebuff(u, j, f) ~= nil) do
				local tex, app, type = UnitDebuff(u, j, f);
				if (f == 1 or type == btype or (type == nil and btype == "")) then
					isbuffed = true;
					break ;
				end
				j = j + 1;
			end
			if (needtxt and isbuffed) then
				hastxt = hastxt .. UnitName(u) .. ", ";
			elseif (needtxt and not isbuffed) then
				txt = txt .. UnitName(u) .. ", ";
			end
			if (isbuffed) then
				buffed = buffed + 1;
			end
			if (needraw) then
				tinsert(raw,
						{
							name = UnitName(u),
							class = RAB_UnitClass(u),
							group = group,
							unit = u,
							append = append,
							buffed = isbuffed
						});
			end
		end
	end
	if (total > 1 and UnitInRaid("player") and needraw) then
		table.sort(raw, function(a, b)
			return a.group < b.group
		end);
	end

	if (needtxt) then
		if (buffed == total) then
			txt = string.format(sRAB_BuffOutput_Debuff_Everyone, bText);
			hastxt = txt;
		elseif (buffed > 0) then
			txt = txthead .. " " .. strsub(txt, 1, -3) .. ".";
			hastxt = hashead .. " " .. strsub(hastxt, 1, -3) .. ".";
		else
			txt = string.format(sRAB_BuffOutput_Debuff_NoOne, bText);
			hastxt = txt;
		end
	end
	return buffed, 0, total, misc, txthead, hashead, txt, hastxt, invert, raw, "group", sRAB_Core_GroupFormat;
end

function RAB_CountItems(itemId, justNeedSlot)
	local bag, slot, count = 0, 0, 0;

	itemId = tostring(itemId);
	for i = 0, 4 do
		for j = 1, GetContainerNumSlots(i) do
			local link = GetContainerItemLink(i, j);
			if (link ~= nil) then
				local _, _, id = string.find(link, "item:(%d+):");
				if (id == itemId) then
					local _, itemCount = GetContainerItemInfo(i, j);
					count = count + itemCount;
					bag, slot = i, j;
					if (justNeedSlot ~= nil) then
						return count, bag, slot;
					end
				end
			end
		end
	end
	return count, bag, slot;
end

-- BLOCK 2: Casting functions

function RAB_UseItem(mode, userData)
	local buffData = RAB_Buffs[userData.buffKey];
	local itemId = buffData.itemId
	local itemName = buffData.name
	local itemUseOn = buffData.useOn
	local count, bag, slot = RAB_CountItems(itemId, true);
	-- RAB_Print(string.format('count %s bag %s slot %s', count, bag, slot))
	if count == 0 and mode == 'tip' then
		return string.format(sRAB_Tooltip_CastFail_NoItem, itemName)
	end
	if mode == 'tip' then
		if userData.useOnClick ~= true then
			return string.format(sRAB_Tooltip_ClickToUseDisabled, itemName)
		end
		return string.format(sRAB_Tooltip_ClickToUse, itemName)
	end

	if (GetContainerItemCooldown(bag, slot) ~= 0) then
		if (mode == "cast") then
			RAB_Print(string.format(sRAB_CastingLayer_Cooldown, itemName), "warn");
			return false;
		else
			local start, duration = GetContainerItemCooldown(bag, slot);
			return string.format(sRAB_Tooltip_CastFail_Cooldown, start + duration - GetTime());
		end
	end

	if userData.useOnClick ~= true then
		return false
	end

	local buffs = {}
	if buffData.useOn == 'weapon' or buffData.useOn == 'weaponOH' then
		buffs = RAB_CollectPlayerWeaponBuffs(buffData)
		local buffed = RAB_WeaponIsBuffed(buffs, buffData)
		if buffed > 0 then
			return false
		end
	end

	for _, identifier in ipairs(buffData.identifiers) do
		if (isUnitBuffUp("player", identifier)) then
			return false; -- don't use again
		end
	end

	if itemUseOn then
		if itemUseOn == 'player' then
			-- spell scroll
			ClearTarget();
			UseContainerItem(bag, slot);
			local shouldRetarget = UnitExists("target");
			if (not SpellIsTargeting()) then
				RAB_Print(sRAB_CastingLayer_NoSession, "warn")
				return false;
			end
			SpellTargetUnit('player');
			if (shouldRetarget) then
				TargetLastTarget();
			end
		elseif itemUseOn == 'weapon' then
			-- weapon enchant
			local slotName = 'MainHandSlot'
			if buffs[slotName] == nil then
				RAB_Print(string.format('[RABuffs] no weapon equipped'), "warn")
			else
				if buffs[slotName] ~= nil and buffs[slotName]['buffed'] == 0 then
					ClearTarget();
					UseContainerItem(bag, slot);
					local shouldRetarget = UnitExists("target");
					if (not SpellIsTargeting()) then
						RAB_Print(sRAB_CastingLayer_NoSession, "warn")
						return false;
					end
					PickupInventoryItem(GetInventorySlotInfo(slotName));
					if (shouldRetarget) then
						TargetLastTarget();
					end
				end
			end
		elseif itemUseOn == 'weaponOH' then
			local slotName = 'SecondaryHandSlot'
			if buffs[slotName] == nil then
				RAB_Print(string.format('[RABuffs] no offhand weapon equipped'), "warn")
			else
				if buffs[slotName] ~= nil and buffs[slotName]['buffed'] == 0 then
					ClearTarget();
					UseContainerItem(bag, slot);
					local shouldRetarget = UnitExists("target");
					if (not SpellIsTargeting()) then
						RAB_Print(sRAB_CastingLayer_NoSession, "warn")
						return false;
					end
					PickupInventoryItem(GetInventorySlotInfo(slotName));
					if (shouldRetarget) then
						TargetLastTarget();
					end
				end
			end
		else
			RAB_Print(string.format('unknown useOn %s', itemUseOn), "warn")
		end
	else
		-- basic potion
		UseContainerItem(bag, slot);
	end
end

function RAB_DefaultCastingHandler(mode, userData)
	local buffData = RAB_Buffs[userData.buffKey];
	local clicktocast = sRAB_Tooltip_ClickToCast;
	if userData.useOnClick ~= true then
		clicktocast = sRAB_Tooltip_ClickToCastDisabled
	end

	if (buffData.grouping ~= RAB_UnitClass("player") or sRAB_SpellNames[userData.buffKey] == nil) then
		return false;
	end
	if (mode == "tip" and RAB_IsBuffUp("player", "druidshift")) then
		return sRAB_Tooltip_CastFail_Shapeshift;
	end

	if (buffData.type == "self" or buffData.type == "aura") then
		RAB_ClearUnitBuffCache("player")
		local isup = RAB_IsBuffUp("player", userData.buffKey);
		if (RAB_ShouldRecast("player", userData.buffKey, isup)) then
			if userData.useOnClick == true then
				clicktocast = sRAB_Tooltip_ClickToRecast;
			end
		elseif (isup) then
			return false;
		end
		local buff = sRAB_SpellNames[userData.buffKey];
		local canbuff, reason, howmuch = RAB_CastSpell_IsCastable(userData.buffKey, true, true);
		if (not (canbuff or dogroupbuff)) then
			if (reason == "Cooldown") then
				return mode == "tip" and
						string.format(getglobal("sRAB_Tooltip_CastFail_" .. reason), floor(howmuch * 10) / 10) or false;
			else
				return mode == "tip" and getglobal("sRAB_Tooltip_CastFail_" .. reason) or false;
			end
		end
		if (mode == "tip") then
			return string.format(clicktocast, buff, RAB_Chat_Colors[RAB_UnitClass("player")] .. UnitName("player"));
		elseif (mode == "cast") then
			if userData.useOnClick ~= true then
				return false
			end
			CastSpellByName(buff, true);

			-- clear player cache
			RABui_LastBuffEvent = GetTime()
			RAB_ClearUnitBuffCache("player")

			RAB_ResetRecastTimer("player", userData);
			RAB_Print(string.format(sRAB_CastBuff_CastNeutral, buff));
			return true;
		end
	end

	local dogroupbuff, mygroup = IsAltKeyDown(), 0;
	if (RABui_Settings.castbigbuffs) then
		dogroupbuff = not dogroupbuff;
	end
	if (buffData.bigcast == nil or not RAB_CastSpell_IsCastable(buffData.bigcast, true, true)) then
		dogroupbuff = false;
	end

	local canbuff, reason, howmuch = RAB_CastSpell_IsCastable(userData.buffKey, true, true);
	if (not (canbuff or dogroupbuff)) then
		if (reason == "Cooldown") then
			return mode == "tip" and string.format(getglobal("sRAB_Tooltip_CastFail_" .. reason), floor(howmuch * 10) /
					10) or false;
		else
			return mode == "tip" and getglobal("sRAB_Tooltip_CastFail_" .. reason) or false;
		end
	end

	if (UnitInRaid("player") and RABui_Settings.partymode == true) then
		for i = 1, 40 do
			if (UnitIsUnit("raid" .. i, "player")) then
				_, _, mygroup = GetRaidRosterInfo(i);
				break ;
			end
		end
	end

	local people, group, i, u, g, ir = {};
	if (mode == "cast") then
		if userData.useOnClick ~= true then
			return false
		end
		if (not RAB_CastSpell_Start(userData.buffKey)) then
			return false;
		end
	end
	local faderenew, pvpfail, rangefail = {}, 0, 0;
	for i, u, g in RAB_GroupMembers(userData) do
		local ekey = UnitName(u) .. "." .. userData.buffKey;
		local pri = UnitIsUnit("player", u) and (buffData.selfPriority ~= nil and buffData.selfPriority or 5) or
				1;
		if (g == mygroup) then
			pri = pri + 1;
		end
		if (RAB_CastLog[u] ~= nil and RAB_CastLog[u] >= time()) then
			pri = pri / 10;
		end
		if (buffData.priority ~= nil and buffData.priority[strlower(RAB_UnitClass(u))] ~= nil) then
			pri = pri +
					buffData.priority[strlower(RAB_UnitClass(u))];
		end
		if (RAB_IsEligible(u, userData) and RAB_IsSanePvP(u) and RAB_RangeCheck(mode, u) and pri > 0) then
			RAB_ClearUnitBuffCache(u) -- clear cache to get most recent data for u
			if (not RAB_IsBuffUp(u, userData.buffKey)) then
				tinsert(people, { u = u, group = g, class = RAB_UnitClass(u), p = pri });
			elseif (RAB_ShouldRecast(u, userData.buffKey, true) and pri > 0) then
				pri = 10000 - RAB_BuffTimers[ekey] + GetTime();
				if (RAB_CastLog[u] ~= nil and RAB_CastLog[u] >= time()) then
					pri = pri / 10;
				end
				tinsert(faderenew, { u = u, group = g, class = RAB_UnitClass(u), p = pri })
			end
		elseif (RAB_IsEligible(u, userData) and pri > 0) then
			RAB_ClearUnitBuffCache(u) -- clear cache to get most recent data for u
			if (not RAB_IsSanePvP(u)) then
				pvpfail = pvpfail + 1;
			elseif (not RAB_IsBuffUp(u, userData.buffKey) and not RAB_RangeCheck(mode, u, userData.buffKey)) then
				rangefail = rangefail + 1;
			end
		end
	end

	if (table.getn(people) == 0 and table.getn(faderenew) == 0) then
		if (mode == "cast") then
			RAB_CastSpell_Abort();
			if (pvpfail > 0 or rangefail > 0) then
				UIErrorsFrame:AddMessage(
						string.format(sRAB_CastingLayer_NoCast, buffData.name, pvpfail, rangefail), 1, 0, 0, 1, 1.5);
			else
				UIErrorsFrame:AddMessage(string.format(sRAB_CastingLayer_NoNeed, buffData.name), 1, 0, 0, 1, 1.5);
			end
		end
		return false;
	elseif (table.getn(people) == 0) then
		people = faderenew;
		if userData.useOnClick == true then
			clicktocast = sRAB_Tooltip_ClickToRecast;
		end
	end

	if (dogroupbuff and table.getn(people) < buffData.bigthreshold and not RABui_Settings.alwayscastbigbuffs) then
		dogroupbuff = false;
	end
	if (dogroupbuff) then
		local bsort, bsortkeys, stype = {}, {}, buffData.bigsort;
		for key, val in people do
			if (bsortkeys[val[stype]] == nil) then
				tinsert(bsort, { pri = val.p, cast = val.u, heads = 1, key = val[stype] });
				bsortkeys[val[stype]] = table.getn(bsort);
			else
				local ckey = bsortkeys[val[stype]];
				bsort[ckey].pri, bsort[ckey].heads = bsort[ckey].pri + val.p, bsort[ckey].heads + 1;
			end
		end
		table.sort(bsort, function(a, b)
			return (a.heads == b.heads) and (a.pri > b.pri) or (a.heads > b.heads)
		end);
		if (bsort[1].heads >= buffData.bigthreshold or RABui_Settings.alwayscastbigbuffs) then
			local bname = sRAB_SpellNames[buffData.bigcast];
			if (mode == "cast") then
				if userData.useOnClick ~= true then
					return false
				end
				RAB_CastSpell_Abort();
				if (RAB_CastSpell_Start(buffData.bigcast)) then
					RAB_CastSpell_Target(bsort[1].cast);
					RAB_ResetRecastTimer(bsort[1].cast, userData, buffData.bigsort);
					RAB_Print(string.format(sRAB_CastBuff_Cast, bname,
							RAB_Chat_Colors[RAB_UnitClass(bsort[1].cast)] ..
									UnitName(bsort[1].cast) .. " [" .. bsort[1].key .. "]"));
					return true;
				else
					RAB_CastSpell_Start(userData.buffKey);
				end
			else
				if userData.useOnClick ~= true then
					clicktocast = sRAB_Tooltip_ClickToUseDisabled
				end
				return string.format(clicktocast, bname,
						RAB_Chat_Colors[RAB_UnitClass(bsort[1].cast)] ..
								UnitName(bsort[1].cast) .. " [" .. bsort[1].key .. "]");
			end
		end
	end

	table.sort(people, function(a, b)
		return (a.p > b.p)
	end);
	local bname = sRAB_SpellNames[userData.buffKey] ~= nil and sRAB_SpellNames[userData.buffKey] or buffData.name;
	if (mode == "cast") then
		RAB_CastSpell_Target(people[1].u);
		RAB_ResetRecastTimer(people[1].u, userData);
		-- clear buff cache for people[1].u
		RAB_Print(string.format(sRAB_CastBuff_Cast,
				sRAB_SpellNames[userData.buffKey] ~= nil and sRAB_SpellNames[userData.buffKey] or buffData.name,
				RAB_Chat_Colors[RAB_UnitClass(people[1].u)] .. UnitName(people[1].u)));
		return true;
	elseif (mode == "tip") then
		return string.format(clicktocast, bname, RAB_Chat_Colors[RAB_UnitClass(people[1].u)] .. UnitName(people[1].u));
	end
	return people;
end

function RAB_RangeCheck(mode, u)
	-- Optimistic.
	return (mode == "tip" and UnitIsVisible(u)) or (mode == "cast" and SpellCanTargetUnit(u));
end

function RAB_CastInventoryItem(mode, userData)
	local buffData = RAB_Buffs[userData.buffKey];
	if (buffData == nil or buffData.ext == nil or RAB_UnitIsDead("player")) then
		return ;
	end
	if (UnitAffectingCombat("player")) then
		return (mode == "tip" and sRAB_Tooltip_CastFail_Combat or nil);
	end
	local _, _, inv, iid = string.find(buffData.ext, "(%d+):(%d+)");

	if (string.find(tostring(GetInventoryItemLink("player", inv)), "item:" .. iid .. ":") ~= nil) then
		return nil;
	end

	local iname = GetItemInfo(tonumber(iid));
	if (iname == nil) then
		iname = string.format(sRAB_BuffOutput_Item_Unknown, iid);
	end
	local c, b, s = RAB_CountItems(iid, true);
	if (c == 0) then
		return (mode == "tip" and string.format(sRAB_Tooltip_CastFail_NoItem, iname) or nil);
	end
	if (mode == "tip") then
		return string.format(sRAB_Tooltip_ClickToEquip, iname);
	elseif (mode == "cast") then
		PickupContainerItem(b, s);
		AutoEquipCursorItem();
	end
end

function RAB_CastSoulstone(mode, userData)
	local i, item, bag, slot;

	if (sRAB_SpellNames.ss == nil or RAB_UnitClass("player") ~= "Warlock") then
		return false; -- We don't do this, sorry.
	end

	-- Stage 1: Do we have a stone?
	for i = 16892, 16896 do
		_, bag, slot = RAB_CountItems(i == 16894 and 5232 or i, true);
		if (bag ~= 0) then
			item = i;
			break ;
		end
	end

	if (bag == 0) then
		-- We need a stone!
		if (mode == "tip") then
			return string.format(sRAB_Tooltip_ClickToCastNeutral, sRAB_SpellNames.ss);
		elseif (mode == "cast" and RAB_CastSpell_IsCastable("ss")) then
			CastSpellByName(sRAB_SpellNames.ss);
			RAB_Print(string.format(sRAB_CastBuff_CastNeutral, sRAB_SpellNames.ss));
			return true;
		end
	else
		if (GetContainerItemCooldown(bag, slot) ~= 0) then
			if (mode == "cast") then
				RAB_Print(string.format(sRAB_CastingLayer_Cooldown, GetItemInfo(item)), "warn");
				return false;
			else
				local start, duration = GetContainerItemCooldown(bag, slot);
				return string.format(sRAB_Tooltip_CastFail_Cooldown, start + duration - GetTime());
			end
		end
		local shouldRetarget = UnitExists("target");
		if (mode == "cast") then
			ClearTarget();
			UseContainerItem(bag, slot);
			if (not SpellIsTargeting()) then
				RAB_Print(sRAB_CastingLayer_NoSession, "warn")
				return false;
			end
		end
		local buffKey, people, pri = "ss", {}, 0;
		local maxpri, maxpriunit = 0, "";
		for i, u, g in RAB_GroupMembers(userData) do
			if (RAB_IsEligible(u, userData) and RAB_IsSanePvP(u) and not RAB_IsBuffUp(u, buffKey) and RAB_RangeCheck(mode, u)) then
				pri = UnitIsUnit("player", u) and
						(RAB_Buffs[buffKey].selfPriority ~= nil and RAB_Buffs[buffKey].selfPriority or 5) or 1;
				if (RAB_CastLog[u] ~= nil and RAB_CastLog[u] >= time()) then
					pri = pri / 10;
				end
				if (RAB_Buffs[buffKey].priority ~= nil and RAB_Buffs[buffKey].priority[strlower(RAB_UnitClass(u))] ~= nil) then
					pri = pri + RAB_Buffs[buffKey].priority[strlower(RAB_UnitClass(u))];
				end
				if (pri > maxpri) then
					maxpri = pri;
					maxpriunit = u;
				end
			end
		end
		if (mode == "cast" and maxpri > 0) then
			SpellTargetUnit(maxpriunit);
			if (shouldRetarget) then
				TargetLastTarget();
			end
			RAB_Print(string.format(sRAB_CastBuff_Cast, GetItemInfo(item),
					RAB_Chat_Colors[RAB_UnitClass(maxpriunit)] .. UnitName(maxpriunit)));
			return true;
		elseif (mode == "tip" and maxpri > 0) then
			return string.format(sRAB_Tooltip_ClickToSoulstone,
					RAB_Chat_Colors[RAB_UnitClass(maxpriunit)] .. UnitName(maxpriunit));
		elseif (mode == "cast") then
			SpellStopCasting();
			if (shouldRetarget) then
				TargetLastTarget();
			end
		end
	end
	return false;
end

function RAB_CastResurrect(mode, userData)
	local res, i, u = strlower(RAB_UnitClass("player")) .. "res";

	if (sRAB_SpellNames[res] == nil) then
		return false;
	end

	local toRes = {}; -- {u="",pri=deci};
	for i, u, group in RAB_GroupMembers(userData) do
		if (UnitIsUnit(u, "player") ~= 1 and UnitIsVisible(u) and (RAB_UnitIsDead(u) and not UnitIsGhost(u)) and RAB_IsSanePvP(u) and (RAB_CTRA_IsBeingRessed == nil or not RAB_CTRA_IsBeingRessed(UnitName(u)))) then
			local pri = (RAB_UnitClass(u) == "Priest" and 2 or 0) + (RAB_UnitClass(u) == "Paladin" and 2 or 0) +
					(RAB_UnitClass(u) == "Shaman" and 2 or 0) + (RAB_UnitClass(u) == "Mage" and 1 or 0) +
					(RAB_Versions[UnitName(u)] ~= nil and 0.25 or 0);
			if (RAB_CastLog[u] ~= nil and RAB_CastLog[u] > GetTime()) then
				pri = pri / 15;
			end
			tinsert(toRes, { u = u, pri = pri });
		end
	end
	if (table.getn(toRes) == 0) then
		return false;
	elseif (table.getn(toRes) > 1) then
		table.sort(toRes, function(a, b)
			return a.pri > b.pri
		end);
	end

	if (mode == "tip") then
		return string.format(sRAB_Tooltip_ClickToCast, sRAB_SpellNames[res],
				RAB_Chat_Colors[RAB_UnitClass(toRes[1].u)] .. UnitName(toRes[1].u));
	end

	if (not RAB_CastSpell_Start(res)) then
		return false;
	end

	for i = 1, table.getn(toRes) do
		u = toRes[i].u;
		if (SpellCanTargetUnit(u)) then
			RAB_CastSpell_Target(u);
			RAB_Print(string.format(sRAB_CastBuff_Cast, sRAB_SpellNames[res],
					RAB_Chat_Colors[RAB_UnitClass(u)] .. UnitName(u)));
			RAB_PendingRes[UnitName(u)] = GetTime() + 70;
			return true;
		end
	end
	RAB_CastSpell_Abort();
	return false;
end

function RAB_CastWater(mode, userData)
	if (not RAB_CastSpell_IsCastable("water", true, true)) then
		return ; -- Lazy.
	end
	if (mode == "tip") then
		return string.format(sRAB_Tooltip_ClickToCastNeutral, sRAB_SpellNames.water);
	elseif (mode == "cast") then
		CastSpellByName(sRAB_SpellNames.water);
		RAB_Print(string.format(sRAB_CastBuff_CastNeutral, sRAB_SpellNames.water));
	end
end
