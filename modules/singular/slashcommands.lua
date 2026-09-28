local T = Camper_Translate
local colorBlu = CreateColor(0.61, 0.85, 0.92)
local colorYello = CreateColor(1.0, 0.82, 0.0)

local LU = LegolandoUtil

SLASH_CAMPERENUMERATEPOOL1 = "/campenum"
SlashCmdList["CAMPERENUMERATEPOOL"] = function()
    for frame in camperDelayers:EnumerateActive() do
        print(frame:GetDebugName(), "IS ACTIVE")
    end
    for index, frame in camperDelayers:EnumerateInactive() do
        print(frame:GetDebugName(), "IS INACTIVE")
    end
end

SLASH_CAMPERRESET1 = "/campres"
SlashCmdList["CAMPERRESET"] = function()
    -- do something maybe
end


SLASH_CAMPERSETTINGS1 = "/camper"
SLASH_CAMPERSETTINGS2 = "/campcamp"
SLASH_CAMPERSETTINGS2 = "/cmpr"
SlashCmdList["CAMPERSETTINGS"] = function() 
    if InCombatLockdown() then
        print(T["Camper: cannot open Config Panel in combat."])
        print(T["Please try again after combat ends."])
        return
    end
    if not Camper.configPanel:IsShown() then 
        Camper.configPanel:Show()
    end
end
