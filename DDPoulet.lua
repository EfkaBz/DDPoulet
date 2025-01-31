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
local imagePath = "Interface\\AddOns\\DDPoulet\\data\\DDPoulet.tga"  -- Image principale
local soundPaths1 = {  
    "Interface\\AddOns\\DDPoulet\\data\\DDPoulet.mp3",
    "Interface\\AddOns\\DDPoulet\\data\\DDPoulet2.mp3",
    "Interface\\AddOns\\DDPoulet\\data\\DDPoulet3.mp3",
    "Interface\\AddOns\\DDPoulet\\data\\DDPoulet4.mp3"
}
local soundPath2 = "Interface\\AddOns\\DDPoulet\\data\\ChickenDeathA.ogg"  -- Son du poulet
local soundPathMoula = "Interface\\AddOns\\DDPoulet\\data\\heymoula.mp3"  -- Nouveau son pour "moula"
local soundPathHakaza = "Interface\\AddOns\\DDPoulet\\data\\hakaza_fourmis.mp3"  -- Nouveau son pour "hakaza fourmis"
local soundPathResistar = "Interface\\AddOns\\DDPoulet\\data\\resistar1.mp3"
local soundPathResistar2 = "Interface\\AddOns\\DDPoulet\\data\\resistar_aidezmoi.mp3"

-- Fonction pour jouer un son aléatoire parmi les variantes de soundPaths1
local function PlayRandomChickenSound()
    if #soundPaths1 > 0 then
        local randomIndex = math.random(1, #soundPaths1)  -- Sélectionne un son aléatoire
        local soundFile = soundPaths1[randomIndex]  -- Récupère le chemin du son
        
        if soundFile then
            PlaySoundFile(soundFile, "Master")  -- Joue le son aléatoire
        else
            print("Erreur : Aucun fichier son trouvé !")
        end
    else
        print("Erreur : Aucune variante de son disponible !")
    end
end

-- Fonction pour jouer le son "moula"
local function PlayMoulaSound()
    PlaySoundFile(soundPathMoula, "Master")  -- Joue le son "moula"
end

-- Fonction pour jouer le son "hakaza fourmis"
local function PlayHakazaSound()
    PlaySoundFile(soundPathHakaza, "Master")  -- Joue le son "hakaza_fourmis"
end

-- Fonction pour jouer le son "resistar aidez moi"
local function PlayResistarSound()
    PlaySoundFile(soundPathResistar2, "Master")  -- Joue le son "resistar_aidezmoi"
end

-- Fonction pour jouer le son "resistar1" (quand "putain" est détecté)
local function PlayResistar1Sound()
    PlaySoundFile(soundPathResistar, "Master")  -- Joue le son "resistar1.mp3"
end

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
        PlayRandomChickenSound()  -- Joue un son aléatoire
        C_Timer.After(2, function() PlaySoundFile(soundPath2, "Master") end)  -- Joue le son du poulet après 2s
    end
end

-- Fonction principale pour intercepter les messages de chat
local function OnEvent(self, event, message, sender, ...)
    if message:lower():find("doigt de poulet") then  -- Vérifie si le message contient "doigt de poulet"
        ShowImageAndSound()
    elseif message:lower():find("moula") then  -- Vérifie si le message contient "moula"
        if DDPouletDB.playSound then
            PlayMoulaSound()  -- Joue le son "moula"
        end
    elseif message:lower():find("hakaza fourmis") then  -- Vérifie si le message contient "hakaza fourmis"
        if DDPouletDB.playSound then
            PlayHakazaSound()  -- Joue le son "hakaza fourmis"
        end
    elseif message:lower():find("putain") then  -- Vérifie si le message contient "putain"
        if DDPouletDB.playSound then
            PlayResistar1Sound()  -- Joue le son "resistar1.mp3"
        end
    end
end

frame:SetScript("OnEvent", OnEvent)

-- Débogage rapide : test manuel avec /ddptest
SLASH_DDPTEST1 = "/ddptest"
SlashCmdList["DDPTEST"] = function()
    ShowImageAndSound()
end

-- Test de "resistar aidez moi" avec /ddpResistarTest
SLASH_DDPRESISTARTEST1 = "/ddpResistarTest"
SlashCmdList["DDPRESISTARTEST"] = function()
    -- Simule une vie inférieure à 20% pour tester le son
    local health = UnitHealth("player")  -- Récupère la santé actuelle du joueur
    local maxHealth = UnitHealthMax("player")  -- Récupère la santé maximale du joueur
    local healthPercent = (health / maxHealth) * 100  -- Calcul du pourcentage de vie restante

    -- Si la vie est inférieure à 20%, joue le son, sinon force le test
    if healthPercent < 20 then
        PlaySoundFile(soundPathResistar2, "Master")
    else
        print("Test forcé : Simule une vie inférieure à 20%.")
        PlaySoundFile(soundPathResistar2, "Master")  -- Joue le son "resistar_aidezmoi.mp3"
    end
end
