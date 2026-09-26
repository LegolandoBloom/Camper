CamperDebugMenu = {

}

function Camper_InitDebugMenuSavedVars()
    if CamperDebugMenu == nil then CamperDebugMenu = {} end
    if CamperDebugMenu.checkboxes == nil then CamperDebugMenu.checkboxes = {} end
    if CamperDebugMenu.checkboxes.debugMode == nil then CamperDebugMenu.checkboxes.debugMode = false end
    if CamperDebugMenu.checkboxes.spellTester == nil then CamperDebugMenu.checkboxes.spellTester = false end
end