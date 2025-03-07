CreateFrame("Frame", "MPOWA", UIParent)
MPOWA.Build = 90
MPOWA.Cloaded = false
MPOWA.loaded = false
MPOWA.selected = 1
MPOWA.CurEdit = 1
MPOWA.Page = 1

MPOWA.frames = {}
MPOWA.auras = {}
MPOWA.groupByNames = {}
MPOWA.groupByUnit = {}
MPOWA.NumBuffs = 0
MPOWA.NeedUpdate = {}
MPOWA.RaidGroupMembers = {}
MPOWA.testall = false

MPOWA.active = {}
MPOWA.pushed = {}
MPOWA.activeTimer = {}
MPOWA.lastCount = {}
MPOWA.mounted = false
MPOWA.party = false
MPOWA.bg = false
MPOWA.instance = false
MPOWA.Zones = {
  [MPOWA_ZONES_MC] = true,
  [MPOWA_ZONES_BWL] = true,
  [MPOWA_ZONES_ONY] = true,
  [MPOWA_ZONES_ZG] = true,
  [MPOWA_ZONES_AQ401] = true,
  [MPOWA_ZONES_AQ20] = true,
  [MPOWA_ZONES_AQ402] = true,
  [MPOWA_ZONES_NAXX] = true
}

MPOWA.SOUND = {
  [0] = "None",
  [1] = "LEVELUP",
  [2] = "LOOTWINDOWCOINMPOWA:SOUND",
  [3] = "MapPing",
  [4] = "HumanExploration",
  [5] = "QUESTADDED",
  [6] = "QUESTCOMPLETED",
  [7] = "WriteQuest",
  [8] = "Fishing Reel in",
  [9] = "igPVPUpdate",
  [10] = "ReadyCheck",
  [11] = "RaidWarning",
  [12] = "AuctionWindowOpen",
  [13] = "AuctionWindowClose",
  [14] = "TellMessage",
  [15] = "igBackPackOpen",
  [16] = "MPOWA\\aggro.ogg",
  [17] = "MPOWA\\bam.ogg",
  [18] = "MPOWA\\cat2.ogg",
  [19] = "MPOWA\\cookie.ogg",
  [20] = "MPOWA\\moan.ogg",
  [21] = "MPOWA\\phone.ogg",
  [22] = "MPOWA\\shot.ogg",
  [23] = "MPOWA\\sonar.ogg",
  [24] = "MPOWA\\splash.ogg",
  [25] = "MPOWA\\wilhelm.ogg",
  [26] = "MPOWA\\huh_1.ogg",
  [27] = "MPOWA\\bear_polar.ogg",
  [28] = "MPOWA\\bigkiss.ogg",
  [29] = "MPOWA\\BITE.ogg",
  [30] = "MPOWA\\PUNCH.ogg",
  [31] = "MPOWA\\burp4.ogg",
  [32] = "MPOWA\\chimes.ogg",
  [33] = "MPOWA\\Gasp.ogg",
  [34] = "MPOWA\\hic3.ogg",
  [35] = "MPOWA\\hurricane.ogg",
  [36] = "MPOWA\\Squeakypig.ogg",
  [37] = "MPOWA\\panther1.ogg",
  [38] = "MPOWA\\rainroof.ogg",
  [39] = "MPOWA\\snakeatt.ogg",
  [40] = "MPOWA\\sneeze.ogg",
  [41] = "MPOWA\\thunder.ogg",
  [42] = "MPOWA\\wickedmalelaugh1.ogg",
  [43] = "MPOWA\\wlaugh.ogg",
  [44] = "MPOWA\\wolf5.ogg",
  [45] = "MPOWA\\swordecho.ogg",
  [46] = "MPOWA\\throwknife.ogg",
  [47] = "MPOWA\\yeehaw.ogg",
  [48] = "MPOWA\\Fireball.ogg",
  [49] = "MPOWA\\rocket.ogg",
  [50] = "MPOWA\\Arrow_Swoosh.ogg",
  [51] = "MPOWA\\ESPARK1.ogg",
  [52] = "MPOWA\\chant4.ogg",
  [53] = "MPOWA\\chant2.ogg",
  [54] = "MPOWA\\shipswhistle.ogg",
  [55] = "MPOWA\\kaching.ogg",
  [56] = "MPOWA\\heartbeat.ogg",
  [57] = "MPOWA\\Hit1.ogg", -- Thanks to Sillywet!
  [58] = "MPOWA\\Hit2.ogg", -- Thanks to Sillywet!
  [59] = "MPOWA\\Hit3.ogg", -- Thanks to Sillywet!
  [60] = "MPOWA\\Hit4.ogg", -- Thanks to Sillywet!
  [61] = "MPOWA\\Hit5.ogg", -- Thanks to Sillywet!
  [62] = "MPOWA\\Hit6.ogg", -- Thanks to Sillywet!
  [63] = "MPOWA\\Hit7.ogg", -- Thanks to Sillywet!
  [64] = "MPOWA\\Hit8.ogg", -- Thanks to Sillywet!
  -- Added WeakAuras Sounds
  [65] = "WeakAuras\\AcousticGuitar.ogg",
  [66] = "WeakAuras\\Adds.ogg",
  [67] = "WeakAuras\\AirHorn.ogg",
  [68] = "WeakAuras\\Applause.ogg",
  [69] = "WeakAuras\\BananaPeelSlip.ogg",
  [70] = "WeakAuras\\BatmanPunch.ogg",
  [71] = "WeakAuras\\BikeHorn.ogg",
  [72] = "WeakAuras\\Blast.ogg",
  [73] = "WeakAuras\\Bleat.ogg",
  [74] = "WeakAuras\\Boss.ogg",
  [75] = "WeakAuras\\BoxingArenaSound.ogg",
  [76] = "WeakAuras\\CartoonVoiceBaritone.ogg",
  [77] = "WeakAuras\\CartoonWalking.ogg",
  [78] = "WeakAuras\\CatMeow2.ogg",
  [79] = "WeakAuras\\WaterDrop.ogg",
  [80] = "WeakAuras\\ChickenAlarm.ogg",
  [81] = "WeakAuras\\Circle.ogg",
  [82] = "WeakAuras\\CowMooing.ogg",
  [83] = "WeakAuras\\Cross.ogg",
  [84] = "WeakAuras\\Diamond.ogg",
  [85] = "WeakAuras\\DontRelease.ogg",
  [86] = "WeakAuras\\DoubleWhoosh.ogg",
  [87] = "WeakAuras\\Drums.ogg",
  [88] = "WeakAuras\\Empowered.ogg",
  [89] = "WeakAuras\\Xylophone.ogg",
  [90] = "WeakAuras\\ErrorBeep.ogg",
  [91] = "WeakAuras\\Focus.ogg",
  [92] = "WeakAuras\\GoatBleating.ogg",
  [93] = "WeakAuras\\Idiot.ogg",
  [94] = "WeakAuras\\KittenMeow.ogg",
  [95] = "WeakAuras\\Left.ogg",
  [96] = "WeakAuras\\Moon.ogg",
  [97] = "WeakAuras\\Next.ogg",
  [98] = "WeakAuras\\OhNo.ogg",
  [99] = "WeakAuras\\WarningSiren.ogg",
  [100] = "WeakAuras\\Portal.ogg",
  [101] = "WeakAuras\\Protected.ogg",
  [102] = "WeakAuras\\Release.ogg",
  [103] = "WeakAuras\\Right.ogg",
  [104] = "WeakAuras\\RingingPhone.ogg",
  [105] = "WeakAuras\\RoaringLion.ogg",
  [106] = "WeakAuras\\RobotBlip.ogg",
  [107] = "WeakAuras\\RoosterChickenCalls.ogg",
  [108] = "WeakAuras\\RunAway.ogg",
  [109] = "WeakAuras\\Triangle.ogg",
  [110] = "WeakAuras\\SharpPunch.ogg",
  [111] = "WeakAuras\\SheepBleat.ogg",
  [112] = "WeakAuras\\Shotgun.ogg",
  [113] = "WeakAuras\\Skull.ogg",
  [114] = "WeakAuras\\Spread.ogg",
  [115] = "WeakAuras\\Square.ogg",
  [116] = "WeakAuras\\SqueakyToyShort.ogg",
  [117] = "WeakAuras\\SquishFart.ogg",
  [118] = "WeakAuras\\Stack.ogg",
  [119] = "WeakAuras\\Torch.ogg",
  [120] = "WeakAuras\\Star.ogg",
  [121] = "WeakAuras\\Switch.ogg",
  [122] = "WeakAuras\\SynthChord.ogg",
  [123] = "WeakAuras\\TadaFanfare.ogg",
  [124] = "WeakAuras\\Taunt.ogg",
  [125] = "WeakAuras\\TempleBellHuge.ogg",
}

