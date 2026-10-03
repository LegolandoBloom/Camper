--Translator: ZamestoTV

if (GAME_LOCALE or GetLocale()) ~= "ruRU" then
  return
end

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


T["Camper Configuration"] = "Настройка Camper"

T["Left Click: Config Panel"] = "ЛКМ: " .. colorYello:WrapTextInColorCode("Панель Настроек")

T["Camper: Minimap Icon hidden, /campmini to show."] = "Camper: иконка миникарты скрыта, введите /campmini, чтобы ее показать."

T["Middle Button: Hide Minimap Icon"] = "СКМ: " .. colorYello:WrapTextInColorCode("скрыть иконку миникарты")

T["Open Config Panel"] = "Открыть панель настроек"

T["Left Click: Config Panel"] = "ЛКМ: " .. colorYello:WrapTextInColorCode("Панель Настроек")

T["Camper: Minimap Button Shown"] = "Camper: кнопка на миникарте отображается"

T["Camper: Minimap Button Hidden"] = "Camper: кнопка на миникарте скрыта"

T["Whether Camper's minimap button is shown."] = "Определяет, отображается ли кнопка Camper на миникарте."

T["You need to open the Config Panel to change Camper's settings!"
.. "\n\n(Hint) You can also:\n - type /camper\n - Click the Minimap/AddonCompartment Button\nto open it."] = "Вам необходимо открыть панель настроек, чтобы изменить параметры Camper!"
.. "\n\n(Подсказка) Вы также можете:\n - ввести команду /camper\n - кликнуть по кнопке на миникарте или в меню модификаторов\nчтобы открыть ее."


T["Camper: cannot open Config Panel in combat."] = colorCamper:WrapTextInColorCode("Camper") .. ": невозможно открыть панель настроек в бою."
T["Please try again after combat ends."] = "Пожалуйста, попробуйте еще раз после окончания боя."

T["[Camper]: I've set up camp here!"] = "[Camper]: Я разбил лагерь здесь!"
T["[Camper]: I found a camp here!"] = "[Camper]: Я нашел лагерь здесь!"



T["Click to send to General Chat: "] = "Кликните, " .. colorWhite:WrapTextInColorCode("чтобы отправить в ") .. colorGeneralChat:WrapTextInColorCode("Общий чат: ")

T["Announce Camp!"] = "Объявить о лагере!"

T["Hiding in: "] = "Скроется через: "
T["Hide After:"] = "Скрыть через:"
T["seconds"] = "сек."

-- Chat prints for when callbacks trigger
T["Camper: You've set up camp. Click the \'Camper Button\' to share the Waypoint!"] = colorCamper:WrapTextInColorCode("Camper: ") 
.. "Вы разбили лагерь. Нажмите кнопку \'Camper\', чтобы поделиться " .. colorWaypoint:WrapTextInColorCode("точкой назначения") .. "!"

T["Camper: Detected Campfire nearby. If you want to share its [Waypoint]: please go towards it, and do /sit."] = colorCamper:WrapTextInColorCode("Camper: ") .. "Detected " .. colorCampfire:WrapTextInColorCode("Campfire ") .. "nearby." 
.. " Если вы хотите поделиться его " .. colorWaypoint:WrapTextInColorCode("[точкой назначения]") .. ", подойдите к нему и используйте эмоцию " .. colorYello:WrapTextInColorCode("/сесть") .. "."

T["Camper: Button Activated. Click to share the camp Waypoint!"] = colorCamper:WrapTextInColorCode("Camper: ") .. "Кнопка активирована. Нажмите, чтобы поделиться точкой назначения лагеря!"

-- Wait for sitdown tooltip
T["You need to sit down next to the camp for Camper to get its proper waypoint.\nPlease locate the campfire and do /sit."] = "Вам нужно сесть рядом с лагерей, чтобы Camper определил правильную " .. colorWaypoint:WrapTextInColorCode("точку назначения") .. ".\nПожалуйста, найдите костер и используйте эмоцию " 
.. colorYello:WrapTextInColorCode("/сесть") .. "."


T["[Debug] Click to say: "] = "[Отладка] Нажмите, чтобы сказать: "
T["Waiting for /sit"] = colorWhite:WrapTextInColorCode("Ожидание ") .. colorYello:WrapTextInColorCode("/сесть")


T["Camper: Please locate the campfire and do /sit before sharing."] = colorCamper:WrapTextInColorCode("Camper: ") 
.. "Пожалуйста, найдите костер и используйте эмоцию " .. colorYello:WrapTextInColorCode("/сесть ") .. " перед отправкой."


-- clickableLink.lua
T["Camper: You've set up camp."] = colorCamper:WrapTextInColorCode("Camper: ") .. "Вы разбили лагерь."
T["Camper: Camp successfully located!"] = colorCamper:WrapTextInColorCode("Camper: ") .. "Лагерь успешно обнаружен!"
T["Camper: Can't locate Campfire. Can't share waypoint."] = colorCamper:WrapTextInColorCode("Camper: ") .. "Не удалось найти костер. Невозможно поделиться точкой на карте."
T["Camper: Outdated link. Please locate/setup a new campfire to share the waypoint."] = colorCamper:WrapTextInColorCode("Camper: ") .. "Устаревшая ссылка. Пожалуйста, найдите или разведите новый костер, чтобы поделиться точкой."
T["Camper: Can't share waypoint while in Combat. After it ends, click again to share."] = colorCamper:WrapTextInColorCode("Camper: ") 
.. "Нельзя делиться точкой во время боя. После его окончания нажмите еще раз, чтобы отправить ссылку."
T["Camper: After combat ends, please locate the campfire -> /sit."] = colorCamper:WrapTextInColorCode("Camper: ") .. "После окончания боя, пожалуйста, подойдите к костру и введите -> " .. colorYello:WrapTextInColorCode("/сесть") .. "."
T["Outdated link. Please locate/setup a new campfire to share the waypoint."] = "Устаревшая ссылка. Пожалуйста, найдите или разведите новый костер, чтобы поделиться точкой."

T["Link pending activation."] = "Ссылка " .. colorPurple:WrapTextInColorCode("ожидает активации.")
T["Please locate the campfire and do /sit before sharing."] = colorWhite:WrapTextInColorCode("Пожалуйста, подойдите к костру и введите ") .. colorYello:WrapTextInColorCode("/сесть ") .. colorWhite:WrapTextInColorCode("перед отправкой ссылки.")

T["Outdated link."] = "Устаревшая ссылка."
T["Please locate/setup a new campfire to share the waypoint."] = colorGrae:WrapTextInColorCode("Пожалуйста, найдите или разведите новый костер, чтобы поделиться точкой.")


T["Share Method:"] = "Способ отправки:"
T["Select Sharing Method"] = "Выберите способ отправки"


T["Hide Button After:"] = "Скрывать кнопку через:"

T["Camper: A clickable link will be sent to your chatbox when you setup/find a campfire.(Default chat window)"] = colorCamper:WrapTextInColorCode("Camper: ") 
.. "В ваш чат будет отправлена " .. colorYello:WrapTextInColorCode("кликабельная ссылка ") .. ", когда вы разобьете или найдете костер.(Окно чата по умолчанию)"

T["Camper: A popup button will appear when you setup/find a campfire."] = colorCamper:WrapTextInColorCode("Camper: ") .. "При разведении или поиске костра " 
.. colorYello:WrapTextInColorCode("всплывающая кнопка ") .. "появится на вашем экране."
