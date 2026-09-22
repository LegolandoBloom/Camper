local T = Camper_Translate

local LU = LegolandoUtil
local LM = LU.Map
local LC = LU.Chat
local LSec = LU.Secret



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
    DevTools_Dump(teeburu)
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

function Camper_SendChatMsgSecureActionButtonMixin.OnEvent(self, event, unit, ...)
    if not initiated then return end
    local arg4, arg5 = ...
    event, unit, arg4, arg5 = LSec:SrubSecret(event, unit, arg4, arg5)
    if event == "PLAYER_REGEN_DISABLED" then
        if self:IsShown() then
            self:Hide()
            self:SetScript("OnUpdate", nil)
            print("Hiding due to combat")
            if self.remainingDelay then
                print("Still have delay leftover: ", self.remainingDelay)
            end            
        end
    elseif event == "PLAYER_REGEN_ENABLED" then
        -- combat ended. Activate any remainder macroText attribute

    end
end


local THRESHOLD_DIVIDER = 5
function Camper_SendChatMsgSecureActionButtonMixin:OnShow()
    if not initiated then return end
    local delay = self.hideAfter
    local threshold = delay / THRESHOLD_DIVIDER
    print("delay: ", delay)
    DevTools_Dump(LU.SingleDelayer)
    DevTools_Dump(LU.SimplifyFloat)
    DevTools_Dump(LU.PoolDelayer)
    -- LU.SingleDelayer(delay, 0, threshold, self, function(remainingDelay)
    --     if remainingDelay > 0 then
    --         self.remainingDelay = remainingDelay
    --     end
    -- end, function()
    --     self.remainingDelay = nil
    --     self:Hide()
    -- end)
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