local frame = CreateFrame("Frame")
local DebuffAlert_TimerFrame = CreateFrame("Frame")
local alertText = nil
local lastDebuffState = false
local flashFrame = nil
local currentPage = 1
local debuffsPerPage = 5
local UpdateInterval = 5

local function LoadVariables()
    DebuffAlert_Store = DebuffAlert_Store or {}
    DebuffAlert_Store.AlertPosition = DebuffAlert_Store.AlertPosition or { point = "CENTER", x = 0, y = 200 }
    DebuffAlert_Store.ShowIcon = DebuffAlert_Store.ShowIcon or true -- Default to showing the icon
    DebuffAlert_Store.DebuffTexturesToWatch = DebuffAlert_Store.DebuffTexturesToWatch or
        {
            ["Spell_BrokenHeart"] = { enabled = true, name = "", boss_warning = "" },
            ["Spell_Shadow_AntiShadow"] = { enabled = true, name = "", boss_warning = "" },
            ["Inv_Misc_ShadowEgg"] = { enabled = true, name = "", boss_warning = "" },
            -- Add more here
        }  
end

-- Update the AddDebuffToWatch function to include a name parameter
function AddDebuffToWatch(texturePath, name)
    DebuffAlert_Store.DebuffTexturesToWatch[texturePath] = { enabled = true, name = name or "" }
end

-- Add a new function to set a debuff's name
function SetDebuffName(texturePath, name)
    if DebuffAlert_Store.DebuffTexturesToWatch[texturePath] then
        DebuffAlert_Store.DebuffTexturesToWatch[texturePath].name = name or ""
    end
end

function RemoveDebuffFromWatch(texturePath)
    DebuffAlert_Store.DebuffTexturesToWatch[texturePath] = nil
end

function SetDebuffEnabled(texturePath, enabled)
    if DebuffAlert_Store.DebuffTexturesToWatch[texturePath] then
        DebuffAlert_Store.DebuffTexturesToWatch[texturePath].enabled = enabled
    end
end

-- Create the screen flash frame
local function CreateFlashFrame()
    if flashFrame then
        flashFrame:Hide()
        flashFrame = nil
    end
    
    flashFrame = CreateFrame("Frame", nil, UIParent)
    flashFrame:SetAllPoints(UIParent)
    flashFrame:SetFrameStrata("FULLSCREEN_DIALOG")
    flashFrame:SetAlpha(0)
    
    local texture = flashFrame:CreateTexture(nil, "BACKGROUND")
    texture:SetAllPoints(flashFrame)
    texture:SetTexture("Interface\\FullScreenTextures\\LowHealth")
    texture:SetVertexColor(1, 0, 0, 0.5) -- Red color with 50% opacity
end

-- Test mode variables
local testModeActive = false
local testModeTexture = nil

-- Function to toggle test mode for a specific debuff texture
function DebuffAlert_ToggleTestMode(texture)
    -- If test mode is already active for this texture, end it
    if testModeActive and testModeTexture == texture then
        DebuffAlert_EndTestMode()
        return
    -- If test mode is active for a different texture, end it first
    elseif testModeActive then
        DebuffAlert_EndTestMode()
    end
    
    -- Create flash frame if it doesn't exist
    if not flashFrame then
        CreateFlashFrame()
    end
    
    -- Set test mode variables
    testModeActive = true
    testModeTexture = texture
    
    -- Inform the user that test mode has started
    DEFAULT_CHAT_FRAME:AddMessage("Debuff Alert: Testing '" .. texture .. "'. Click the [?] button again to stop.")
    
    -- Important: Remove any existing OnUpdate scripts to avoid conflicts
    frame:SetScript("OnUpdate", nil)
    
    -- Immediately trigger the alert
    DebuffAlert_ShowTestAlert(texture)
end

