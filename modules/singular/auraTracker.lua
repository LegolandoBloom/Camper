local LU = LegolandoUtil
local LM = LU.Map
local LSpell = LU.Spell

local addonName, camp = ...
local secureButton = Camper_SendChatMsgSecureActionButton

local pr = camp.pr

local auraTrckerFrame = CreateFrame("Frame")

local CAMPAURA_SPELLID = 1283391 -- "Campfire Nearby"

local testing = true
local function spellTracker_Events(self, event, unit, ...)
    if camp.addonLoaded == false then return end
    local arg4, arg5 = ...
    if testing and event == "PLAYER_STOPPED_MOVING" then
        
    elseif event == "UNIT_AURA" and not issecretvalue(unit) and unit == "player" then
        local auraData = LSpell:GetNonSecretActiveAuraDataFromSpell(CAMPAURA_SPELLID)
        -- DevTools_Dump(auraData)
        if auraData then
            pr:TriggerEvent("Camper_PlayerFoundCamp")
        end
    end
end

auraTrckerFrame:SetScript("OnEvent", spellTracker_Events)
auraTrckerFrame:RegisterEvent("PLAYER_STOPPED_MOVING")
auraTrckerFrame:RegisterEvent("UNIT_AURA")