local LU = LegolandoUtil
local LM = LU.Map
local LC = LU.Chat
local LSec = LU.Secret


local DEBUGGING = false
local d = LU.Debug.CreateDebugHandler(DEBUGGING)
local addonName, camp = ...
local pr = camp.pr
pr:RegisterCallback("Camper_Settings_DebugEnabled", function(_, caller)
    d.toggleDebug(true)
end)
pr:RegisterCallback("Camper_Settings_DebugDisabled", function(_, caller)
    d.toggleDebug(false)
end)

--                               ┌────────────────────────────┐                                                    
--  _____________________________│ Current Logical Structure: │_____________________________                       
--                               └────────────────────────────┘                                                    
                                                                                                                    
--  External Events(that trigger from outside of the file)                                                         
--  ──────────────────────────────────────────────────────                                                         
                                                                                                                    
--    Player enters camp range                                                                                     
--     - :Start_PromptUser()  Desaturate button. Set tooltip to 'wait for /sit'. If not in combat, Show()       
                                                                                                                    
--    Player leaves camp range                                                                                     
--      - :Cancel_PromptUser() Saturate button. Remove tooltip. If not in combat, Hide()                        
                                                                                                                    
--    Player casts "Set Campfire"                                                                                  
--      - :Cancel_PromptUser() Saturate button. Remove tooltip.                                                 
                                                                                                                    
--      - :SetToPlayerSetupCamp()────────┐                                                                         
--                                       └─► if not in combat: ActivateWithAttributes()                            
                                                                                                                    
--    Player sits down(while within camp range)                                                                    
                                                                                                                    
--      - if waiting for sit: :SetToPlayerFoundCamp()                                                              
                                                                                                                    
                                                                                                                    
--  Internal(?) Events(actual WOW API events)                                                                      
--  ─────────────────────────────────────────                                                                      
                                                                                                                    
--    PLAYER_REGEN_DISABLED                                                                                        
--     - if shown: :Hide()                                                                                         
                                                                                                                    
--    PLAYER_REGEN_ENABLED                                                                                         
--     1) :SetToPlayerSetupCamp() OR :SetToPlayerFoundCamp() called during combat.(macrobody is in the buffer)     
--       - ActivateWithAttributes()                                                                                
                                                                                                                    
--     2) Delay remains                                   -                                                        
--       - Show(), which will continue the remainder delay                                                         
                                                                                                                    
--     3) Waiting for SitDown is in effect                                                                         
--       - Show(), which will continue waiting for sitdown                                                         
                                                                                                                    
--     4) Neither                                                                                                  
--       - do nothing                                                                                              
--  ________________________________________________________________________________________                       
                                                                                                                    

local T = Camper_Translate





Camper_SendChatMsgSecureActionButtonMixin = {}

local initiated = false
function Camper_SendChatMsgSecureActionButtonMixin:Init()
    local teeburu = self.savedVarTable
    local reference = self.reference
    if not teeburu or not reference then
        print("no saved variable or reference")
        return
    end
    -- no need to save teeburu[reference] as a value, we'll need it to be dynamic
    d.tableToString(teeburu)
    
    initiated = true
end

function Camper_SendChatMsgSecureActionButtonMixin:OnLoad()
    self.icon:SetSize(48, 48)
    self.icon:SetTexture("Interface/AddOns/Camper/images/campericon.png")
    self.title:SetText(T["Announce Camp!"])
    
    self:SetAttribute("type", "macro")
    self:RegisterForClicks("AnyDown", "AnyUp")
    
    self:SetMovable(true)
    self:RegisterForDrag("LeftButton")
    
    self:RegisterEvent("PLAYER_REGEN_DISABLED")
    self:RegisterEvent("PLAYER_REGEN_ENABLED")
end


function Camper_SendChatMsgSecureActionButtonMixin:IsTesting()
    if CamperDebug.checkboxes.simulationEnabled or CamperDebug.checkboxes.spellTester then return true end
    return false
end

--___________________________ Buffers ___________________________
function Camper_SendChatMsgSecureActionButtonMixin:ClearBuffers()
    self.activationMessageBuffer = nil
    self.macroTextBuffer = nil
    self.tooltipTitleBuffer = nil
    self.tooltipTextBuffer = nil