-- Function to end test mode
function DebuffAlert_EndTestMode()
    -- Only do cleanup if test mode is active
    if not testModeActive then return end
    
    testModeActive = false
    testModeTexture = nil
    
    -- Stop the OnUpdate handler
    frame:SetScript("OnUpdate", nil)
    
    -- Hide the alert
    if alertFrame then
        alertFrame:Hide()
    end
    
    if flashFrame then
        flashFrame:SetAlpha(0)
        flashFrame:Hide()
    end
    
    lastDebuffState = false
    
    -- Re-initialize the standard delay check (if needed)
    local timeSinceLastCheck = 0
    frame:SetScript("OnUpdate", function(self, elapsed)
        if not elapsed then return end
        timeSinceLastCheck = timeSinceLastCheck + elapsed
        if timeSinceLastCheck >= 1 then
            CheckDebuff()
            self:SetScript("OnUpdate", nil)
        end
    end)
end

-- Update ShowTestAlert to respect the ShowIcon setting
function DebuffAlert_ShowTestAlert(texture)
    if not alertFrame then 
        -- Create the alert frame if it doesn't exist
        alertFrame = CreateAlertText()
    end
    
    -- Set the icon texture to the test texture
    alertFrame.icon:SetTexture("Interface\\Icons\\" .. texture)
    
    -- Show or hide the icon based on the setting
    if DebuffAlert_Store.ShowIcon then
        alertFrame.icon:Show()
    else
        alertFrame.icon:Hide()
    end
    
    -- Get the custom name for this texture
    local debuffName = ""
    if DebuffAlert_Store.DebuffTexturesToWatch[texture] and DebuffAlert_Store.DebuffTexturesToWatch[texture].name then
        debuffName = DebuffAlert_Store.DebuffTexturesToWatch[texture].name
    end
    
    -- Set the alert text based on the custom name (if it exists)
    if debuffName and debuffName ~= "" then
        alertFrame.text:SetText(debuffName)
    else
        alertFrame.text:SetText("Debuff Alert - Move!")
    end
    
    -- Show the alert frame
    alertFrame:Show()
    
    -- Play the warning sound
    PlaySoundFile("Sound\\Interface\\RaidWarning.wav", "Master")
    
    -- Flash the screen - make sure we use the function properly
    if not flashFrame then
        CreateFlashFrame()
    end
    
    -- Make sure the flash frame is shown and visible
    flashFrame:Show()
    UIFrameFadeIn(flashFrame, 0.2, 0, 0.5)
    
    -- Set last debuff state to true (so the alert stays visible)
    lastDebuffState = true
end

-- Create the floating alert text and icon
local function CreateAlertText()
    local pos = DebuffAlert_Store.AlertPosition
    
    -- Create a parent frame to hold both icon and text
    local alertFrame = CreateFrame("Frame", "DebuffAlert_AlertFrame", UIParent)
    alertFrame:SetWidth(300)
    alertFrame:SetHeight(300)
    alertFrame:SetPoint(pos.point, UIParent, pos.point, pos.x, pos.y)
    alertFrame:Hide()
    
    -- Create the icon texture
    local alertIcon = alertFrame:CreateTexture("DebuffAlert_Icon", "OVERLAY")
    alertIcon:SetWidth(100)  -- Large icon (100x100 pixels)
    alertIcon:SetHeight(100)
    alertIcon:SetPoint("BOTTOM", alertFrame, "CENTER", 0, 40)  -- Position above the center point
    
    -- Create the text
    alertText = alertFrame:CreateFontString(nil, "OVERLAY")
    alertText:SetFont("Fonts\\FRIZQT__.TTF", 160, "OUTLINE")
    alertText:SetPoint("TOP", alertIcon, "BOTTOM", 0, -20)  -- Position below the icon
    alertText:SetTextColor(1, 0, 0, 1)
    alertText:SetText("Debuff Alert - Move!")
    alertText:SetShadowColor(0, 0, 0, 1)
    alertText:SetShadowOffset(4, -4)
    alertText:SetSpacing(4)
    
    -- Store references for later use
    alertFrame.icon = alertIcon
    alertFrame.text = alertText
    
    -- Update the position of the alert frame if position data changes
    local function UpdateAlertFramePosition()
        local pos = DebuffAlert_Store.AlertPosition
        if pos then
            alertFrame:ClearAllPoints()
            alertFrame:SetPoint(pos.point, UIParent, pos.point, pos.x, pos.y)
        end
    end

    -- Call this function whenever the position changes
    DebuffAlert_DraggableAlert:SetScript("OnDragStop", function()
        DebuffAlert_DraggableAlert:StopMovingOrSizing()  -- Stop moving the frame
        local point, _, _, x, y = DebuffAlert_DraggableAlert:GetPoint()  -- Get the new position
        DebuffAlert_Store.AlertPosition = { point = point, x = x, y = y }  -- Save the new position
        UpdateAlertFramePosition()  -- Update the alert frame position immediately
    end)

    -- Initially set the position of the alert frame
    UpdateAlertFramePosition()
    
    -- Return the frame for use elsewhere
    return alertFrame
