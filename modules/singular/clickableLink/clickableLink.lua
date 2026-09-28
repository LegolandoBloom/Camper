local T = Camper_Translate

local addonName, camp = ...
local pr = camp.pr

camp.clickableLink = {}

local cl = camp.clickableLink

SLASH_CAMPERTEST1 = "/camptest"


local link_playerSetCamp = "|cFFFFFF00|Haddon:Camper:PlayerSetCamp|h[Click here to share the Waypoint!]|h|r"


local function linksCallback(_, link, text, button, chatFrame)
    local linkType, addonName, linkData = strsplit(":", link)
    if linkType == "addon" and addonName == "Camper" then
        securecall(C_ChatInfo.SendChatMessage, "test", "SAY")
        C_Timer.After(5, function()
            securecall(C_ChatInfo.SendChatMessage, "test", "SAY")
        end)
    end
end 
EventRegistry:RegisterCallback("SetItemRef", linksCallback)

function cl.playerSetCamp()
    print(T["Camper: You've set up camp. "] .. link_playerSetCamp)
end