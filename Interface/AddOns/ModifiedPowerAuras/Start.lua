--------------- Frames and Funktionallity ---------------
function MPOWA:CreateSave(i)
  self.SAVE[i] = MPOWA_AURA_DEFAULT_SETTINGS

  local cat = i;

  if self.SAVE[i]["flashanim"] then
    self:AddAnimFlash(cat)
  end

  if self.SAVE[i]["growout"] then
    self:AddAnimGrowOut(cat)
  end

  if self.SAVE[i]["growin"] then
    self:AddAnimGrowIn(cat)
  end

  if self.SAVE[i]["fadeout"] then
    self:AddAnimFadeOut(cat)
  end

  if self.SAVE[i]["fadein"] then
    self:AddAnimFadeIn(cat)
  end

  if self.SAVE[i]["escapeanimout"] then
    self:AddAnimEscapeOut(cat)
  end

  if self.SAVE[i]["escapeanimin"] then
    self:AddAnimEscapeIn(cat)
  end

  if self.SAVE[i]["shrinkanim"] then
    self:AddAnimShrink(cat)
  end

  if self.SAVE[i]["sizeanim"] then
    self:AddAnimSizeIn(cat)
  end

  if self.SAVE[i]["translateanim"] then
    self:AddAnimTranslate(cat)
  end

  if self.SAVE[i]["rotateanimout"] then
    self:AddAnimRotateOut(cat)
  end

  if self.SAVE[i]["rotateanimin"] then
    self:AddAnimRotateIn(cat)
  end

  if self.SAVE[i]["batmananimout"] then
    self:AddAnimRotateShrinkFadeOut(cat)
  end

  if self.SAVE[i]["batmananimin"] then
    self:AddAnimRotateShrinkFadeIn(cat)
  end

  if not self.SAVE[i]["cpstacks"] then
    self.SAVE[cat]["cpstacks"] = ">=0"
  end
end

function MPOWA:Init()
  if MPOWA_SAVE then
    self.SAVE = table.copy(MPOWA_SAVE, true)
  end

  MPowa_Tooltip:SetOwner(UIParent, "ANCHOR_NONE")

  SLASH_MPOWA1 = "/mpowa"
  SLASH_MPOWA2 = "/wa"  -- Added for those of us with Classic/Retail habits
  SlashCmdList["MPOWA"] = function(msg)
    if MPowa_MainFrame:IsVisible() then
      MPowa_MainFrame:Hide()
    else
      self:Show()
    end
  end

  if self.SAVE == nil then
    self.SAVE = {}
    self:CreateSave(1)
  end

  if MPOWA_PROFILE == nil then
    MPOWA_PROFILE = {}
  end

  for cat, val in self.SAVE do
    if val["used"] or (self.SAVE[cat + 1] and self.SAVE[cat + 1]["used"]) then
      if not self.frames[cat] then
        self.frames[cat] = {}
      end

      if not self.auras[val["buffname"]] then
        self.auras[val["buffname"]] = {}
      end
      tinsert(self.auras[val["buffname"]], cat)

      if (val["inverse"] or val["cooldown"]) and val["buffname"] ~= "unitpower" then
        self.NeedUpdate[cat] = true
      end

      if val["enemytarget"] or val["friendlytarget"] then
        self.SAVE[cat]["unit"] = "target"
      else
        self.SAVE[cat]["unit"] = nil
      end

      if val["used"] then
        self.NumBuffs = cat
      end

      if val["rgmname"] then
        self.RaidGroupMembers[val["rgmname"]] = true
      end

      if not val["secsleftdur"] or val["secsleftdur"] == "" then
        self.SAVE[cat]["secsleftdur"] = 0
      end

      if not val["inraidinstance"] then
        self.SAVE[cat]["inraidinstance"] = 0
      end

      if not val["secondspecifiertext"] then
        self.SAVE[cat]["secondspecifiertext"] = ""
      end

      -- Initializing animations
      if not val["animduration"] then
        self.SAVE[cat]["animduration"] = 0.5
      end

      if not val["translateoffsetx"] then
        self.SAVE[cat]["translateoffsetx"] = 50
      end

      if not val["translateoffsety"] then
        self.SAVE[cat]["translateoffsety"] = 50
      end

      if not val["fadealpha"] then
        self.SAVE[cat]["fadealpha"] = 0.99
      end

      if not val["scalefactor"] then
        self.SAVE[cat]["scalefactor"] = 0.8
      end

      if not val["dynamicorientation"] then
        self.SAVE[cat]["dynamicorientation"] = 1
      end

      if not val["timerfont"] then
        self.SAVE[cat]["timerfont"] = 1
      end

      if not val["dynamicspacing"] then
        self.SAVE[cat]["dynamicspacing"] = 5
      end

      if not val["blendmode"] then
        self.SAVE[cat]["blendmode"] = 1
      end

      if not val["timerfontsize"] then
        self.SAVE[cat]["timerfontsize"] = 1
      end

      if not val["stance"] then
        self.SAVE[cat]["stance"] = 1
      end

      if not val["spellslot"] then
        self.SAVE[cat]["spellslot"] = 1
      end

      MPOWA:SpellSlot(val)

      if not val["abilityavailable"] then
        self.SAVE[cat]["abilityavailable"] = false
      end

      self:CreateIcon(cat, cat)
      self:ApplyConfig(cat)

      if val["flashanim"] then
        self:AddAnimFlash(cat)
      end

      if val["growout"] then
        self:AddAnimGrowOut(cat)
      end

      if val["growin"] then
        self:AddAnimGrowIn(cat)
      end

      if val["fadeout"] then
        self:AddAnimFadeOut(cat)
      end

      if val["fadein"] then
        self:AddAnimFadeIn(cat)
      end

      if val["escapeanimout"] then
        self:AddAnimEscapeOut(cat)
      end

      if val["escapeanimin"] then
        self:AddAnimEscapeIn(cat)
      end

      if val["shrinkanim"] then
        self:AddAnimShrink(cat)
      end

      if val["sizeanim"] then
        self:AddAnimSizeIn(cat)
      end

      if val["translateanim"] then
        self:AddAnimTranslate(cat)
      end

      if val["rotateanimout"] then
        self:AddAnimRotateOut(cat)
      end

      if val["rotateanimin"] then
        self:AddAnimRotateIn(cat)
      end

      if val["batmananimout"] then
        self:AddAnimRotateShrinkFadeOut(cat)
      end

      if val["batmananimin"] then
        self:AddAnimRotateShrinkFadeIn(cat)
      end

      if not val["cpstacks"] then
        self.SAVE[cat]["cpstacks"] = ">=0"
      end

      self.SAVE[cat]["test"] = false
    else
      self.SAVE[cat] = nil
    end
  end
  self.testAll = false