end

-- Flash animation
local function FlashScreen()
    if not flashFrame then return end
    UIFrameFadeIn(flashFrame, 0.2, 0, 0.5)
end

-- Create the draggable alert (default to hidden)
local DebuffAlert_DraggableAlert = CreateFrame("Frame", "DebuffAlert_DraggableAlert", UIParent)
DebuffAlert_DraggableAlert:SetWidth(200)  -- Set width instead of SetSize
DebuffAlert_DraggableAlert:SetHeight(30)  -- Set height instead of SetSize
DebuffAlert_DraggableAlert:SetBackdrop({
    bgFile = "Interface/Tooltips/UI-Tooltip-Background",
    edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
    tile = true, tileSize = 16, edgeSize = 16,
    insets = { left = 4, right = 4, top = 4, bottom = 4 }
})
DebuffAlert_DraggableAlert:SetBackdropColor(0, 0, 0, 0.8)
DebuffAlert_DraggableAlert.text = DebuffAlert_DraggableAlert:CreateFontString(nil, "OVERLAY", "GameFontNormal")
DebuffAlert_DraggableAlert.text:SetPoint("CENTER", DebuffAlert_DraggableAlert, "CENTER")
DebuffAlert_DraggableAlert.text:SetText("Debuff Alert Position")
DebuffAlert_DraggableAlert:EnableMouse(true)
DebuffAlert_DraggableAlert:RegisterForDrag("LeftButton")
DebuffAlert_DraggableAlert:SetMovable(true)
DebuffAlert_DraggableAlert:SetClampedToScreen(true)
DebuffAlert_DraggableAlert:Hide()  -- Keep it hidden by default

-- OnDragStart and OnDragStop should directly use DebuffAlert_DraggableAlert in their functions
DebuffAlert_DraggableAlert:SetScript("OnDragStart", function()
    DebuffAlert_DraggableAlert:StartMoving()  -- Start moving the frame
end)

DebuffAlert_DraggableAlert:SetScript("OnDragStop", function()
    DebuffAlert_DraggableAlert:StopMovingOrSizing()  -- Stop moving the frame
    local point, _, _, x, y = DebuffAlert_DraggableAlert:GetPoint()  -- Get the new position
    DebuffAlert_Store.AlertPosition = { point = point, x = x, y = y }  -- Save the new position
    
    -- Update the position of the actual alert (text) immediately
    if DebuffAlert_Store.AlertPosition then
        DebuffAlert_DraggableAlert:SetPoint(DebuffAlert_Store.AlertPosition.point, UIParent, DebuffAlert_Store.AlertPosition.point, DebuffAlert_Store.AlertPosition.x, DebuffAlert_Store.AlertPosition.y)
    end
end)

-- Add a function to toggle the icon display
function DebuffAlert_ToggleIconDisplay()
    DebuffAlert_Store.ShowIcon = not DebuffAlert_Store.ShowIcon
    
    -- Inform the user of the current state
    if DebuffAlert_Store.ShowIcon then
        DEFAULT_CHAT_FRAME:AddMessage("Debuff Alert: Icon display is now ENABLED")
    else
        DEFAULT_CHAT_FRAME:AddMessage("Debuff Alert: Icon display is now DISABLED")
    end
    
    -- If we're in test mode, update the display immediately
    if testModeActive and alertFrame then
        if DebuffAlert_Store.ShowIcon then
            alertFrame.icon:Show()
        else
            alertFrame.icon:Hide()
        end
    end
    
    -- Update the toggle button appearance
    if DebuffAlert_IconToggleButton then
        if DebuffAlert_Store.ShowIcon then
            DebuffAlert_IconToggleButton:SetText("Hide Icon")
        else
            DebuffAlert_IconToggleButton:SetText("Show Icon")
        end
    end
