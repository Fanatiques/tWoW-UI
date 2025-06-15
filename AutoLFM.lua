--
--
--
--
--
--

---------------------------------------------------------------------------------
--                                Variables                                    --
---------------------------------------------------------------------------------


local selectedDungeons = {} -- Table to store selected dungeons
local selectedRaids = {} -- Table to store selected raids
local selectedRoles = {} -- Table to store selected roles
local userInputMessage = "" -- Variable to store user input message
local combinedMessage = "" -- String to store the combined message


---------------------------------------------------------------------------------
--                            Variables Donjons                                --
---------------------------------------------------------------------------------


local donjons = {
  { nom = "Ragefire Chasm", abrev = "RFC", size = 5, lvl = "13-18", lvl_min = 13, lvl_max = 18 },
  { nom = "The Deadmines", abrev = "DM", size = 5, lvl = "17-24", lvl_min = 17, lvl_max = 24 },
  { nom = "Wailing Caverns", abrev = "WC", size = 5, lvl = "17-24", lvl_min = 17, lvl_max = 24 },
  { nom = "The Stockade", abrev = "Stockade", size = 5, lvl = "22-30", lvl_min = 22, lvl_max = 30 },
  { nom = "Shadowfang Keep", abrev = "SFK", size = 5, lvl = "22-30", lvl_min = 22, lvl_max = 30 },
  { nom = "Blackfathom Deeps", abrev = "BFD", size = 5, lvl = "23-32", lvl_min = 23, lvl_max = 32 },
  { nom = "Scarlet Monastery Graveyard", abrev = "SM Grav", size = 5, lvl = "27-36", lvl_min = 27, lvl_max = 36 },
  { nom = "Scarlet Monastery Library", abrev = "SM Lib", size = 5, lvl = "28-39", lvl_min = 28, lvl_max = 39 },
  { nom = "Gnomeregan", abrev = "Gnomeregan", size = 5, lvl = "29-38", lvl_min = 29, lvl_max = 38 },
  { nom = "Razorfen Kraul", abrev = "RFK", size = 5, lvl = "29-38", lvl_min = 29, lvl_max = 38 },
  { nom = "The Crescent Grove", abrev = "Crescent", size = 5, lvl = "32-38", lvl_min = 32, lvl_max = 38 },
  { nom = "Scarlet Monastery Armory", abrev = "SM Armo", size = 5, lvl = "32-41", lvl_min = 32, lvl_max = 41 },
  { nom = "Scarlet Monastery Cathedral", abrev = "SM Cath", size = 5, lvl = "35-45", lvl_min = 35, lvl_max = 45 },
  { nom = "Razorfen Downs", abrev = "RFD", size = 5, lvl = "36-46", lvl_min = 36, lvl_max = 46 },
  { nom = "Uldaman", abrev = "Ulda", size = 5, lvl = "40-51", lvl_min = 40, lvl_max = 51 },
  { nom = "Gilneas City", abrev = "Gilneas", size = 5, lvl = "42-50", lvl_min = 42, lvl_max = 50 },
  { nom = "Zul'Farrak", abrev = "ZF", size = 5, lvl = "44-54", lvl_min = 44, lvl_max = 54 },
  { nom = "Maraudon Purple", abrev = "Maraudon Purple", size = 5, lvl = "45-55", lvl_min = 45, lvl_max = 55 },
  { nom = "Maraudon Orange", abrev = "Maraudon Orange", size = 5, lvl = "47-55", lvl_min = 47, lvl_max = 55 },
  { nom = "Maraudon Princess", abrev = "Maraudon Princess", size = 5, lvl = "47-55", lvl_min = 47, lvl_max = 55 },
  { nom = "The Sunken Temple", abrev = "ST", size = 5, lvl = "50-60", lvl_min = 50, lvl_max = 60 },
  { nom = "Halteforge Quarry", abrev = "HQ", size = 5, lvl = "50-60", lvl_min = 50, lvl_max = 60 },
  { nom = "Blackrock Depths Arena", abrev = "BRD Arena", size = 5, lvl = "52-60", lvl_min = 52, lvl_max = 60 },
  { nom = "Blackrock Depths", abrev = "BRD", size = 5, lvl = "52-60", lvl_min = 52, lvl_max = 60 },
  { nom = "Blackrock Depths Emperor", abrev = "BRD Emperor", size = 5, lvl = "52-60", lvl_min = 54, lvl_max = 60 },
  { nom = "Lower Blackrock Spire", abrev = "LBRS", size = 5, lvl = "55-60", lvl_min = 55, lvl_max = 60 },
  { nom = "Dire Maul East", abrev = "DM East", size = 5, lvl = "55-60", lvl_min = 55, lvl_max = 60 },
  { nom = "Dire Maul West", abrev = "DM W", size = 5, lvl = "57-60", lvl_min = 57, lvl_max = 60 },
  { nom = "Dire Maul North", abrev = "DM N", size = 5, lvl = "57-60", lvl_min = 57, lvl_max = 60 },
  { nom = "Dire Maul Tribute", abrev = "DM Tribute", size = 5, lvl = "57-60", lvl_min = 57, lvl_max = 60 },
  { nom = "Scholomance 5", abrev = "Scholo 5", size = 5, lvl = "58-60", lvl_min = 58, lvl_max = 60 },
  { nom = "Stratholme Live 5", abrev = "Strat Live 5", size = 5, lvl = "58-60", lvl_min = 58, lvl_max = 60 },
  { nom = "Karazhan Crypt", abrev = "Kara Crypt", size = 5, lvl = "58-60", lvl_min = 58, lvl_max = 60 },
  { nom = "Stratholme UD 5", abrev = "Strat UD 5", size = 5, lvl = "58-60", lvl_min = 58, lvl_max = 60 },
  { nom = "Caverns of Time. Black Morass", abrev = "Black Morass", size = 5, lvl = "60", lvl_min = 60, lvl_max = 60 },
  { nom = "Stormwind Vault", abrev = "SWV", size = 5, lvl = "60", lvl_min = 60, lvl_max = 60 },
  
}


---------------------------------------------------------------------------------
--                            Variables Raids                                  --
---------------------------------------------------------------------------------


local raids = {
    { nom = "Scholomance 10", abrev = "Scholo 10", size_min = 10, size_max = 10},
    { nom = "Stratholme Live 10", abrev = "Strat Live 10", size_min = 10, size_max = 10},
    { nom = "Stratholme UD 10", abrev = "Strat UD 10", size_min = 10, size_max = 10},
    { nom = "Upper Blackrock Spire", abrev = "UBRS", size_min = 10, size_max = 10 },
    { nom = "Zul'Gurub", abrev = "ZG", size_min = 12, size_max = 20},
    { nom = "Ruins of Ahn'Qiraj", abrev = "AQ20", size_min = 12, size_max = 20},
    { nom = "Molten Core", abrev = "MC", size_min = 20, size_max = 40},
    { nom = "Onyxia's Lair", abrev = "Ony", size_min = 20, size_max = 40},
    { nom = "Lower Karazhan Halls", abrev = "Kara10", size_min = 10, size_max = 10},
    { nom = "Blackwing Lair", abrev = "BWL", size_min = 20, size_max = 40},
    { nom = "Emerald Sanctum", abrev = "ES", size_min = 30, size_max = 40},
    { nom = "Temple of Ahn'Qiraj", abrev = "AQ40", size_min = 20, size_max = 40},
    { nom = "Naxxramas", abrev = "Naxx", size_min = 30, size_max = 40},
}


---------------------------------------------------------------------------------
--                           Variables Roles                                   --
---------------------------------------------------------------------------------


local roles = {
  "Tank",
  "Healer",
  "DPS"
}



---------------------------------------------------------------------------------
--                          Canaux World & LFG                                 --
---------------------------------------------------------------------------------

-- Fonction pour capturer les messages du canal Hardcore
local function OnHardcoreChatMessage(self, event, msg, author, _, _, _, _, _, _, _, channelId, channelName)
    -- Vérifier si l'événement est bien CHAT_MSG_HARDCORE (événement personnalisé)
    if "CHAT_MSG_HARDCORE" then
        -- Afficher le message reçu dans la fenêtre de chat
        -- DEFAULT_CHAT_FRAME:AddMessage("Message reçu dans")
    end
end

-- Créer un cadre pour écouter les événements personnalisés
local frame = CreateFrame("Frame")
frame:RegisterEvent("CHAT_MSG_HARDCORE")  -- S'abonner à l'événement personnalisé CHAT_MSG_HARDCORE
frame:SetScript("OnEvent", OnHardcoreChatMessage)

-- Liste des canaux à rechercher
local channelsToFind = {"WORLD", "LookingForGroup", "Hardcore"}

-- Table pour stocker les canaux trouvés
local foundChannels = {}

-- Fonction pour rechercher et stocker les canaux
local function findChannels()
    -- Effacer la table foundChannels avant de la remplir
    foundChannels = {}

    -- Recherche des canaux définis
    for _, channel in ipairs(channelsToFind) do
        if channel == "Hardcore" then
            -- Ajoute un canal personnalisé "Hardcore" à la table foundChannels
            table.insert(foundChannels, {name = "Hardcore", id = "hardcore_channel"})
        else
            -- Recherche l'ID du canal standard avec GetChannelName
            local channelId = GetChannelName(channel)
            if channelId and channelId > 0 then
                -- Ajoute l'ID du canal trouvé à la table foundChannels
                table.insert(foundChannels, {name = channel, id = channelId})
            else
                -- DEFAULT_CHAT_FRAME:AddMessage("Canal " .. channel .. " non trouvé ou non ouvert.")
            end
        end
    end

    -- Afficher les canaux trouvés dans la fenêtre de chat pour vérifier
    if next(foundChannels) then
        for _, channel in ipairs(foundChannels) do
            -- DEFAULT_CHAT_FRAME:AddMessage("Canal trouvé : " .. channel.name)
        end
    else
        -- DEFAULT_CHAT_FRAME:AddMessage("Aucun canal trouvé.")
    end
end

-- -- Fonction pour afficher les canaux trouvés
-- local function displayFoundChannels()
--     -- Vérifier si la table foundChannels est vide sans utiliser #
--     if next(foundChannels) == nil then
--          DEFAULT_CHAT_FRAME:AddMessage("Aucun canal trouvé.")
--     else
--         for _, channel in ipairs(foundChannels) do
--              DEFAULT_CHAT_FRAME:AddMessage("Canal trouvé : " .. channel.name .. " (ID: " .. channel.id .. ")")
--         end
--     end
-- end

-- -- Commande slash pour afficher les canaux trouvés
-- SLASH_CHECKCHANNELS1 = "/cc"
-- SlashCmdList["CHECKCHANNELS"] = function()
--     -- Appel de la fonction pour rechercher et afficher les canaux
--     displayFoundChannels()  -- Affiche les canaux trouvés
-- end


  -- Appel initial pour rechercher les canaux à l'ouverture de l'addon

  -- Initialisation des variables sauvegardées
if not AutoLFM_SavedVariables then
    AutoLFM_SavedVariables = {}  -- Si les variables n'existent pas encore, on les initialise
end

-- Initialisation de selectedChannels dans AutoLFM_SavedVariables si nécessaire
if not AutoLFM_SavedVariables.selectedChannels then
    AutoLFM_SavedVariables.selectedChannels = {}
end

-- Liste des canaux sélectionnés (chargée depuis les variables sauvegardées)
local selectedChannels = AutoLFM_SavedVariables.selectedChannels or {}

-- Fonction pour sauvegarder les canaux sélectionnés
local function SaveSelectedChannels()
    -- Obtenir le nom du personnage et du serveur actuel
    local charName = UnitName("player")  -- Nom du personnage
    local realmName = GetRealmName()    -- Nom du serveur (réalm)

    -- Créer un identifiant unique basé sur le nom du personnage et du serveur
    local uniqueIdentifier = charName .. "-" .. realmName

    -- Initialiser la table si elle n'existe pas encore
    if not AutoLFM_SavedVariables then
        AutoLFM_SavedVariables = {}
    end

    -- Sauvegarder les canaux sélectionnés pour ce personnage et serveur
    AutoLFM_SavedVariables[uniqueIdentifier] = {
        selectedChannels = selectedChannels
    }

    -- DEFAULT_CHAT_FRAME:AddMessage("Channels saved for " .. uniqueIdentifier .. ": " .. table.concat(selectedChannels, ", "))
end


-- Fonction pour charger les canaux sélectionnés lors du démarrage
local function LoadSelectedChannels()
    -- Obtenir le nom du personnage et du serveur actuel
    local charName = UnitName("player")  -- Nom du personnage
    local realmName = GetRealmName()    -- Nom du serveur (réalm)

    -- Créer un identifiant unique basé sur le nom du personnage et du serveur
    local uniqueIdentifier = charName .. "-" .. realmName

    -- Vérifier si les canaux sont déjà sauvegardés pour ce personnage et serveur
    if AutoLFM_SavedVariables[uniqueIdentifier] then
        selectedChannels = AutoLFM_SavedVariables[uniqueIdentifier].selectedChannels
    else
        selectedChannels = {}  -- Si aucune donnée sauvegardée, initialiser la table vide
    end
