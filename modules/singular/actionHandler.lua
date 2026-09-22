local LU = LegolandoUtil
local LM = LU.Map

local addonName, camp = ...
local secureButton = Camper_SendChatMsgSecureActionButton

local pr = camp.pr


pr:RegisterCallback("Camper_PlayerSetCamp", function(ownerID)
    secureButton:SetToPlayerSetupCamp()
    print("yohohoho")
end)

pr:RegisterCallback("Camper_FoundCampAura", function(ownerID)
    -- secureButton:SetToPlayerFoundCamp()
end)

