local LU = LegolandoUtil
local LM = LU.Map
local LC = LU.Chat
local LSec = LU.Secret


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


local T = Camper_Translate


Camper_SendChatMsgSecureActionButtonMixin = {}

local initiated = false
function Camper_SendChatMsgSecureActionButtonMixin:Init()
    local teeburu = self.savedVarTable
    local reference = self.reference
    if not teeburu or not reference then
        print("no saved variable or reference")
        return
    end
    -- no need to save teeburu[reference] as a value, we'll need it to be dynamic
    d.tableToString(teeburu)

    initiated = true
    self.tooltipTitle = T["Click to send to General Chat: "]
end

function Camper_SendChatMsgSecureActionButtonMixin:OnLoad()
    self.icon:SetSize(48, 48)
    self.icon:SetTexture("Interface/AddOns/Camper/images/campericon.png")
    self.title:SetText(T["Announce Camp!"])
    

    self:SetAttribute("type", "macro")
    self:RegisterForClicks("AnyDown", "AnyUp")

    self:SetMovable(true)
    self:RegisterForDrag("LeftButton")

    self:RegisterEvent("PLAYER_REGEN_DISABLED")
    self:RegisterEvent("PLAYER_REGEN_ENABLED")
end

function Camper_SendChatMsgSecureActionButtonMixin:ActivateWithAttributes()
    d.print("ActivateWithAttributes called")
    if not initiated then return end
    if not self.macroTextBuffer then return end
    if InCombatLockdown() then return end
    self:SetAttribute("macrotext", self.macroTextBuffer)
    self.macroTextBuffer = nil
    self.tooltipText = self.tooltipTextBuffer
    self.tooltipTextBuffer = nil
    self:Show()
    self:StartHideDelayer()
end
function Camper_SendChatMsgSecureActionButtonMixin:ClearAttributes()
    if not initiated then return end
    self:SetAttribute("macrotext", "")
    self.tooltipText = nil
end

local macroSoundEffectLine = "/script PlaySound(5274)"
local macroCloseFrameLine = "/script Camper_SendChatMsgSecureActionButton:MacroSuccessful()"

-- _____________________________________ Setup Camp _____________________________________
local playerSetUpCampMessage = T["[Camper]: I've set up camp here!"]
local testing = true
function Camper_SendChatMsgSecureActionButtonMixin:SetToPlayerSetupCamp()
    d.print("SetToPlayerSetupCamp called")
    if not initiated then return end
    local hyperlink = LM:GetCurrentPositionWaypointLink()
    if not hyperlink then return end
    local generalChat_index = LC:GetChatChannelIndexFromName(COMMUNITIES_DEFAULT_CHANNEL_NAME)
    local macroText = "/c " .. generalChat_index .. " " ..  playerSetUpCampMessage .. " " .. hyperlink .. "\n" .. macroSoundEffectLine .. "\n" .. macroCloseFrameLine
    if CamperDebug.checkboxes.simulationEnabled or CamperDebug.checkboxes.spellTester then macroText = "/s " .. playerSetUpCampMessage .. " " .. hyperlink .. "\n" .. macroSoundEffectLine .. "\n" .. macroCloseFrameLine end
    self.macroTextBuffer = macroText
    self.tooltipTextBuffer = playerSetUpCampMessage .. " " .. hyperlink
    if not InCombatLockdown() then
        self:ActivateWithAttributes()
    end
end
-- ______________________________________________________________________________________

-- _____________________________________ Found Camp _____________________________________
function Camper_SendChatMsgSecureActionButtonMixin:StartWaitForSitDown()
    self:DesaturateHierarchy(1)
    self:Show()
end
function Camper_SendChatMsgSecureActionButtonMixin:CancelWaitForSitDown()
    print("called")
    self:DesaturateHierarchy(0)
    self:Hide()
end

local playerFoundCampMessage = T["[Camper]: I found a camp here!"]
function Camper_SendChatMsgSecureActionButtonMixin:SetToPlayerFoundCamp()
    d.print("SetToPlayerFoundCamp called")
    if not initiated then return end
    local hyperlink = LM:GetCurrentPositionWaypointLink()
    if not hyperlink then return end
    local generalChat_index = LC:GetChatChannelIndexFromName(COMMUNITIES_DEFAULT_CHANNEL_NAME)
    if testing then generalChat_index = 1 end
    local macroText = "/c " .. generalChat_index .. " " ..  playerFoundCampMessage .. " " .. hyperlink .. "\n" .. macroSoundEffectLine .. "\n" .. macroCloseFrameLine
    if CamperDebug.checkboxes.simulationEnabled then macroText = "/s " .. playerFoundCampMessage .. " " .. hyperlink .. "\n" .. macroSoundEffectLine .. "\n" .. macroCloseFrameLine end
    self.macroTextBuffer = macroText
    self.tooltipTextBuffer = playerFoundCampMessage .. " " .. hyperlink
    if not InCombatLockdown() then
        self:ActivateWithAttributes()
    end
