local colorRed = CreateColor(1, 0, 0)
local colorGrae = CreateColor(0.85, 0.85, 0.85)

local debugMenu = Camper_DebugMenu

local addonName, camp = ...
local pr = camp.pr

local function _setupCheckboxes(checkboxesFrame)
    checkboxesFrame.debugMode.text:SetText("Debug Prints")
    checkboxesFrame.debugMode.tooltip = "\nUse when troubleshooting."
    checkboxesFrame.debugMode.onClickCallback = function(configPanel, isChecked) 
        if isChecked == true then
            pr:TriggerEvent("Camper_Settings_DebugEnabled")
        elseif isChecked == false then
            pr:TriggerEvent("Camper_Settings_DebugDisabled")
        end
    end

    checkboxesFrame.spellTester.text:SetText("Spell Tester")
    checkboxesFrame.spellTester.tooltip = colorRed:WrapTextInColorCode("ONLY MEANT FOR TESTING PURPOSES.\n\n") 
    .. colorGrae:WrapTextInColorCode("When checked:\n\n"
    .. "- treat certain list of spells as the camp spell")
    checkboxesFrame.spellTester.onClickCallback = function(configPanel, isChecked) 
        if isChecked == true then

        elseif isChecked == false then
            
        end
    end

    checkboxesFrame.savedVarTable = CamperConfig.checkboxes
    checkboxesFrame.spellTester.reference = "spellTester"
    checkboxesFrame.debugMode.reference = "debugMode"
    checkboxesFrame:Update()
    
    if checkboxesFrame.debugMode.checkbox:GetChecked() then pr:TriggerEvent("Camper_Settings_DebugEnabled") end
end

function Camper_SetupDebugMenu()
    _setupCheckboxes(debugMenu.checkboxes)
end