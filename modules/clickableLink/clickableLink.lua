local T = Camper_Translate

local LU = LegolandoUtil
local LM = LU.Map
local LC = LU.Chat
local LSec = LU.Secret


local DEBUGGING = false
local d = LU.Debug.CreateDebugHandler(DEBUGGING)

-- clickableLink.lua will always be analogous to secureAction_chat for maintainability's sake

local addonName, camp = ...
local pr = camp.pr
pr:RegisterCallback("Camper_Settings_DebugEnabled", function(_, caller)
    d.toggleDebug(true)
end)
pr:RegisterCallback("Camper_Settings_DebugDisabled", function(_, caller)
    d.toggleDebug(false)
end)

camp.clickableLink = {}

local cl = camp.clickableLink

SLASH_CAMPERTEST1 = "/camptest"




local link_clickToWaypoint = "|cFFFFFF00|Haddon:Camper:ClickToWaypoint|h[Click here to share the Waypoint!]|h|r"
local hi = "hi"

local testing = false

local function linksCallback(_, link, text, button, chatFrame)
    local linkType, addonName, linkData = strsplit(":", link)
    if linkType == "addon" and addonName == "Camper" then
        -- DevTools_Dump(cl)
        if cl.linkActive then
            if cl:IsTesting() then
                print("testing", cl.activeMessage .. link_clickToWaypoint)
                securecall(C_ChatInfo.SendChatMessage, cl.activeMessage .. " " .. link_clickToWaypoint, "SAY")
                C_ChatInfo.SendChatMessage(cl.activeMessage .. " " , "SAY") 
                C_ChatInfo.SendChatMessage(link_clickToWaypoint, "SAY") 
                C_ChatInfo.SendChatMessage(hi, "SAY") 

            else
                securecall(C_ChatInfo.SendChatMessage, cl.activeMessage .. link_clickToWaypoint, "CHANNEL", nil, cl.activeChatIndex)
            end
        elseif cl.waitingPromptedAction then
            cl:PostClick()
        else
            print(T["Camper: Outdated link. Please locate/setup a new campfire to share the waypoint."])
        end
    end
end 
EventRegistry:RegisterCallback("SetItemRef", linksCallback)


local function cl_OnEnter(...)
    if not cl.linkActive then return end
    local what, self, link, text, region, left, bottom, width, height = ...
    if cl.linkActive or cl.waitingPromptedAction then
        GameTooltip:SetOwner(UIParent, "ANCHOR_CURSOR", 0, 0)
        GameTooltip:AddLine(cl.activeTooltipTitle)
        GameTooltip:AddLine("\n")
        GameTooltip:AddLine(cl.activeTooltipText, 1, 1, 1, false)
        GameTooltip:Show()
    end
    -- print("What: ", what)
    -- print("Self:", self:GetDebugName())
    -- print("Link: ", link)
    -- print("Text: ", text)
    -- print("Region: ", region:GetDebugName())
    -- print("Left: ", left)
    -- print("Bottom: ", bottom)
    -- print("Width: ", width)
    -- print("Height: ", height)
end
local function cl_OnLeave()
    GameTooltip:Hide()
end
EventRegistry:RegisterCallback("ChatFrame.OnHyperlinkEnter", cl_OnEnter)
EventRegistry:RegisterCallback("ChatFrame.OnHyperlinkLeave", cl_OnLeave)


function Camper_InitClickableLink(teeburu, reference)
    -- if not teeburu or not reference then
    --     print("no saved variable or reference")
    --     return
    -- end
    -- cl.savedVarTable = teeburu
    -- cl.reference = reference
    -- d.tableToString(cl.savedVarTable)
    cl.initiated = true
end

function cl:IsTesting()
    if CamperDebug.checkboxes.simulationEnabled or CamperDebug.checkboxes.spellTester then return true end
    return false
end


