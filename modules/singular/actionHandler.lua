local LU = LegolandoUtil
local LM = LU.Map

local DEBUGGING = false
local d = LU.Debug.CreateDebugHandler(DEBUGGING)
local addonName, camp = ...
local pr = camp.pr
pr:RegisterCallback("Camper_Settings_DebugEnabled", function(_, caller)
    d.toggleDebug(true)
end)
pr:RegisterCallback("Camper_Settings_DebugDisabled", function(_, caller)
    d.toggleDebug(false)
end)

local secureButton = Camper_SendChatMsgSecureActionButton

local AFTERSPELL_FOUNDAURA_DELAYER = 15


local delayFrame = CreateFrame("Frame")
local foundDelayActive = false


pr:RegisterCallback("Camper_PlayerSetCamp", function(ownerID)
    secureButton:SetToPlayerSetupCamp()
    foundDelayActive = true
    Camper_SingleDelayer(AFTERSPELL_FOUNDAURA_DELAYER, 0, 1, delayFrame, function(remainingDelay)
        d.print("actionHandler: PlayerSetCamp delay active:", LU.SimplifyFloat(remainingDelay, 0))
    end, function()
        
        foundDelayActive = false
    end)
end)

pr:RegisterCallback("Camper_PlayerFoundCamp", function(ownerID)
    -- Don't accept PlayerFoundCamp triggers for 15 seconds after PlayerSetCamp(So that it doesn't trigger again from own aura)
    -- The Campfire Aura's instanceID will still have been saved in auraTracker, so it won't unnecessarily trigger even after the 15 seconds passes
    if foundDelayActive == true then 
        d.print("actionHandler: STOPPED PlayerFoundCamp from activating due to PlayerSetCamp delay.")    
        return 
    end
    secureButton:SetToPlayerFoundCamp()
end)

