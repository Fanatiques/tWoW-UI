-- load pfUI environment
setfenv(1, pfUI:GetEnvironment())

local scanner = libtipscan:GetScanner("WeakIcons")

local function GetBuffData(unit, id, atype, skipTooltip)
    if unit == "player" then
        local bid = GetPlayerBuff(PLAYER_BUFF_START_ID+id, atype)
        local stacks = GetPlayerBuffApplications(bid)
        local remaining = GetPlayerBuffTimeLeft(bid)
        local texture = GetPlayerBuffTexture(bid)
        local name
        if not skipTooltip and texture then
            scanner:SetPlayerBuff(bid)
            name = scanner:Line(1)
        end
        return texture, name, remaining, stacks
    elseif libdebuff then
        local name, _, texture, stacks, _, _, remaining = libdebuff:UnitDebuff(unit, id)
        return texture, name, remaining, stacks
    end
end

--{{
-- Creates a frame that watches player and target aura situation
local watcher = CreateFrame("Frame", "pfWeakIconsWatcherFrame", UIParent)

watcher.playerbuffs = {}
for i=1,32 do
    watcher.playerbuffs[i] = {}
end
watcher.targetdebuffs = {}
for i=1,32 do
    watcher.targetdebuffs[i] = {}
end

-- Update the OnUpdate script to include debuffs found in buff slots
watcher:SetScript("OnUpdate", function()
    --Throttle updates frequency
    if ( this.tick or 1 ) > GetTime() then return end
    this.tick = GetTime() + 0.4

    --Assign dynamic information to parent frame
    for i=1,32 do
        local texture, name, timeleft, stacks = GetBuffData("player", i, "HELPFUL")
        timeleft = timeleft or 0
        if texture and name and name ~= "" then
            this.playerbuffs[i][1] = timeleft
            this.playerbuffs[i][2] = i
            this.playerbuffs[i][3] = name
            this.playerbuffs[i][4] = texture
            this.playerbuffs[i][5] = stacks
        else
            this.playerbuffs[i][1] = 0
            this.playerbuffs[i][2] = nil
            this.playerbuffs[i][3] = nil
            this.playerbuffs[i][4] = nil
            this.playerbuffs[i][5] = 0
        end

        -- Check debuff slots
        texture, name, timeleft, stacks = GetBuffData("target", i, "HARMFUL")
        timeleft = timeleft or 0
        if texture and name and name ~= "" then
            this.targetdebuffs[i][1] = timeleft
            this.targetdebuffs[i][2] = i
            this.targetdebuffs[i][3] = name
            this.targetdebuffs[i][4] = texture
            this.targetdebuffs[i][5] = stacks
        else
            -- Check buff slots for debuffs when debuff slots are full
            texture, name, timeleft, stacks = GetBuffData("target", i, "HELPFUL")
            if name and name ~= "" then
                this.targetdebuffs[i][1] = timeleft
                this.targetdebuffs[i][2] = i
                this.targetdebuffs[i][3] = name
                this.targetdebuffs[i][4] = texture
                this.targetdebuffs[i][5] = stacks
            else
                this.targetdebuffs[i][1] = 0
                this.targetdebuffs[i][2] = nil
                this.targetdebuffs[i][3] = nil
                this.targetdebuffs[i][4] = nil
                this.targetdebuffs[i][5] = 0
            end
        end
    end
end)

function watcher:fetch(name, unit)
    if unit == "player" then
        for i=1,32 do
            if self.playerbuffs[i][3] == name then
                return self.playerbuffs[i]
            end
        end
    elseif unit == "target" then
        for i=1,32 do
            if self.targetdebuffs[i][3] == name then
                return self.targetdebuffs[i]
            end
        end
        -- Check buff slots for debuffs when debuff slots are full
        for i=1,32 do
            local texture, buffName, timeleft, stacks = GetBuffData("target", i, "HELPFUL")
            if buffName == name then
                return {timeleft, i, buffName, texture, stacks}
            end
        end
    end
end
