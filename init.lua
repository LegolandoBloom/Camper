local T = Camper_Translate

local colorYello = CreateColor(1.0, 0.82, 0.0)
local colorBlu = CreateColor(0.61, 0.85, 0.92)
local colorGreen = CreateColor(0, 1, 0)

-- 'camp' is the camper namespace
local addonName, camp = ...

camp.addonLoaded = false


camp.pr = CreateFromMixins(CallbackRegistryMixin)
camp.pr:OnLoad()
camp.pr:SetUndefinedEventsAllowed(true)
local pr = camp.pr

camperDelayers = CreateFramePool("Frame", camperDelayers, nil, function(framePool, frame)
    frame:ClearAllPoints()
    frame:SetScript("OnUpdate", nil)
    frame:Hide()
end)

Camper_ReusablePictureTooltip = CreateFrame("GameTooltip", "Camper_ReusablePictureTooltip", UIParent, "Legolando_PictureTooltipTemplate_Camper")
Camper_ReusableFrameAnchorableTooltip = CreateFrame("GameTooltip", "Camper_ReusableFrameAnchorTooltip", UIParent, "Legolando_FrameAnchorableTooltipTemplate_Camper")


CamperConfig = {
    
}
CamperCharacter = {

}

CamperAudio = {

}

CamperUI = {

}



-- ____________________________________________________________________________________________

function Init_CamperSavedVariables()
    if CamperConfig == nil then CamperConfig = {} end
    if CamperConfig.checkboxes == nil then CamperConfig.checkboxes = {} end
    if CamperConfig.editBoxes == nil then CamperConfig.editBoxes = {} end
    if CamperConfig.editBoxes.hideAfter == nil then CamperConfig.editBoxes.hideAfter = 16 end

    if CamperCharacter == nil then CamperCharacter = {} end
    if CamperAudio == nil then CamperAudio = {} end
    if CamperUI == nil then CamperUI = {} end

        -- CamperMinimapButton
    if CamperMinimapButton == nil then
        CamperMinimapButton = {}
    end
    if CamperMinimapButton.show == nil then
        CamperMinimapButton.show = true
    end

    Camper_SendChatMsgSecureActionButton.savedVarTable = CamperConfig.editBoxes
    Camper_SendChatMsgSecureActionButton.reference = "hideAfter"
    Camper_SendChatMsgSecureActionButton:Init()
end

-- ___ temporary measure for the Forever Branch ___
local WOW_PROJECT_MAINLINE = 69
local WOW_PROJECT_FOREVER = 1
-- ________________________________________________

-- 1 : Retail | 2 : MoP(Or Cata) | 3 : Vanilla | 4 : Forever | (0: None, fail)
function Camper_CheckVersion()
    if WOW_PROJECT_ID == WOW_PROJECT_MAINLINE then
        if LE_EXPANSION_LEVEL_CURRENT == LE_EXPANSION_MIDNIGHT then
            return 1
        elseif LE_EXPANSION_LEVEL_CURRENT == LE_EXPANSION_CLASSIC then
            return 4
        end
    elseif WOW_PROJECT_ID == WOW_PROJECT_CATACLYSM_CLASSIC or WOW_PROJECT_ID == 19 then
        return 2
    elseif WOW_PROJECT_ID == WOW_PROJECT_CLASSIC or WOW_PROJECT_ID == WOW_PROJECT_BURNING_CRUSADE_CLASSIC then
        return 3
    end
    return 0
end
camp.gameVersion = Camper_CheckVersion()

-- USE TO CHECK VERSIONS
-- /run print(WOW_PROJECT_ID == WOW_PROJECT_MAINLINE and "Retail" 
-- or WOW_PROJECT_ID == WOW_PROJECT_CATACLYSM_CLASSIC and "Cata"
-- or WOW_PROJECT_ID == WOW_PROJECT_CLASSIC and "Vanilla" or "I don't know")


function Camper_SingleDelayer(delay, timeElapsed, elapsedThreshhold, delayFrame, cycleFunk, endFunk)
    delayFrame:SetScript("OnUpdate", function(self, elapsed)
        timeElapsed = timeElapsed + elapsed
        if timeElapsed > elapsedThreshhold then
            delay = delay - timeElapsed
            timeElapsed = 0
            if cycleFunk then
                if cycleFunk(delay) == true then
                    -- If cycleFunk returns true the delayer is stopped, and the script set to nil. endFunk is not executed..
                    self:SetScript("OnUpdate", nil)
                    return
                end
            end
        end
        
        if delay <= 0 then
            self:SetScript("OnUpdate", nil)
            if endFunk then endFunk() end
            return
        end
    end)
end

CamperCombatDelayFrame = CreateFrame("Frame")
CamperCombatDelayFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
CamperFunctionsQueueTable = {}
function Camper_CombatDelayer(funk)
    if InCombatLockdown() then
        --print("triggered")
        table.insert(CamperFunctionsQueueTable, funk)
        CamperCombatDelayFrame:SetScript("OnEvent", function()
            for i, funktion in pairs(CamperFunctionsQueueTable) do
                funktion()
                --print("executed: ", funktion)
            end
            CamperFunctionsQueueTable = {}
            CamperCombatDelayFrame:SetScript("OnEvent", nil)
        end)
    else
        funk()
    end
end

