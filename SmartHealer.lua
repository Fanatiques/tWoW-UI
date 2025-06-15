--Original idea of this addon is based on Ogrisch's LazySpell

SmartHealer = AceLibrary("AceAddon-2.0"):new("AceHook-2.1", "AceConsole-2.0", "AceDB-2.0")
SmartHealer:RegisterDB("SmartHealerDB")
SmartHealer:RegisterDefaults("account", { overheal = 1 })

local libHC = AceLibrary("HealComm-1.0")
local libIB = AceLibrary("ItemBonusLib-1.0")
local libSC = AceLibrary("SpellCache-1.0")

function SmartHealer:OnEnable()
    if Clique and Clique.CastSpell then
        self:Hook(Clique, "CastSpell", "Clique_CastSpell")
    end

    if CM and CM.CastSpell then
        self:Hook(CM, "CastSpell", "CM_CastSpell")
    end

    if pfUI and pfUI.uf and pfUI.uf.ClickAction then
        self:Hook(pfUI.uf, "ClickAction", "pfUI_ClickAction")
    end

    if SlashCmdList and SlashCmdList.PFCAST then
        self:Hook(SlashCmdList, "PFCAST", "pfUI_PFCast")
    end

    self:RegisterChatCommand({ "/heal" }, function(arg) SmartHealer:CastHeal(arg) end, "SMARTHEALER")
    self:RegisterChatCommand({ "/sh_overheal" }, function(arg) SmartHealer:Overheal(arg) end, "SMARTOVERHEALER")
    self:Print('loaded')
end

-------------------------------------------------------------------------------
-- Handler function for /heal <spell_name>[, overheal_multiplier]
-------------------------------------------------------------------------------
-- Function automatically choose which rank of heal will be casted based on
-- amount of missing life.
--
-- NOTE: Argument "spellName" should be always heal and shouldn't contain rank.
-- If there is a rank, function won't scale it. It means that "Healing Wave"
-- will use rank as needed, but "Healing Wave(Rank 3)" will always cast rank 3.
-- Argument "spellName" can contain overheal multiplier information separated
-- by "," or ";" and it should be either number (1.1) or percentage (110%).
--
-- Examples:
-- SamrtHealer:CastSpell("Healing Wave")			--/heal Healing Wave
-- SamrtHealer:CastSpell("Healing Wave, 1.15")		--/heal Healing Wave, 1.15
-- SamrtHealer:CastSpell("Healing Wave;120%")		--/heal Healing Wave;120%
-------------------------------------------------------------------------------
function SmartHealer:CastHeal(spellName)
    local overheal

    -- self:Print("spellname: ", spellName, type(spellName), string.len(spellName))
    if not spellName or string.len(spellName) == 0 or type(spellName) ~= "string" then
        return
    else
        spellName = string.gsub(spellName, "^%s*(.-)%s*$", "%1") --strip leading and trailing space characters
        spellName = string.gsub(spellName, "%s+", " ")           --replace all space character with actual space

        local _, _, arg = string.find(spellName, "[,;]%s*(.-)$") --tries to find overheal multiplier (number after spell name, separated by "," or ";")
        if arg then
            local _, _, percent = string.find(arg, "(%d+)%%")
            if percent then
                overheal = tonumber(percent) / 100
            else
                overheal = tonumber(arg)
            end

            spellName = string.gsub(spellName, "[,;].*", "") --removes everything after first "," or ";"
        end

        if not overheal then
            overheal = self.db.account.overheal
        end
    end

    local spell, rank = libSC:GetRanklessSpellName(spellName)
    local unit, onSelf

    if UnitExists("target") and UnitCanAssist("player", "target") then
        unit = "target"
    end

    if unit == nil then
        if GetCVar("autoSelfCast") == "1" then
            unit = "player"
            onSelf = true
        else
            return
        end
    end

    if spell and rank == nil and libHC.Spells[spell] then
        rank = self:GetOptimalRank(spell, unit, overheal)
        if rank then
            spellName = libSC:GetSpellNameText(spell, rank)
        end
    end

    -- self:Print("spellname: ", spellName)

    CastSpellByName(spellName, onSelf)

    if UnitIsUnit("player", unit) then
        if SpellIsTargeting() then
            SpellTargetUnit(unit)
        end
        if SpellIsTargeting() then
            SpellStopTargeting()
        end
    end
