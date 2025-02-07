local panel = CreateFrame("Frame")
panel.name = "DDPoulet"

-- Titre du panneau
local title = panel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
title:SetPoint("TOP", 0, -10)
title:SetText("Options de DDPoulet")

-- Créer une icône à droite du panneau et plus grande
panel.icon = panel:CreateTexture(nil, "OVERLAY")
panel.icon:SetTexture("Interface\\AddOns\\DDPoulet\\data\\pics\\icone_DDPoulet.tga")  -- Chemin de l'icône
panel.icon:SetSize(64, 64)  -- Taille de l'icône plus grande
panel.icon:SetPoint("TOPRIGHT", panel, "TOPRIGHT", -10, -10)  -- Positionner l'icône à droite du panneau

-- Ajouter un message centré en bas de la fenêtre
local messageText = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
messageText:SetPoint("BOTTOM", panel, "BOTTOM", 0, 10)  -- Centré en bas
messageText:SetText("Daeler adore les doigts de poulet ...")

-- Case à cocher pour afficher l’image
local checkboxImage = CreateFrame("CheckButton", "DDPouletCheckboxImage", panel, "UICheckButtonTemplate")
checkboxImage:SetPoint("TOPLEFT", 10, -40)
checkboxImage.text = checkboxImage:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
checkboxImage.text:SetPoint("LEFT", checkboxImage, "RIGHT", 5, 0)
checkboxImage.text:SetText("Afficher l’image")

checkboxImage:SetScript("OnClick", function(self)
    DDPouletDB.showImage = self:GetChecked()
end)

-- Case à cocher pour jouer le son
local checkboxSound = CreateFrame("CheckButton", "DDPouletCheckboxSound", panel, "UICheckButtonTemplate")
checkboxSound:SetPoint("TOPLEFT", 10, -70)
checkboxSound.text = checkboxSound:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
checkboxSound.text:SetPoint("LEFT", checkboxSound, "RIGHT", 5, 0)
checkboxSound.text:SetText("Jouer le son")

checkboxSound:SetScript("OnClick", function(self)
    DDPouletDB.playSound = self:GetChecked()
end)

-- Case à cocher pour afficher la fenêtre de bienvenue
local checkboxWelcome = CreateFrame("CheckButton", "DDPouletCheckboxWelcome", panel, "UICheckButtonTemplate")
checkboxWelcome:SetPoint("TOPLEFT", 10, -100)
checkboxWelcome.text = checkboxWelcome:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
checkboxWelcome.text:SetPoint("LEFT", checkboxWelcome, "RIGHT", 5, 0)
checkboxWelcome.text:SetText("Afficher la fenêtre de bienvenue")

checkboxWelcome:SetScript("OnClick", function(self)
    DDPouletDB.showWelcomeWindow = self:GetChecked()  -- Sauvegarder l'état de la case à cocher
    if DDPouletDB.showWelcomeWindow then
        welcomeFrame:Show()  -- Afficher la fenêtre si activée
    else
        welcomeFrame:Hide()  -- Cacher la fenêtre si désactivée
    end
end)

-- Chargement des valeurs sauvegardées
panel:SetScript("OnShow", function()
    -- Initialiser les paramètres si DDPouletDB est nil
    if DDPouletDB == nil then
        DDPouletDB = { showImage = true, playSound = true, showWelcomeWindow = true }
    end
    -- Charger les paramètres de l'utilisateur
    checkboxImage:SetChecked(DDPouletDB.showImage)
    checkboxSound:SetChecked(DDPouletDB.playSound)
    checkboxWelcome:SetChecked(DDPouletDB.showWelcomeWindow)

    -- Si la case à cocher pour la fenêtre de bienvenue est activée, afficher la fenêtre
    if DDPouletDB.showWelcomeWindow then
        welcomeFrame:Show()
    else
        welcomeFrame:Hide()
    end
end)

-- Ajout au menu des extensions dans WoW (Dragonflight+)
local category = Settings.RegisterCanvasLayoutCategory(panel, "DDPoulet")
Settings.RegisterAddOnCategory(category)

-- Créer un cadre pour la fenêtre de bienvenue
local welcomeFrame = CreateFrame("Frame", "DDPouletWelcomeFrame", UIParent, "BasicFrameTemplateWithInset")
welcomeFrame:SetSize(300, 175)  -- Taille de la fenêtre
welcomeFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)  -- Centrer la fenêtre
welcomeFrame:Hide()  -- La cacher au démarrage