--___________________________ Buffers ___________________________
-- cl.activeMessageBuffer
-- cl.activeChatIndexBuffer
-- cl.activeTooltipTitleBuffer
-- cl.activeTooltipTextBuffer
function cl:ClearBuffers()
    self.activeMessageBuffer = nil
    self.activeChatIndexBuffer = nil
    self.activeTooltipTitleBuffer = nil
    self.activeTooltipTextBuffer = nil
end
function cl:ValidateBuffers()
    if not self.activeChatIndexBuffer then return false, "activeChatIndexBuffer" end
    if not self.activeMessageBuffer then return false, "activeMessageBuffer" end
    if not self.activeTooltipTitleBuffer then return false, "activeTooltipTitleBuffer" end
    if not self.activeTooltipTextBuffer then return false, "activeTooltipTextBuffer" end
    return true
end
function cl:ActivateBuffers()
    self.activeChatIndex = self.activeChatIndexBuffer
    self.activeMessage = self.activeMessageBuffer
    self.tooltipText = self.tooltipTextBuffer
    self.tooltipTitle = self.tooltipTitleBuffer
end
--_______________________________________________________________


function cl:ActivateWithLink()
    d.print("clickableLink: ActivateWithLink called")
    if not self.initiated then return end
    local valid, missing = self:ValidateBuffers()
    if not valid then
        print("clickableLink: Buffer missing: ", missing)
        self:ClearBuffers()
        return 
    end
    if InCombatLockdown() then return end
    self:ActivateBuffers()
    self:ClearBuffers()
    print(self.activeMessage, link_clickToWaypoint)
    self:ResetDelayer()
    self:StartLinkDisableDelayer()
    self.linkActive = true
end

function cl:ClearLink()
    if not self.initiated then return end
    self:ClearBuffers()
    self.activeChatIndex = nil
    self.activeMessage = nil
    self.tooltipText = nil
    self.tooltipTitle = nil
    self.linkActive = false
end

-- _____________________________________ Setup/Found Camp _____________________________________
function cl:SetToSendMessageToChannelIndex(channelIndex, message, tooltipTitle, tooltipText)
    d.print("clickableLink: SetToSendMessageToChannelIndex called, channelIndex:", channelIndex, "message:", message, "Tootlip: ", tooltipTitle, tooltipText)
    if not self.initiated then return end
    if not channelIndex or not message then return end
    self.activeChatIndexBuffer = channelIndex
    self.activeMessageBuffer = message
    self.activeTooltipTitleBuffer = tooltipTitle
    self.activeTooltipTextBuffer = tooltipText
    if not InCombatLockdown() then
        self:ActivateWithLink()
    end
end
-- ____________________________________________________________________________________________




-- _____ Waiting For SitDown _____
function cl:PostClick()
    if not self.waitingPromptedAction then return end
    local warning = self.clickWarningMessage
    if not warning then return end
    print(warning)
end
function cl:Start_PromptUser(tooltipTitle, tooltipText, clickWarningMessage)
    if self.linkActive then return end
    self.waitingPromptedAction = true
    d.print("clickableLink: started wait-for-sitdown")
    self.tooltipTitle = tooltipTitle
    self.tooltipText = tooltipText
    self.clickWarningMessage = clickWarningMessage
end
function cl:Cancel_PromptUser()
    if self.linkActive then return end
    self.waitingPromptedAction = false
    d.print("clickableLink: canceled wait-for-sitdown")
    self.tooltipTitle = nil
    self.tooltipText = nil
    self.clickWarningMessage = nil
end
-- _______________________________