end

-- Modify the CheckDebuff function to respect the ShowIcon setting
local function CheckDebuff()
    if not alertFrame then return end

    local hasDebuff = false
    local currentDebuffTexture = nil
    local currentDebuffName = nil
    
    -- Check all debuffs
    for i = 1, 40 do
        local texture = UnitDebuff("player", i)
        if texture then
            local entry
            local normalizedTexture = string.lower(texture)
            local iconName = nil

            for storedTexture, data in pairs(DebuffAlert_Store.DebuffTexturesToWatch or {}) do
                if "interface\\icons\\" .. string.lower(storedTexture) == normalizedTexture then
                    entry = data
                    iconName = storedTexture
                    currentDebuffTexture = texture  -- Store the full texture path
                    currentDebuffName = data.name   -- Store the custom name
                    break
                end
            end

            if entry and entry.enabled then
                hasDebuff = true
                break
            end
        end        
    end

    if hasDebuff then
        DebuffAlert_EndTestMode()
    end

    -- Update alert visibility based on debuff state
    if hasDebuff and not lastDebuffState then
        -- Set the icon texture to the current debuff
        alertFrame.icon:SetTexture(currentDebuffTexture)
        
        -- Show or hide the icon based on the setting
        if DebuffAlert_Store.ShowIcon then
            alertFrame.icon:Show()
        else
            alertFrame.icon:Hide()
        end
        
        -- Set the alert text based on the custom name (if it exists)
        if currentDebuffName and currentDebuffName ~= "" then
            alertFrame.text:SetText(currentDebuffName)
        else
            alertFrame.text:SetText("Debuff Alert - Move!")
        end
        
        alertFrame:Show()
        PlaySoundFile("Sound\\Interface\\RaidWarning.wav", "Master")
        FlashScreen() -- Add screen flash effect
        lastDebuffState = true
    elseif not hasDebuff and lastDebuffState then
        alertFrame:Hide()
        if flashFrame then
            flashFrame:Hide()
        end
        lastDebuffState = false
    end
end

function DebuffAlert_OnDebuffToggle()
    local texture = this.texture
    if texture and DebuffAlert_Store.DebuffTexturesToWatch[texture] then
        DebuffAlert_Store.DebuffTexturesToWatch[texture].enabled = this:GetChecked()
    end
end