MPOWA.Windfury = false
MPOWA.SAVE = {}

local function deepCopy(object)
  local lookup_table = {}
  local function _copy(object)
    if type(object) ~= "table" then
      return object
    elseif lookup_table[object] then
      return lookup_table[object]
    end
    local new_table = {}
    lookup_table[object] = new_table
    for index, value in pairs(object) do
      new_table[_copy(index)] = _copy(value)
    end
    return setmetatable(new_table, getmetatable(object))
  end
  return _copy(object)
end
table.copy = deepCopy

if MPOWA_SAVE then
  for j = 1, table.getn(MPOWA_SAVE) do
    if not MPOWA_SAVE[j].funct then
      MPOWA_SAVE[j].funct = nil
    end
  end
  MPOWA.SAVE = table.copy(MPOWA_SAVE, true)
end

function MPOWA:OnEvent(event, arg1)
  if event == "UNIT_AURA" then
    if arg1 == "target" or self.groupByUnit[arg1] then
      self:Iterate(arg1)
    end
  elseif event == "PLAYER_TARGET_CHANGED" then
    for c, v in self.auras do
      if v then
        for cat, val in v do
          if self.active[val] or self.frames[val][1]:IsVisible() then
            local p = self.SAVE[val]
            if p["enemytarget"] or p["friendlytarget"] then
              self.active[val] = false
              self:FHide(val)
              self.frames[val][3]:Hide()
              self.frames[val][1]:SetAlpha(p["alpha"])
            end
          end
        end
      end
    end
    self:Iterate("target")
  elseif event == "RAID_ROSTER_UPDATE" or event == "PARTY_MEMBERS_CHANGED" then
    self:GetGroup()
  elseif event == "PLAYER_AURAS_CHANGED" then
    self:Iterate("player")
  elseif event == "CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS" then
    if arg1 == MPOWA_WINDFURY_GAIN or arg1 == MPOWA_WINDFURY_GAIN2 or arg1 == MPOWA_WINDFURY_GAIN3 then
      self.Windfury = true
    end
  elseif event == "CHAT_MSG_SPELL_AURA_GONE_SELF" or event == "PLAYER_REGEN_DISABLED" or event == "PLAYER_REGEN_ENABLED" then
    if arg1 == MPOWA_WINDFURY_GONE or arg1 == MPOWA_WINDFURY_GONE2 or arg1 == MPOWA_WINDFURY_GONE3 then
      self.Windfury = false
    end
  elseif event == "UNIT_MANA" or event == "UNIT_RAGE" or event == "UNIT_ENERGY" then
    if arg1 then
      local unit = arg1
      if (unit == "target") then
        self:Push("unitpower", unit, 45, false)
      elseif (string.find(unit, "raid")) then
        local st = string.sub(unit, 5)
        if st and tonumber(st) then
          self:Push("unitpower", unit, (tonumber(st) or 0) + 45, false)
        end
      elseif (string.find(unit, "party")) then
        local st = string.sub(unit, 6)
        if st and tonumber(st) then
          self:Push("unitpower", unit, (tonumber(st) or 0) + 45, false)
        end
      end
    end
  elseif event == "PLAYER_LOGOUT" then
    MPOWA_SAVE = table.copy(self.SAVE, true)
  else
    self:Init()
    self.loaded = true
  end
end