-- Modifier le titre de la fenêtre
welcomeFrame.title = welcomeFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
welcomeFrame.title:SetPoint("TOP", welcomeFrame, "TOP", 0, -5)
welcomeFrame.title:SetText("DDPoulet, bienvenue")

-- Ajouter un message de bienvenue dans la fenêtre avec une police plus petite
local welcomeMessage = welcomeFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
welcomeMessage:SetFont("Fonts\\FRIZQT__.TTF", 10.5)  -- Ajuste la taille (ex: 16)
welcomeMessage:SetPoint("TOP", welcomeFrame, "TOP", 0, -30)
welcomeMessage:SetText("\nLa v3.0.1 de Doigt De Poulet est la!\n\nNouveautée!\n\nAjout d'un sommaire des sons\n/ddpsons\nOu dans le menu interface")

-- Ajouter l'icône de DDPoulet dans la fenêtre de bienvenue (positionnée en bas à droite)
local icon = welcomeFrame:CreateTexture(nil, "OVERLAY")
icon:SetTexture("Interface\\AddOns\\DDPoulet\\data\\pics\\icone_DDPoulet.tga")  -- Chemin vers l'icône
icon:SetSize(50, 50)  -- Taille de l'icône
icon:SetPoint("BOTTOMRIGHT", welcomeFrame, "BOTTOMRIGHT", -10, 10)  -- Positionner en bas à droite

-- Créer un bouton pour fermer la fenêtre
local closeButton = CreateFrame("Button", nil, welcomeFrame, "UIPanelButtonTemplate")
closeButton:SetSize(100, 30)
closeButton:SetPoint("BOTTOM", welcomeFrame, "BOTTOM", 0, 20)
closeButton:SetText("Fermer")
closeButton:SetScript("OnClick", function()
    welcomeFrame:Hide()
    DDPouletDB.showWelcomeWindow = false  -- Marque que la fenêtre ne doit plus être affichée
    checkboxWelcome:SetChecked(false)  -- Désactiver la case à cocher
end)

-- Vérifier si la fenêtre de bienvenue doit être affichée lors du chargement
if not DDPouletDB.welcomeShown then
    -- Si ce n'est pas encore affiché, afficher la fenêtre
    welcomeFrame:Show()
    DDPouletDB.welcomeShown = true  -- Marquer que la fenêtre a été montrée
else
    -- Si la fenêtre a déjà été montrée, ne pas la réafficher
    welcomeFrame:Hide()
end

--- Ajouter une texture centrée dans la fenêtre des options
local background = panel:CreateTexture(nil, "ARTWORK")
background:SetTexture("Interface\\AddOns\\DDPoulet\\data\\pics\\Hakaza_fourmis.tga")  -- Chemin de ton image
background:SetSize(550, 350)  -- Ajuste la largeur et la hauteur selon ton besoin
background:SetPoint("CENTER", panel, "CENTER", 0, -50)  -- Centre l’image dans la fenêtre

-- Créer la fenêtre "Sommaire des sons"
local soundSummaryFrame = CreateFrame("Frame", "DDSoundSummaryFrame", UIParent, "BasicFrameTemplateWithInset")
soundSummaryFrame:SetSize(250, 400)
soundSummaryFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
soundSummaryFrame:Hide()

-- Définir la priorité d'affichage : elle doit être devant les autres fenêtres
soundSummaryFrame:SetFrameLevel(100)  -- Plus le niveau est élevé, plus la fenêtre est au-dessus
soundSummaryFrame:SetFrameStrata("DIALOG")  -- Placer dans la strata de fenêtre de dialogue (plus élevée que Background)

-- Ajouter le titre de la fenêtre
soundSummaryFrame.title = soundSummaryFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
soundSummaryFrame.title:SetPoint("TOP", soundSummaryFrame, "TOP", 0, -5)
soundSummaryFrame.title:SetText("Sommaire des Sons DDPoulet")

-- Rendre la fenêtre déplaçable
local isDragging = false
local startX, startY, offsetX, offsetY  -- Variables pour enregistrer la position du curseur et du cadre

-- Quand on clique sur le titre, on commence à déplacer la fenêtre
soundSummaryFrame.title:SetScript("OnMouseDown", function(self)
    isDragging = true
    -- Enregistrer la position du curseur et la position du cadre
    startX, startY = GetCursorPosition()
    local centerX, centerY = soundSummaryFrame:GetCenter()
    offsetX = startX - centerX
    offsetY = startY - centerY
    soundSummaryFrame:StartMoving()  -- Démarre le mouvement
end)