end
function Camper_SendChatMsgSecureActionButtonMixin:ValidateBuffers()
    if not self.activationMessageBuffer then return false, "activationMessageBuffer" end
    if not self.macroTextBuffer then return false, "macroTextBuffer" end
    if not self.tooltipTitleBuffer then return false, "tooltipTitleBuffer" end
    if not self.tooltipTextBuffer then return false, "tooltipTextBuffer" end
    return true
end
function Camper_SendChatMsgSecureActionButtonMixin:ActivateBuffers()
    self.activationMessage = self.activationMessageBuffer
    self:SetAttribute("macrotext", self.macroTextBuffer)
    self.tooltipText = self.tooltipTextBuffer
    self.tooltipTitle = self.tooltipTitleBuffer
end
--_______________________________________________________________
function Camper_SendChatMsgSecureActionButtonMixin:ActivateWithAttributes()
    d.print("secureaction_chat: ActivateWithAttributes called")
    if not initiated then return end
    local valid, missing = self:ValidateBuffers()
    if not valid then
        print("Camper_SendChatMsgSecureActionButton: Buffer missing: ", missing)
        self:ClearBuffers()
        return 
    end
    if InCombatLockdown() then return end
    self:ActivateBuffers()
    self:ClearBuffers()
    self:Show()
    print(self.activationMessage)
    self:StartHideDelayer()
    self.attributesActive = true
end

function Camper_SendChatMsgSecureActionButtonMixin:ClearAttributes()
    if not initiated then return end
    self:SetAttribute("macrotext", "")
    self:ClearBuffers()
    self.tooltipTitle = nil
    self.activationMessage = nil
    self.tooltipText = nil
    self.attributesActive = false
end



-- _____________________________________ Setup/Found Camp _____________________________________
local macroEndSnippet = "\n/script PlaySound(5274)"
.. "\n/script Camper_SendChatMsgSecureActionButton:MacroSuccessful()"
function Camper_SendChatMsgSecureActionButtonMixin:SetToSendMessageToChannelIndex(message_activation, channelIndex, message_send, tooltipTitle, tooltipText)
    d.print("secureaction_chat: SetToSendMessageToChannelIndex called, channelIndex:", channelIndex, "message:", message_send, "Tootlip: ", tooltipTitle, tooltipText)
    if not initiated then return end
    if not channelIndex or not message_send then return end
    local macroText = "/c " .. channelIndex .. " " .. message_send .. macroEndSnippet
    if self:IsTesting() then macroText = "/s " .. message_send .. macroEndSnippet end
    self.activationMessageBuffer = message_activation
    self.macroTextBuffer = macroText
    self.tooltipTitleBuffer = tooltipTitle
    self.tooltipTextBuffer = tooltipText
    if not InCombatLockdown() then
        self:ActivateWithAttributes()
    end
end
-- ____________________________________________________________________________________________



-- _____ Waiting For SitDown _____
-- APPENDED - Does NOT OVERWRITE SecureAction's OnClick
function Camper_SendChatMsgSecureActionButtonMixin:PostClick(button, down)
    if button ~= "LeftButton" or down == true then return end
    if not self.waitingPromptedAction then return end
    local warning = self.clickWarningMessage
    if not warning then return end
    print(warning)
end


function Camper_SendChatMsgSecureActionButtonMixin:Start_PromptUser(tooltipTitle, tooltipText, clickWarningMessage)
    if self.attributesActive then return end
    self.waitingPromptedAction = true
    d.print("secureaction_chat: started wait-for-sitdown")
    self:DesaturateHierarchy(1)
    if not InCombatLockdown() then 
        self:Show()
    end
    self.tooltipTitle = tooltipTitle
    self.tooltipText = tooltipText
    self.clickWarningMessage = clickWarningMessage
end
function Camper_SendChatMsgSecureActionButtonMixin:Cancel_PromptUser()
    if self.attributesActive then return end
    self.waitingPromptedAction = false
    d.print("secureaction_chat: canceled wait-for-sitdown")
    self:DesaturateHierarchy(0)
    if not InCombatLockdown() then 
        self:Hide()
    end
    self.tooltipTitle = nil
    self.tooltipText = nil
    self.clickWarningMessage = nil
end
-- _______________________________






