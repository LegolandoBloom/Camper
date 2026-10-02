local T = Camper_Translate
local colorRed = CreateColor(1, 0, 0)
local colorGrae = CreateColor(0.85, 0.85, 0.85)

local LU = LegolandoUtil
local LUI = LU.UI

local addonName, camp = ...
local pr = camp.pr

local configPanel = Camper.configPanel


local function setup_Dropdowns()
    local elementTable = {
        [1] = "Clickable Chat Link",
        [2] = "Popup Button",
    }
    local shareMethod = LUI.SetupGenericBlizzMenuDropdown(configPanel, CamperConfig.dropdownMenus, "shareMethod", T["Select Sharing Method"], "some default text", elementTable, function(index)
    end, function(index)
        if elementTable[index] == "Popup Button" then
            print(T["Camper: A popup button will appear when you setup/find a campfire."])
            configPanel.hideAfter:Show()
        elseif elementTable[index] == "Clickable Chat Link" then
            print(T["Camper: A clickable link will be sent to your chatbox when you setup/find a campfire.(Default chat window)"])
            configPanel.hideAfter:Hide()
        else
            configPanel.hideAfter:Hide()
        end
    end)
    if elementTable[CamperConfig.dropdownMenus.shareMethod] == "Popup Button" then
        configPanel.hideAfter:Show()
    end
    shareMethod:SetPoint("TOPLEFT", configPanel, "TOPLEFT", 20, -55)
    local x, y = shareMethod:GetSize()
    shareMethod :SetSize(120, y)
    local SCALER = 1
    shareMethod:SetScale(SCALER)
    shareMethod:Show()
    local titleText = shareMethod:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    titleText:SetPoint("BOTTOMLEFT", shareMethod, "TOPLEFT", 0, 5)
    titleText:SetText(T["Share Method:"])
    titleText:SetScale(1 / SCALER)
end

local function setup_Checkboxes()
    -- configPanel.checkboxes.someCheckbox1.text:SetText("Some Checkbox 1")
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
    configPanel.hideAfter.unitTextTop:SetText(T["Hide Button After:"])
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
    setup_Dropdowns()
end