end


function MPOWA:SpellSlot(val)
  if val["buffname"] and val["spellslot"] then
    val["spellslot"] = 1
    local spellIndex = 1
    while true do
      local name, rank = GetSpellName(spellIndex, "spell")
      if (not name) or strfind(strlower(name), strlower(val["buffname"])) or name == val["buffname"] then
        break
      end
      if spellIndex > 1000 then
        spellIndex = 0
        break -- Lets give up at this point
      end
      spellIndex = spellIndex + 1
    end
    local spellTexture = GetSpellTexture(spellIndex, "spell")
    for i = 1, 120 do
      local slotTexture = GetActionTexture(i)
      if slotTexture == spellTexture then
        val["spellslot"] = i
        return
      end
    end
    return
  end
end


function MPOWA:GetStanceSlot(val)
  for i = 1, 6 do
    local icon, name, active, castable = GetShapeshiftFormInfo(i);
    if active then
      return i
    end
  end
  return 0
end
--------------- Post Init --------------------------

MPOWA:SetScript("OnUpdate", function()
  MPOWA:OnUpdate(arg1)
end)
MPOWA:SetScript("OnEvent", function()
  MPOWA:OnEvent(event, arg1)
end)
MPOWA:RegisterEvent("VARIABLES_LOADED")
MPOWA:RegisterEvent("UNIT_AURA")
MPOWA:RegisterEvent("PLAYER_TARGET_CHANGED")
MPOWA:RegisterEvent("RAID_ROSTER_UPDATE")
MPOWA:RegisterEvent("PARTY_MEMBERS_CHANGED")
MPOWA:RegisterEvent("PLAYER_AURAS_CHANGED")
MPOWA:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS")
MPOWA:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_SELF")
MPOWA:RegisterEvent("PLAYER_REGEN_DISABLED")
MPOWA:RegisterEvent("PLAYER_REGEN_ENABLED")
MPOWA:RegisterEvent("UNIT_MANA")
MPOWA:RegisterEvent("UNIT_RAGE")
MPOWA:RegisterEvent("UNIT_ENERGY")
MPOWA:RegisterEvent("PLAYER_LOGOUT")