local hideTimerMessage = T["Hiding in: "]
-- _____________________________ Hide-Delayer _____________________________
local THRESHOLD_DIVIDER = 5
local THRESHOLD = 1
function Camper_SendChatMsgSecureActionButtonMixin:StartHideDelayer()
    local teeburu = self.savedVarTable
    local reference = self.reference
    local delay = teeburu[reference]
    self.delayerActive = true
    self.hideTimer:SetText(hideTimerMessage .. delay)
    LU.SingleDelayer(delay, 0, THRESHOLD, self, function(remainingDelay)
        if remainingDelay > 0 then
            d.print("secureaction_chat: Delay remaining: ", LU.SimplifyFloat(remainingDelay, 0))
            self.hideTimer:SetText(hideTimerMessage .. LU.SimplifyFloat(remainingDelay, 0))
        end
    end, function()
        d.print("secureaction_chat: Delay ended. Hiding Frame.")
        self:ClearAttributes()
        self:Hide()
        self:ResetDelayer()
    end)
end

function Camper_SendChatMsgSecureActionButtonMixin:ResetDelayer()
    self.delayerActive = false
    self.hideTimer:SetText(nil)
    self:SetScript("OnUpdate", nil)
end

-- ___MAYBE NOT NEEDED__
-- function Camper_SendChatMsgSecureActionButtonMixin:PauseHideDelayer()
--     self:SetScript("OnUpdate", nil)
--     if self.remainingDelay then
--         d.print("secureaction_chat: Still have delay leftover: ", self.remainingDelay)
--     end      
-- end
-- function Camper_SendChatMsgSecureActionButtonMixin:ContinueHideDelayer()
--     if not self.remainingDelay then return end
--     self:Show()WW
--     d.print("secureaction_chat: Continuing delay where left off", self.remainingDelay)
--     local delay = self.remainingDelay
--     local threshold = delay / THRESHOLD_DIVIDER
--     LU.SingleDelayer(delay, 0, threshold, self, function(remainingDelay)
--         if remainingDelay > 0 then
--             self.remainingDelay = remainingDelay
--             d.print("secureaction_chat: (Continue) Delay remaining: ", remainingDelay)
--         end
--     end, function()
--         d.print("secureaction_chat: (Continue) Delay ended. Hiding Frame.")
--         self.remainingDelay = nil
--         self:Hide()
--     end)
-- end
-- _____________________
-- ________________________________________________________________________


function Camper_SendChatMsgSecureActionButtonMixin.OnEvent(self, event, unit, ...)
    if not initiated then return end
    local arg4, arg5 = ...
    event, unit, arg4, arg5 = LSec.ScrubSecret(event, unit, arg4, arg5)
    if event == "PLAYER_REGEN_DISABLED" then
        -- Button activated --> player entered combat while active
        if self:IsShown() then
            self:Hide()
            d.print("secureaction_chat: Hiding due to combat")
        end
    elseif event == "PLAYER_REGEN_ENABLED" then
        -- "SetToSendMessageToChannelIndex" function was called during combat, and now there are buffers waiting to be processed
        if self:ValidateBuffers() then
            d.print("secureaction_chat: \"SetTo\" function was called during combat")
                self:ActivateWithAttributes()
        -- Hide delay was ongoing when entering combat, and no new "SetToSendMessageToChannelIndex" function to overwrite it was called
        elseif self.delayerActive then
            d.print("secureaction_chat: Remainder delay was not reset. Show and continue.")
            self:Show()
        elseif self.waitingPromptedAction then
            d.print("secureaction_chat: Was waiting for sitdown. Show and continue.")
            self:Show()
        end
    end
end

function Camper_SendChatMsgSecureActionButtonMixin:OnShow()
    -- bugs out in "PUSHED" state if player's ActionButtonUseKeyDown is set to 1, so we reset it here
    self:SetButtonState("NORMAL")
end

function Camper_SendChatMsgSecureActionButtonMixin:OnHide()
    
end

function Camper_SendChatMsgSecureActionButtonMixin:MacroSuccessful()
    d.print("secureaction_chat: MACRO SUCCESSFUL!", self:GetDebugName())
    self:ResetDelayer()
    self:ClearAttributes()
    self:Hide()
end

function Camper_SendChatMsgSecureActionButtonMixin:OnDragStart(button)
    self:StartMoving()
    self.title:Hide()
    -- reusableTooltip:Hide()
end

function Camper_SendChatMsgSecureActionButtonMixin:OnDragStop(button)
    self:StopMovingOrSizing()
    self.title:Show()
end