function DebuffAlert_UpdateList()
    local scrollFrame = DebuffAlert_ScrollFrame
    local textures = {}

    -- Build a numerically indexed list of debuffs
    for texture, data in pairs(DebuffAlert_Store.DebuffTexturesToWatch or {}) do
        table.insert(textures, { texture = texture, enabled = data.enabled, name = data.name or "", boss_warning = data.boss_warning or "" })
    end

    local total = table.getn(textures)
    local offset = (currentPage - 1) * debuffsPerPage
    local numToShow = debuffsPerPage

    -- Clear existing rows before adding new ones
    for i = 1, numToShow do
        local row = getglobal("DebuffAlert_Row"..i)
        if row then
            row:Hide()
        end
    end

    for i = 1, numToShow do
        local index = offset + i
        local row = getglobal("DebuffAlert_Row"..i)

        if not row then
            row = CreateFrame("CheckButton", "DebuffAlert_Row"..i, DebuffAlert_Frame, "OptionsCheckButtonTemplate")
            row:SetPoint("TOPLEFT", DebuffAlert_ScrollFrame, "TOPLEFT", 32, -((i - 1) * 40))
            row.text = row:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
            row.text:SetPoint("LEFT", row, "RIGHT", 5, 0)

            row.icon = row:CreateTexture(nil, "ARTWORK")
            row.icon:SetWidth(32)
            row.icon:SetHeight(32)
            row.icon:SetPoint("LEFT", row, "LEFT", -32, 0)

            -- Create name edit box
            row.nameEdit = CreateFrame("EditBox", "DebuffAlert_NameEdit"..i, row, "InputBoxTemplate")
            row.nameEdit:SetHeight(20)
            row.nameEdit:SetWidth(120)
            row.nameEdit:SetPoint("LEFT", row.text, "RIGHT", 20, 0)
            row.nameEdit:SetAutoFocus(false)
            row.nameEdit:SetMaxLetters(20)
            row.nameEdit:SetFont("Fonts\\FRIZQT__.TTF", 10, "")
            row.nameEdit:SetScript("OnEnterPressed", function()
                this:ClearFocus()
            end)
            row.nameEdit:SetScript("OnEscapePressed", function()
                this:ClearFocus()
            end)

            -- Create name label
            local nameLabel = row:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
            nameLabel:SetPoint("BOTTOMLEFT", row.nameEdit, "TOPLEFT", 0, 2)  -- Position above the nameEdit
            nameLabel:SetText("Alert Text")

            -- Create boss warning edit box
            row.bossWarningEdit = CreateFrame("EditBox", "DebuffAlert_BossWarningEdit"..i, row, "InputBoxTemplate")
            row.bossWarningEdit:SetHeight(20)
            row.bossWarningEdit:SetWidth(120)
            row.bossWarningEdit:SetPoint("LEFT", row.nameEdit, "RIGHT", 20, 0)
            row.bossWarningEdit:SetAutoFocus(false)
            row.bossWarningEdit:SetMaxLetters(100)  -- Adjust max letters as needed
            row.bossWarningEdit:SetFont("Fonts\\FRIZQT__.TTF", 10, "")
            row.bossWarningEdit:SetScript("OnEnterPressed", function()
                this:ClearFocus()
            end)
            row.bossWarningEdit:SetScript("OnEscapePressed", function()
                this:ClearFocus()
            end)

            -- Create boss warning label
            local bossWarningLabel = row:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
            bossWarningLabel:SetPoint("BOTTOMLEFT", row.bossWarningEdit, "TOPLEFT", 0, 2)  -- Position above the bossWarningEdit
            bossWarningLabel:SetText("Message to Listen For")

            -- Delete button - moved to the right of the boss warning edit box
            row.deleteButton = CreateFrame("Button", nil, row, "UIPanelButtonTemplate")
            row.deleteButton:SetWidth(18)
            row.deleteButton:SetHeight(18)
            row.deleteButton:SetText("X")
            row.deleteButton:SetPoint("LEFT", row.bossWarningEdit, "RIGHT", 10, 0)
            
            -- Test button
            row.testButton = CreateFrame("Button", nil, row, "UIPanelButtonTemplate")
            row.testButton:SetWidth(18)
            row.testButton:SetHeight(18)
            row.testButton:SetText("?")
            row.testButton:SetPoint("LEFT", row.deleteButton, "RIGHT", 2, 0)
        end

        local entry = textures[index]
        if entry then
            row:Show()
            row:SetChecked(entry.enabled)
            row.text:SetText(entry.texture)
            row.icon:SetTexture("Interface\\Icons\\" .. entry.texture)
            row.nameEdit:SetText(entry.name or "")
            row.bossWarningEdit:SetText(entry.boss_warning or "")  -- Set the boss warning text

            row.texture = entry.texture
            row:SetScript("OnClick", DebuffAlert_OnDebuffToggle)

            -- Set up script to save the name when it changes
            row.nameEdit:SetScript("OnEditFocusLost", function()
                local newName = this:GetText() or ""
                SetDebuffName(row.texture, newName)
                -- Update the displayed alert text if we're in test mode for this texture
                if testModeActive and testModeTexture == row.texture then
                    if newName and newName ~= "" then
                        alertFrame.text:SetText(newName)
                    else
                        alertFrame.text:SetText("Debuff Alert - Move!")
                    end
                end
            end)

            -- Set up script to save the boss warning when it changes
            row.bossWarningEdit:SetScript("OnEditFocusLost", function()
                local newBossWarning = this:GetText() or ""
                DebuffAlert_Store.DebuffTexturesToWatch[row.texture].boss_warning = newBossWarning
            end)

            row.deleteButton:SetScript("OnClick", function()
                DebuffAlert_Store.DebuffTexturesToWatch[entry.texture] = nil
                DebuffAlert_UpdateList()
            end)
            row.deleteButton:Show()
            
            -- Set up the test button script to toggle test mode
            row.testButton:SetScript("OnClick", function()
                DebuffAlert_ToggleTestMode(entry.texture)
                
                -- Visual feedback on the button (highlight if testing this texture)
                if testModeActive and testModeTexture == entry.texture then
                    -- If testing, change button color to indicate active test
                    row.testButton:SetNormalTexture("Interface\\Buttons\\UI-Panel-Button-Down")
                else
                    -- If not testing, use normal button texture
                    row.testButton:SetNormalTexture("Interface\\Buttons\\UI-Panel-Button-Up")
                end
            end)
            
            -- Set the button's initial state based on whether this texture is being tested
            if testModeActive and testModeTexture == entry.texture then
                row.testButton:SetNormalTexture("Interface\\Buttons\\UI-Panel-Button-Down")
            else
                row.testButton:SetNormalTexture("Interface\\Buttons\\UI-Panel-Button-Up")
            end
            
            row.testButton:Show()
            row.nameEdit:Show()
            row.bossWarningEdit:Show()  -- Show the boss warning edit box
        else
            row:Hide()
            if row.deleteButton then row.deleteButton:Hide() end
            if row.testButton then row.testButton:Hide() end
            if row.nameEdit then row.nameEdit:Hide() end
            if row.bossWarningEdit then row.bossWarningEdit:Hide() end  -- Hide the boss warning edit box
        end
    end

     -- Update the pagination buttons
     UpdatePaginationButtons(total)