end


-- Fonction pour mettre à jour le canal sélectionné dans la table
local function ToggleChannelSelection(channelName, isSelected)
    if isSelected then
        selectedChannels[channelName] = true  -- Ajouter le canal aux sélectionnés
    else
        selectedChannels[channelName] = nil  -- Retirer le canal des sélectionnés
    end

    -- Sauvegarder après chaque modification
    SaveSelectedChannels()
end


---------------------------------------------------------------------------------
--                            Log Message                                      --
---------------------------------------------------------------------------------

local msglog = CreateFrame("Frame")
msglog:RegisterEvent("PLAYER_ENTERING_WORLD")

local function OnPlayerEnteringWorld(self, event)
--   local seg1 = "|cffffffff ---- Refonte de l'addon ---- "
  local seg2 = "|cffffffff <"
  local seg3 = "|cffffff00 Auto "
  local seg4 = "|cff0070DDL"
  local seg5 = "|cffffffffF"
  local seg6 = "|cffff0000M "
  local seg7 = "|cffffffff>"
  local seg8 = " "
  local seg9 = "|cff00FF00 Loaded successfully !"
  local seg10 = "|cffffff00   More information with  : "
  local seg11 = "|cff00FFFF  /lfm help"


  -- Combine the segments and display the message
--   DEFAULT_CHAT_FRAME:AddMessage(seg1)
  DEFAULT_CHAT_FRAME:AddMessage(seg2 .. seg3 .. seg4 .. seg5 .. seg6 .. seg7 .. seg8 .. seg9)
  DEFAULT_CHAT_FRAME:AddMessage(seg10 .. seg11)

  DisplayDungeonsByColor()
  findChannels()
  LoadSelectedChannels()
  msglog:UnregisterEvent("PLAYER_ENTERING_WORLD")
end

msglog:SetScript("OnEvent", OnPlayerEnteringWorld)


---------------------------------------------------------------------------------
--                               Fonctions                                     --
---------------------------------------------------------------------------------


-- Créer strsplit
function strsplit(delim, text)
  local result = {}
  local start = 1
  local i = 1

  while true do
      -- Recherche de l'emplacement du prochain délimiteur
      local s, e = string.find(text, delim, start)

      if not s then  -- Si aucun délimiteur n'est trouvé, on arrête
          result[i] = string.sub(text, start)
          break
      end

      -- Ajouter le segment trouvé dans le tableau
      result[i] = string.sub(text, start, s - 1)
      i = i + 1

      -- Mettre à jour le point de départ pour la prochaine recherche
      start = e + 1
  end

  return result
end

-- Fonction pour vérifier si un élément est présent dans la table
local function tableContains(table, element)
    return table[element] ~= nil  -- Vérification optimisée
end

function tableContains(table, value)
  for _, v in pairs(table) do
      if v == value then
          return true
      end
  end
  return false
end

local function CheckRaidStatus()
    if UnitInRaid("player") then
        return true
    else
        return false
    end
end

-- Utilisation avec un frame événement
local frame = CreateFrame("Frame")
frame:RegisterEvent("GROUP_ROSTER_UPDATE")
frame:SetScript("OnEvent", function()
    CheckRaidStatus()
end)


---------------------------------------------------------------------------------
--                       Cadre Principal AutoLFM                               --
---------------------------------------------------------------------------------


-- Création du cadre
local AutoLFM = CreateFrame("Frame", "AutoLFM", UIParent)
AutoLFM:SetWidth(600)
AutoLFM:SetHeight(400)
AutoLFM:SetPoint("CENTER", UIParent, "CENTER")
AutoLFM:SetMovable(true)
AutoLFM:EnableMouse(true)
AutoLFM:RegisterForDrag("LeftButton")

-- Ajouter le fond
AutoLFM:SetBackdrop({
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
    tile = true, tileSize = 32, edgeSize = 32,
    insets = { left = 10, right = 10, top = 10, bottom = 10 },
})

-- Créer un titre du cadre
local title = CreateFrame("Frame", nil, AutoLFM)
title:SetPoint("BOTTOM", AutoLFM, "TOP", 0, -8)
title:SetWidth(200)
title:SetHeight(50)
title:SetMovable(true)
title:EnableMouse(true)
title:RegisterForDrag("LeftButton")

title:SetBackdrop({
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
    tile = true, tileSize = 32, edgeSize = 32,
    insets = { left = 10, right = 10, top = 10, bottom = 10 },
})

---------------------------------------------------------------------------------
--                        Icone en haut à gauche                              --
---------------------------------------------------------------------------------

-- Frame pour l'icône en haut à gauche
local iconFrame = CreateFrame("Frame", nil, AutoLFM)
iconFrame:SetHeight(50)
iconFrame:SetWidth(50)
iconFrame:SetPoint("TOPLEFT", AutoLFM, "TOPLEFT", -15, 15) 

-- Texture ronde (cercle)
local border = iconFrame:CreateTexture(nil, "BORDER")
border:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")
border:SetHeight(100)
border:SetWidth(100)
border:SetPoint("TOPLEFT", -5, 4)

-- Icône centrale
local iconTexture = iconFrame:CreateTexture(nil, "ARTWORK")
iconTexture:SetTexture("Interface\\AddOns\\AutoLFM\\icon\\ring.png") 
iconTexture:SetHeight(50)
iconTexture:SetWidth(50)
iconTexture:SetPoint("CENTER", iconFrame, "CENTER", 0, 0)

---------------------------------------------------------------------------------
--                           Select Channel                                    --
---------------------------------------------------------------------------------


-- Création du cadre pour les canaux
local channelsFrame = CreateFrame("Frame", nil, AutoLFM)
channelsFrame:SetWidth(180)
channelsFrame:SetHeight(150)
channelsFrame:SetPoint("BOTTOMRIGHT", AutoLFM, "BOTTOMRIGHT", 180, 0)

-- Ajouter un fond pour le cadre des canaux
channelsFrame:SetBackdrop({
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
    tile = true, tileSize = 32, edgeSize = 32,
    insets = { left = 10, right = 10, top = 10, bottom = 10 },
})

channelsFrame:Hide()  -- Masquer le cadre par défaut

-- Ajouter un titre en haut du cadre
local titleText = channelsFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
titleText:SetPoint("TOP", channelsFrame, "TOP", 0, -10)
titleText:SetText("Select Channel Broadcast")
titleText:SetTextColor(1, 1, 0)  -- Couleur dorée pour le titre
titleText:SetJustifyH("CENTER")




-- Créer un cadre interne pour contenir les boutons et les organiser
local buttonFrame = CreateFrame("Frame", nil, channelsFrame)
buttonFrame:SetPoint("TOP", titleText, "BOTTOM", 0, -10)
buttonFrame:SetWidth(channelsFrame:GetWidth() - 20)  -- Légèrement plus petit que la largeur du cadre principal
buttonFrame:SetHeight(channelsFrame:GetHeight() - 50)  -- Réduit la hauteur pour que les boutons tiennent dans la frame



-- -- Définir une commande slash pour vérifier les canaux sélectionnés
-- SLASH_CHECKSELECTEDCHANNEL1 = "/ccs"
-- SlashCmdList["CHECKSELECTEDCHANNEL"] = function()
--     -- Affiche les canaux sélectionnés dans la fenêtre de chat
--     UpdateSelectedChannels()
-- end

-- -- Commande slash pour vérifier l'état de la table channelsToFind et foundChannels
-- SLASH_CHECKTABLES1 = "/cct"
-- SlashCmdList["CHECKTABLES"] = function()
--     -- Vérifier le contenu de la table channelsToFind
--     DEFAULT_CHAT_FRAME:AddMessage("Liste des canaux à rechercher :")
--     for _, channel in ipairs(channelsToFind) do
--         DEFAULT_CHAT_FRAME:AddMessage("Canal à rechercher : " .. channel)
--     end

--     -- Vérifier le contenu de la table foundChannels
--     if next(foundChannels) then
--         DEFAULT_CHAT_FRAME:AddMessage("Canaux trouvés :")
--         for _, channel in ipairs(foundChannels) do
--             DEFAULT_CHAT_FRAME:AddMessage("Canal trouvé : " .. channel.name .. " (ID: " .. channel.id .. ")")
--         end
--     else
--         DEFAULT_CHAT_FRAME:AddMessage("Aucun canal trouvé.")
--     end
-- end






---------------------------------------------------------------------------------
--                           Titre segmenté LFM                                --
---------------------------------------------------------------------------------


local titleSegments = {}
local part1 = title:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
part1:SetText("|cff0070DDL|r")
part1:SetFont("Fonts\\SKURRI.TTF", 24, "OUTLINE")
table.insert(titleSegments, part1)

local part2 = title:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
part2:SetText("F")
part2:SetFont("Fonts\\SKURRI.TTF", 24, "OUTLINE")
part2:SetTextColor(1, 1, 1)
part2:SetPoint("LEFT", part1, "RIGHT", 5, 0)
table.insert(titleSegments, part2)

local part3 = title:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
part3:SetText("|cffff0000M|r")
part3:SetFont("Fonts\\SKURRI.TTF", 24, "OUTLINE")
part3:SetPoint("LEFT", part2, "RIGHT", 5, 0)
table.insert(titleSegments, part3)

-- Calculer la largeur totale du texte
local totalWidth = 0
for _, segment in ipairs(titleSegments) do
    totalWidth = totalWidth + segment:GetStringWidth()
end

local currentX = -totalWidth / 2
for _, segment in ipairs(titleSegments) do
    segment:SetPoint("CENTER", title, "CENTER", currentX, 0)
    currentX = currentX + segment:GetStringWidth()
end


---------------------------------------------------------------------------------
--                                 Bouton X                                    --
---------------------------------------------------------------------------------


-- --- Création du bouton rond "X" en haut à droite de la frame principale ---
local closeButton = CreateFrame("Button", nil, AutoLFM)
closeButton:SetWidth(30)
closeButton:SetHeight(30)
closeButton:SetPoint("TOPRIGHT", AutoLFM, "TOPRIGHT", 8, 8)

-- Appliquer une forme ronde au bouton avec une bordure
closeButton:SetBackdrop({
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    edgeSize = 16,
    insets = { left = 4, right = 4, top = 4, bottom = 4 }
})

-- Ajouter un texte (un "X") à l'intérieur du bouton
local closeIcon = closeButton:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
closeIcon:SetText("X")
closeIcon:SetPoint("CENTER", closeButton, "CENTER", 0, 0)
closeIcon:SetTextColor(1, 1, 1)

-- Ajouter un script pour masquer la frame quand le bouton est cliqué
closeButton:SetScript("OnClick", function()
    AutoLFM:Hide()
end)

-- Option pour ajouter un effet de survol :
closeButton:SetScript("OnEnter", function(self)
    this:SetBackdropBorderColor(1, 0, 0, 1)
    closeIcon:SetTextColor(1, 0, 0)
end)

closeButton:SetScript("OnLeave", function(self)
  this:SetBackdrop({
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    edgeSize = 16,
    insets = { left = 4, right = 4, top = 4, bottom = 4 }
  })
  closeIcon:SetTextColor(1, 1, 1)
end)


---------------------------------------------------------------------------------
--                            Minimap Buton                                    --
---------------------------------------------------------------------------------

