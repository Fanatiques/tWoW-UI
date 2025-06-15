local L = "LoseControl"
local BS = AceLibrary("Babble-Spell-2.2a");
local CC      = "CC"
local Silence = "Silence"
local Disarm  = "Disarm"
local Root    = "Root"
local Snare   = "Snare"
local Immune  = "Immune"
local PvE     = "PvE"

local Prio = {CC,Silence,Disarm,Root,Snare}

--[[
	SaySapped: Says "Sapped!" when you get sapped allowing you to notify nearby players about it.
	Also works for many other CCs.
	Author: Coax  - Nostalrius PvP
	Translate and rework by: CFM - LH
	Original idea: Bitbyte of Icecrown
--]]

-- Slash Command
SLASH_LOSECONTROL1 = '/saysapped'
SLASH_LOSECONTROL2 = '/ssap'
function SlashCmdList.LOSECONTROL(msg, editbox)
  	if SaySappedConfig then
		SaySappedConfig = false
		DEFAULT_CHAT_FRAME:AddMessage(SS_DISABLED)
	else
		SaySappedConfig = true
		DEFAULT_CHAT_FRAME:AddMessage(SS_ENABLED)
	end
end

-- Translated by CFM
if GetLocale()=="ruRU" then
	SS_Sapped='Sapped!'
	SS_SpellSap='"Ошеломление".'
	SS_Loaded='|cffffff55LoseControl загружен /ssap. Мод от CFM.'
	SS_SELFHARMFULL='Вы находитесь'
	SS_DISABLED='|cffffff55SaySapped выключен!'
	SS_ENABLED='|cffffff55SaySapped включен!'
else
	SS_Sapped='Sapped!'
	SS_SpellSap=' Sap.'
	SS_Loaded='|cffffff55LoseControl loaded /ssap. Mod by CFM.'
	SS_SELFHARMFULL='You are'
	SS_DISABLED='|cffffff55SaySapped disabled!'
	SS_ENABLED='|cffffff55SaySapped enabled!'
end

local SaySapped = CreateFrame("Frame",nil,UIParent)
SaySapped:RegisterEvent("ADDON_LOADED")

SaySapped:SetScript("OnEvent", function()
	if arg1 == "LoseControl" then
		DEFAULT_CHAT_FRAME:AddMessage(SS_Loaded)
		if not SaySappedConfig then
			SaySappedConfig = true;
		end
		SaySapped.checkbuff = CreateFrame("Frame")
		SaySapped.checkbuff:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE")
		SaySapped.checkbuff:SetScript("OnEvent", function()
			if string.find(arg1, SS_SELFHARMFULL) then
				SaySapped_FilterDebuffs(arg1)
			end
		end)
	end
end)

-- Check if sapped
function SaySapped_FilterDebuffs(spell)
	if string.find(spell, SS_SpellSap) and SaySappedConfig then
		SendChatMessage(SS_Sapped,"SAY")
		DEFAULT_CHAT_FRAME:AddMessage(SS_Sapped)
	end
end