end

-------------------------------------------------------------------------------
-- Handler function for /sh_overheal
-------------------------------------------------------------------------------
-- Saves new default overheal multiplier, argument "value" should be either
-- string or number. String could contain number ("1.15") or percentage ("115%")
-- If "value" is not specified or invalid, function prints current overheal
-- multiplier.
-------------------------------------------------------------------------------
function SmartHealer:Overheal(value)
    if value and type(value) == "string" then
        value = string.gsub(value, "^%s*(.-)%s*$", "%1")

        local _, _, percent = string.find(value, "(%d+)%%")
        if percent then
            value = tonumber(percent) / 100
        else
            value = tonumber(value)
        end
    end

    if type(value) == "number" then
        self.db.account.overheal = math.floor(value * 1000 + 0.5) / 1000
    else
        self:Print("Overheal multiplier: ", self.db.account.overheal, "(", self.db.account.overheal * 100, "%)")
    end
end

-------------------------------------------------------------------------------
-- Function selects optimal spell rank to cast based on unit's missing HP
-------------------------------------------------------------------------------
-- spell	- spell name to cast ("Healing Wave")
-- unit	 	- unitId ("player", "target", ...)
-- overheal	- overheal multiplier. If nil, then using self.db.account.overheal.
-------------------------------------------------------------------------------
function SmartHealer:GetOptimalRank(spell, unit, overheal)
    if not libSC.data[spell] then
        self:Print('smartheal rank not found')
        return
    end

    local bonus, power, mod
    if TheoryCraft == nil then
        bonus = tonumber(libIB:GetBonus("HEAL"))
        power, mod = libHC:GetUnitSpellPower(unit, spell)
        local buffpower, buffmod = libHC:GetBuffSpellPower()
        bonus = bonus + buffpower
        mod = mod * buffmod
    end
    local missing = UnitHealthMax(unit) - UnitHealth(unit)
    local max_rank = tonumber(libSC.data[spell].Rank)
    local rank = max_rank
    overheal = overheal or self.db.account.overheal

    local mana = UnitMana("player")
    local spelldata = nil
    for i = max_rank, 1, -1 do
        spellData = TheoryCraft ~= nil and TheoryCraft_GetSpellDataByName(spell, i)
        if spellData then
            if mana >= spellData.manacost then
                if spellData.averagehealnocrit > (missing * overheal) then
                    rank = i
                else
                    break
                end
            else
                rank = i > 1 and i - 1 or 1
            end
        else
            local heal = (libHC.Spells[spell][i](bonus) + power) * mod
            if heal > (missing * overheal) then
                rank = i
            else
                break
            end
        end
    end
    --[[
    self:Print(spell
            .. ' rank ' .. rank
            .. ' hp ' .. math.floor(spellData.averagehealnocrit)
            .. ' hpm ' .. (spellData.averagehealnocrit / spellData.manacost)
            .. ' mana ' .. spellData.manacost )
    ]]
    return rank
end

-------------------------------------------------------------------------------
-- Support for Clique
-------------------------------------------------------------------------------
function SmartHealer:Clique_CastSpell(clique, spellName, unit)
    unit = unit or clique.unit

    if UnitExists(unit) then
        local spell, rank = libSC:GetRanklessSpellName(spellName)

        if spell and rank == nil and libHC.Spells[spell] then
            rank = self:GetOptimalRank(spellName, unit)
            if rank then
                spellName = libSC:GetSpellNameText(spell, rank)
            end
        end
    end

    self.hooks[Clique]["CastSpell"](clique, spellName, unit)
end

