local T = Camper_Translate


-- Going with vertical-layout-category for now, might implement a canvas category later instead
-- (Canvas provides more control)
function Camper_LoadAddonsTab()
    local category, layout = Settings.RegisterVerticalLayoutCategory("Camper")
    
    do 
        local name = "Show Minimap Button"
        local variable = "Camper_ShowMinimap"
        local variableKey = "show"
        local variableTbl = CamperMinimapButton
        local defaultValue = false


        local function OnSettingChanged(setting, value)
            -- print("Setting changed:", setting:GetVariable(), value)
            Camper_ToggleMinimapButton(value)
        end
        local setting = Settings.RegisterAddOnSetting(category, variable, variableKey, variableTbl, type(defaultValue), name, defaultValue)
        setting:SetValueChangedCallback(OnSettingChanged)

        local tooltip = T["Whether Camper's minimap button is shown."]
        local cbox1 = Settings.CreateCheckbox(category, setting, tooltip)
    end

    do
        local buttonText, addSearchTags = T["Open Config Panel"], true
        local tooltip = T["You need to open the Config Panel to change Camper's settings!"
        .. "\n\n(Hint) You can also:\n - type /camper\n - Click the Minimap/AddonCompartment Button\nto open it."]
        local function onButtonClick(self)
            local left, bottom = self:GetRect()
            Camper.configPanel:ClearAllPoints()
            Camper.configPanel:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", left, bottom - 30)
            Camper.configPanel:Raise()
            if not Camper.configPanel:IsShown() then Camper.configPanel:Show() end
        end
        layout:AddInitializer(CreateSettingsButtonInitializer("", buttonText, onButtonClick, tooltip, addSearchTags))
    end

    Settings.RegisterAddOnCategory(category)
end

-- print("Settings: ")
-- DevTools_Dump(category:GetID())
-- DevTools_Dump(Settings.GetCategory(category:GetID()))
-- DevTools_Dump(category:GetCategorySet())
-- DevTools_Dump(category:GetName())
-- DevTools_Dump(Settings.GetSetting("Camper_ShowMinimap"))