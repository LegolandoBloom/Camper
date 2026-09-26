local LU = LegolandoUtil
local LM = LU.Map

local addonName, camp = ...
local secureButton = Camper_SendChatMsgSecureActionButton

local pr = camp.pr

local spellTrackerFrame = CreateFrame("Frame")

local function CheckTable(table ,spell)
    local matchFound = false
    for i, value in pairs(table) do
        if spell == value then
            matchFound = true
            break
        end
    end
    return matchFound
end

local campSpellTable = {
    -- Basic Campfire
    1307227,
    -- Journeyman Campfire
    1307252,
    -- Expert Campfire
    1307237,
}

local function spellTracker_Events(self, event, unit, ...)
    if camp.addonLoaded == false then return end
    local arg4, arg5 = ...
    if CamperConfig.checkboxes.spellTester and event == "PLAYER_STOPPED_MOVING" then
        pr:TriggerEvent("Camper_PlayerSetCamp")
    elseif event == "UNIT_SPELLCAST_SUCCEEDED" and not issecretvalue(unit) and unit == "player" then
        if not CheckTable(campSpellTable, arg5) then return end
        pr:TriggerEvent("Camper_PlayerSetCamp")
    end
end

spellTrackerFrame:SetScript("OnEvent", spellTracker_Events)
spellTrackerFrame:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")