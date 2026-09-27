

local addonName, camp = ...
local secureButton = Camper_SendChatMsgSecureActionButton

local pr = camp.pr

Camper_ActionSimulatorMixin = {}

function Camper_ActionSimulatorMixin:OnLoad()
    self.setupCamp.icon:SetTexture("Interface/Addons/Camper/images/debug/setupcamp.png")
    self.setupCamp.icon:SetSize(64, 64)
    self.setupCamp:SetScript("OnClick", function()
        pr:TriggerEvent("Camper_PlayerSetCamp")
    end)
    
    
    self.foundCamp.icon:SetTexture("Interface/Addons/Camper/images/debug/enteredaura.png")
    self.foundCamp.icon:SetSize(64, 64)
    self.foundCamp:SetScript("OnClick", function()
        pr:TriggerEvent("Camper_PlayerFoundCamp")
        if self.setupCampDelay then
            print("Found Camp Event trigger disabled because you recently Set-Up your own camp")
        end
    end)
    
    self.unfoundCamp.icon:SetTexture("Interface/Addons/Camper/images/debug/leftaura.png")
    self.unfoundCamp.icon:SetSize(64, 64)
    self.unfoundCamp:SetScript("OnClick", function()
        pr:TriggerEvent("Camper_PlayerNOTFoundCamp")
    end)
end

function Camper_ActionSimulatorMixin:TogglePlayerSetupCampDelay(enable)
    self.setupCampDelay = enable
    if enable then
        self.foundCamp:DesaturateHierarchy(1)
        self.foundCamp.title:Hide()
    else
        self.foundCamp:DesaturateHierarchy(0)
        self.foundCamp.title:Show()
    end
end