-- Créer un bouton de case à cocher pour chaque canal
local function CreateChannelButtons()
    -- Vérifier si des canaux ont été trouvés avant de créer les boutons
    if not next(foundChannels) then
        -- DEFAULT_CHAT_FRAME:AddMessage("Unable to create buttons : No channel found.")
        return
    end

    -- Effacer les anciens boutons avant de créer de nouveaux boutons
    for _, button in ipairs(channelsFrame.buttons or {}) do
        button:Hide()  -- Masquer les anciens boutons
    end
    channelsFrame.buttons = {}  -- Réinitialiser la liste des boutons

    local lastButton = nil
    -- Créer un bouton pour chaque canal trouvé
    for _, channel in ipairs(foundChannels) do
        -- Vérifier si channel est valide avant de créer le bouton
        if channel and channel.name then
            -- Créer le bouton de case à cocher
            local button = CreateFrame("CheckButton", nil, channelsFrame, "UICheckButtonTemplate")
            button:SetWidth(24)
            button:SetHeight(24)
            if lastButton then
                button:SetPoint("TOP", lastButton, "BOTTOM", 0, -5)  -- Espacer les boutons
            else
                button:SetPoint("TOPLEFT", buttonFrame, "TOPLEFT", 10, -5)  -- Premier bouton sous le titre
            end


            -- Créer un texte à afficher à côté de la case à cocher
            local channelText = button:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            channelText:SetPoint("LEFT", button, "RIGHT", 5, 0)
            channelText:SetText(channel.name)

            -- Vérifier si le canal est sélectionné
            button:SetChecked(selectedChannels[channel.name])  -- Vérifier si le canal est dans la liste des sélectionnés

            -- Capturer explicitement la valeur du canal dans une variable locale
            local currentChannel = channel

            -- Fonction à appeler lorsque la case à cocher est modifiée
            button:SetScript("OnClick", function()
                if currentChannel and currentChannel.name then
                    -- Afficher le contenu de channel dans le chat pour déboguer
                    -- DEFAULT_CHAT_FRAME:AddMessage("Canal dans OnClick: " .. tostring(currentChannel) .. ", Name: " .. tostring(currentChannel.name))

                    -- Mettre à jour la sélection du canal dans la table
                    ToggleChannelSelection(currentChannel.name, button:GetChecked())
                else
                    -- DEFAULT_CHAT_FRAME:AddMessage("Erreur : canal non valide dans OnClick. Canal : " .. tostring(currentChannel))
                end
            end)

            -- Ajouter le bouton dans le tableau pour pouvoir les masquer/mettre à jour plus tard
            table.insert(channelsFrame.buttons, button)

            lastButton = button  -- Référence au dernier bouton créé pour la position suivante
        else
            -- DEFAULT_CHAT_FRAME:AddMessage("Erreur : canal invalide lors de la création du bouton. Canal : " .. tostring(channel))
        end
    end
end

-- Création du bouton de la mini-carte
local AutoLFMMinimapBtn = CreateFrame("Button", "AutoLFMMinimapBtn", Minimap)
AutoLFMMinimapBtn:SetFrameStrata("LOW")  -- Ajuster la strate du cadre pour qu'il soit au-dessus de la mini-carte
AutoLFMMinimapBtn:SetHeight(24)
AutoLFMMinimapBtn:SetWidth(24)

-- Positionner le bouton par rapport à la mini-carte
AutoLFMMinimapBtn:SetPoint("TOPRIGHT", Minimap, "TOPRIGHT", -10, -10)  -- Ajuste la position selon tes besoins

-- Texture de bordure (au-dessus du bouton)
local borderTexture = AutoLFMMinimapBtn:CreateTexture(nil, "BORDER")
borderTexture:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")
borderTexture:SetHeight(54)
borderTexture:SetWidth(54)
borderTexture:SetPoint("TOPLEFT", -4, 3)

-- Icône de l'addon (en dessous de la bordure)
AutoLFMMinimapBtn:SetNormalTexture("Interface\\AddOns\\AutoLFM\\icon\\ring.png")  -- Icône de l'addon
AutoLFMMinimapBtn:GetNormalTexture():SetTexCoord(0.0, 1.0, 0.0, 1.0)

-- Ajouter un effet de survol
AutoLFMMinimapBtn:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")

-- Ajouter un effet de clic
AutoLFMMinimapBtn:SetPushedTexture("Interface\\AddOns\\AutoLFM\\icon\\fermer.png")  -- Ajouter un effet de clic

-- Ajouter un effet lors du survol de la souris
AutoLFMMinimapBtn:SetScript("OnEnter", function()

    -- Afficher le tooltip
    GameTooltip:SetOwner(AutoLFMMinimapBtn, "ANCHOR_RIGHT")
    local seg4 = "|cff0070DDL"
    local seg5 = "|cffffffffF"
    local seg6 = "|cffff0000M "
    GameTooltip:SetText("Auto" .. seg4 .. seg5 .. seg6)
    GameTooltip:AddLine("Click to toggle AutoLFM interface.", 1, 1, 1)
    GameTooltip:AddLine("Ctrl + Click for move.", 1, 1, 1)
    GameTooltip:Show()
end)

-- Réinitialiser la couleur et l'effet lors de la sortie de la souris
AutoLFMMinimapBtn:SetScript("OnLeave", function()
    -- Réinitialiser la couleur de l'icône (retour à la couleur normale)
    AutoLFMMinimapBtn:GetNormalTexture():SetVertexColor(1, 1, 1)  -- Retour à la couleur d'origine (blanc)

    -- Cacher le tooltip
    GameTooltip:Hide()
end)

-- Clic gauche pour ouvrir/fermer l'interface
AutoLFMMinimapBtn:SetScript("OnClick", function()
    -- Vérifier si la touche Ctrl est enfoncée
    if IsControlKeyDown() then
        return
    end

    -- Si Ctrl n'est pas enfoncé, gérer l'ouverture/fermeture de l'interface
    if AutoLFM:IsShown() then
        AutoLFM:Hide()
    else
        AutoLFM:Show()
        findChannels()
        CreateChannelButtons()
        -- Vérifier si des canaux sont sélectionnés
        if next(selectedChannels) == nil then
            channelsFrame:Show()  -- Afficher le cadre des canaux
        else
            LoadSelectedChannels()
            channelsFrame:Hide()  -- Masquer le cadre des canaux si aucun canal n'est sélectionné
        end
    end
end)


---------------------------------------------------------------------------------
--                             Drag and Drop                                   --
---------------------------------------------------------------------------------


-- Fonction pour démarrer le mouvement de la frame et du titre
local function StartMovingFrame(self)
  if AutoLFM:IsShown() then
      AutoLFM:StartMoving()
      title:StartMoving()
  end
end

-- Fonction pour arrêter le mouvement de la frame et du titre
local function StopMovingFrame(self)
  if AutoLFM:IsShown() then
      AutoLFM:StopMovingOrSizing()
      title:StopMovingOrSizing()
  end
end

-- Fonction pour arrêter le mouvement de la frame et du titre quand ils sont cachés
local function StopMovingOnHide(self)
  AutoLFM:StopMovingOrSizing()
  title:StopMovingOrSizing()
end

-- Détecter les événements de déplacement sur la frame principale
AutoLFM:SetScript("OnMouseDown", StartMovingFrame)
AutoLFM:SetScript("OnMouseUp", StopMovingFrame)
AutoLFM:SetScript("OnHide", StopMovingOnHide)

-- Détecter les événements de déplacement sur le titre
title:SetScript("OnMouseDown", StartMovingFrame)
title:SetScript("OnMouseUp", StopMovingFrame)
title:SetScript("OnHide", StopMovingOnHide)

-- Rendre le bouton déplacable avec Ctrl + Clic gauche
AutoLFMMinimapBtn:SetMovable(true)
AutoLFMMinimapBtn:EnableMouse(true)
AutoLFMMinimapBtn:RegisterForDrag("LeftButton")

AutoLFMMinimapBtn:SetScript("OnMouseDown", function(self, button)
    -- Vérifier si Ctrl est maintenu lors du clic
    if IsControlKeyDown() then
        AutoLFMMinimapBtn:StartMoving()
    end
end)

AutoLFMMinimapBtn:SetScript("OnMouseUp", function(self, button)
    -- Arrêter le déplacement du bouton
    AutoLFMMinimapBtn:StopMovingOrSizing()
end)


---------------------------------------------------------------------------------
--                                Frames                                       --
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
--                                Donjons                                      --
---------------------------------------------------------------------------------


-- Initialisation des variables
local donjonCount = 0
local maxDonjons = 100

for _, donjon in pairs(donjons) do
  if donjonCount >= maxDonjons then
      break
  end
  donjonCount = donjonCount + 1
end

-- Créer cadre djframe
local djframe = CreateFrame("Frame", nil, AutoLFM)
djframe:SetWidth(265)
djframe:SetHeight(380)
djframe:SetPoint("TOPLEFT", AutoLFM, "TOPLEFT", 10, -10)
djframe:SetBackdrop({
    edgeFile = "Interface\\PVPFrame\\UI-Character-PVP-Highlight", edgeSize = 16,
    insets = { left = 2, right = 2, top = 2, bottom = 2 }
})

local djScrollFrame = CreateFrame("ScrollFrame", "AutoLFM_ScrollFrame_Dungeons", djframe, "UIPanelScrollFrameTemplate")
djScrollFrame:SetPoint("TOPLEFT", djframe, "TOPLEFT", 10, -40)
djScrollFrame:SetWidth(265)
djScrollFrame:SetHeight(330)

-- Créer le contenu du ScrollFrame pour les donjons
local contentFrame = CreateFrame("Frame", nil, djScrollFrame)
contentFrame:SetWidth(250)
contentFrame:SetHeight(donjonCount * 30)  -- Hauteur dynamique basée sur le nombre de donjons
djScrollFrame:SetScrollChild(contentFrame)


---------------------------------------------------------------------------------
--                                  Raids                                      --
---------------------------------------------------------------------------------


-- Créer cadre raidFrame
local raidFrame = CreateFrame("Frame", nil, AutoLFM)
raidFrame:SetWidth(240)
raidFrame:SetHeight(380)
raidFrame:SetPoint("TOPLEFT", AutoLFM, "TOPLEFT", 10, -10)
raidFrame:SetBackdrop({
    edgeFile = "Interface\\PVPFrame\\UI-Character-PVP-Highlight", edgeSize = 16,
    insets = { left = 2, right = 2, top = 2, bottom = 2 }
})

local raidScrollFrame = CreateFrame("ScrollFrame", "AutoLFM_ScrollFrame_Raids", raidFrame, "UIPanelScrollFrameTemplate")
raidScrollFrame:SetPoint("TOPLEFT", raidFrame, "TOPLEFT", 10, -40)
raidScrollFrame:SetWidth(240)
raidScrollFrame:SetHeight(330)



---------------------------------------------------------------------------------
--                           Init Donjons & Raids                              --
---------------------------------------------------------------------------------


contentFrame:Show()
djframe:Show()
djScrollFrame:Show()
raidFrame:Hide()
raidScrollFrame:Hide()
AutoLFMMinimapBtn:Show()


---------------------------------------------------------------------------------
--                                 Roles                                       --
---------------------------------------------------------------------------------


-- Créer cadre roleframe
local roleframe = CreateFrame("Frame", nil, AutoLFM)
roleframe:SetBackdrop({
    bgFile = nil,
    -- edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",  -- Bordure blanche dev position
    edgeSize = 16,
    insets = { left = 4, right = 2, top = 4, bottom = 4 }, -- Marge de 4 pixels
})
roleframe:SetBackdropColor(1, 1, 1, 0.3)
roleframe:SetBackdropBorderColor(1, 1, 1, 1)

-- Positionner le roleframe
roleframe:SetWidth(AutoLFM:GetWidth() * 0.4)
roleframe:SetHeight(AutoLFM:GetHeight() * 0.2) --
roleframe:SetPoint("TOPRIGHT", AutoLFM, "TOPRIGHT", -30, -40)

-- Réduction de la taille des icônes de 20 % au total
local iconWidth = roleframe:GetWidth() / 3 * 0.7
local iconHeight = roleframe:GetHeight() * 0.7

-- Espacement entre les icônes (en pixels) : augmenter l'espacement à 20 pixels
local iconSpacing = 20

-- Ajouter un texte au-dessus des icônes
local selectRoleText = roleframe:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
selectRoleText:SetText("Choose the role(s) you need ")
selectRoleText:SetPoint("BOTTOM", roleframe, "TOP", 0, 5)
selectRoleText:SetJustifyH("CENTER")
selectRoleText:SetFont("Fonts\\FRIZQT__.TTF", 14, "OUTLINE")


---------------------------------------------------------------------------------
--                                msgFrame                                     --
---------------------------------------------------------------------------------


local msgFrame = CreateFrame("Frame", nil, AutoLFM)

-- Positionner le cadre msgFrame juste en dessous de roleframe
msgFrame:SetWidth(roleframe:GetWidth())
msgFrame:SetHeight(roleframe:GetHeight() + 20)
msgFrame:SetPoint("TOPRIGHT", roleframe, "BOTTOMRIGHT", 0, -5)


---------------------------------------------------------------------------------
--                         Message Frame Donjons                               --
---------------------------------------------------------------------------------


local msgFrameDj = CreateFrame("Frame", nil, AutoLFM)
msgFrameDj:SetBackdrop({
  bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
  edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
  edgeSize = 16,
  insets = { left = 5, right = 5, top = 5, bottom = 5 },
})

-- Positionner le cadre msgFrameDj juste en dessous de roleframe
msgFrameDj:SetWidth(roleframe:GetWidth())
msgFrameDj:SetHeight(roleframe:GetHeight() + 20)
msgFrameDj:SetPoint("TOPRIGHT", roleframe, "BOTTOMRIGHT", 0, 0)


