local LU = LegolandoUtil
local LM = LU.Map

local addonName, camp = ...
local secureButton = Camper_SendChatMsgSecureActionButton

local pr = camp.pr

local FOUND_AURA_DELAYER = 


pr:RegisterCallback("Camper_PlayerSetCamp", function(ownerID)
    secureButton:SetToPlayerSetupCamp()
end)

pr:RegisterCallback("Camper_PlayerFoundCamp", function(ownerID)
    print("I FOUND CAMPZ")
    secureButton:SetToPlayerFoundCamp()
end)