-- _____________________________ LinkDisable-Delayer _____________________________
local THRESHOLD_DIVIDER = 5
local THRESHOLD = 1
local delayerFrame = CreateFrame("Frame")
-- set it to 120 default for now. maybe add adjuster to configpanel later
local delay = 120
function cl:StartLinkDisableDelayer()
    -- local teeburu = self.savedVarTable
    -- local reference = self.reference
    -- local delay = teeburu[reference]
    self.delayerActive = true
    LU.SingleDelayer(delay, 0, THRESHOLD, delayerFrame, function(remainingDelay)
        if remainingDelay > 0 then
            self.remainingDelay = remainingDelay
            d.print("clickableLink: Delay remaining: ", LU.SimplifyFloat(remainingDelay, 0))
        end
    end, function()
        d.print("clickableLink: Delay ended. Disabling link.")
        self:ClearLink()
        self:ResetDelayer()
    end)
end

function cl:ResetDelayer()
    self.delayerActive = false
    self.remainingDelay = nil
    delayerFrame:SetScript("OnUpdate", nil)
end

function cl:PauseLinkDisableDelayer()
    delayerFrame:SetScript("OnUpdate", nil)
    if self.remainingDelay then
        d.print("clickableLink: Still have delay leftover: ", self.remainingDelay)
    end      
end
function cl:ContinueLinkDisableDelayer()
    if not self.remainingDelay then return end
    d.print("clickableLink: Continuing delay where left off", self.remainingDelay)
    local delay = self.remainingDelay
    LU.SingleDelayer(delay, 0, THRESHOLD, self, function(remainingDelay)
        if remainingDelay > 0 then
            self.remainingDelay = remainingDelay
            d.print("clickableLink: (Continue) Delay remaining: ", remainingDelay)
        end
    end, function()
        d.print("clickableLink: (Continue) Delay ended. Hiding Frame.")
        self:ClearLink()
        self:ResetDelayer()
    end)
end
-- _______________________________________________________________________________


local function cl_OnEvent(self, event, unit, ...)
    if not self.initiated then return end
    local arg4, arg5 = ...
    event, unit, arg4, arg5 = LSec.ScrubSecret(event, unit, arg4, arg5)
    if event == "PLAYER_REGEN_DISABLED" then
        -- Button activated --> player entered combat while active
        if cl.linkActive and cl.delayerActive then
            cl:PauseLinkDisableDelayer()
            d.print("clickableLink: Disabling temporarily due to combat")
        end
    elseif event == "PLAYER_REGEN_ENABLED" then
        -- "SetToSendMessageToChannelIndex" function was called during combat, and now there are buffers waiting to be processed
        if cl:ValidateBuffers() then
            d.print("clickableLink: \"SetTo\" function was called during combat")
                cl:ActivateWithLink()
        -- Hide delay was ongoing when entering combat, and no new "SetToSendMessageToChannelIndex" function to overwrite it was called
        elseif cl.delayerActive then
            d.print("clickableLink: Remainder delay was not reset. Show and continue.")
            cl:ContinueLinkDisableDelayer()
        elseif cl.waitingPromptedAction then
            d.print("clickableLink: Was waiting for sitdown. Continue waiting.")
        end
    end
end
local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("PLAYER_REGEN_DISABLED")
eventFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
eventFrame:SetScript("OnEvent", cl_OnEvent)




    -- Numy snippet @Numdelicious
-- for _, frameName in pairs(CHAT_FRAMES) do
    -- local frame = _G[frameName];
    -- self:SecureHookScript(frame, "OnHyperlinkEnter");
    -- self:SecureHookScript(frame, "OnHyperlinkLeave");
-- end
-- self:SecureHook('FloatingChatFrame_SetupScrolling', function(frame)
--     self:SecureHookScript(frame, 'OnHyperlinkEnter');
--     self:SecureHookScript(frame, 'OnHyperlinkLeave');
-- end);
-- if Chattynator and Chattynator.API and Chattynator.API.GetHyperlinkHandler and Chattynator.API.GetHyperlinkHandler() then
--     self:SecureHookScript(Chattynator.API.GetHyperlinkHandler(), 'OnHyperlinkEnter');
--     self:SecureHookScript(Chattynator.API.GetHyperlinkHandler(), 'OnHyperlinkLeave');
-- end