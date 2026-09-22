local T = Camper_Translate

local LU = LegolandoUtil
local LM = LU.Map
local LC = LU.Chat

Camper_SendChatMsgSecureActionButtonMixin = {}



function Camper_SendChatMsgSecureActionButtonMixin:OnLoad()
    self.icon:SetSize(48, 48)
    self.icon:SetTexture("Interface/AddOns/Camper/images/campericon.png")
    local title = self:CreateFontString("$parent_Text", "ARTWORK", "GameFontNormal")
    title:SetText("Announce Camp")
    title:SetPoint("BOTTOM", self, "TOP")

    self:SetAttribute("type", "macro")
    self:RegisterForClicks("AnyDown", "AnyUp")
end

local playerCampMessage = T["[Camper]: I've set up camp here!"]
local testing = true
function Camper_SendChatMsgSecureActionButtonMixin:SetToPlayerSetupCamp()
    local hyperlink = LM:GetCurrentPositionWaypointLink()
    local generalChat_index = LC:GetChatChannelIndexFromName(COMMUNITIES_DEFAULT_CHANNEL_NAME)
    if testing then generalChat_index = 1 end
    if not testing then
        self:SetAttribute("macrotext", "/c " .. generalChat_index .. " " ..  playerCampMessage .. " " .. hyperlink)
    end

    if testing then
        self:SetAttribute("macrotext", "/c 1 " .. C_ColorUtil.WrapTextInColor("Hiyah", DARKYELLOW_FONT_COLOR))
    end
end