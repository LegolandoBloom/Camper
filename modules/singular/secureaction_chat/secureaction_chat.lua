local DEBUGGING = true

local T = Camper_Translate

local LU = LegolandoUtil
local LM = LU.Map
local LC = LU.Chat
local LSec = LU.Secret
local d = LU.Debug.CreateDebugHandler(DEBUGGING)

Camper_SendChatMsgSecureActionButtonMixin = {}

local initiated = false
function Camper_SendChatMsgSecureActionButtonMixin:Init()
    local teeburu = self.savedVarTable
    local reference = self.reference
    if not teeburu or not reference then
        print("no saved variable or reference")
        return
    end
    local hideAfter = teeburu[reference]
    d.tableToString(teeburu)
    self.hideAfter = hideAfter
    initiated = true
end

function Camper_SendChatMsgSecureActionButtonMixin:OnLoad()
    self.icon:SetSize(48, 48)
    self.icon:SetTexture("Interface/AddOns/Camper/images/campericon.png")
    self.title = self:CreateFontString("$parent_Text", "ARTWORK", "GameFontNormal")
    self.title:SetText("Announce Camp")
    self.title:SetPoint("BOTTOM", self, "TOP", 0, 5)

    self:SetAttribute("type", "macro")
    self:RegisterForClicks("AnyDown", "AnyUp")

    self:SetMovable(true)
    self:RegisterForDrag("LeftButton")

    self:RegisterEvent("PLAYER_REGEN_DISABLED")
    self:RegisterEvent("PLAYER_REGEN_ENABLED")
end

function Camper_SendChatMsgSecureActionButtonMixin:ActivateAttributes()
    if not initiated then return end
    if not self.macroText then return end
    if InCombatLockdown() then return end
    self:SetAttribute("macrotext", self.macroText)
    self.macroText = nil
end

local playerCampMessage = T["[Camper]: I've set up camp here!"]
local testing = true
function Camper_SendChatMsgSecureActionButtonMixin:SetToPlayerSetupCamp()
    if not initiated then return end
    local hyperlink = LM:GetCurrentPositionWaypointLink()
    if not hyperlink then return end
    local generalChat_index = LC:GetChatChannelIndexFromName(COMMUNITIES_DEFAULT_CHANNEL_NAME)
    if testing then generalChat_index = 1 end
    local macroText = "/c " .. generalChat_index .. " " ..  playerCampMessage .. " " .. hyperlink
    self.macroText = macroText
    if not InCombatLockdown() then
        self:ActivateAttributes()
        self:Show()
    end
end


-- _____________________________ Hide Delayer _____________________________
local THRESHOLD_DIVIDER = 5
function Camper_SendChatMsgSecureActionButtonMixin:StartHideDelayer()
    local delay = self.hideAfter
    local threshold = delay / THRESHOLD_DIVIDER
    LU.SingleDelayer(delay, 0, threshold, self, function(remainingDelay)
        if remainingDelay > 0 then
            self.remainingDelay = remainingDelay
            d.print("Delay remaining: ", remainingDelay)
        end
    end, function()
        d.print("Delay ended. Hiding Frame.")
        self.remainingDelay = nil
        self:Hide()
    end)
end
function Camper_SendChatMsgSecureActionButtonMixin:PauseHideDelayer()
    self:SetScript("OnUpdate", nil)
    if self.remainingDelay then
        d.print("Still have delay leftover: ", self.remainingDelay)
    end      
end
function Camper_SendChatMsgSecureActionButtonMixin:ContinueHideDelayer()
    if not self.remainingDelay then return end
    self:Show()
    d.print("Continuing delay where left off", self.remainingDelay)
    local delay = self.remainingDelay
    local threshold = delay / THRESHOLD_DIVIDER
    LU.SingleDelayer(delay, 0, threshold, self, function(remainingDelay)
        if remainingDelay > 0 then
            self.remainingDelay = remainingDelay
            d.print("(Continue) Delay remaining: ", remainingDelay)
        end
    end, function()
        d.print("(Continue) Delay ended. Hiding Frame.")
        self.remainingDelay = nil
        self:Hide()
    end)
end
-- ________________________________________________________________________


function Camper_SendChatMsgSecureActionButtonMixin.OnEvent(self, event, unit, ...)
    if not initiated then return end
    local arg4, arg5 = ...
    event, unit, arg4, arg5 = LSec.ScrubSecret(event, unit, arg4, arg5)
    if event == "PLAYER_REGEN_DISABLED" then
        if self:IsShown() then
            self:Hide()
            d.print("Hiding due to combat")
            self:PauseHideDelayer()
        end
    elseif event == "PLAYER_REGEN_ENABLED" then
        self:ContinueHideDelayer()
    end
end

function Camper_SendChatMsgSecureActionButtonMixin:OnShow()
    if not initiated then return end
    if not self.remainingDelay then
        self:StartHideDelayer()
    end
end

function Camper_SendChatMsgSecureActionButtonMixin:OnHide()
    if not initiated then return end
    self:SetAttribute("macrotext", "")
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