-- Créer un FontString dans msgFrameDj pour afficher le message
local msgTextDj = msgFrameDj:CreateFontString(nil, "OVERLAY", "GameFontNormal")
msgTextDj:SetPoint("CENTER", msgFrameDj, "CENTER")
msgTextDj:SetTextColor(1, 1, 1)
msgTextDj:SetJustifyH("CENTER")
msgTextDj:SetJustifyV("CENTER")
msgTextDj:SetWidth(msgFrameDj:GetWidth())


---------------------------------------------------------------------------------
--                          Message Frame Raids                                --
---------------------------------------------------------------------------------


local msgFrameRaids = CreateFrame("Frame", nil, AutoLFM)
msgFrameRaids:SetBackdrop({
  bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
  edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
  edgeSize = 16,
  insets = { left = 5, right = 5, top = 5, bottom = 5 },
})

-- Positionner le cadre msgFrameRaids juste en dessous de roleframe
msgFrameRaids:SetWidth(roleframe:GetWidth())
msgFrameRaids:SetHeight(roleframe:GetHeight() + 20)
msgFrameRaids:SetPoint("TOPRIGHT", roleframe, "BOTTOMRIGHT", 0, 0)

msgFrameRaids:Hide()

-- Créer un FontString dans msgFrame pour afficher le message
local msgTextRaids = msgFrameRaids:CreateFontString(nil, "OVERLAY", "GameFontNormal")
msgTextRaids:SetPoint("CENTER", msgFrameRaids, "CENTER")
msgTextRaids:SetTextColor(1, 1, 1)
msgTextRaids:SetJustifyH("CENTER")
msgTextRaids:SetJustifyV("CENTER")
msgTextRaids:SetWidth(msgFrameRaids:GetWidth())

---------------------------------------------------------------------------------
--                                EditBox                                      --
---------------------------------------------------------------------------------


-- Créer une zone de saisie de texte en bas de msgFrame
local editBox = CreateFrame("EditBox", "MonAddonEditBox", msgFrame)
editBox:SetPoint("BOTTOM", msgFrame, "BOTTOM", 0, -60)  -- Positionner en bas, avec un écart de 10 pixels du bas du cadre

-- Définir les propriétés de la zone de texte sans spécifier la taille
editBox:SetAutoFocus(false)  -- Empêcher le focus automatique
editBox:SetFont("Fonts\\FRIZQT__.TTF", 16)  -- Police de texte normale
editBox:SetMaxLetters(150)  -- Limiter le nombre de caractères
editBox:SetText("")  -- Texte initial (vide)
editBox:SetTextInsets(10, 10, 10, 10)  -- Marge interne de 10 pixels

-- Adapter la largeur de la zone de texte à la largeur de msgFrame moins une marge (pour éviter que le texte soit collé aux bords)
editBox:SetWidth(msgFrame:GetWidth() - 30)  -- Largeur légèrement réduite par rapport à msgFrame

-- Définir une hauteur fixe pour la zone de saisie (sans SetSize)
editBox:SetHeight(30)  -- Hauteur fixe de la zone de saisie

-- Fonction pour gérer l'appui sur "Entrée"
editBox:SetScript("OnEnterPressed", function(self)
  this:ClearFocus()  -- Retirer le focus de la zone de texte
end)

editBox:SetScript("OnEscapePressed", function(self)
  this:ClearFocus()  -- Retirer le focus de la zone de texte
end)

-- Créer un texte pour afficher un tiret centré au-dessus de la zone de saisie
local dashText = msgFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
dashText:SetPoint("BOTTOM", editBox, "TOP", 0, 8)  -- Placer au-dessus de editBox avec un écart de 5 pixels
dashText:SetText("Add details (optional)")  -- Le texte du tiret

-- Personnaliser l'apparence du tiret (par exemple, couleur et taille de police)
dashText:SetFontObject(GameFontNormal)  -- Utiliser la police de texte normale
dashText:SetTextColor(1, 1, 1, 1)  -- Couleur blanche pour le tiret

-- Optionnel : ajouter un fond à la zone de saisie pour la rendre plus visible
editBox:SetBackdrop({
  bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
  edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
  edgeSize = 12,
  insets = { left = 5, right = 5, top = 5, bottom = 5 },
})
editBox:SetTextColor(1, 1, 1)  -- Couleur du texte blanc

local function CreateQuestLink(questIndex)
    if not AutoLFM or not AutoLFM:IsVisible() then
        return -- autoLFM fermé, ne fait rien
    end
    local title, level, _, _, _, _, _, questID = GetQuestLogTitle(questIndex)
    if not title or title == "" then return nil end
    if not questID then
        -- En 1.12, questID est souvent nil, mais on peut essayer d'extraire autrement (limité)
        questID = 0
    end
    -- Construire le lien (format 1.12)
    local color = "|cffffff00"  -- jaune, couleur des quêtes
    local link = string.format("%s|Hquest:%d:%d|h[%s]|h|r", color, questID, level or 0, title)
    return link
end

-- Sauvegarder la fonction d'origine
local Original_QuestLogTitleButton_OnClick = QuestLogTitleButton_OnClick

-- Surcharge de QuestLogTitleButton_OnClick
function QuestLogTitleButton_OnClick(self, button)

    Original_QuestLogTitleButton_OnClick(self, button)

    if "LeftButton" and IsShiftKeyDown() then
        local questIndex = this:GetID()
        if questIndex then
            local questLink = CreateQuestLink(questIndex)
            if questLink then
                editBox:SetText(questLink)
                editBox:SetFocus()
            end
        end
    end
end

-- On sauvegarde la fonction d'origine OnClick des boutons d'item du sac
local Original_ContainerFrameItemButton_OnClick = ContainerFrameItemButton_OnClick

function ContainerFrameItemButton_OnClick(self, button)
    -- Appeler la fonction originale (ouvrir tooltip, etc.)
    Original_ContainerFrameItemButton_OnClick(self, button)

    if "LeftButton" and IsShiftKeyDown() then
        local bag = this:GetParent():GetID()
        local slot = this:GetID()
        local itemLink = GetContainerItemLink(bag, slot)
        if itemLink then
            if editBox then
                editBox:SetText(itemLink)
                editBox:SetFocus()
            end
        end
    end
end

-- Sauvegarder la fonction d'origine
local Original_SetItemRef = SetItemRef

-- Nouvelle fonction pour intercepter les clics sur les liens
function SetItemRef(link, text, button, chatFrame)

    Original_SetItemRef(link, text, button, chatFrame)

    -- Vérifier clic gauche + Shift + lien d'item
    if "LeftButton" and IsShiftKeyDown() then
        -- En 1.12, les liens d'item commencent souvent par "item:"
        if link and string.find(link, "^item:") then
            if editBox then
                editBox:SetText(text)
                editBox:SetFocus()
            end
        end
    end
end



---------------------------------------------------------------------------------
--                                 Slider                                      --
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
--                                Interval                                     --
---------------------------------------------------------------------------------


-- Créer cadre sliderframe
local sliderframe = CreateFrame("Frame", nil, AutoLFM)
sliderframe:SetBackdrop({
    bgFile = nil,
    edgeSize = 16,  -- Taille de la bordure
    insets = { left = 4, right = 2, top = 4, bottom = 4 },
})
sliderframe:SetBackdropColor(1, 1, 1, 0.3)
sliderframe:SetBackdropBorderColor(1, 1, 1, 1)

-- Positionner le nouveau cadre juste en dessous de roleframe
sliderframe:SetWidth(roleframe:GetWidth())
sliderframe:SetHeight(roleframe:GetHeight() + 50)
sliderframe:SetPoint("TOPRIGHT", msgFrame, "BOTTOMRIGHT", 0, -40)

-- Créer la barre de glissement (Slider)
local slider = CreateFrame("Slider", nil, sliderframe, "OptionsSliderTemplate")
slider:SetWidth(200)
slider:SetHeight(20)
slider:SetPoint("CENTER", sliderframe, "CENTER", 0, 0)
slider:SetMinMaxValues(40, 120)
slider:SetValue(80)
slider:SetValueStep(10)

--------------------------- SLIDER DE TAILLE ---------------------------

-- Créer un cadre pour le slider
local sliderSizeFrame = CreateFrame("Frame", nil, msgFrame)
sliderSizeFrame:SetBackdropColor(1, 1, 1, 0.3)
sliderSizeFrame:SetBackdropBorderColor(1, 1, 1, 1)
sliderSizeFrame:SetWidth(220)  -- Largeur du slider
sliderSizeFrame:SetHeight(100)  -- Hauteur du cadre (augmentée pour laisser de la place au texte supplémentaire)
sliderSizeFrame:SetPoint("CENTER", msgFrame, "CENTER", 260, 5)  -- Positionner le cadre en bas au centre du panneau principal

sliderSizeFrame:SetBackdrop{
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
    edgeSize = 12,
    insets = { left = 5, right = 5, top = 5, bottom = 5 },
}

sliderSizeFrame:Hide()  -- Masquer le cadre au départ

-- Créer le slider
local sliderSize = CreateFrame("Slider", nil, sliderSizeFrame, "OptionsSliderTemplate")
sliderSize:SetWidth(200)
sliderSize:SetHeight(20)
sliderSize:SetPoint("CENTER", sliderSizeFrame, "CENTER", 0, 0)

-- Initialiser la valeur
sliderSize:SetValueStep(1)  -- Pas de valeur du slider

-- Variable globale pour stocker la valeur du slider
local sliderValue = 0

-- Variable pour stocker la référence du slider
local currentSliderFrame = nil
local sliderValueText = nil  -- Texte pour afficher la plage
local sliderCurrentValueText = nil  -- Texte pour afficher la valeur actuelle

-- Fonction pour mettre à jour le texte en fonction de la valeur du slider
local function UpdateSliderText(value)
    if value then  -- Vérifier que value est défini et est un nombre
        local minValue, maxValue = sliderSize:GetMinMaxValues()

        -- Afficher la plage de valeurs du slider
        sliderValueText:SetText(value)

        -- Afficher la valeur actuelle du slider
        sliderCurrentValueText:SetText("Raid Size: " .. minValue .. " at " .. maxValue)
    else
        -- Afficher un message par défaut si la valeur est nil
        sliderValueText:SetText("Raid Size: N/A")
        sliderCurrentValueText:SetText("Valeur actuelle: N/A")
    end
end


-- Fonction pour afficher le slider pour un raid sélectionné
local function ShowSliderForRaid(raid)

    if currentSliderFrame then
        currentSliderFrame:Hide()  -- Masquer le précédent slider
    end

    -- Vérifier si les valeurs de raid sont valides
    if not raid.size_min or not raid.size_max then
        print("Erreur: Les valeurs size_min ou size_max ne sont pas définies correctement.")
        return
    end

    -- Créer les textes si ils n'existent pas encore
    if not sliderValueText then
        sliderValueText = sliderSizeFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        sliderValueText:SetPoint("CENTER", sliderSize, "TOP", 0, 10)
    end

    if not sliderCurrentValueText then
        sliderCurrentValueText = sliderSizeFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        sliderCurrentValueText:SetPoint("CENTER", sliderSize, "BOTTOM", 0, -10)  -- Placer sous le slider
    end

    -- Définir les valeurs min et max pour le slider en fonction du raid sélectionné
    sliderSize:SetMinMaxValues(raid.size_min, raid.size_max)

    -- **Vérification de la valeur initiale** (on la force à la valeur précédemment sauvegardée ou à la valeur par défaut)
    local initialSliderValue = sliderValue ~= 0 and sliderValue or raid.size_min  -- Si une valeur est déjà enregistrée, on l'utilise
    sliderSize:SetValue(initialSliderValue)  -- Définir la valeur initiale

    -- Mettre à jour le texte avec la valeur actuelle
    UpdateSliderText(sliderSize:GetValue())

    -- Afficher le cadre du slider
    sliderSizeFrame:Show()

    -- Sauvegarder la référence du slider pour pouvoir le masquer plus tard
    currentSliderFrame = sliderSizeFrame
end

-- Mettre à jour le texte chaque fois que la valeur du slider change
sliderSize:SetScript("OnValueChanged", function(value)
    sliderValue = value  -- Sauvegarder la nouvelle valeur du slider
    UpdateSliderText(value)  -- Mettre à jour le texte avec la valeur actuelle
end)





-- Fonction pour cacher le slider lorsqu'un raid est décoché
local function HideSliderForRaid()
    if currentSliderFrame then
        currentSliderFrame:Hide()  -- Masquer le cadre du slider
        currentSliderFrame = nil   -- Réinitialiser la référence
    end
end




---------------------------------------------------------------------------------
--                            Msg Dynamique                                    --
---------------------------------------------------------------------------------


-- Fonction pour compter les membres du groupe
local function countGroupMembers()
    local groupSize
    groupSize = GetNumPartyMembers() + 1
    return groupSize
end