function Camper_PoolDelayer(delay, timeElapsed, elapsedThreshhold, delayFramePool, cycleFunk, endFunk, uniqueIdentifier)
    -- ______________________________________________________________________________________________________
    -- ____________________________________ (Optional) OVERRIDE SYSTEM ______________________________________
    -- ______________________________________________________________________________________________________
    -- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ unique Identifier --> optional argument ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    -- If optional argument is provided, there will only be a SINGLE INSTANCEe of that type of delayer
    -- running at one time, and any calls of Camper_PoolDelayer with that specific 'uniqueIdentifier' 
    -- argument will release the one beforehand, overriding it.
    -- ______________________________________________________________________________________________________
    if uniqueIdentifier then
        for poolFrame in delayFramePool:EnumerateActive() do
            if poolFrame.uniqueIdentifier and poolFrame.uniqueIdentifier == uniqueIdentifier then
                -- print("overriding same type delayer", uniqueIdentifier)
                delayFramePool:Release(poolFrame)
            end
        end
    end
    local delayFrame = delayFramePool:Acquire()
    delayFrame.uniqueIdentifier = uniqueIdentifier
    delayFrame:Show()
    delayFrame:SetScript("OnUpdate", function(self, elapsed)
        timeElapsed = timeElapsed + elapsed
        if timeElapsed > elapsedThreshhold then 
            if cycleFunk then 
                if cycleFunk() == true then
                    delayFramePool:Release(self)
                    return
                end
            end
            delay = delay - timeElapsed
            timeElapsed = 0
        end
        if delay <= 0 then
            if endFunk then endFunk() end
            delayFramePool:Release(self)
            return
        end
    end)
    -- Keep this part commented
    -- local count = 0
    -- local uniques = {}
    -- local uniqCount = 0
    -- for delayFrame in delayFramePool:EnumerateActive() do
    --     count = count + 1
    --     local uniqID = delayFrame.uniqueIdentifier
    --     if uniqID then
    --         for i, v in pairs(uniques) do
    --             if v == uniqID then
    --                 print("ERROR: More than one widget with the same unique identifier detected. This isn't supposed to happen.")
    --                 return
    --             end
    --         end
    --         table.insert(uniques, uniqID)
    --         uniqCount = uniqCount + 1
    --     end
    -- end
    -- print("Total number of widgets: ", count)
    -- print("Widgets with different uniqueIdentifiers: ", uniqCount)
    -- print("Table of active unique identifiers:")
    -- DevTools_Dump(uniques)
end


--**************************[1]****************************
--**           Loading & Unloading of Camper            **
--**************************[1]****************************
function Camper_OnLoad(self)
    self:RegisterEvent("ADDON_LOADED")
    self:RegisterEvent("PLAYER_ENTERING_WORLD")
    self:RegisterEvent("PLAYER_LOGOUT")
    self:RegisterEvent("ADDONS_UNLOADING")
    self:RegisterEvent("PLAYER_STARTED_MOVING")
    self:RegisterEvent("PLAYER_REGEN_DISABLED")
    self:RegisterEvent("PLAYER_DEAD")
    self:RegisterEvent("PLAYER_REGEN_ENABLED")
    self:SetScript("OnEvent", Camper_EventLoader)
end


local function _onLogin()
 
end
local function _onReload()

end




local function _load_not_retail()
    if camp.gameVersion == 1 then return end
end

local function _load_retail()
    if camp.gameVersion ~= 1 then return end
end
local function _load_mists()
    if camp.gameVersion ~= 2 then return end
end

-- Commented for now
-- Camper_TempCVars = {

-- }
-- Camper_TempCVarHandler = CreateFrame("Frame", "Camper_CVarHandler", UIParent, "Legolando_TempCVarHandlerTemplate_Camper")
-- Camper_TempCVarHandler.tempCVarsTable = Camper_TempCVars
-- Camper_TempCVarHandler:Init()

local function _cvars_load()

end


local firstMove = true
local helpTipCloseText = "|cnHIGHLIGHT_FONT_COLOR:The |r|cnNORMAL_FONT_COLOR:Interact Key|r|cnHIGHLIGHT_FONT_COLOR: allows you to interact with NPCs and objects using a keypress|n|n|r|cnRED_FONT_COLOR:Assign an Interact Key binding under Control options|r"
function Camper_EventLoader(self, event, unit, ...)
    local arg4, arg5 = ...
    if event == "ADDON_LOADED" and unit == "Camper" then
        Init_CamperSavedVariables()
        camp.addonLoaded = true
        Camper_SetupConfigPanel()

        Camper_InitDebugMenuSavedVars()
        Camper_InitClickableLink()
        Camper_SetupDebugMenu()
    elseif event == "PLAYER_ENTERING_WORLD" then
        -- return if zone change
        if unit == false and arg4 == false then return end
        if unit == true then
            _onLogin()
        elseif arg4 == true then
            _onReload()
        end
        -- ___ Version based load functions ___
        _load_retail()
        _load_not_retail()
        _load_mists()
        _cvars_load()
        -- ____________________________________
        if CamperMinimapButton.show then
            Camper_InitMinimapButton()
        end
        Camper_LoadAddonsTab()
        Camper_FirstInstall()
    elseif event == "PLAYER_LOGOUT" then
        Camper_Unload()
    elseif event == "PLAYER_REGEN_DISABLED" then

    elseif event == "PLAYER_DEAD" then

    elseif event == "PLAYER_REGEN_ENABLED" then
    elseif event == "PLAYER_STARTED_MOVING" then
        if camp.gameVersion ~= 1 then return end
        if InCombatLockdown() then return end
        if firstMove == true and CamperCharacter.sleeping == false then
            firstMove = false
        end
    end
end

function Camper_Unload()
    -- Camper_TempCVarHandler:ReleaseAll()
end