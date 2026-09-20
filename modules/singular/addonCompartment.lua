local T = Camper_Translate
local colorBlu = CreateColor(0.61, 0.85, 0.92)
local colorWhite = CreateColor(1, 1, 1)
local colorYello = CreateColor(1.0, 0.82, 0.0)

function Camper_AddonCompartment_OnClick(addonName, clickButton)
    if clickButton == "RightButton" then

    else
        Camper.configPanel:Show()
    end
end

function Camper_AddonCompartment_OnEnter(addonName, compartmentButton)
    GameTooltip:SetOwner(compartmentButton, "ANCHOR_BOTTOMLEFT", 45)
    GameTooltip:AddLine(colorBlu:WrapTextInColorCode("Camper"))
    GameTooltip:AddLine(T["Left Click: Config Panel"], 1, 1, 1)
    GameTooltip:Show()
end

function Camper_AddonCompartment_OnLeave()
    GameTooltip:Hide()
end