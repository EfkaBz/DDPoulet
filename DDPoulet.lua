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
frame:RegisterEvent("UNIT_HEALTH")  -- Ajout de l'événement pour surveiller la santé

-- Chemins vers l'image et les sons
-- Reprendre les paths
local imagePath = "Interface\\AddOns\\DDPoulet\\data\\pics\\DDPoulet.tga"  -- Image principale
local soundPaths1 = {  
    "Interface\\AddOns\\DDPoulet\\data\\sounds\\DDPoulet.mp3",
    "Interface\\AddOns\\DDPoulet\\data\\sounds\\DDPoulet2.mp3",
    "Interface\\AddOns\\DDPoulet\\data\\sounds\\DDPoulet3.mp3",
    "Interface\\AddOns\\DDPoulet\\data\\sounds\\DDPoulet4.mp3"
}

local sounds = {
    chicken = "Interface\\AddOns\\DDPoulet\\data\\sounds\\ChickenDeathA.ogg" , -- Son du poulet
    moula = "Interface\\AddOns\\DDPoulet\\data\\sounds\\heymoula.mp3",
    hakaza = "Interface\\AddOns\\DDPoulet\\data\\sounds\\hakaza_fourmis.mp3",
    resistar = "Interface\\AddOns\\DDPoulet\\data\\sounds\\resistar1.mp3",
    resistar2 = "Interface\\AddOns\\DDPoulet\\data\\sounds\\resistar_aidezmoi.mp3",
    ika = "Interface\\AddOns\\DDPoulet\\data\\sounds\\tudekaliss.mp3",
    daeler = "Interface\\AddOns\\DDPoulet\\data\\sounds\\daelerback.mp3",
    gg = "Interface\\AddOns\\DDPoulet\\data\\sounds\\tu_vie.mp3",
}
-- Récupère le nom des sons
local names = {}
for k in pairs(sounds) do
  print(k)
    table.insert(names, k)
end

-- Récupère le chemin des sons
for _, n in ipairs(names) do
    print(sounds[n])
end

local function PlaySound(path)
    PlaySoundFile(path, "Master")
end


-- Variable pour suivre si la santé est sous les 20%
local isBelow20Percent = false

-- Variable pour suivre le dernier moment où le son "tu_vie.mp3" a été joué
local lastPlayedTime = 0
local cooldownDuration = 20  -- Cooldown de 20 secondes

-- Fonction pour jouer un son aléatoire parmi les variantes de soundPaths1
local function PlayRandomChickenSound()
    if #soundPaths1 > 0 then
        local randomIndex = math.random(1, #soundPaths1)  -- Sélectionne un son aléatoire
        local soundFile = soundPaths1[randomIndex]  -- Récupère le chemin du son
        
        if soundFile then
            PlayggSound(soundFile)  -- Joue le son aléatoire
        else
            print("Erreur : Aucun fichier son trouvé !")
        end
    else
        print("Erreur : Aucune variante de son disponible !")
    end
end
-- Fonction pour jouer le son "tu_vie" (quand "gg" est détecté)
local function PlayggSound()
    local currentTime = GetTime()  -- Récupère le temps actuel en secondes

    -- Vérifie si le cooldown est écoulé
    if currentTime - lastPlayedTime >= cooldownDuration then
        PlaySoundFile(soundPath, "Master")  -- Joue le son "tu_vie.mp3" GG RETIRER DE SOUNDPATH CAR PETE COUILLE IN GAME EN FAIT
        lastPlayedTime = currentTime  -- Met à jour le timestamp du dernier jeu
    else
        
    end
end

-- Initialisation de la base de données si elle n'existe pas
DDPouletDB = DDPouletDB or { showImage = true, playSound = true }
if DDPouletDB.playSound == false then return 0
    
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
        C_Timer.After(2, function() PlaySound(soundPath2) end)  -- Joue le son du poulet après 2s
    end
end

-- Fonction principale pour intercepter les messages de chat et surveiller la santé
local function OnEvent(self, event, ...)
    if DDPouletDB.playSound == false end
    if event == "UNIT_HEALTH" then
        local unit = ...
        if unit == "player" then
            local health = UnitHealth("player")  -- Récupère la santé actuelle du joueur
            local maxHealth = UnitHealthMax("player")  -- Récupère la santé maximale du joueur
            local healthPercent = (health / maxHealth) * 100  -- Calcul du pourcentage de vie restante

            if healthPercent <= 20 and not isBelow20Percent then
                -- Si la santé est sous les 20% et que le son n'a pas encore été joué
                PlaySound("resistar2")  -- Joue le son "resistar_aidezmoi.mp3"
                isBelow20Percent = true  -- Marque que le son a été joué
            elseif healthPercent > 20 and isBelow20Percent then
                -- Si la santé remonte au-dessus de 20%, réinitialise la variable
                isBelow20Percent = false
            end
        end
    else
        local message, sender = ...
        if message:lower():find("doigt de poulet") then  -- Vérifie si le message contient "doigt de poulet"
            ShowImageAndSound()
        elseif sounds[message] == false end
        else PlaySound(message) end
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
        PlaySound(soundPathResistar2)
    else
        print("Test forcé : Simule une vie inférieure à 20%.")
        PlaySound(soundPathResistar2)
    end
end