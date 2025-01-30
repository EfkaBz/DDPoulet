-- Crée un cadre pour enregistrer les événements
local frame = CreateFrame("Frame")
frame:RegisterEvent("CHAT_MSG_SAY")
frame:RegisterEvent("CHAT_MSG_YELL")
frame:RegisterEvent("CHAT_MSG_GUILD")
frame:RegisterEvent("CHAT_MSG_PARTY")
frame:RegisterEvent("CHAT_MSG_PARTY_LEADER")
frame:RegisterEvent("CHAT_MSG_RAID")
frame:RegisterEvent("CHAT_MSG_RAID_LEADER")
frame:RegisterEvent("CHAT_MSG_WHISPER")
frame:RegisterEvent("CHAT_MSG_CHANNEL")

-- Chemins vers l'image et les sons
local imagePath = "Interface\\AddOns\\DDPoulet\\data\\DDPoulet.tga"  -- Chemin de l'image
local soundPath1 = "Interface\\AddOns\\DDPoulet\\data\\DDPoulet.mp3"  -- Son personnalisé
local soundPath2 = "Interface\\AddOns\\DDPoulet\\data\\ChickenDeathA.ogg"  -- Son du poulet

-- Initialisation de la base de données si elle n'existe pas
DDPouletDB = DDPouletDB or { showImage = true, playSound = true }

-- Création de la texture pour afficher l'image
frame.texture = frame:CreateTexture(nil, "BACKGROUND")
frame.texture:SetTexture(imagePath)
frame.texture:SetSize(200, 200)
frame.texture:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
frame.texture:Hide()  -- Cache l'image au démarrage

-- Fonction pour afficher l'image et jouer les sons
local function ShowImageAndSound()
    if DDPouletDB.showImage then
        frame.texture:Show()
        C_Timer.After(3, function() frame.texture:Hide() end)
    end

    if DDPouletDB.playSound then
        PlaySoundFile(soundPath1, "Master")
        C_Timer.After(2, function() PlaySoundFile(soundPath2, "Master") end)
    end
end

-- Fonction principale pour intercepter les messages de chat
local function OnEvent(self, event, message, sender, ...)
    if message:lower():find("doigt de poulet") then  -- Vérifie si le message contient "doigt de poulet"
        ShowImageAndSound()
    end
end

frame:SetScript("OnEvent", OnEvent)