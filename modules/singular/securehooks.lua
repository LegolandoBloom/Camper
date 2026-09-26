local addonName, camp = ...
local pr = camp.pr


hooksecurefunc(C_ChatInfo, "PerformEmote", function(...)
    local arg1, arg2, arg3, arg4 = ...
    if arg1 == "SIT" then
        pr:TriggerEvent("Camper_PlayerSit")
    end
end)