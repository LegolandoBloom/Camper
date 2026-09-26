function Camper_InitDebugMenuSavedVars()
    if CamperDebug == nil then CamperDebug = {} end
    if CamperDebug.checkboxes == nil then CamperDebug.checkboxes = {} end
    if CamperDebug.checkboxes.debugMode == nil then CamperDebug.checkboxes.debugMode = false end
    if CamperDebug.checkboxes.spellTester == nil then CamperDebug.checkboxes.spellTester = false end
    if CamperDebug.checkboxes.simulationEnabled == nil then CamperDebug.checkboxes.simulationEnabled = false end
end