end

-- Function to update the state of the pagination buttons
function UpdatePaginationButtons(total)
    -- Calculate total pages
    local totalPages = math.ceil(total / debuffsPerPage)

    if totalPages > 1 then
        DebuffAlert_PreviousButton:Show()
        DebuffAlert_NextButton:Show()
    else
        DebuffAlert_PreviousButton:Hide()
        DebuffAlert_NextButton:Hide()
    end

    -- Enable/Disable Previous and Next buttons
    if currentPage > 1 then
        DebuffAlert_PreviousButton:Enable()
    else
        DebuffAlert_PreviousButton:Disable()
    end

    if currentPage < totalPages then
        DebuffAlert_NextButton:Enable()
    else
        DebuffAlert_NextButton:Disable()
    end
end

-- Create the toggle icon button (placed next to the Move Alert Position button)
local function CreateToggleIconButton()
    -- Create the toggle icon button
    local button = CreateFrame("Button", "DebuffAlert_IconToggleButton", DebuffAlert_Frame, "UIPanelButtonTemplate")
    
    -- Set the button text based on current state
    if DebuffAlert_Store.ShowIcon then
        button:SetText("Hide Icon")
    else
        button:SetText("Show Icon")
    end
    
    -- Size and position the button
    button:SetWidth(80)
    button:SetHeight(22)
    
    -- Find the Move Position button and place this one next to it
    local movePositionButton = getglobal("DebuffAlert_MoveButton")
    if movePositionButton then
        button:SetPoint("LEFT", movePositionButton, "RIGHT", 10, 0)
    else
        -- Fallback if we can't find the move button
        button:SetPoint("BOTTOMLEFT", DebuffAlert_Frame, "BOTTOMLEFT", 160, 10)
    end
    
    -- Set the click handler
    button:SetScript("OnClick", DebuffAlert_ToggleIconDisplay)
    
    return button
end

