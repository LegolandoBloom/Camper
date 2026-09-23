local LU = LegolandoUtil
local LM = LU.Map
local LSpell = LU.Spell

local addonName, camp = ...
local secureButton = Camper_SendChatMsgSecureActionButton

local pr = camp.pr

local auraTrckerFrame = CreateFrame("Frame")

local CAMPAURA_SPELLID = 1283391 -- "Campfire Nearby"
CAMPAURA_SPELLID = 20580 -- Shadowmeld (for testing)

local trackedInstanceIDs = {

}

local function queryCampAuraFromSpellIDAndUpdateTracked()
    local auraData = LSpell:GetNonSecretActiveAuraDataFromSpell(CAMPAURA_SPELLID)
    if not auraData then 
        trackedInstanceIDs[CAMPAURA_SPELLID] = nil
        return
    end
    local campAuraInstanceID = auraData.auraInstanceID
    if trackedInstanceIDs[CAMPAURA_SPELLID] == nil or trackedInstanceIDs[CAMPAURA_SPELLID] ~= campAuraInstanceID then
        trackedInstanceIDs[CAMPAURA_SPELLID] = campAuraInstanceID
        pr:TriggerEvent("Camper_PlayerFoundCamp")
        print("Have I though")
    end
end

local function auraTracker_Events(self, event, unit, ...)
    if camp.addonLoaded == false then return end
    local arg4, arg5 = ...
    if CamperConfig.checkboxes.testerMode and event == "PLAYER_STOPPED_TURNING" then
        pr:TriggerEvent("Camper_PlayerFoundCamp")
    elseif event == "UNIT_AURA" and not issecretvalue(unit) and unit == "player" then
        queryCampAuraFromSpellIDAndUpdateTracked()
    end
end

auraTrckerFrame:SetScript("OnEvent", auraTracker_Events)
auraTrckerFrame:RegisterEvent("PLAYER_STOPPED_TURNING")
auraTrckerFrame:RegisterEvent("UNIT_AURA")