end
-- ______________________________________________________________________________________

local hideTimerMessage = T["Hiding in: "]
-- _____________________________ Hide-Delayer _____________________________
local THRESHOLD_DIVIDER = 5
local THRESHOLD = 1
function Camper_SendChatMsgSecureActionButtonMixin:StartHideDelayer()
    local teeburu = self.savedVarTable
    local reference = self.reference
    local delay = teeburu[reference]
    self.delayerActive = true
    self.hideTimer:SetText(hideTimerMessage .. delay)
    LU.SingleDelayer(delay, 0, THRESHOLD, self, function(remainingDelay)
        if remainingDelay > 0 then
            d.print("Delay remaining: ", LU.SimplifyFloat(remainingDelay, 0))
            self.hideTimer:SetText(hideTimerMessage .. LU.SimplifyFloat(remainingDelay, 0))
        end
    end, function()
        d.print("Delay ended. Hiding Frame.")
        self:ClearAttributes()
        self:Hide()
        self:ResetDelayer()
    end)
end

function Camper_SendChatMsgSecureActionButtonMixin:ResetDelayer()
    self.delayerActive = false
    self.hideTimer:SetText(nil)
    self:SetScript("OnUpdate", nil)
end

-- ___MAYBE NOT NEEDED__
-- function Camper_SendChatMsgSecureActionButtonMixin:PauseHideDelayer()
--     self:SetScript("OnUpdate", nil)
--     if self.remainingDelay then
--         d.print("Still have delay leftover: ", self.remainingDelay)
--     end      
-- end
-- function Camper_SendChatMsgSecureActionButtonMixin:ContinueHideDelayer()
--     if not self.remainingDelay then return end
--     self:Show()WW
--     d.print("Continuing delay where left off", self.remainingDelay)
--     local delay = self.remainingDelay
--     local threshold = delay / THRESHOLD_DIVIDER
--     LU.SingleDelayer(delay, 0, threshold, self, function(remainingDelay)
--         if remainingDelay > 0 then
--             self.remainingDelay = remainingDelay
--             d.print("(Continue) Delay remaining: ", remainingDelay)
--         end
--     end, function()
--         d.print("(Continue) Delay ended. Hiding Frame.")
--         self.remainingDelay = nil
--         self:Hide()
--     end)
-- end
-- _____________________
-- ________________________________________________________________________


function Camper_SendChatMsgSecureActionButtonMixin.OnEvent(self, event, unit, ...)
    if not initiated then return end
    local arg4, arg5 = ...
    event, unit, arg4, arg5 = LSec.ScrubSecret(event, unit, arg4, arg5)
    if event == "PLAYER_REGEN_DISABLED" then
        -- Button activated --> player entered combat while active
        if self:IsShown() then
            self:Hide()
            d.print("Hiding due to combat")
        end
    elseif event == "PLAYER_REGEN_ENABLED" then
        -- "SetTo" function was called during combat, and now there is macroTextBuffer waiting to be processed
        if self.macroTextBuffer then
            d.print("\"SetTo\" function was called during combat")
                self:ActivateWithAttributes()
                -- Hide delay was ongoing when entering combat, and no new "SetTo" function was called
        elseif self.delayerActive then
            d.print("Remainder delay was not reset. Show and continue.")
            self:Show()
        end
    end
end

function Camper_SendChatMsgSecureActionButtonMixin:OnShow()

end

function Camper_SendChatMsgSecureActionButtonMixin:OnHide()
    
end

function Camper_SendChatMsgSecureActionButtonMixin:MacroSuccessful()
    d.print("MACRO SUCCESSFUL!", self:GetDebugName())
    self:ResetDelayer()
    self:ClearAttributes()
    self:Hide()
end

function Camper_SendChatMsgSecureActionButtonMixin:OnDragStart(button)
    self:StartMoving()
    self.title:Hide()
    -- reusableTooltip:Hide()
end

function Camper_SendChatMsgSecureActionButtonMixin:OnDragStop(button)
    self:StopMovingOrSizing()
    self.title:Show()
end