function DebuffAlert_SetPropValue(propName, propValue, propType)
    if not DebuffAlert_Store then DebuffAlert_Store = {} end
    if not DebuffAlert_Store.DebuffTexturesToWatch then
        DebuffAlert_Store.DebuffTexturesToWatch = {}
    end

    if not DebuffAlert_Store.DebuffTexturesToWatch[propName] then
        DebuffAlert_Store.DebuffTexturesToWatch[propName] = { enabled = true, name = "" }
        DEFAULT_CHAT_FRAME:AddMessage("INFO: Added new debuff: " .. propName)
    end

    if propType == "name" then
        DebuffAlert_Store.DebuffTexturesToWatch[propName].name = propValue
        DEFAULT_CHAT_FRAME:AddMessage("INFO: Saved debuff name: " .. propName .. " = " .. tostring(propValue))
    else
        DebuffAlert_Store.DebuffTexturesToWatch[propName].enabled = propValue
        DEFAULT_CHAT_FRAME:AddMessage("INFO: Saved debuff state: " .. propName .. " = " .. tostring(propValue))
    end
end

-- Debuff Alert Slash Commands
local function DebuffAlertCommands(msg, editbox)
    if DebuffAlertOptions:IsShown() then
        DebuffAlertOptions:Hide()
    else
        DebuffAlertOptions:Show()
        DebuffAlert_UpdateList()
    end
end

-- Instead of overriding the entire event handler, let's add a function
-- that will be called directly in the ADDON_LOADED handler

function DebuffAlert_InitializeIconToggle()
    -- Create the toggle icon button
    local button = CreateFrame("Button", "DebuffAlert_IconToggleButton", DebuffAlert_Frame, "UIPanelButtonTemplate")
    
    -- Set the button text based on current state
    if DebuffAlert_Store.ShowIcon then
        button:SetText("Hide Icon")
    else
        button:SetText("Show Icon")
    end
    
    -- Size and position the button
    button:SetWidth(80)
    button:SetHeight(22)
    
    -- Find the Move Position button and place this one next to it
    -- Note: The exact name of your move position button may be different
    -- Adjust this to match your actual button name
    local movePositionButton = getglobal("DebuffAlert_MoveButton")
    if movePositionButton then
        button:SetPoint("LEFT", movePositionButton, "RIGHT", 10, 0)
    else
        -- Fallback position
        button:SetPoint("BOTTOMLEFT", DebuffAlert_Frame, "BOTTOMLEFT", 160, 10)
    end
    
    -- Set the click handler
    button:SetScript("OnClick", DebuffAlert_ToggleIconDisplay)
    
    return button
end

function GetDebuffCount()
    local count = 0
    for _ in pairs(DebuffAlert_Store.DebuffTexturesToWatch) do
        count = count + 1
    end
    return count
end

local function setTimer(duration, func)
	local endTime = GetTime() + duration;
	
    DebuffAlert_TimerFrame:Show()
	DebuffAlert_TimerFrame:SetScript("OnUpdate", function()
		if(endTime < GetTime()) then
			--time is up
			func()
			DebuffAlert_TimerFrame:SetScript("OnUpdate", nil)
            DebuffAlert_TimerFrame:Hide()
		end
	end);
end

local function OnChatMessage(msg, sender)
    -- Convert the incoming message to lowercase for case insensitive comparison
    local lowerMsg = string.lower(msg)

    -- Check against each active debuff's boss_warning value
    for texture, data in pairs(DebuffAlert_Store.DebuffTexturesToWatch) do
        if data.enabled and data.boss_warning and data.boss_warning ~= "" then
            if string.find(lowerMsg, string.lower(data.boss_warning)) then
                -- Trigger the debuff alert for the specific texture
                DebuffAlert_ShowTestAlert(texture)  -- Use the actual texture path
                testModeActive = true

                setTimer(5, function()
                    if testModeActive then
                        DebuffAlert_EndTestMode()
                    end
                    DebuffAlert_TimerFrame:Hide()
                end)
                break  -- Exit the loop once a match is found
            end
        end
    end
end

