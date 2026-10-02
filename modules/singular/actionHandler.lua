local T = Camper_Translate

local LU = LegolandoUtil
local LM = LU.Map
local LC = LU.Chat

local DEBUGGING = false
local d = LU.Debug.CreateDebugHandler(DEBUGGING)
local addonName, camp = ...
local pr = camp.pr
local cl = camp.clickableLink

pr:RegisterCallback("Camper_Settings_DebugEnabled", function(_, caller)
    d.toggleDebug(true)
end)
pr:RegisterCallback("Camper_Settings_DebugDisabled", function(_, caller)
    d.toggleDebug(false)
end)


local s = {
    message_promptUser = {
        waitingForSitDown_both = T["Camper: Detected Campfire nearby. If you want to share its [Waypoint]: please go towards it, and do /sit."]
    },
    message_activation = {
        setupCamp_button = T["Camper: You've set up camp. Click the \'Camper Button\' to share the Waypoint!"],
        setupCamp_link = T["Camper: You've set up camp."],
        foundCamp_button = T["Camper: Button Activated. Click to share the camp Waypoint!"],
        foundCamp_link = T["Camper: Camp successfully located!"],
    },
    message_send = {
        setupCamp = T["[Camper]: I've set up camp here!"], 
        foundCamp = T["[Camper]: I found a camp here!"],
        clickWarning = T["Camper: Please locate the campfire and do /sit before sharing."],
    },
    tooltipTitle = {
        waitingForSitDown = T["Waiting for /sit"],
        sendToGeneralChat = T["Click to send to General Chat: "],
        sendToSay = T["[Debug] Click to say: "],
    },
    tooltip = {
        waitingForSitDown = T["You need to sit down next to the camp for Camper to get its proper waypoint.\nPlease locate the campfire and do /sit."],
    }
}



local secureButton = Camper_SendChatMsgSecureActionButton

local AFTERSPELL_FOUNDAURA_DELAYER = 15


local delayFrame = CreateFrame("Frame")
local foundDelayActive = false
local waitingForSitDown = false

local enum_shareMethod = {
    ClickableLink = 1,
    PopupButton = 2,
}

-- NOTE: Not doing "shareMethod" checks on Cancel_PromptUser - it's always good to clear pending things regardless which one is currently actively being used as a general programming principle
-- __________________________________________________________________ Setup Camp __________________________________________________________________
pr:RegisterCallback("Camper_PlayerSetCamp", function(ownerID)
    local shareMethod = CamperConfig.dropdownMenus.shareMethod
    if waitingForSitDown then 
        secureButton:Cancel_PromptUser()
        cl:Cancel_PromptUser()
    end
    local generalChat_index = LC:GetChatChannelIndexFromName(COMMUNITIES_DEFAULT_CHANNEL_NAME)
    local waypoint = LM:GetCurrentPositionWaypointLink()
    if shareMethod == enum_shareMethod["ClickableLink"] then
        cl:SetToSendMessageToChannelIndex(s.message_activation.setupCamp_link, generalChat_index, s.message_send.setupCamp .. waypoint, s.tooltipTitle.sendToGeneralChat, s.message_send.setupCamp)
    elseif shareMethod == enum_shareMethod["PopupButton"] then
        secureButton:SetToSendMessageToChannelIndex(s.message_activation.setupCamp_button, generalChat_index, s.message_send.setupCamp .. waypoint, s.tooltipTitle.sendToGeneralChat, s.message_send.setupCamp)
    end
    foundDelayActive = true
    --__ Debug ___
    Camper_ActionSimulator:TogglePlayerSetupCampDelay(true)
    --____________
    waitingForSitDown = false
    Camper_SingleDelayer(AFTERSPELL_FOUNDAURA_DELAYER, 0, 1, delayFrame, function(remainingDelay)
        d.print("actionHandler: PlayerSetCamp delay active:", LU.SimplifyFloat(remainingDelay, 0))
    end, function()
        foundDelayActive = false
        --__ Debug ___
        Camper_ActionSimulator:TogglePlayerSetupCampDelay(false)
        --____________
    end)
end)
-- ________________________________________________________________________________________________________________________________________________


-- __________________________________________________________________ Found Camp __________________________________________________________________
pr:RegisterCallback("Camper_PlayerNOTFoundCamp", function(ownerID)
    if not waitingForSitDown then return end
    d.print("Camper_PlayerNOTFoundCamp")
    waitingForSitDown = false
    secureButton:Cancel_PromptUser()
    cl:Cancel_PromptUser()
end)

pr:RegisterCallback("Camper_PlayerFoundCamp", function(ownerID)
    local shareMethod = CamperConfig.dropdownMenus.shareMethod
    -- Don't accept PlayerFoundCamp triggers for 15 seconds after PlayerSetCamp(So that it doesn't trigger again from own aura)
    -- The Campfire Aura's instanceID will still have been saved in auraTracker, so it won't unnecessarily trigger even after the 15 seconds passes
    if foundDelayActive == true then 
        d.print("actionHandler: STOPPED PlayerFoundCamp from activating due to PlayerSetCamp delay.")    
        return
    end
    if waitingForSitDown then 
        secureButton:Cancel_PromptUser()
        cl:Cancel_PromptUser()
    end
    d.print("Camper_PlayerFoundCamp")
    waitingForSitDown = true
    if shareMethod == enum_shareMethod["ClickableLink"] then
        cl:Start_PromptUser(s.message_promptUser.waitingForSitDown_both, s.tooltipTitle.waitingForSitDown, s.tooltip.waitingForSitDown, s.message_send.clickWarning)
    elseif shareMethod == enum_shareMethod["PopupButton"] then
        secureButton:Start_PromptUser(s.message_promptUser.waitingForSitDown_both, s.tooltipTitle.waitingForSitDown, s.tooltip.waitingForSitDown, s.message_send.clickWarning)
    end
end)

pr:RegisterCallback("Camper_PlayerSit", function(ownerID)
    local shareMethod = CamperConfig.dropdownMenus.shareMethod
    if not waitingForSitDown then return end
    if waitingForSitDown then 
        secureButton:Cancel_PromptUser()
        cl:Cancel_PromptUser()
    end
    waitingForSitDown = false
    local generalChat_index = LC:GetChatChannelIndexFromName(COMMUNITIES_DEFAULT_CHANNEL_NAME)
    local waypoint = LM:GetCurrentPositionWaypointLink()
    if shareMethod == enum_shareMethod["ClickableLink"] then
        cl:SetToSendMessageToChannelIndex(s.message_activation.foundCamp_link, generalChat_index, s.message_send.foundCamp .. waypoint, s.tooltipTitle.sendToGeneralChat, s.message_send.foundCamp)
    elseif shareMethod == enum_shareMethod["PopupButton"] then
        secureButton:SetToSendMessageToChannelIndex(s.message_activation.foundCamp_button, generalChat_index, s.message_send.foundCamp .. waypoint, s.tooltipTitle.sendToGeneralChat, s.message_send.foundCamp)
    end
    
end)
-- ________________________________________________________________________________________________________________________________________________