local spellIds = {
	-- Druid
	[BS["Hibernate"]] = CC, -- Hibernate
	[BS["Starfire Stun"]] = CC, -- Starfire
	[BS["Bash"]] = CC, -- Bash
	[BS["Feral Charge Effect"]] = Root, -- Feral Charge Efect
	[BS["Pounce"]] = CC, -- Pounce
	[BS["Pounce Bleed"]] = CC, -- Pounce
	[BS["Entangling Roots"]] = Root, -- Entangling Roots
	-- Hunter
	[BS["Freezing Trap"]] = CC, -- Freezing Trap
	[BS["Intimidation"]] = CC, -- Intimidation
	[BS["Scare Beast"]] = CC, -- Scare Beast
	[BS["Scatter Shot"]] = CC, -- Scatter Shot
	[BS["Improved Concussive Shot"]] = CC, -- Improved Concussive Shot
	[BS["Concussive Shot"]] = Snare, -- Concussive Shot
	[BS["Freezing Trap Effect"]] = CC, -- Freezing Trap
	[BS["Freezing Trap"]] = CC, -- Freezing Trap
	[BS["Frost Trap Aura"]] = Root, -- Freezing Trap
	[BS["Frost Trap"]] = Root, -- Frost Trap
	[BS["Entrapment"]] = Root, -- Entrapment
	[BS["Wyvern Sting"]] = CC, -- Wyvern Sting; requires a hack to be removed later
	[BS["Counterattack"]] = Root, -- Counterattack
	[BS["Improved Wing Clip"]] = Root, -- Improved Wing Clip
	[BS["Wing Clip"]] = Snare, -- Wing Clip
	["Boar Charge"] = Root, -- Boar Charge
	-- Mage
	[BS["Polymorph"]] = CC, -- Polymorph: Sheep
	[BS["Polymorph: Turtle"]] = CC, -- Polymorph: Turtle
	[BS["Polymorph: Pig"]] = CC, -- Polymorph: Pig
	["Polymorph: Cow"] = CC, -- Polymorph: Cow
	["Polymorph: Chicken"] = CC, -- Polymorph: Chicken
	[BS["Counterspell - Silenced"]] = Silence, -- Counterspell
	[BS["Impact"]] = CC, -- Impact
	[BS["Blast Wave"]] = Snare, -- Blast Wave
	[BS["Frostbite"]] = Root, -- Frostbite
	[BS["Freeze"]] = Root, -- Freeze
	[BS["Frost Nova"]] = Root, -- Frost Nova
	[BS["Frostbolt"]] = Snare, -- Frostbolt
	[BS["Chilled"]] = Snare, -- Improved Blizzard + Ice armor
	[BS["Cone of Cold"]] = Snare, -- Cone of Cold
	[BS["Counterspell - Silenced"]] = Silence, -- Counterspell - Silenced
	-- Paladin
	[BS["Hammer of Justice"]] = CC, -- Hammer of Justice
	[BS["Repentance"]] = CC, -- Repentance
	-- Priest
	[BS["Mind Control"]] = CC, -- Mind Control
	[BS["Psychic Scream"]] = CC, -- Psychic Scream
	[BS["Blackout"]] = CC, -- Затмение
	[BS["Silence"]] = Silence, -- Silence
	[BS["Mind Flay"]] = Snare, -- Mind Flay
	-- Rogue
	[BS["Blind"]] = CC, -- Blind
	[BS["Cheap Shot"]] = CC, -- Cheap Shot
	[BS["Gouge"]] = CC, -- Gouge
	[BS["Kidney Shot"]] = CC, -- Kidney shot; the buff is 30621
	[BS["Sap"]] = CC, -- Sap
	[BS["Kick - Silenced"]] = Silence, -- Kick
	[BS["Crippling Poison"]] = Snare, -- Crippling Poison
	-- Warlock
	[BS["Death Coil"]] = CC, -- Death Coil
	[BS["Fear"]] = CC, -- Fear
	[BS["Howl of Terror"]] = CC, -- Howl of Terror
	[BS["Curse of Exhaustion"]] = Snare, -- Curse of Exhaustion
	[BS["Pyroclasm"]] = CC, -- Pyroclasm
	[BS["Aftermath"]] = Snare, -- Aftermath
	[BS["Seduction"]] = CC, -- Seduction
	[BS["Spell Lock"]] = Silence, -- Spell Lock
	[BS["Inferno Effect"]] = CC, -- Inferno Effect
	[BS["Inferno"]] = CC, -- Inferno
	[BS["Cripple"]] = Snare, -- Cripple
	-- Warrior
	[BS["Charge Stun"]] = CC, -- Charge Stun
	[BS["Intercept Stun"]] = CC, -- Intercept Stun
	[BS["Intimidating Shout"]] = CC, -- Intimidating Shout
	[BS["Revenge Stun"]] = CC, -- Revenge Stun
	[BS["Concussion Blow"]] = CC, -- Concussion Blow
	[BS["Piercing Howl"]] = Snare, -- Piercing Howl
	[BS["Mortal Strike"]] = Snare, -- Mortal Strike CFM
	[BS["Shield Bash - Silenced"]] = Silence, -- Shield Bash - Silenced
	--CFM
	-- other
	[BS["War Stomp"]] = CC, -- War Stomp
	[BS["Mace Stun Effect"]] = CC, -- Mace Specialization CFM
	[BS["Ice Blast"]] = CC, -- Ice Yeti
	[BS["Snap Kick"]] = CC, -- Ashenvale Outrunner
	[BS["Lash"]] = CC, -- Lashtail Raptor
	[BS["Crystal Gaze"]] = CC, -- Crystal Spine Basilisk
	[BS["Web"]] = Root,      -- Carrion Lurker
	[BS["Terrify"]] = CC, -- Fr Pterrordax
	[BS["Terrifying Screech"]] = CC, -- Pterrordax
	[BS["Flash Freeze"]] = CC, -- Freezing Ghoul
	[BS["Knockdown"]] = CC, -- Zaeldarr the Outcast etc
	[BS["Net"]] = Root,-- Witherbark Headhunter etc
	[BS["Flash Bomb"]] = CC,-- AV 	Световая бомба
	[BS["Reckless Charge"]] = CC, -- инженерка Безрассудная атака
	[BS["Tidal Charm"]] = CC, -- Tidal Charm
	[BS["Stun"]] = CC, -- Stun
	["Gnomish Mind Control Cap"] = CC, -- Gnomish Mind Control Cap
	[BS["Sleep"]] = CC, -- Sleep
	[BS["Dazed"]] = Snare, -- Dazed
	[BS["Freeze"]] = Root, -- Freeze
	["Chill"] = Snare, -- Chill
	[BS["Charge"]] = CC, -- Charge
}

local wipe = function(t)
	for k,v in pairs(t) do
		t[k]=nil
	end
	return t
end

