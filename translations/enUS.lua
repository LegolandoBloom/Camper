Camper_Translate = {}
local T = Camper_Translate

local colorYello = CreateColor(1.0, 0.82, 0.0)
local colorGrae = CreateColor(0.85, 0.85, 0.85)
local colorBlu = CreateColor(0.61, 0.85, 0.92)
local colorWhite = CreateColor(1, 1, 1)
local colorGreen = CreateColor(0, 1, 0)
local colorPurple = CreateColor(0.64, 0.3, 0.71)
local colorBrown = CreateColor(0.67, 0.41, 0)
local colorRed = CreateColor(1, 0, 0)
local colorUnderlight = CreateColor(0.9, 0.8, 0.5)
local colorDarkRed = CreateColor(0.68, 0, 0)
local colorDarkBlu = CreateColor(0.12, 0.5, 1)

local colorGeneralChat = CreateColor(1, 0.75, 0.75)
local colorCamper = CreateColor(1, 0.62, 0)
local colorCampfire = CreateColor(0.8, 0.43, 0.23)
local colorWaypoint = CreateColor(0.86, 0.86, 0)


T["Camper Configuration"] = "Camper Configuration"

T["Left Click: Config Panel"] = "Left Click: " .. colorYello:WrapTextInColorCode("Config Panel")

T["Camper: Minimap Icon hidden, /campmini to show."] = "Camper: Minimap Icon hidden, /campmini to show."

T["Middle Button: Hide Minimap Icon"] = "Middle Button: " .. colorYello:WrapTextInColorCode("Hide Minimap Icon")

T["Open Config Panel"] = "Open Config Panel"

T["Left Click: Config Panel"] = "Left Click: " .. colorYello:WrapTextInColorCode("Config Panel")

T["Camper: Minimap Button Shown"] = "Camper: Minimap Button Shown"

T["Camper: Minimap Button Hidden"] = "Camper: Minimap Button Hidden"

T["Whether Camper's minimap button is shown."] = "Whether Camper's minimap button is shown."

T["You need to open the Config Panel to change Camper's settings!"
.. "\n\n(Hint) You can also:\n - type /camper\n - Click the Minimap/AddonCompartment Button\nto open it."] = "You need to open the Config Panel to change Camper's settings!"
.. "\n\n(Hint) You can also:\n - type /camper\n - Click the Minimap/AddonCompartment Button\nto open it."


T["Camper: cannot open Config Panel in combat."] = colorCamper:WrapTextInColorCode("Camper") .. ": cannot open Config Panel in combat."
T["Please try again after combat ends."] = "Please try again after combat ends."

T["[Camper]: I've set up camp here!"] = "[Camper]: I've set up camp here!"
T["[Camper]: I found a camp here!"] = "[Camper]: I found a camp here!"



T["Click to send to General Chat: "] = "Click " .. colorWhite:WrapTextInColorCode("to send to ") .. colorGeneralChat:WrapTextInColorCode("General Chat: ")

T["Announce Camp!"] = "Announce Camp!"

T["Hiding in: "] = "Hiding in: "
T["Hide After:"] = "Hide After:"
T["seconds"] = "seconds"


-- Chat prints for when callbacks trigger
T["Camper: You've set up camp. Click the \'Camper Button\' to share the Waypoint!"] = colorCamper:WrapTextInColorCode("Camper: ") 
.. "You've set up camp. Click the \'Camper Button\' to share the " .. colorWaypoint:WrapTextInColorCode("Waypoint") .. "!"

T["Camper: Detected Campfire nearby. If you want to share its [Waypoint]: please go towards it, and do /sit."] = colorCamper:WrapTextInColorCode("Camper: ") .. "Detected " .. colorCampfire:WrapTextInColorCode("Campfire ") .. "nearby." 
.. " If you want to share its " .. colorWaypoint:WrapTextInColorCode("[Waypoint]") .. ": please go towards it, and do " .. colorYello:WrapTextInColorCode("/sit") .. "."

T["Camper: Button Activated. Click to share the camp Waypoint!"] = colorCamper:WrapTextInColorCode("Camper: ") .. "Button Activated. Click to share the camp Waypoint!"

-- Wait for sitdown tooltip
T["You need to sit down next to the camp for Camper to get its proper waypoint.\nPlease locate the campfire and do /sit."] = "You need to sit down next to the camp for Camper to get its proper " .. colorWaypoint:WrapTextInColorCode("waypoint") .. ".\nPlease locate the campfire and do " 
.. colorYello:WrapTextInColorCode("/sit") .. "."


T["[Debug] Click to say: "] = "[Debug] Click to say: "
T["Waiting for /sit"] = colorWhite:WrapTextInColorCode("Waiting for ") .. colorYello:WrapTextInColorCode("/sit")


T["Camper: Please locate the campfire and do /sit before sharing."] = colorCamper:WrapTextInColorCode("Camper: ") 
.. "Please locate the campfire and do " .. colorYello:WrapTextInColorCode("/sit ") .. "before sharing."


-- clickableLink.lua
T["Camper: You've set up camp."] = colorCamper:WrapTextInColorCode("Camper: ") .. "You've set up camp."
T["Camper: Camp successfully located!"] = colorCamper:WrapTextInColorCode("Camper: ") .. "Camp successfully located!"
T["Camper: Can't locate Campfire. Can't share waypoint."] = colorCamper:WrapTextInColorCode("Camper: ") .. "Can't locate Campfire. Can't share waypoint."
T["Camper: Outdated link. Please locate/setup a new campfire to share the waypoint."] = colorCamper:WrapTextInColorCode("Camper: ") .. "Outdated link. Please locate/setup a new campfire to share the waypoint."
T["Camper: Can't share waypoint while in Combat. After it ends, click again to share."] = colorCamper:WrapTextInColorCode("Camper: ") 
.. "Can't share waypoint while in Combat. After it ends, click again to share."
T["Camper: After combat ends, please locate the campfire -> /sit."] = colorCamper:WrapTextInColorCode("Camper: ") .. "After combat ends, please locate the campfire -> " .. colorYello:WrapTextInColorCode("/sit") .. "."
T["Outdated link. Please locate/setup a new campfire to share the waypoint."] = "Outdated link. Please locate/setup a new campfire to share the waypoint."

T["Link pending activation."] = "Link " .. colorPurple:WrapTextInColorCode("pending activation.")
T["Please locate the campfire and do /sit before sharing."] = colorWhite:WrapTextInColorCode("Please locate the campfire and do ") .. colorYello:WrapTextInColorCode("/sit ") .. colorWhite:WrapTextInColorCode("before sharing.")

T["Outdated link."] = "Outdated link."
T["Please locate/setup a new campfire to share the waypoint."] = colorGrae:WrapTextInColorCode("Please locate/setup a new campfire to share the waypoint.")
