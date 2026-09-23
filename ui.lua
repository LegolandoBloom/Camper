local T = Camper_Translate
local colorRed = CreateColor(1, 0, 0)
local colorGrae = CreateColor(0.85, 0.85, 0.85)

local addonName, camp = ...
local pr = camp.pr

local configPanel = Camper.configPanel


local function setup_Checkboxes()
    configPanel.checkboxes.debugMode.text:SetText("Debug Mode")
    configPanel.checkboxes.debugMode.tooltip = "\nUse when troubleshooting."
    configPanel.checkboxes.debugMode.onClickCallback = function(configPanel, isChecked) 
        if isChecked == true then
            pr:TriggerEvent("Camper_Settings_DebugEnabled")
        elseif isChecked == false then
            pr:TriggerEvent("Camper_Settings_DebugDisabled")
        end
    end

    configPanel.checkboxes.testerMode.text:SetText("Tester Mode")
    configPanel.checkboxes.testerMode.tooltip = colorRed:WrapTextInColorCode("ONLY MEANT FOR TESTING PURPOSES.\n\n") 
    .. colorGrae:WrapTextInColorCode("When checked:\n\n"
                                    .. "- treat \'Player Stopped Moving\' as --> \'Player Set Up A Campsite\'\n\n"
                                    .. "- treat \'Player Stopped Turning\' as --> \'Player Found A Campsite\'\n\n"
                                    .. "- message and waypoint will be sent to /say instead of General Chat")
    configPanel.checkboxes.testerMode.onClickCallback = function(configPanel, isChecked) 
        if isChecked == true then
            pr:TriggerEvent("Camper_Settings_DebugEnabled")
        elseif isChecked == false then
            pr:TriggerEvent("Camper_Settings_DebugDisabled")
        end
    end

    configPanel.checkboxes.savedVarTable = CamperConfig.checkboxes
    configPanel.checkboxes.testerMode.reference = "testerMode"
    configPanel.checkboxes.debugMode.reference = "debugMode"
    configPanel.checkboxes:Update()
    
    if configPanel.checkboxes.debugMode.checkbox:GetChecked() then pr:TriggerEvent("Camper_Settings_DebugEnabled") end
end

local function setup_EditBoxes()
    configPanel.hideAfter.unitTextTop:SetText(T["Hide After:"])
    configPanel.hideAfter.unitTextBottom:SetText(T["seconds"])
    configPanel.hideAfter.savedVarTable = CamperConfig.editBoxes
    configPanel.hideAfter.reference = "hideAfter"
    configPanel.hideAfter.onSaveCallback = function(editBoxes, value, table)
        print("Set to:", value)
    end
    -- Optional (If You Want Multiple Elements To Be Able To Change The Same Value) --
    configPanel.hideAfter.privateRegistry = pr
	configPanel.hideAfter.privateRegistryString = "ValueChanged_" .. configPanel.hideAfter:GetDebugName()
    ----------------------------------------------------------------------------------
    configPanel.hideAfter:Init(5, 120)
    
end

function Camper_SetupConfigPanel()
    setup_Checkboxes()
    setup_EditBoxes()
end