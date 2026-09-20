local T = Camper_Translate
local colorBlu = CreateColor(0.61, 0.85, 0.92)
local colorWhite = CreateColor(1, 1, 1)
local colorYello = CreateColor(1.0, 0.82, 0.0)

local minimapButtonCreated = false
function Camper_InitMinimapButton()
    local mapData = LibStub("LibDataBroker-1.1"):NewDataObject("CamperMinimap", {  
        type = "launcher",  
        text = "Camper!",
        icon = "Interface\\AddOns\\Camper\\images\\campericon.png",
        OnClick = function(self, b) 
            if b == "RightButton" then
                if InCombatLockdown() then
                    print(T["Can't change sleep state in combat."])
                    return
                end
                if UnitIsDeadOrGhost("player") then
                    print(T["Can't change sleep state while in ghost form."])
                    return
                end
            elseif b == "LeftButton" then
                Camper.configPanel:Show()
            elseif b == "MiddleButton" then
                CamperMinimapButton.show = false
                Camper_ToggleMinimapButton(false)
                print(T["Camper: Minimap Icon hidden, /campmini to show."])
            end
        end,
        OnEnter = function(self)
            GameTooltip:SetOwner(self, "ANCHOR_BOTTOMLEFT", 45)
            GameTooltip:AddLine(colorBlu:WrapTextInColorCode("Camper"))
            GameTooltip:AddLine(T["Left Click: Config Panel"], 1, 1, 1)
            -- GameTooltip:AddLine(T["Right Click: " .. colorYello:WrapTextInColorCode("Sleep/Wake")], 1, 1, 1)
            GameTooltip:AddLine(T["Middle Button: Hide Minimap Icon"], 1, 1, 1)
            GameTooltip:Show()
        end,
        OnLeave = function(self)
            GameTooltip:Hide()
        end,
        --Interface\\Icons\\INV_Chest_Cloth_17 
    })
    local icon = LibStub("LibDBIcon-1.0")
    icon:Register("CamperMinimap", mapData , CamperMinimapButton)
    minimapButtonCreated = true
    LibDBIcon10_CamperMinimap:Show()
    CamperMinimapButton.show = true
    -- Camper.configPanel.tab3.contents.showMinimapButton.checkbox:SetChecked(true)
end

SLASH_CAMPERMINIMAP1 = "/campmini"
SlashCmdList["CAMPERMINIMAP"] = function()
    if minimapButtonCreated == false then 
        Camper_InitMinimapButton()
        return
    end
    CamperMinimapButton.show = not CamperMinimapButton.show
    Camper_ToggleMinimapButton(CamperMinimapButton.show)
end

function Camper_ToggleMinimapButton(enable)
    if minimapButtonCreated == false then
        Camper_InitMinimapButton()
        return
    end
    if enable == true then
        LibDBIcon10_CamperMinimap:Show()
        -- Camper.configPanel.tab3.contents.showMinimapButton.checkbox:SetChecked(true)
        print(T["Camper: Minimap Button Shown"])
    elseif enable == false then
        LibDBIcon10_CamperMinimap:Hide()
        -- Camper.configPanel.tab3.contents.showMinimapButton.checkbox:SetChecked(false)
        print(T["Camper: Minimap Button Hidden"])
    end
end