-------------------------------------------------------------------------------
-- Support for ClassicMouseover
-------------------------------------------------------------------------------
function SmartHealer:CM_CastSpell(cm, spellName, unit)
    if UnitExists(unit) then
        local spell, rank = libSC:GetRanklessSpellName(spellName)

        if spell and rank == nil and libHC.Spells[spell] then
            rank = self:GetOptimalRank(spellName, unit)
            if rank then
                spellName = libSC:GetSpellNameText(spell, rank)
            end
        end
    end

    self.hooks[CM]["CastSpell"](cm, spellName, unit)
end

-------------------------------------------------------------------------------
-- Support for pfUI Click-Casting
-------------------------------------------------------------------------------
function SmartHealer:pfUI_ClickAction(pfui_uf, button)
    local spellName = ""
    local key = "clickcast"

    if button == "LeftButton" then
        local unit = (this.label or "") .. (this.id or "")

        if UnitExists(unit) then
            if this.config.clickcast == "1" then
                if IsShiftKeyDown() then
                    key = key .. "_shift"
                elseif IsAltKeyDown() then
                    key = key .. "_alt"
                elseif IsControlKeyDown() then
                    key = key .. "_ctrl"
                end

                spellName = pfUI_config.unitframes[key]

                if spellName ~= "" then
                    local spell, rank = libSC:GetRanklessSpellName(spellName)

                    if spell and rank == nil and libHC.Spells[spell] then
                        rank = self:GetOptimalRank(spellName, unit)
                        if rank then
                            pfUI_config.unitframes[key] = libSC:GetSpellNameText(spell, rank)
                        end
                    end
                end
            end
        end
    end

    self.hooks[pfUI.uf]["ClickAction"](pfui_uf, button)

    if spellName ~= "" then
        pfUI_config.unitframes[key] = spellName
    end
end

-------------------------------------------------------------------------------
-- Support for pfUI /pfcast and /pfmouse commands
-------------------------------------------------------------------------------

-- Inspired by how pfui deduces the intended target inside the implementation of /pfcast
-- Must be kept in sync with the pfui codebase   otherwise there might be cases where the
-- wrong target is assumed here thus leading to wrong healing rank calculations 

-- Prepare a list of units that can be used via SpellTargetUnit
local st_units = { [1] = "player", [2] = "target", [3] = "mouseover" }
for i = 1, MAX_PARTY_MEMBERS do table.insert(st_units, "party" .. i) end
for i = 1, MAX_RAID_MEMBERS do table.insert(st_units, "raid" .. i) end

-- Try to find a valid (friendly) unitstring that can be used for
-- SpellTargetUnit(unit) to avoid another target switch
local function getUnitString(unit)
    for index, unitstr in pairs(st_units) do
        if UnitIsUnit(unit, unitstr) then
            return unitstr
        end
    end

    return nil
end

local function getProperTargetBasedOnMouseOver()
    local unit = "mouseover"
    if not UnitExists(unit) then
        local frame = GetMouseFocus()
        if frame.label and frame.id then
            unit = frame.label .. frame.id
        elseif UnitExists("target") then
            unit = "target"
        elseif GetCVar("autoSelfCast") == "1" then
            unit = "player"
        else
            return
        end
    end

    -- If target and mouseover are friendly units, we can't use spell target as it
    -- would cast on the target instead of the mouseover. However, if the mouseover
    -- is friendly and the target is not, we can try to obtain the best unitstring
    -- for the later SpellTargetUnit() call.
    return ((not UnitCanAssist("player", "target") and UnitCanAssist("player", unit) and getUnitString(unit)) or "player")
end

function SmartHealer:pfUI_PFCast(msg)
    local spell, rank = libSC:GetRanklessSpellName(msg)
    if spell and rank == nil and libHC.Spells[spell] then
        local unitstr = getProperTargetBasedOnMouseOver()
        if unitstr == nil then return end
        rank = self:GetOptimalRank(msg, unitstr)
        if rank then
            self.hooks[SlashCmdList]["PFCAST"](libSC:GetSpellNameText(spell, rank)) -- mission accomplished
            return
        end
    end

    self.hooks[SlashCmdList]["PFCAST"](msg) -- fallback if we can't find optimal rank
end
