local T = Camper_Translate
local colorRed = CreateColor(1, 0, 0)
local colorGrae = CreateColor(0.85, 0.85, 0.85)

local addonName, camp = ...
local pr = camp.pr

local configPanel = Camper.configPanel


local function setup_Checkboxes()
    -- configPanel.checkboxes.someCheckbox1.text:SetText("Tester Mode")
    -- configPanel.checkboxes.someCheckbox1.tooltip = "When checked: etc..."
    -- configPanel.checkboxes.someCheckbox1.onClickCallback = function(configPanel, isChecked) 
    --     if isChecked == true then

    --     elseif isChecked == false then

    --     end
    -- end

    -- configPanel.checkboxes.savedVarTable = CamperConfig.checkboxes
    -- configPanel.checkboxes.someCheckbox1.reference = "someCheckbox1"
    -- configPanel.checkboxes:Update()
    
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