-- Fonction pour compter les membres du raid
local function countRaidMembers()
  local raidSize = GetNumRaidMembers()-- Nombre de membres dans le raid
  return raidSize
end

-- Fonction pour générer le message dynamique
local function updateMsgFrameCombined()
    local totalPlayersInGroup = countGroupMembers()
    local totalPlayersInRaid = countRaidMembers()
    local totalGroupSize = 0

    local selectedContent = {}
    local selectedCountRoles = 0

    -- Compter les rôles sélectionnés
    for _, role in pairs(selectedRoles) do
        selectedCountRoles = selectedCountRoles + 1
    end

    local rolesList = table.concat(selectedRoles, " & ")
    local finalRolesSegment = ""
    if selectedCountRoles == 3 then
        finalRolesSegment = "Need All"
    elseif selectedCountRoles > 0 then
        finalRolesSegment = "Need " .. rolesList
    end

    -- Gérer les raids
    local selectedRaids = GetSelectedRaids()
    local isRaidSelected = false
    local raidSize = 0

    if table.getn(selectedRaids) > 0 then
        for _, raidAbrev in pairs(selectedRaids) do
            for _, raid in pairs(raids) do
                if raid.abrev == raidAbrev then
                    table.insert(selectedContent, raid.abrev)
                    ShowSliderForRaid(raid)
                    if raid.size_min == raid.size_max then
                        sliderSizeFrame:Hide()
                    end
                    isRaidSelected = true
                    raidSize = sliderValue
                    break
                end
            end
        end
    end

    -- Donjons si aucun raid sélectionné
    if not isRaidSelected then
        for _, donjonAbrev in pairs(selectedDungeons) do
            for _, donjon in pairs(donjons) do
                if donjon.abrev == donjonAbrev then
                    if donjon.size and totalPlayersInGroup then
                        totalGroupSize = donjon.size
                        local missingPlayers = totalGroupSize - totalPlayersInGroup
                        if missingPlayers < 0 then
                            missingPlayers = 0
                            stopMessageBroadcast()
                        end
                        if missingPlayers > 0 then
                            table.insert(selectedContent, donjon.abrev)
                        end
                    else
                        DEFAULT_CHAT_FRAME:AddMessage("Erreur : Invalid dungeon size or number of players for " .. donjon.abrev)
                    end
                    break
                end
            end
        end
    end

    -- Aucun contenu, rôle, ou message
    local contentCount = table.getn(selectedContent)
    if contentCount == 0 and selectedCountRoles == 0 and userInputMessage == "" then
        combinedMessage = ""
        msgTextDj:SetText(combinedMessage)
        msgTextRaids:SetText(combinedMessage)
        return
    end

    -- Calcul du manque (mate)
    local mate = 0
    local raidPlayerCountText = ""
    local currentCount = 0

    if isRaidSelected then
        if totalPlayersInRaid > 0 then
            currentCount = totalPlayersInRaid
        else
            currentCount = totalPlayersInGroup
        end
        mate = raidSize - currentCount
        if mate < 0 then mate = 0 end
        raidPlayerCountText = " " .. currentCount .. "/" .. raidSize
    else
        mate = totalGroupSize - totalPlayersInGroup
        if mate < 0 then mate = 0 end
    end

    -- Construction du message
    local contentMessage = table.concat(selectedContent, " & ")

    if contentCount == 0 and selectedCountRoles == 0 then
        combinedMessage = userInputMessage

    elseif contentCount == 0 and selectedCountRoles > 0 then
        combinedMessage = finalRolesSegment
        if userInputMessage ~= "" then
            combinedMessage = combinedMessage .. " " .. userInputMessage
        end

    elseif contentCount > 0 and selectedCountRoles == 0 then
        if isRaidSelected then
            combinedMessage = contentMessage .. " LF" .. mate .. "M" .. raidPlayerCountText
        else
            combinedMessage = "LF" .. mate .. "M for " .. contentMessage
        end
        if userInputMessage ~= "" then
            combinedMessage = combinedMessage .. " " .. userInputMessage
        end

    elseif contentCount > 0 and selectedCountRoles > 0 then
        if isRaidSelected then
            combinedMessage = contentMessage .. " LF" .. mate .. "M " .. finalRolesSegment .. raidPlayerCountText
        else
            combinedMessage = "LF" .. mate .. "M for " .. contentMessage .. " " .. finalRolesSegment
        end
        if userInputMessage ~= "" then
            combinedMessage = combinedMessage .. " " .. userInputMessage
        end
    end

    msgTextDj:SetText(combinedMessage)
    msgTextRaids:SetText(combinedMessage)
end



-- Fonction pour gérer le changement de texte
editBox:SetScript("OnTextChanged", function(self)
  -- print("Texte saisi : " .. this:GetText())  -- Afficher le texte dans la console
  userInputMessage = this:GetText()
      -- Vérifier si un message saisi existe
  if userInputMessage ~= "" then
      return updateMsgFrameCombined(userInputMessage)
  end
  updateMsgFrameCombined()
end)

-- Mettre à jour le texte chaque fois que la valeur du slider change
sliderSize:SetScript("OnValueChanged", function(value)
    value = sliderSize:GetValue()  -- Obtenir la valeur actuelle du slider
    sliderValue = value  -- Sauvegarder la nouvelle valeur du slider
    UpdateSliderText(sliderValue)  -- Mettre à jour le texte avec la valeur actuelle
    updateMsgFrameCombined()
end)

-- Fonction pour mettre à jour le message dans msgFrame


AutoLFM:RegisterEvent("PARTY_MEMBERS_CHANGED")
AutoLFM:RegisterEvent("GROUP_ROSTER_UPDATE")

-- Fonction pour surveiller les changements dans le raid
local function OnRaidRosterUpdate()
  countRaidMembers()
  updateMsgFrameCombined()
end

local function OnGroupUpdate()
    countGroupMembers()
    updateMsgFrameCombined()
end



-- Fonction pour réinitialiser le message saisi
local function resetUserInputMessage()
  userInputMessage = ""  -- Réinitialiser le message saisi
  editBox:SetText(userInputMessage)  -- Mettre à jour l'EditBox
  updateMsgFrameCombined()
end

function GetCombinedMessage()
  return combinedMessage or {}
end

function GetSelectedRoles()
  return selectedRoles or {}
end

function GetSelectedDungeons()
  return selectedDungeons or {}
end

function GetSelectedRaids()
  return selectedRaids or {}
end



-- Appeler la fonction pour rechercher les canaux et créer les boutons
CreateChannelButtons()  -- Créer les boutons après avoir trouvé les canaux

---------------------------------------------------------------------------------
--                            Role Fonction                                    --
---------------------------------------------------------------------------------


-- -- Calculer la largeur totale nécessaire pour les icônes et l'espacement
local totalIconsWidth = 3 * iconWidth + 2 * iconSpacing

-- -- Calculer l'offset X pour centrer les icônes (centrer par rapport au `roleframe`)
local offsetX = (roleframe:GetWidth() - totalIconsWidth) / 2

-- -- Positionner les icônes
local offsetY = (roleframe:GetHeight() - iconHeight) / 2  -- Centrer verticalement

-- Créer l'icône Tank
local tankIcon = CreateFrame("Button", nil, roleframe)
tankIcon:SetWidth(iconWidth)
tankIcon:SetHeight(iconHeight)
tankIcon:SetPoint("TOPLEFT", roleframe, "TOPLEFT", offsetX, -offsetY)

tankIcon.texture = tankIcon:CreateTexture(nil, "BACKGROUND")
tankIcon.texture:SetAllPoints(tankIcon)
tankIcon.texture:SetTexture("Interface\\AddOns\\AutoLFM\\icon\\tank.png")

tankIcon.selected = false
tankIcon:SetScript("OnClick", function()
  -- Inverser l'état de sélection
  if tankIcon.selected then
      -- Désélectionner
      tankIcon.selected = false
      tankIcon:SetBackdrop(nil)  -- Retirer les bordures
      tankIcon.texture:SetAlpha(0.5)  -- Appliquer un effet de fade (transparence)
      -- Ajouter une ombre pour la désélection
      tankIcon:SetBackdrop({
          edgeFile = "Interface\\AddOns\\AutoLFM\\icon\\shadow-border.tga",  -- Texture pour l'ombre
          edgeSize = 16,
      })
      -- Supprimer le rôle Tank de la table selectedRoles
      for i, role in ipairs(selectedRoles) do
          if role == "Tank" then
              table.remove(selectedRoles, i)
              break
          end
      end
  else
      -- Sélectionner
      tankIcon.selected = true
      -- Appliquer une bordure plus lumineuse et épaisse
      tankIcon:SetBackdrop({
          edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
          edgeSize = 16,
          insets = { left = 4, right = 4, top = 4, bottom = 4 },
      })
      -- Bordure jaune plus lumineuse
      tankIcon:SetBackdropBorderColor(1, 1, 0, 1)

      -- Appliquer un effet de glow (halo lumineux)
      tankIcon:SetBackdrop({
          edgeFile = "Interface\\AddOns\\AutoLFM\\icon\\glow-border.tga",  -- Texture personnalisée pour glow
          edgeSize = 32,
      })
      tankIcon:SetBackdropBorderColor(0, 1, 0, 1)  -- Bordure néon verte pour l'effet lumineux

      tankIcon.texture:SetAlpha(1)  -- Rendre l'icône entièrement opaque
      -- Ajouter le rôle Tank à la table selectedRoles
      table.insert(selectedRoles, "Tank")
  end
  updateMsgFrameCombined()  -- Mettre à jour le message dans msgFrame
end)

-- Créer l'icône DPS
local dpsIcon = CreateFrame("Button", nil, roleframe)
dpsIcon:SetWidth(iconWidth)
dpsIcon:SetHeight(iconHeight)
dpsIcon:SetPoint("TOPLEFT", tankIcon, "TOPRIGHT", iconSpacing, 0)

dpsIcon.texture = dpsIcon:CreateTexture(nil, "BACKGROUND")
dpsIcon.texture:SetAllPoints(dpsIcon)
dpsIcon.texture:SetTexture("Interface\\AddOns\\AutoLFM\\icon\\dps.png")

dpsIcon.selected = false
dpsIcon:SetScript("OnClick", function()
  -- Inverser l'état de sélection
  if dpsIcon.selected then
      -- Désélectionner
      dpsIcon.selected = false
      dpsIcon:SetBackdrop(nil)  -- Retirer les bordures
      dpsIcon.texture:SetAlpha(0.5)  -- Appliquer un effet de fade (transparence)
      -- Ajouter une ombre pour la désélection
      dpsIcon:SetBackdrop({
          edgeFile = "Interface\\AddOns\\AutoLFM\\icon\\shadow-border.tga",  -- Texture pour l'ombre
          edgeSize = 16,
      })
      -- Supprimer le rôle DPS de la table selectedRoles
      for i, role in ipairs(selectedRoles) do
          if role == "DPS" then
              table.remove(selectedRoles, i)
              break
          end
      end
  else
      -- Sélectionner
      dpsIcon.selected = true
      -- Appliquer une bordure plus lumineuse et épaisse
      dpsIcon:SetBackdrop({
          edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
          edgeSize = 16,
          insets = { left = 4, right = 4, top = 4, bottom = 4 },
      })
      -- Bordure jaune plus lumineuse
      dpsIcon:SetBackdropBorderColor(1, 1, 0, 1)

      -- Appliquer un effet de glow (halo lumineux)
      dpsIcon:SetBackdrop({
          edgeFile = "Interface\\AddOns\\AutoLFM\\icon\\glow-border.tga",  -- Texture personnalisée pour glow
          edgeSize = 32,
      })
      dpsIcon:SetBackdropBorderColor(0, 1, 0, 1)  -- Bordure néon verte pour l'effet lumineux

      dpsIcon.texture:SetAlpha(1)  -- Rendre l'icône entièrement opaque
      -- Ajouter le rôle DPS à la table selectedRoles
      table.insert(selectedRoles, "DPS")
  end
  updateMsgFrameCombined()  -- Mettre à jour le message dans msgFrame
end)

-- Créer l'icône Heal
local healIcon = CreateFrame("Button", nil, roleframe)
healIcon:SetWidth(iconWidth)
healIcon:SetHeight(iconHeight)
healIcon:SetPoint("TOPLEFT", dpsIcon, "TOPRIGHT", iconSpacing, 0)

healIcon.texture = healIcon:CreateTexture(nil, "BACKGROUND")
healIcon.texture:SetAllPoints(healIcon)
healIcon.texture:SetTexture("Interface\\AddOns\\AutoLFM\\icon\\heal.png")

