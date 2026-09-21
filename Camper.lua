---@diagnostic disable: cast-local-type, param-type-mismatch
local T = Camper_Translate

local LU = LegolandoUtil
local LM = LU.Map

-- 'camp' is the camper namespace
local addonName, camp = ...
local debugChannel = 1
local colorDebug = CreateColor(0.24, 0.76, 1) -- angleur blue

local secureChat = Camper_SendChatMsgSecureActionButton

local eventsFrame = CreateFrame("Frame")



local function camper_Events(self, event, unit, ...)
    if event == "PLAYER_STOPPED_MOVING" then
        local hyperlink = LM:GetCurrentPositionWaypointLink()
        Camper_SendChatMsgSecureActionButton:SetAttribute("macrotext", "/c 1 " .. hyperlink)
    end
end


eventsFrame:SetScript("OnEvent", camper_Events)
eventsFrame:RegisterEvent("PLAYER_STOPPED_MOVING")
