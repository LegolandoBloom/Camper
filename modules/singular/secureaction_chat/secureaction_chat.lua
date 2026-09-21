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