local ToggleDrag = function()
  if not LoseControlPlayer:IsMouseEnabled() then
  	LoseControlPlayer:EnableMouse(true)
  	LoseControlPlayer:RegisterForDrag("RightButton")
  	LoseControlPlayer:SetScript("OnDragStart",function() this:StartMoving() end)
  	LoseControlPlayer:SetScript("OnDragStop",function() this:StopMovingOrSizing() end)
  	LoseControlPlayer.texture:SetTexture(1,0,0,1)
  	LoseControlPlayer:Show()
  	DEFAULT_CHAT_FRAME:AddMessage("LoseControl: Drag with right button")
  else
  	LoseControlPlayer:RegisterForDrag(nil)
  	LoseControlPlayer:EnableMouse(false)
  	LoseControlPlayer:SetScript("OnDragStart",nil)
  	LoseControlPlayer:SetScript("OnDragStop",nil)
  	LoseControlPlayer.texture:SetTexture(nil)
  	LoseControlPlayer:Hide()
  	DEFAULT_CHAT_FRAME:AddMessage("LoseControl: Saved new position")
  end
end

function LCPlayer_OnLoad()	
	this:SetPoint("CENTER", 0, -60)
	this:RegisterEvent("UNIT_AURA")
	this:RegisterEvent("PLAYER_AURAS_CHANGED")
	this:RegisterEvent("VARIABLES_LOADED")

	this.texture = this:CreateTexture(this, "BACKGROUND")
	this.texture:SetAllPoints(this)
	this.cooldown = CreateFrame("Model", "Cooldown", this, "CooldownFrameTemplate")
	this.cooldown:SetAllPoints(this) 
	this.maxExpirationTime = 0
	this:Hide()
	this:EnableMouse(false)
	this:SetUserPlaced(true)
end

local trackedSpells = {}
local cachedTextures = {}
function LCPlayer_OnEvent()
	if event == "VARIABLES_LOADED" then
		LoseControlDB = LoseControlDB or {size=40}
		this:SetHeight(LoseControlDB.size)
		this:SetWidth(LoseControlDB.size)
		if IsAddOnLoaded("pfUI") then
			if pfUI.api ~= nil and type(pfUI.api.CreateBackdrop) == "function" then
				pfUI.api.CreateBackdrop(this)
				this:UnregisterEvent("VARIABLES_LOADED")
			end
		end
		return
	end
	trackedSpells = wipe(trackedSpells)
	local spellFound
	for i=1, 16 do -- 16 is enough due to HARMFUL filter
		local texture = UnitDebuff("player", i)
		LCTooltip:ClearLines()
		LCTooltip:SetUnitDebuff("player", i)
		local buffName = LCTooltipTextLeft1:GetText()
		if spellIds[buffName] ~= nil then
			if cachedTextures[buffName] == nil then cachedTextures[buffName] = texture end
			trackedSpells[table.getn(trackedSpells)+1] = buffName
		end
	end
	if table.getn(trackedSpells) > 1 then
		table.sort(trackedSpells,function(a,b)
				if Prio[spellIds[a]]~=nil and Prio[spellIds[b]]~=nil then
				return Prio[spellIds[a]] < Prio[spellIds[b]] end
				return a > b
			end)
	end
	spellFound = trackedSpells[1] -- highest prio spell
	if (spellFound) then
		for j=0, 31 do
			local buffTexture = GetPlayerBuffTexture(j)
			if cachedTextures[spellFound] == buffTexture then
				local expirationTime = GetPlayerBuffTimeLeft(j)
				this:Show()
				this.texture:SetTexture(buffTexture)
				this.cooldown:SetModelScale(this:GetEffectiveScale() or 1)
				if this.maxExpirationTime <= expirationTime then
					CooldownFrame_SetTimer(this.cooldown, GetTime(), expirationTime, 1)
					this.maxExpirationTime = expirationTime
				end
				return
			end
		end	
	end
	if spellFound == nil then
		this.maxExpirationTime = 0
		this:Hide()
	end
end

SLASH_LOSECONTROL1 = "/losecontrol"
SlashCmdList["LOSECONTROL"] = function(options)
  if not (options) or options == "" then
  	DEFAULT_CHAT_FRAME:AddMessage("/losecontrol unlock : toggles lock for dragging")
  	DEFAULT_CHAT_FRAME:AddMessage("/losecontrol size x : sets icons size to x (10-50)")
  else
    local option = {}
    for opt in string.gfind(options,"([^ ]+)") do
      table.insert(option,opt)
    end
    if table.getn(option) > 0 then
    	local command = string.lower(table.remove(option,1))
    	-- TODO: future options would go here (scale, prio, filter etc)
    	if command == "unlock" or command == "lock" then
    		ToggleDrag()
    	elseif command == "size" then
    		local newsize = tonumber(table.remove(option,1))
    		if (newsize) and newsize >= 10 and newsize <= 50 then
    			LoseControlPlayer:SetWidth(newsize)
    			LoseControlPlayer:SetHeight(newsize)
    			LoseControlDB.size = newsize
    		end
    	end
    end
  end
end

function LCTarget_OnLoad()
	
end

function LCTarget_OnEvent()
	
end