healIcon.selected = false
healIcon:SetScript("OnClick", function()
  -- Inverser l'état de sélection
  if healIcon.selected then
      -- Désélectionner
      healIcon.selected = false
      healIcon:SetBackdrop(nil)  -- Retirer les bordures
      healIcon.texture:SetAlpha(0.5)  -- Appliquer un effet de fade (transparence)
      -- Ajouter une ombre pour la désélection
      healIcon:SetBackdrop({
          edgeFile = "Interface\\AddOns\\AutoLFM\\icon\\shadow-border.tga",  -- Texture pour l'ombre
          edgeSize = 16,
      })
      -- Supprimer le rôle Heal de la table selectedRoles
      for i, role in ipairs(selectedRoles) do
          if role == "Heal" then
              table.remove(selectedRoles, i)
              break
          end
      end
  else
      -- Sélectionner
      healIcon.selected = true
      -- Appliquer une bordure plus lumineuse et épaisse
      healIcon:SetBackdrop({
          edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
          edgeSize = 16,
          insets = { left = 4, right = 4, top = 4, bottom = 4 },
      })
      -- Bordure jaune plus lumineuse
      healIcon:SetBackdropBorderColor(1, 1, 0, 1)

      -- Appliquer un effet de glow (halo lumineux)
      healIcon:SetBackdrop({
          edgeFile = "Interface\\AddOns\\AutoLFM\\icon\\glow-border.tga",
          edgeSize = 32,
      })
      healIcon:SetBackdropBorderColor(0, 1, 0, 1)  -- Bordure néon verte pour l'effet lumineux

      healIcon.texture:SetAlpha(1)  -- Rendre l'icône entièrement opaque
      -- Ajouter le rôle Heal à la table selectedRoles
      table.insert(selectedRoles, "Heal")
  end
  updateMsgFrameCombined()  -- Mettre à jour le message dans msgFrame
end)

-- Appliquer un effet de fade (transparence) initialement lorsque non sélectionnée
dpsIcon.texture:SetAlpha(0.5)  -- Applique un fade initial pour DPS
healIcon.texture:SetAlpha(0.5)  -- Applique un fade initial pour Heal
tankIcon.texture:SetAlpha(0.5)  -- Applique un fade initial lorsque non sélectionnée

-- Fonction pour gérer l'effet de survol
local function OnEnterEffect(icon)
  -- Changer la transparence de l'icône survolée pour la rendre plus visible
  icon.texture:SetAlpha(1)  -- L'icône devient pleinement opaque
  -- Appliquer une bordure lumineuse (par exemple, une bordure bleue claire)
  icon:SetBackdrop({
      edgeSize = 16,
      insets = { left = 4, right = 4, top = 4, bottom = 4 },
  })
  icon:SetBackdropBorderColor(0, 0, 1, 1)  -- Bordure bleue pour l'effet de survol
end

-- Fonction pour réinitialiser l'effet de survol
local function OnLeaveEffect(icon)
  -- Réinitialiser la transparence de l'icône
  if not icon.selected then
      icon.texture:SetAlpha(0.5)  -- Appliquer un fade si l'icône n'est pas sélectionnée
  end
  -- Réinitialiser la bordure de l'icône
  icon:SetBackdrop(nil)
end

-- Ajouter les effets de survol pour chaque icône

tankIcon:SetScript("OnEnter", function() OnEnterEffect(tankIcon) end)
tankIcon:SetScript("OnLeave", function() OnLeaveEffect(tankIcon) end)

dpsIcon:SetScript("OnEnter", function() OnEnterEffect(dpsIcon) end)
dpsIcon:SetScript("OnLeave", function() OnLeaveEffect(dpsIcon) end)

healIcon:SetScript("OnEnter", function() OnEnterEffect(healIcon) end)
healIcon:SetScript("OnLeave", function() OnLeaveEffect(healIcon) end)

-- Fonction pour récupérer les rôles sélectionnés
local function getSelectedRoles()
  return selectedRoles
end

-- Fonction pour désélectionner tous les rôles et vider la table selectedRoles
local function clearSelectedRoles()
    -- Vider la table selectedRoles
    selectedRoles = getSelectedRoles()

    if tankIcon.selected then
    -- Désélectionner l'icône Tank
      tankIcon.selected = false
      tankIcon:SetBackdrop(nil)  -- Retirer les bordures
      tankIcon.texture:SetAlpha(0.5)  -- Appliquer un effet de fade (transparence)
      tankIcon:SetBackdrop({
          edgeFile = "Interface\\AddOns\\AutoLFM\\icon\\shadow-border.tga",  -- Texture pour l'ombre
          edgeSize = 16,
      })
        -- Supprimer le rôle Tank de la table selectedRoles
      for i, role in ipairs(selectedRoles) do
        if role == "Tank" then
            table.remove(selectedRoles, i)
            break
        end
      end
    end

    if dpsIcon.selected then
    -- Désélectionner l'icône DPS
      dpsIcon.selected = false
      dpsIcon:SetBackdrop(nil)  -- Retirer les bordures
      dpsIcon.texture:SetAlpha(0.5)  -- Appliquer un effet de fade (transparence)
      dpsIcon:SetBackdrop({
          edgeFile = "Interface\\AddOns\\AutoLFM\\icon\\shadow-border.tga",  -- Texture pour l'ombre
          edgeSize = 16,
      })
      -- Supprimer le rôle DPS de la table selectedRoles
      for i, role in ipairs(selectedRoles) do
        if role == "DPS" then
            table.remove(selectedRoles, i)
            break
        end
      end
    end

    if healIcon.selected then
    -- Désélectionner l'icône Heal
      healIcon.selected = false
      healIcon:SetBackdrop(nil)  -- Retirer les bordures
      healIcon.texture:SetAlpha(0.5)  -- Appliquer un effet de fade (transparence)
      healIcon:SetBackdrop({
          edgeFile = "Interface\\AddOns\\AutoLFM\\icon\\shadow-border.tga",  -- Texture pour l'ombre
          edgeSize = 16,
      })
      -- Supprimer le rôle Heal de la table selectedRoles
      for i, role in ipairs(selectedRoles) do
        if role == "Heal" then
            table.remove(selectedRoles, i)
            break
        end
      end
    end
    -- Mettre à jour l'affichage après avoir désélectionné tous les rôles
end


---------------------------------------------------------------------------------
--                               Slider Frame                                  --
---------------------------------------------------------------------------------


-- Valeur de pas fixe pour arrondir
local step = 10

-- Fonction pour arrondir la valeur du slider à l'étape la plus proche
local function SnapToStep(value)
    if value then
        local roundedValue = math.floor(value / step + 0.5) * step
        return roundedValue
    end
end

-- Variable pour stocker la valeur du slider
local sliderValue = 80

-- Créer une police pour afficher la valeur actuelle du slider (placer la valeur au-dessus du slider)
local valueText = slider:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
valueText:SetPoint("BOTTOM", slider, "TOP", 0, 5)
valueText:SetFont("Fonts\\FRIZQT__.TTF", 14, "OUTLINE")

-- Mettre à jour la valeur du slider
sliderframe:SetScript("OnUpdate", function(self, elapsed)
  -- Récupérer la valeur actuelle du slider
  local currentValue = slider:GetValue()

  -- Arrondir la valeur à l'étape la plus proche
  local snappedValue = SnapToStep(currentValue)

  -- Appliquer la valeur arrondie au slider si nécessaire (au cas où la valeur serait flottante)
  if currentValue ~= snappedValue then
      slider:SetValue(snappedValue)
  end

  -- Mettre à jour dynamiquement le texte pour refléter la nouvelle valeur en temps réel
  valueText:SetText("Dispense every " .. slider:GetValue() .. " seconds")
end)


---------------------------------------------------------------------------------
--                               Donjon Fonction                               --
---------------------------------------------------------------------------------


-- Initialiser les tables si elles ne le sont pas déjà
donjonCheckButtons = donjonCheckButtons or {}
raidCheckButtons = raidCheckButtons or {}

-- Ajouter l'index à chaque donjon
for index, donjon in ipairs(donjons) do
  donjon.originalIndex = index
end

function calculer_priorite(niveau_joueur, donjon)
  local diff_min = niveau_joueur - donjon.lvl_min  -- Différence par rapport au niveau minimum du donjon
  local diff_max = niveau_joueur - donjon.lvl_max  -- Différence par rapport au niveau maximum du donjon

  local priority

  if diff_min > 7 then
      priority = 4  -- Gris : trop élevé, le joueur a plus de 7 niveaux au-dessus du donjon
  elseif diff_min >= 3 then
      priority = 1  -- Vert : adapté, joueur est à +2 niveaux du niveau minimum du donjon
  elseif diff_min >= 1 then
      priority = 2  -- Orange : légèrement en dessous, joueur à 1 niveau en dessous du niveau minimum
  elseif diff_min < 0 and math.abs(diff_min) > 5 then
      priority = 3  -- Rouge : trop faible, joueur a plus de 5 niveaux en dessous du donjon
  else
      priority = 3  -- Rouge : situation où le joueur est trop faible mais moins de 5 niveaux en dessous
  end

  return priority
end

-- Fonction pour afficher les donjons par code couleur avec le niveau du donjon
function DisplayDungeonsByColor()
  -- Effacer les précédents donjons affichés
  for _, child in ipairs({contentFrame:GetChildren()}) do
      child:Hide()
  end

  local playerLevel = UnitLevel("player")  -- Récupère le niveau du joueur
  local yOffset = 0  -- Position verticale pour les donjons
  local donjonCount = 0  -- Initialiser le compteur de donjons

  -- Créer une table de priorités pour organiser les donjons selon leur couleur
  local sortedDungeons = {}

  -- Ajouter une priorité pour chaque donjon
  for _, donjon in pairs(donjons) do
      if donjonCount >= maxDonjons then
          break
      end
      donjonCount = donjonCount + 1

      -- Utiliser la fonction calculer_priorite pour obtenir la priorité du donjon
      local priority = calculer_priorite(playerLevel, donjon)

      -- Ajouter le donjon à la table avec son index pour garder l'ordre d'origine
      table.insert(sortedDungeons, {donjon = donjon, priority = priority, originalIndex = donjon.originalIndex})
  end

  -- Tri par priorité (couleur)
  table.sort(sortedDungeons, function(a, b)
      if a.priority == b.priority then
          return a.originalIndex < b.originalIndex  -- Si la priorité est identique, trier par ordre d'apparition
      else
          return a.priority < b.priority  -- Sinon, trier par priorité de couleur (vert, rouge, gris)
      end
  end)

  -- Afficher les donjons dans l'ordre trié
  for _, entry in ipairs(sortedDungeons) do
      local donjon = entry.donjon
      local priority = entry.priority

      -- Créer une ligne cliquable qui englobe la case à cocher et les labels
      local clickableFrame = CreateFrame("Button", "ClickableDonjonFrame" .. donjon.abrev, contentFrame)
      clickableFrame:SetHeight(30)  -- Hauteur de la ligne
      clickableFrame:SetPoint("TOPLEFT", contentFrame, "TOPLEFT", 0, -yOffset)
      clickableFrame:SetWidth(300)  -- Largeur de la ligne
      clickableFrame:SetScript("OnClick", function()
          -- Gestion de la sélection des donjons lorsqu'on clique sur la ligne
          local checkbox = donjonCheckButtons[donjon.abrev]
          checkbox:SetChecked(not checkbox:GetChecked())
          checkbox:GetScript("OnClick")()  -- Appeler la fonction OnClick déjà définie
      end)

      -- Ajouter les événements de survol (hover)
      clickableFrame:SetScript("OnEnter", function()
          clickableFrame:SetBackdrop({
              bgFile = "Interface\\Buttons\\WHITE8X8",  -- Changer la couleur de fond
              insets = {left = 1, right = 1, top = 1, bottom = 1},
          })
          clickableFrame:SetBackdropColor(0.2, 0.2, 0.2, 0.8)  -- Fond gris foncé lors du survol
      end)

      clickableFrame:SetScript("OnLeave", function()
          clickableFrame:SetBackdrop(nil)  -- Réinitialiser l'arrière-plan
      end)

      -- Créer la case à cocher à gauche du label
      local checkbox = CreateFrame("CheckButton", "DonjonCheckbox" .. donjon.abrev, clickableFrame, "UICheckButtonTemplate")
      checkbox:SetWidth(20)
      checkbox:SetHeight(20)
      checkbox:SetPoint("LEFT", clickableFrame, "LEFT", 0, 0)  -- Positionner la case à cocher à gauche

      local donjonAbrev = donjon.abrev
      donjonCheckButtons[donjonAbrev] = checkbox

      -- Créer un label pour afficher le niveau du donjon à droite de la case à cocher
      local levelLabel = clickableFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
      levelLabel:SetPoint("LEFT", checkbox, "RIGHT", 5, 0)
      levelLabel:SetText(donjon.lvl_min .. "-" .. donjon.lvl_max)

      -- Créer un label pour chaque donjon à droite du niveau du donjon
      local label = clickableFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
      label:SetPoint("LEFT", levelLabel, "RIGHT", 10, 0)

      -- Attribuer la couleur en fonction de la priorité calculée
      if priority == 4 then
          label:SetTextColor(0.5, 0.5, 0.5)  -- Gris (trop élevé)
      elseif priority == 1 then
          label:SetTextColor(0, 1, 0)  -- Vert (adapté ou légèrement en dessous)
      elseif priority == 2 then
          label:SetTextColor(1, 0.5, 0)  -- Orange (légèrement en dessous)
      else
          label:SetTextColor(1, 0, 0)  -- Rouge (trop faible)
      end

      label:SetText(donjon.nom)

      -- Ajouter la gestion de la sélection des donjons
      checkbox:SetScript("OnClick", function()
          local isChecked = checkbox:GetChecked()

          if isChecked then
              -- Vérifier si déjà 2 donjons sont sélectionnés
              if table.getn(selectedDungeons) >= 4 then
                  -- Retirer le premier élément sélectionné et décocher la case correspondante
                  local firstDonjonAbrev = selectedDungeons[1]  -- Récupérer l'abréviation du premier donjon
                  table.remove(selectedDungeons, 1)  -- Retirer le premier donjon
                  -- Décocher la case du premier donjon retiré
                  if donjonCheckButtons[firstDonjonAbrev] then
                      donjonCheckButtons[firstDonjonAbrev]:SetChecked(false)
                  end
              end
              -- Ajouter le nouveau donjon sélectionné à la liste
              table.insert(selectedDungeons, donjonAbrev)
          else
              -- Si la case est décochée, retirer l'abréviation du donjon de la liste
              for i, value in pairs(selectedDungeons) do
                  if value == donjonAbrev then
                      table.remove(selectedDungeons, i)
                      -- Après avoir retiré l'élément de la liste, décocher la case
                      checkbox:SetChecked(false)
                      break
                  end
              end
          end
          updateMsgFrameCombined()  -- Mettre à jour l'affichage
      end)

      yOffset = yOffset + 30
  end