-- Quand la souris est relâchée, on arrête de déplacer la fenêtre
soundSummaryFrame:SetScript("OnMouseUp", function(self)
    if isDragging then
        isDragging = false
        soundSummaryFrame:StopMovingOrSizing()  -- Arrête de déplacer la fenêtre
    end
end)

-- Lorsque la souris quitte la fenêtre, on arrête le déplacement
soundSummaryFrame:SetScript("OnLeave", function(self)
    if isDragging then
        isDragging = false
        soundSummaryFrame:StopMovingOrSizing()
    end
end)

-- Suivre le mouvement de la souris
soundSummaryFrame:SetScript("OnUpdate", function(self)
    if isDragging then
        local curX, curY = GetCursorPosition()
        local newX = curX - offsetX
        local newY = curY - offsetY
        soundSummaryFrame:SetPoint("CENTER", UIParent, "BOTTOMLEFT", newX, newY)
    end
end)



-- Liste des sons
local soundList = {
    { name = "DDPoulet 1", path = "Interface\\AddOns\\DDPoulet\\data\\sounds\\DDPoulet.mp3" },
    { name = "DDPoulet 2", path = "Interface\\AddOns\\DDPoulet\\data\\sounds\\DDPoulet2.mp3" },
    { name = "DDPoulet 3", path = "Interface\\AddOns\\DDPoulet\\data\\sounds\\DDPoulet3.mp3" },
    { name = "DDPoulet 4", path = "Interface\\AddOns\\DDPoulet\\data\\sounds\\DDPoulet4.mp3" },
    { name = "Poulet !", path = "Interface\\AddOns\\DDPoulet\\data\\sounds\\ChickenDeathA.ogg" },
    { name = "Hey Moula", path = "Interface\\AddOns\\DDPoulet\\data\\sounds\\heymoula.mp3" },
    { name = "Hakaza Fourmis", path = "Interface\\AddOns\\DDPoulet\\data\\sounds\\hakaza_fourmis.mp3" },
    { name = "Meilleur war", path = "Interface\\AddOns\\DDPoulet\\data\\sounds\\resistar1.mp3" },
    { name = "AIDEZ-MOI", path = "Interface\\AddOns\\DDPoulet\\data\\sounds\\resistar_aidezmoi.mp3" },
    { name = "Tu Dekaliss", path = "Interface\\AddOns\\DDPoulet\\data\\sounds\\tudekaliss.mp3" },
    { name = "Daeler Back !", path = "Interface\\AddOns\\DDPoulet\\data\\sounds\\daelerback.mp3" },
}

-- Ajouter les boutons pour chaque son
for i, sound in ipairs(soundList) do
    local button = CreateFrame("Button", nil, soundSummaryFrame, "UIPanelButtonTemplate")
    button:SetSize(150, 25)
    button:SetPoint("TOP", soundSummaryFrame, "TOP", 0, 0 - (i * 30))
    button:SetText(sound.name)
    button:SetScript("OnClick", function()
        PlaySoundFile(sound.path, "Master")
    end)
end

-- Ajouter un bouton pour fermer la fenêtre
local closeButton = CreateFrame("Button", nil, soundSummaryFrame, "UIPanelButtonTemplate")
closeButton:SetSize(100, 30)
closeButton:SetPoint("BOTTOM", soundSummaryFrame, "BOTTOM", 0, 10)
closeButton:SetText("Fermer")
closeButton:SetScript("OnClick", function()
    soundSummaryFrame:Hide()
end)

-- Commande slash pour ouvrir la fenêtre
SLASH_DDSOUNDMENU1 = "/ddpsons"
SlashCmdList["DDSOUNDMENU"] = function()
    if soundSummaryFrame:IsShown() then
        soundSummaryFrame:Hide()
    else
        soundSummaryFrame:Show()
    end
end

-- Créer un bouton dans le panneau principal pour ouvrir la fenêtre Sommaire des sons
local soundSummaryButton = CreateFrame("Button", nil, panel, "UIPanelButtonTemplate")
soundSummaryButton:SetSize(200, 30)
soundSummaryButton:SetPoint("TOPLEFT", checkboxWelcome, "BOTTOMLEFT", 0, -20)
soundSummaryButton:SetText("Sommaire des Sons")
soundSummaryButton:SetScript("OnClick", function()
    if soundSummaryFrame:IsShown() then
        soundSummaryFrame:Hide()
    else
        soundSummaryFrame:Show()
    end
end)
