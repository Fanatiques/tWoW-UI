-- RABuffs_strings.lua
--  Non-code storage for various code/title strings. Do not localize this file.
-- Version 0.10.3

sRAB_DownloadURL = "https://github.com/Pepopo/Rabuffs/";

sRAB_Settings_UIHeader = "RABuffs";
sRAB_Settings_ReleaseNotes = "<h2 align=\"left\">Release notes</h2><p>- Issue: GoTW is mis-identified as MoTW on non-enUS clients.</p><p>- Issue: Failed casting of resurrection spells bans the target from further attempts for 70 seconds.</p><br/><br/>";

sRAB_LOCALIZATION, sRAB_Localization_UI, sRAB_Localization_Output, sRAB_Localization_SpellLayer = {}, "", "",
"|c00ff9922Automatic spellbook|r";

sRAB_ChangeLog2 = [[<html><body>
			<h1 align="center">RABuffs Version 0.11.0</h1>
			<h2>General</h2>
			<p> - Hide in combat option.</p>
			<p> - Hide active buffs/consumes option.</p>
			<p> - Exclude player names for buffs.</p>
			<br/><br/></body></html>]];

sRAB_SpellNames = {};
sRAB_SpellIDs = {};

function sRAB_Localize(strings, spells)
	if (strings) then
		sRAB_LOCALIZATION_vui = "enUS";
		sRAB_LOCALIZATION_out = "enUS";
		sRAB_LOCALIZATION["enUS"](true, true, (GetLocale() == "enUS"));
		if (RABui_Settings.uilocale ~= "enUS" and sRAB_LOCALIZATION[RABui_Settings.uilocale] ~= nil) then
			sRAB_LOCALIZATION[RABui_Settings.uilocale](true, false);
			sRAB_LOCALIZATION_vui = RABui_Settings.uilocale;
		end
		if (RABui_Settings.outlocale ~= "enUS" and sRAB_LOCALIZATION[RABui_Settings.outlocale] ~= nil) then
			sRAB_LOCALIZATION[RABui_Settings.outlocale](false, true);
			sRAB_LOCALIZATION_out = RABui_Settings.outlocale;
		end
		if (RABui_Localize ~= nil) then
			RABui_Localize();
		end
	end
	if (spells) then
		sRAB_PseudoLocalize();
		if (sRAB_LOCALIZATION[GetLocale()] ~= nil) then
			sRAB_LOCALIZATION[GetLocale()](false, false, true);
		end
	end
end

function sRAB_PseudoLocalize()
	sRAB_SpellLayerLocale = "auto";
	local _, _, i = GetSpellTabInfo(2);
	if (i == 0 or i == nil) then
		return ; -- There is only one tab, "General", so no spells for us.
	end
	local sName, sTex, sArr, sManaCost = "", "", {}, {};
	local mana = 0;
	while true do
		i = i + 1;
		sName, sRank = GetSpellName(i, BOOKTYPE_SPELL)
		if (sName == nil) then
			break ;
		end
		sTex = GetSpellTexture(i, BOOKTYPE_SPELL);
		sTex = strsub(sTex, 1 + strlen("Interface/Icons/"));
		mana = RAB_SpellManaCost(i);
		if ((sArr[sTex] == nil) or (mana > sManaCost[sTex])) then
			sArr[sTex] = i;
			sManaCost[sTex] = mana;
		end
	end
	local mc = RAB_UnitClass("player");
	for buffKey, buffData in RAB_Buffs do
		if (buffData.grouping == mc and buffData.identifiers ~= nil) then
			sName = GetSpellName(i, BOOKTYPE_SPELL);
			-- loop through textures
			for _, identifier in ipairs(RAB_Buffs[buffKey].identifiers) do
				if (sArr[identifier.texture] ~= nil) then
					-- store bigcast spell names separately
					if identifier.bigcast then
						sRAB_SpellNames[identifier.bigcast] = GetSpellName(
								sArr[identifier.texture], BOOKTYPE_SPELL);
						sRAB_SpellIDs[identifier.bigcast] = sArr[identifier.texture], sManaCost[identifier.texture];
					elseif sRAB_SpellNames[buffKey] == nil then
						sRAB_SpellNames[buffKey] = GetSpellName(
								sArr[identifier.texture], BOOKTYPE_SPELL);
						sRAB_SpellIDs[buffKey] = sArr[identifier.texture], sManaCost[identifier.texture];
					end
				end
			end
		end
	end
end

function sRAB_FindSpellId(SpellName)
	local _, _, i = GetSpellTabInfo(2);
	if (i == 0 or i == nil) then
		return 0; -- There is only one tab, "General", so no spells for us.
	end
	local sName, iManaCost, sId = "", 0, 0;
	while true do
		i = i + 1;
		sName = GetSpellName(i, BOOKTYPE_SPELL);
		if (sName == nil) then
			break ;
		elseif (sName == SpellName) then
			sId = i;
		elseif (sId ~= 0) then
			return sId;
		end
	end
	return sId;
end

function RAB_SpellManaCost(spell, book)
	RAB_Spelltip:SetOwner(RABFrame, "ANCHOR_LEFT");
	RAB_Spelltip:ClearLines();
	RAB_Spelltip:SetSpell(spell, book ~= nil and book or BOOKTYPE_SPELL);
	local t = RAB_SpelltipTextLeft2:GetText();
	local _, _, mana = string.find(t ~= nil and t or "", "(%d+) ");
	RAB_Spelltip:Hide();
	return (mana ~= nil and tonumber(mana) or 0);
end