end

-- Fonction pour effacer les donjons sélectionnés
function clearSelectedDungeons()
  -- Décoche toutes les cases des donjons
  for _, donjonCheckbox in pairs(donjonCheckButtons) do
      donjonCheckbox:SetChecked(false)
  end
  selectedDungeons = {}
end


---------------------------------------------------------------------------------
--                             Raids Fonctions                                 --
---------------------------------------------------------------------------------



---------------------------------------------------------------------------------
--                           VARIABLES ET INITIATION                           --
---------------------------------------------------------------------------------


-- Nombre maximum de raids à afficher
local raidCount = 0
local maxRaids = 100

-- Créer le contenu du ScrollFrame pour les raids
local raidContentFrame = CreateFrame("Frame", nil, raidScrollFrame)
raidContentFrame:SetWidth(raidFrame:GetWidth() - 20)
raidContentFrame:SetHeight(raidFrame:GetHeight() - 60)
raidScrollFrame:SetScrollChild(raidContentFrame)


raidCheckButtons = {}


---------------------------------------------------------------------------------
--                       CRÉATION DES CASES À COCHER                           --
---------------------------------------------------------------------------------


-- Fonction pour créer et gérer les cases à cocher des raids
for index, raid in pairs(raids) do
  -- Incrémenter le nombre de raids
  raidCount = raidCount + 1
  if raidCount >= maxRaids then
      break
  end

  -- Créer le cadre cliquable qui englobe la case à cocher et le label
  local clickableFrame = CreateFrame("Button", "ClickableRaidFrame" .. index, raidContentFrame)
  clickableFrame:SetHeight(30)  -- Hauteur de la ligne
  clickableFrame:SetPoint("TOPLEFT", raidContentFrame, "TOPLEFT", 0, -(30 * (index - 1)))
  clickableFrame:SetWidth(raidContentFrame:GetWidth())  -- Largeur de la ligne

  -- Capturer l'abréviation du raid localement
  local raidAbrev = raid.abrev
  local raidName = raid.nom
  -- local sizeMin = raid.size_min
  -- local sizeMax = raid.size_max

  -- Créer la case à cocher pour chaque raid
  local checkbox = CreateFrame("CheckButton", "RaidCheckbox" .. index, clickableFrame, "UICheckButtonTemplate")
  checkbox:SetWidth(20)
  checkbox:SetHeight(20)
  checkbox:SetPoint("LEFT", clickableFrame, "LEFT", 0, 0)  -- Positionner la case à cocher à gauche

  -- Créer le label pour chaque raid
  local label = clickableFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  label:SetPoint("LEFT", checkbox, "RIGHT", 5, 0)
  label:SetText(raidName)

  -- Ajouter la case à cocher dans la table raidCheckButtons
  raidCheckButtons[raidAbrev] = checkbox

  -- Ajouter la gestion de la sélection des raids
  checkbox:SetScript("OnClick", function()
      -- Si la case est cochée, désélectionner toutes les autres cases
      if checkbox:GetChecked() then
          -- Désélectionner toutes les autres cases à cocher de raid
          for _, otherCheckbox in pairs(raidCheckButtons) do
              if otherCheckbox ~= checkbox then
                  otherCheckbox:SetChecked(false)
              end
          end
          -- Ajouter le raid sélectionné à la liste
          selectedRaids = {raidAbrev}
            -- name = raidName
            -- sizeMin = sizeMin
            -- sizeMax = sizeMax
            -- -- Mettre à jour le slider avec les nouvelles valeurs
            -- raid = {name, sizeMin, sizeMax}
            -- updateSliderForSelectedRaid(raid, sizeMin, sizeMax)
      else
          -- Si la case est décochée, retirer l'abréviation du raid de la liste
          selectedRaids = {}
          sliderSizeFrame:Hide()
      end
      -- Mettre à jour l'affichage après chaque changement
      updateMsgFrameCombined()
  end)

  -- Ajouter la gestion du clic sur la ligne entière (le cadre cliquable)
  clickableFrame:SetScript("OnClick", function()
      -- Lorsque la ligne entière est cliquée, basculer la sélection de la case à cocher
      checkbox:SetChecked(not checkbox:GetChecked())
      checkbox:GetScript("OnClick")()  -- Appeler la fonction OnClick déjà définie
  end)

  -- Ajouter les événements de survol (hover)
  clickableFrame:SetScript("OnEnter", function()
      clickableFrame:SetBackdrop({
          bgFile = "Interface\\Buttons\\WHITE8X8",  -- Changer la couleur de fond
          insets = {left = 1, right = 1, top = 1, bottom = 1},
      })
      clickableFrame:SetBackdropColor(0.2, 0.2, 0.2, 0.8)  -- Fond gris foncé lors du survol
  end)

  clickableFrame:SetScript("OnLeave", function()
      clickableFrame:SetBackdrop(nil)  -- Réinitialiser l'arrière-plan
  end)
end


---------------------------------------------------------------------------------
--                       FONCTIONS SUPPLÉMENTAIRES                             --
---------------------------------------------------------------------------------


-- Fonction pour effacer les raids sélectionnés
function clearSelectedRaids()
    -- Décoche toutes les cases des raids
    for _, raidCheckbox in pairs(raidCheckButtons) do
        raidCheckbox:SetChecked(false)
    end
    selectedRaids = {}
    -- sliderSizeFrame:Hide()  -- Masquer le slider
end


---------------------------------------------------------------------------------
--                               Swap Bouton                                   --
---------------------------------------------------------------------------------


local swapButton = CreateFrame("Button", nil, AutoLFM, "OptionsButtonTemplate")
swapButton:SetText("Raids List")
swapButton:SetWidth(200)
swapButton:SetHeight(25)
swapButton:SetPoint("BOTTOM", djScrollFrame, "TOP", 0, 10)
swapButton:SetBackdrop({
  bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
  insets = { left = 4, right = 4, top = 4, bottom = 4 }
})

--- Action lorsque le bouton est cliqué ---
swapButton:SetScript("OnClick", function()
    -- Si les donjons et les raids sont vides, basculer entre les vues
    if djScrollFrame:IsShown() then
        -- Cacher les donjons et afficher les raids
        djScrollFrame:Hide()
        swapButton:SetText("Dungeons List")
        raidFrame:Show()
        raidContentFrame:Show()
        raidScrollFrame:Show()
        raidFrame:Show()
        msgFrameDj:Hide()
        msgFrameRaids:Show()
        clearSelectedDungeons()
        clearSelectedRoles()
        resetUserInputMessage()
        updateMsgFrameCombined()
    else
        -- Cacher les raids et afficher les donjons
        swapButton:SetText("Raids List")
        djScrollFrame:Show()
        msgFrameRaids:Hide()
        raidContentFrame:Hide()
        raidScrollFrame:Hide()
        raidFrame:Hide()
        msgFrameDj:Show()
        clearSelectedRaids()
        clearSelectedRoles()
        resetUserInputMessage()
        updateMsgFrameCombined()
        HideSliderForRaid()
        -- sliderSizeFrame:Hide()
    end
end)


---------------------------------------------------------------------------------
--                             Broadcast Fonction                              --
---------------------------------------------------------------------------------


-- Variables pour gérer l'intervalle et la diffusion du message
local isBroadcasting = false
local broadcastStartTime = 0
local lastBroadcastTime = 0
local broadcastedHalf = false
local broadcastedOneSecBefore = false

local iconUpdateFrame = CreateFrame("Frame")  -- Frame pour gérer l'update des icônes

-- Fonction pour alterner les icônes
local function toggleMinimapButtonIcon()
    local randomChoice = math.random(1, 2)
    if randomChoice == 1 then
        AutoLFMMinimapBtn:SetNormalTexture("Interface\\AddOns\\AutoLFM\\icon\\ring.png")
        AutoLFMMinimapBtn:SetPushedTexture("Interface\\AddOns\\AutoLFM\\icon\\fermer.png")
    else
        AutoLFMMinimapBtn:SetNormalTexture("Interface\\AddOns\\AutoLFM\\icon\\fermer.png")
        AutoLFMMinimapBtn:SetPushedTexture("Interface\\AddOns\\AutoLFM\\icon\\ring.png")
    end
end


-- Fonction pour arrêter la diffusion du message
local function stopMessageBroadcast()
    isBroadcasting = false
    DEFAULT_CHAT_FRAME:AddMessage("Broadcast stopped")
    -- Réinitialiser l'icône du bouton lorsque la diffusion s'arrête
    AutoLFMMinimapBtn:SetNormalTexture("Interface\\AddOns\\AutoLFM\\icon\\ring.png")
    AutoLFMMinimapBtn:SetPushedTexture("Interface\\AddOns\\AutoLFM\\icon\\fermer.png")
    -- Désactiver la mise à jour de l'icône
    iconUpdateFrame:SetScript("OnUpdate", nil)
end

-- Fonction pour envoyer un message dans tous les canaux sélectionnés
local function sendMessageToSelectedChannels(message)
    -- Vérifier si des canaux ont été sélectionnés
    if next(selectedChannels) then
        local allChannelsValid = true  -- Indicateur pour vérifier si tous les canaux sont valides

        -- Itérer sur tous les canaux sélectionnés
        for channelName, _ in pairs(selectedChannels) do
            -- Ignorer "Hardcore" lors de la vérification des autres canaux
            if channelName ~= "Hardcore" then
                -- Recherche l'ID du canal en utilisant GetChannelName pour s'assurer qu'il est ouvert
                local channelId = GetChannelName(channelName)

                -- Si le canal est invalide (ID non valide)
                if not (channelId and channelId > 0) then
                    DEFAULT_CHAT_FRAME:AddMessage("Error : The channel " .. channelName .. " is invalid or closed.")
                    allChannelsValid = false  -- Un canal invalide a été trouvé, donc on arrête l'envoi
                    break  -- Quitte la boucle dès qu'un canal invalide est trouvé
                end
            end
        end

        -- Si tous les canaux sont valides (en ignorant "Hardcore"), envoyer le message
        if allChannelsValid then
            -- Envoi du message dans tous les canaux sélectionnés
            for channelName, _ in pairs(selectedChannels) do
                -- Si le canal est "Hardcore", ajouter le préfixe "/h"
                if channelName == "Hardcore" then
                    -- Ajouter "/h" au message pour le canal Hardcore
                    local hardcoreMessage = message
                    -- Envoie le message comme une commande dans le canal "Hardcore"
                    SendChatMessage(hardcoreMessage, "Hardcore")  -- Utiliser "SAY" ou un autre canal pour simuler l'envoi
                    -- Affiche dans le chat du jeu le message envoyé (facultatif)
                    -- DEFAULT_CHAT_FRAME:AddMessage("Message envoyé au canal : " .. channelName .. " avec le préfixe /h : " .. hardcoreMessage)
                else
                    -- Pour les autres canaux, envoyer le message normalement
                    local channelId = GetChannelName(channelName)
                    SendChatMessage(message, "CHANNEL", nil, channelId)
                    -- Affiche dans le chat du jeu le message envoyé (dev mode)
                    -- DEFAULT_CHAT_FRAME:AddMessage("Message envoyé au canal : " .. channelName)
                end
            end
        else
            print("1977 : The message has not been sent, because one or more channels are invalid.")
        end
    else
        DEFAULT_CHAT_FRAME:AddMessage("Error: No channel selected.")
    end
