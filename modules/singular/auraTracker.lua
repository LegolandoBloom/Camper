local LU = LegolandoUtil
local LM = LU.Map
local LSpell = LU.Spell

local addonName, camp = ...
local secureButton = Camper_SendChatMsgSecureActionButton

local pr = camp.pr

local auraTrckerFrame = CreateFrame("Frame")


--__________________________________________________ DEBUG __________________________________________________
local TESTAURA_SPELLID = 1966 -- Feint
local trackedInstanceIDs_TEST = {}
local function _handleSpellTester()
    if not CamperDebug.checkboxes.spellTester then return end 
    local auraData = LSpell:GetNonSecretActiveAuraDataFromSpell(TESTAURA_SPELLID)
    if not auraData then 
        trackedInstanceIDs_TEST[TESTAURA_SPELLID] = nil
        pr:TriggerEvent("Camper_PlayerNOTFoundCamp")
        return
    end
    local campAuraInstanceID = auraData.auraInstanceID
    if trackedInstanceIDs_TEST[TESTAURA_SPELLID] == nil or trackedInstanceIDs_TEST[TESTAURA_SPELLID] ~= campAuraInstanceID then
        trackedInstanceIDs_TEST[TESTAURA_SPELLID] = campAuraInstanceID
        pr:TriggerEvent("Camper_PlayerFoundCamp")
    end
end
--___________________________________________________________________________________________________________



local CAMPAURA_SPELLID = 1283391 -- "Campfire Nearby"
-- CAMPAURA_SPELLID = 20580 -- Shadowmeld (for testing)

local trackedInstanceIDs = {

}

local function queryCampAuraFromSpellIDAndUpdateTracked()
    local auraData = LSpell:GetNonSecretActiveAuraDataFromSpell(CAMPAURA_SPELLID)
    if not auraData then 
        trackedInstanceIDs[CAMPAURA_SPELLID] = nil
        pr:TriggerEvent("Camper_PlayerNOTFoundCamp")
        return
    end
    local campAuraInstanceID = auraData.auraInstanceID
    if trackedInstanceIDs[CAMPAURA_SPELLID] == nil or trackedInstanceIDs[CAMPAURA_SPELLID] ~= campAuraInstanceID then
        trackedInstanceIDs[CAMPAURA_SPELLID] = campAuraInstanceID
        pr:TriggerEvent("Camper_PlayerFoundCamp")
    end
end

local function auraTracker_Events(self, event, unit, ...)
    if camp.addonLoaded == false then return end
    local arg4, arg5 = ...
    if event == "UNIT_AURA" and not issecretvalue(unit) and unit == "player" then
        queryCampAuraFromSpellIDAndUpdateTracked()
        --______________________________ DEBUG ______________________________
        -- Needs to be called after queryCampAuraFromSpellIDAndUpdateTracked
        _handleSpellTester()
        --___________________________________________________________________
    end
end

auraTrckerFrame:SetScript("OnEvent", auraTracker_Events)
auraTrckerFrame:RegisterEvent("UNIT_AURA")