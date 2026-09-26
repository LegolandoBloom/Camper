local addonName, camp = ...
local secureButton = Camper_SendChatMsgSecureActionButton

local pr = camp.pr


Camper_DebugMenuMixin = {}



function Camper_DebugMenuMixin:OnLoad()
    tinsert(UISpecialFrames, self:GetName())
    self.TitleText:SetText("Camper Debug Menu(ONLY FOR TESTING)")
    self:SetMovable(true)
    self:RegisterForDrag("LeftButton")
    
    self.setupCamp.icon:SetTexture("Interface/Addons/Camper/images/debug/setupcamp.png")
    self.setupCamp.icon:SetSize(64, 64)
    self.setupCamp:SetScript("OnClick", function()
        pr:TriggerEvent("Camper_PlayerSetCamp")
    end)
    
    
    self.foundCamp.icon:SetTexture("Interface/Addons/Camper/images/debug/enteredaura.png")
    self.foundCamp.icon:SetSize(64, 64)
    self.foundCamp:SetScript("OnClick", function()
        pr:TriggerEvent("Camper_PlayerFoundCamp")
    end)
    
    self.unfoundCamp.icon:SetTexture("Interface/Addons/Camper/images/debug/leftaura.png")
    self.unfoundCamp.icon:SetSize(64, 64)
    self.unfoundCamp:SetScript("OnClick", function()
        pr:TriggerEvent("Camper_PlayerNOTFoundCamp")
    end)
end