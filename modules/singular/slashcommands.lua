local T = Camper_Translate
local colorBlu = CreateColor(0.61, 0.85, 0.92)
local colorYello = CreateColor(1.0, 0.82, 0.0)

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
SLASH_CAMPERTEST1 = "/camptest"
SlashCmdList["CAMPERTEST"] = function()
	local currentMapID = C_Map.GetBestMapForUnit("player")
	local mapInfo = C_Map.GetMapInfo(currentMapID)
	DevTools_Dump(mapInfo)
	local coords = C_Map.GetPlayerMapPosition(currentMapID, "player")
	if not coords then return end
	local x, y = coords:GetXY()
	C_Map.SetUserWaypoint(UiMapPoint.CreateFromCoordinates(currentMapID, x, y))
	local hyperlink = C_Map.GetUserWaypointHyperlink()
	SendChatMessage(hyperlink, "SAY", nil, nil)
	C_Map.ClearUserWaypoint()
end

SLASH_CAMPERSETTINGS1 = "/camper"
SLASH_CAMPERSETTINGS2 = "/campcamp"
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
