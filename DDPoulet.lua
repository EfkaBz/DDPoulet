-- Initialisation de la base de données si elle n'existe pas
DDPouletDB = DDPouletDB or {
    showImage = true,
    playSound = true
}
if DDPouletDB.playSound == false then
    return 0
end

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
frame:RegisterEvent("UNIT_HEALTH") -- Ajout de l'événement pour surveiller la santé

local imagePath = "Interface\\AddOns\\DDPoulet\\data\\pics\\DDPoulet.tga" -- Image principale

-- Création de la texture pour afficher l'image
frame.texture = frame:CreateTexture(nil, "BACKGROUND")
frame.texture:SetTexture(imagePath)
frame.texture:SetSize(200, 200)
frame.texture:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
frame.texture:Hide() -- Cache l'image au démarrage

local chickenSounds = {"Interface\\AddOns\\DDPoulet\\data\\sounds\\DDPoulet.mp3",
                       "Interface\\AddOns\\DDPoulet\\data\\sounds\\DDPoulet2.mp3",
                       "Interface\\AddOns\\DDPoulet\\data\\sounds\\DDPoulet3.mp3",
                       "Interface\\AddOns\\DDPoulet\\data\\sounds\\DDPoulet4.mp3"}
local sounds = {
    chicken = "Interface\\AddOns\\DDPoulet\\data\\sounds\\ChickenDeathA.ogg", -- Son du poulet
    moula = "Interface\\AddOns\\DDPoulet\\data\\sounds\\heymoula.mp3",
    hakaza = "Interface\\AddOns\\DDPoulet\\data\\sounds\\hakaza_fourmis.mp3",
    resistar = "Interface\\AddOns\\DDPoulet\\data\\sounds\\resistar1.mp3",
    resistar2 = "Interface\\AddOns\\DDPoulet\\data\\sounds\\resistar_aidezmoi.mp3",
    ika = "Interface\\AddOns\\DDPoulet\\data\\sounds\\tudekaliss.mp3",
    daeler = "Interface\\AddOns\\DDPoulet\\data\\sounds\\daelerback.mp3",
    gg = "Interface\\AddOns\\DDPoulet\\data\\sounds\\tu_vie.mp3"
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

-- Joue un son, c'est tout le temps Master donc autant simplifier
local function PlaySound(path)
    PlaySoundFile(path, "Master")
end

-- Fonction pour jouer un son aléatoire parmi les variantes de chickenSounds
local function PlayRandomChickenSound()
    local randomIndex = math.random(1, #chickenSounds) -- Sélectionne un son aléatoire
    local soundFile = chickenSounds[randomIndex] -- Récupère le chemin du son
    PlayggSound(soundFile) -- Joue le son aléatoire
    print("Erreur : Aucune variante de son disponible !")
end

-- Fonction pour jouer le son "tu_vie" (quand "gg" est détecté)
local function PlayggSound()
    local currentTime = GetTime() -- Récupère le temps actuel en secondes

    -- Vérifie si le cooldown est écoulé
    if currentTime - lastPlayedTime >= cooldownDuration then
        PlaySound(sounds.gg) -- Joue le son "tu_vie.mp3" GG RETIRER DE SOUNDPATH CAR PETE COUILLE IN GAME EN FAIT
        lastPlayedTime = currentTime -- Met à jour le timestamp du dernier jeu
    else

    end
end

-- Fonction pour afficher l'image et jouer les sons
local function ShowImageAndSound()
    frame.texture:Show()
    C_Timer.After(3, function()
        frame.texture:Hide()
    end)
    PlayRandomChickenSound() -- Joue un son aléatoire
    C_Timer.After(2, function()
        PlaySound(sounds.chicken)
    end) -- Joue le son du poulet après 2s
end

-- Variable pour suivre si la santé est sous les 20%
local isBelow20Percent = false

-- Variable pour suivre le dernier moment où le son "tu_vie.mp3" a été joué
local lastPlayedTime = 0
local cooldownDuration = 20 -- Cooldown de 20 secondes

-- Fonction principale pour intercepter les messages de chat et surveiller la santé
local function OnEvent(self, event, ...)
    if event == "UNIT_HEALTH" then
        local unit = ...
        if unit == "player" then
            local health = UnitHealth("player") -- Récupère la santé actuelle du joueur
            local maxHealth = UnitHealthMax("player") -- Récupère la santé maximale du joueur
            local healthPercent = (health / maxHealth) * 100 -- Calcul du pourcentage de vie restante

            if healthPercent <= 20 and not isBelow20Percent then
                -- Si la santé est sous les 20% et que le son n'a pas encore été joué
                PlaySound(sounds.resistar2) -- Joue le son "resistar_aidezmoi.mp3"
                isBelow20Percent = true -- Marque que le son a été joué
            elseif healthPercent > 20 and isBelow20Percent then
                -- Si la santé remonte au-dessus de 20%, réinitialise la variable
                isBelow20Percent = false
            end
        end
    else
        local message, sender = ...
        local soundToPlay = sounds[1]; -- Son du poulet par defaut
        message = message.lower()

        if message:lower():find("doigt de poulet") then -- Vérifie si le message contient "doigt de poulet"
            ShowImageAndSound()
        end
        if message:find("moula") then -- Vérifie si le message contient "moula"
            soundToPlay = sounds.moula
        elseif message:find("hakaza fourmis") then -- Vérifie si le message contient "hakaza fourmis"
            soundToPlay = sounds.hakaza
        elseif message:find("putain") then -- Vérifie si le message contient "putain"
            soundToPlay = sounds.resistar
        elseif message:find("ika") or message:find("ikalyss") then -- Vérifie si le message contient "ika"
            soundToPlay = sounds.ika
        elseif message:find("daeler") then -- Vérifie si le message contient "daeler"
            soundToPlay = sounds.daeler
        elseif message:lower():find("gg") then -- Vérifie si le message contient "gg"
            soundToPlay = sounds.gg
        end
        PlaySound(soundToPlay)
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
    local health = UnitHealth("player") -- Récupère la santé actuelle du joueur
    local maxHealth = UnitHealthMax("player") -- Récupère la santé maximale du joueur
    local healthPercent = (health / maxHealth) * 100 -- Calcul du pourcentage de vie restante

    -- Si la vie est inférieure à 20%, joue le son, sinon force le test
    if healthPercent < 20 then
        PlaySound(sounds.resistar2)
    else
        print("Test forcé : Simule une vie inférieure à 20%.")
        PlaySound(sounds.resistar2)
    end
end
