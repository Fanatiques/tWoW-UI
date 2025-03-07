local stf = strfind
local _G = getglobal
local tinsert = table.insert
local tremove = table.remove
local UN = UnitName
local strform = string.format
local flr = floor
local strgfind = string.gfind
local strfind = string.find
local GT = GetTime
local tnbr = tonumber

function MPOWA:Reverse(bool)
  return not bool
end

function MPOWA:Print(msg)
  DEFAULT_CHAT_FRAME:AddMessage("MPOWA: " .. msg)
end

function MPOWA:GetGroup()
  local num, type = GetNumPartyMembers(), "party"
  if num <= 0 then
    num = GetNumRaidMembers()
    type = "raid"
  end
  if num > 0 then
    for i = 1, num do
      local name = UN(type .. i)
      if self.RaidGroupMembers[name] then
        self.groupByNames[name] = type .. i
        self.groupByUnit[type .. i] = name
      end
    end
  end
end

function MPOWA:GetTablePosition(tab, value)
  for cat, val in tab do
    if val == value then
      return cat
    end
  end
  return false
end

function MPOWA:GetMaxValues(val)
  val = tonumber(val)
  return ceil(val) + 50
end

function MPOWA:GetMinValues(val)
  val = tonumber(val)
  return ceil(val) - 50
end

function MPOWA:GetTableSize(t)
    local count = 0
    for _, _ in pairs(t) do
        count = count + 1
    end
    return count
end


function MPOWA:FormatValue(x)
    if type(x) == "nil" then
        return "nil"
    elseif type(x) == "boolean" then
        return tostring(x)
    elseif type(x) == "number" then
        return tostring(x)
    elseif type(x) == "string" then
        return x
    elseif type(x) == "table" then
        local result = "{"
        for k, v in pairs(x) do
            result = result .. "[" .. tostring(k) .. "] = " .. formatValue(v) .. ", "
        end
        result = result .. "}"
        return result
    else
        return "unsupported type"
    end
end


function MPOWA:RegisterSound(label, mpath)
    local s = MPOWA:GetTableSize(MPOWA.SOUND_ENTRIES)
    MPOWA.SOUND_ENTRIES[s] = mpath
    MPOWA:Print("Added idx[" .. s .. "] for " .. mpath)
end