end





-- Fonction pour démarrer la diffusion du message
local function startMessageBroadcast()
    -- Vérifier si combinedMessage est vide avant de démarrer la diffusion
    if combinedMessage == "" or combinedMessage == " " then
        print("The LFM message is empty. The broadcast cannot begin.")
        return
    end

    isBroadcasting = true
    broadcastStartTime = GetTime()
    lastBroadcastTime = broadcastStartTime
    DEFAULT_CHAT_FRAME:AddMessage("Broadcast started.")

    -- Diffuser immédiatement le message dès le démarrage
    sendMessageToSelectedChannels(combinedMessage)

    -- Alterner les icônes toutes les 2 secondes pendant la diffusion
    iconUpdateFrame:SetScript("OnUpdate", function(self, elapsed)
        if isBroadcasting then
            -- Alterner les icônes toutes les 2 secondes
            if GetTime() - broadcastStartTime >= 0.3 then
                toggleMinimapButtonIcon()
                broadcastStartTime = GetTime()  -- Réinitialiser le temps à chaque changement
            end
        else
            -- Si la diffusion est arrêtée, arrêter de changer l'icône
            iconUpdateFrame:SetScript("OnUpdate", nil)

        end
    end)
end

-- Frame d'update pour gérer le délai entre chaque diffusion
local broadcastFrame = CreateFrame("Frame")

broadcastFrame:SetScript("OnUpdate", function(self, elapsed)
  if isBroadcasting then
      -- Mettre à jour la valeur de l'intervalle du slider
      local sliderValue = slider:GetValue()

      -- Vérifier si le temps écoulé est supérieur ou égal à l'intervalle du slider
      local timeElapsed = GetTime() - lastBroadcastTime

      -- Calculer la moitié de la valeur du slider
      local halfSliderValue = sliderValue / 2
      local oneSecondBefore = sliderValue - 1

      -- Afficher un message une seule fois pour chaque niveau du décompte
      if not broadcastedHalf and timeElapsed >= halfSliderValue and timeElapsed < halfSliderValue + 1 then
          -- Message à la moitié du temps
          DEFAULT_CHAT_FRAME:AddMessage("Rediffusion in " .. math.floor(halfSliderValue) .. " seconds", 0, 1, 1)
          broadcastedHalf = true  -- Marquer comme diffusé une fois
      end

      if not broadcastedOneSecBefore and timeElapsed >= oneSecondBefore and timeElapsed < oneSecondBefore + 1 then
          -- Message 1 seconde avant la diffusion
          DEFAULT_CHAT_FRAME:AddMessage("Rediffusion of Message", 0, 1, 1)
          broadcastedOneSecBefore = true  -- Marquer comme diffusé une fois
      end

      -- Une fois le temps écoulé, envoyer le message
      if timeElapsed >= sliderValue then
          -- Diffuser le message
          if combinedMessage ~= "" then
              sendMessageToSelectedChannels(combinedMessage)
          end

          -- Réinitialiser le temps pour la prochaine diffusion
          lastBroadcastTime = GetTime()

          -- Réinitialiser les drapeaux
          broadcastedHalf = false
          broadcastedOneSecBefore = false
      end
  end
end)


---------------------------------------------------------------------------------
--                              Toggle Bouton                                  --
---------------------------------------------------------------------------------


-- Créer un bouton Toggle en dessous de msgFrame, centré par rapport à AutoLFM
local toggleButton = CreateFrame("Button", "ToggleButton", msgFrame, "UIPanelButtonTemplate")
toggleButton:SetWidth(120)
toggleButton:SetHeight(30)

-- Positionner le bouton en bas centré, sous roleframe et msgFrame par rapport à AutoLFM
toggleButton:SetPoint("CENTER", msgFrame, "CENTER", 0, -10)  -- Placer 10 pixels sous msgFrame
toggleButton:SetPoint("BOTTOM", AutoLFM, 0, 20)

toggleButton:SetText("Start")

-- Fonction pour gérer le changement d'état du bouton et démarrer/arrêter la diffusion
toggleButton:SetScript("OnClick", function()
    -- Vérifier si le message combiné est vide ou ne contient que des espaces
    if combinedMessage == " " or combinedMessage == "" then
        -- Si le message est vide, ne pas démarrer la diffusion
        if not isBroadcasting then
            print("The message is empty. The broadcast cannot begin.")
            -- Ne pas changer le texte du bouton si la diffusion ne commence pas
            return
        end
    end

    -- Vérifier la validité des canaux avant de commencer la diffusion
    local allChannelsValid = true  -- Indicateur pour vérifier si tous les canaux sont valides
    for channelName, _ in pairs(selectedChannels) do
        -- Ignorer "Hardcore" lors de la vérification
        if channelName ~= "Hardcore" then
            local channelId = GetChannelName(channelName)
            if not (channelId and channelId > 0) then
                allChannelsValid = false
                break  -- Arrêter dès qu'un canal invalide est trouvé
            end
        end
    end

    -- Si tous les canaux sont valides (en ignorant "Hardcore"), démarrer la diffusion
    if allChannelsValid then
        if isBroadcasting then
            stopMessageBroadcast()
            toggleButton:SetText("Start")  -- Réinitialiser le texte à "Start" si on arrête
            PlaySoundFile("Interface\\AddOns\\AutoLFM\\sound\\LFG_Denied.ogg")
        else
            startMessageBroadcast()
            toggleButton:SetText("Stop")  -- Changer le texte à "Stop" lorsqu'on commence
            PlaySoundFile("Interface\\AddOns\\AutoLFM\\sound\\LFG_RoleCheck.ogg")
        end
    else
        DEFAULT_CHAT_FRAME:AddMessage("2112 : Broadcast has not started because one or more channels are invalid.")
    end
end)


-- Ajouter un événement pour surveiller les changements dans le raid
AutoLFM:RegisterEvent("RAID_ROSTER_UPDATE")

AutoLFM:SetScript("OnEvent", function(self, event, ...)
  if "RAID_ROSTER_UPDATE" then
    
    OnRaidRosterUpdate()
  end
end)

AutoLFM:SetScript("OnEvent", function(self, event, ...)
  if "GROUP_ROSTER_UPDATE" then
    local raid = selectedRaids[1]  -- Récupérer le raid sélectionné
    local donjon = selectedDungeons[1]  -- Récupérer le donjon sélectionné
    if raid ~= nil then
        raidSize = value
        local totalPlayersInRaid = countRaidMembers()  -- Récupérer le nombre total de membres du groupe
        if raidSize == totalPlayersInRaid then
            stopMessageBroadcast()  -- Si le groupe a atteint la taille du raid, arrêter la diffusion
            clearSelectedRaids() -- Effacer les donjons sélectionnés
            clearSelectedRoles()  -- Effacer les rôles sélectionnés
            resetUserInputMessage()  -- Réinitialiser le message d'entrée utilisateur
            updateMsgFrameCombined()  -- Mettre à jour le message combiné
            toggleButton:SetText("Start")  -- Réinitialiser le texte du bouton à "Start"
            PlaySoundFile("Interface\\AddOns\\AutoLFM\\sound\\LFG_Denied.ogg")  -- Jouer le son d'arrêt
        else
            OnGroupUpdate()  -- Mettre à jour le groupe
        end
    elseif donjon ~= nil then
        donjonSize = 5
        local totalPlayersInRaid = countGroupMembers()  -- Récupérer le nombre total de membres du groupe
        if donjonSize == totalPlayersInRaid then
            stopMessageBroadcast()  -- Si le groupe a atteint la taille du donjon, arrêter la diffusion
            clearSelectedDungeons()  -- Effacer les donjons sélectionnés
            clearSelectedRoles()  -- Effacer les rôles sélectionnés
            resetUserInputMessage()  -- Réinitialiser le message d'entrée utilisateur
            updateMsgFrameCombined()  -- Mettre à jour le message combiné
            toggleButton:SetText("Start")  -- Réinitialiser le texte du bouton à "Start"
            PlaySoundFile("Interface\\AddOns\\AutoLFM\\sound\\LFG_Denied.ogg")  -- Jouer le son d'arrêt
        else
            OnGroupUpdate()  -- Mettre à jour le groupe
        end
    end
  end
end)


---------------------------------------------------------------------------------
--                       Commandes Slash pour l'addon                          --
---------------------------------------------------------------------------------


-- Définir les slash commandes
SLASH_LFM1 = "/lfm"
SLASH_LFM3 = "/lfm help"
SLASH_LFM2 = "/lfm broadcast"
SLASH_LFM5 = "/lfm minimap show"
SLASH_LFM6 = "/lfm minimap hide"


-- Fonction principale des commandes Slash
SlashCmdList["LFM"] = function(msg)
    -- Séparer le message en argument
    local args = strsplit(" ", msg)

    -- Afficher les commandes disponibles
    if args[1] == "help" then
        -- Afficher les commandes disponibles dans le chat avec des couleurs
        DEFAULT_CHAT_FRAME:AddMessage("|cffffff00Available commands :")
        DEFAULT_CHAT_FRAME:AddMessage("|cff00FFFF /lfm  |cffFFFFFFOpens AutoLFM window.")
        DEFAULT_CHAT_FRAME:AddMessage("|cff00FFFF /lfm help   |cffFFFFFFDisplays all available orders.")  -- Bleu clair pour la commande et blanc pour l'explication
        DEFAULT_CHAT_FRAME:AddMessage("|cff00FFFF /lfm broadcast   |cffFFFFFFOpen Broadcast settings.")  -- Bleu clair pour la commande et blanc pour l'explication
        DEFAULT_CHAT_FRAME:AddMessage("|cff00FFFF /lfm minimap show   |cffFFFFFFDisplays the minimap button.")
        DEFAULT_CHAT_FRAME:AddMessage("|cff00FFFF /lfm minimap hide   |cffFFFFFFHide minimap button.")
        return
    end

    -- Commande pour ouvrir la fenêtre AutoLFM
    if args[1] == "" or args[1] == "open" then
        if AutoLFM then
            if AutoLFM:IsVisible() then
                AutoLFM:Hide()  -- Si la fenêtre est visible, la cacher
            else
                AutoLFM:Show()  -- Si la fenêtre est cachée, l'afficher
            end
        end
        return
    end

    -- Commande pour afficher le bouton de la minimap
    if args[1] == "minimap" and args[2] == "show" then
      if AutoLFMMinimapBtn:IsVisible() then
          DEFAULT_CHAT_FRAME:AddMessage("The minimap button is already visible.", 1.0, 0.0, 0.0)  -- Texte rouge
      else
          AutoLFMMinimapBtn:Show()
          DEFAULT_CHAT_FRAME:AddMessage("The minimap button has been redisplayed.", 0.0, 1.0, 0.0)  -- Texte vert
      end
      return
    end

        -- Commande pour masquer le bouton de la minimap
    if args[1] == "minimap" and args[2] == "hide" then
      if AutoLFMMinimapBtn:IsVisible() then
        AutoLFMMinimapBtn:Hide()  -- Masquer le bouton
        DEFAULT_CHAT_FRAME:AddMessage("The minimap button has been hidden.", 0.0, 1.0, 0.0)  -- Texte vert
      else
        DEFAULT_CHAT_FRAME:AddMessage("The minimap button is already hidden.", 1.0, 0.0, 0.0)  -- Texte rouge
      end
      return
    end

    if args[1] == "broadcast" then
        if channelsFrame:IsVisible() then
            channelsFrame:Hide()  -- Cacher le cadre des canaux
            DEFAULT_CHAT_FRAME:AddMessage("Channels frame hidden.")  -- Message de confirmation
        else
            CreateChannelButtons()
            LoadSelectedChannels()
            channelsFrame:Show()  -- Afficher le cadre des canaux
            DEFAULT_CHAT_FRAME:AddMessage("Channels frame displayed.")  -- Message de confirmation
        end
        return
    end

    -- Si la commande est incorrecte
    DEFAULT_CHAT_FRAME:AddMessage("|cffff0000 ! Usage !   |cff00FFFF/lfm help |cffFFFFFFto list all commands.")  -- Rouge
end

AutoLFM:Hide()


---------------------------------------------------------------------------------
---------------------------------------------------------------------------------
---------------------------------------------------------------------------------