-- Modify the event handler
-- Replace your existing event handler with this updated version
frame:SetScript("OnEvent", function()
    local event = event
    if not event then return end
    
    if event == "ADDON_LOADED" and arg1 == "DebuffAlert" then
        DebuffAlertOptions = DebuffAlert_Frame
        LoadVariables()
        
        -- Backup the original CheckDebuff function before we potentially override it
        if not original_CheckDebuff then
            original_CheckDebuff = CheckDebuff
        end
        
        DebuffAlert_UpdateList()

        -- Previous page button
        DebuffAlert_PreviousButton:SetScript("OnClick", function()
            if currentPage > 1 then
                currentPage = currentPage - 1
                DebuffAlert_UpdateList()
            end
        end)

        -- Next page button
        DebuffAlert_NextButton:SetScript("OnClick", function()
            local total = GetDebuffCount()
            local totalPages = math.ceil(total / debuffsPerPage)
            if currentPage < totalPages then
                currentPage = currentPage + 1
                DebuffAlert_UpdateList()
            end
        end)

        -- If there's a stored position, set it
        if DebuffAlert_Store.AlertPosition then
            DebuffAlert_DraggableAlert:SetPoint(DebuffAlert_Store.AlertPosition.point, UIParent, DebuffAlert_Store.AlertPosition.point, DebuffAlert_Store.AlertPosition.x, DebuffAlert_Store.AlertPosition.y)
        end

        local function DebuffAlertCommands(msg, editbox)
            if DebuffAlertOptions and DebuffAlertOptions:IsShown() then
                DebuffAlertOptions:Hide()
            elseif DebuffAlertOptions then
                DebuffAlertOptions:Show()
                DebuffAlert_UpdateList()  -- Update the list when showing options
            end
        end

        SLASH_DEBUFFALERT1 = "/da"
        SlashCmdList["DEBUFFALERT"] = DebuffAlertCommands

        CreateFlashFrame()
        alertFrame = CreateAlertText()  -- Create and store the alert frame
        
        -- Initialize the icon toggle button
        DebuffAlert_InitializeIconToggle()
        
        CheckDebuff()

        -- Outside the function, on load:
        DebuffAlert_TimerFrame:Hide()
    elseif event == "CHAT_MSG_RAID_BOSS_EMOTE" or event == "CHAT_MSG_RAID_BOSS_WHISPER" or event == "CHAT_MSG_MONSTER_EMOTE" or event == "CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE" or event == "CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF" or event == "CHAT_MSG_RAID_WARNING" then
        local msg = arg1  -- The message text
        local sender = arg2  -- The sender of the message
        OnChatMessage(msg, sender)  -- Pass the captured arguments
    elseif event == "PLAYER_ENTERING_WORLD" then
        CreateFlashFrame()
        if not alertFrame then
            alertFrame = CreateAlertText()  -- Create the alert frame if it doesn't exist
        end
        
        -- End any active test mode when entering the world
        if testModeActive then
            DebuffAlert_EndTestMode()
        end
        
        CheckDebuff()
    elseif event == "UNIT_AURA" and arg1 == "player" then
        CheckDebuff()
    elseif event == "PLAYER_LOGOUT" then
        -- Ensure we end test mode when logging out
        if testModeActive then
            DebuffAlert_EndTestMode()
        end
    end
end)

-- Register additional events
frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:RegisterEvent("UNIT_AURA")
frame:RegisterEvent("PLAYER_LOGOUT")
frame:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")
frame:RegisterEvent("CHAT_MSG_RAID_BOSS_WHISPER")
frame:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")
frame:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE")
frame:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF")
frame:RegisterEvent("CHAT_MSG_RAID_WARNING")

-- Additional event to handle hiding options window
-- Add a script to end test mode when the options panel is closed
function DebuffAlert_OnHide()
    if testModeActive then
        DebuffAlert_EndTestMode()
    end
end

-- Force an initial check after a short delay
local timeSinceLastCheck = 0
frame:SetScript("OnUpdate", function(self, elapsed)
    if not elapsed then return end
    timeSinceLastCheck = timeSinceLastCheck + elapsed
    if timeSinceLastCheck >= 1 then
        CreateFlashFrame()
        CreateAlertText()
        CheckDebuff()
        self:SetScript("OnUpdate", nil)
    end
end)

-- Apply the OnHide script to the options frame
DebuffAlert_Frame:SetScript("OnHide", DebuffAlert_OnHide)
