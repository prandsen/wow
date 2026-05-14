local GlobalAddonName = ...

---@class AddonDB
local AddonDB = select(2, ...)

if not AddonDB.is12 then return end

local MRT = GMRT
---@class Locale
local LR = AddonDB.LR

---@class BossModPrototype
---@field version number?
---@field encounterID number
---@field name string
---@field onEncounterStart fun(self:BossMod, encounterID:number, encounterName:string, difficultyID:number, groupSize:number)
---@field onEventAdded fun(self:BossMod, event:EncounterEvent)
---@field onEventStateChanged fun(self:BossMod, event:EncounterEvent, newState:number)
---@field onEventRemoved fun(self:BossMod, event:EncounterEvent)
---@field onEncounterWarning fun(self:BossMod, info:EncounterWarningData)?
---@field onStageChanged fun(self:BossMod, newStage:number)?
---@field onUnitEngage fun(self:BossMod)?
---@field logUNIT_SPELLCAST_SUCCEEDED boolean?
---@field logUNIT_SPELLCAST_START boolean?
---@field logUNIT_AURA boolean?
---@field UNIT_AURA_FILTER string? # by defualt "HARMFUL", used to filter auras in UNIT_AURA event when logging
---@field s table<string, number> # spellIDs used in this boss mod
---@field sorted_s nil|fun(self:BossMod):table<number|string> # returns a sorted list of spellIDs and phase markers (strings) used in this boss mod, used for UI display
---@field overrideStageEvents boolean? # if true, other modules should ignore stage changes from BW/DBM

---@class BossMod: BossModPrototype
---@field GetEncounterTime fun(self):number
---@field IsTimeEqual fun(self, time1:number, time2:number, withinMargin?:number):boolean # default margin is 0.1 second
---@field encounterStartTime number?
---@field lastAddedEvent EncounterEvent?
---@field lastStateChangedEvent EncounterEvent?
---@field lastRemovedEvent EncounterEvent?
---@field SetSpellID fun(self, event:EncounterEvent, spellID:number)
---@field currentStage number
---@field currentStageChangedAt number?
---@field SetStage fun(self, stage:number)
---@field GetStage fun(self):number
---@field GetStageTime fun(self):number
---@field SetNoteStage fun(self, stage:number)
---@field GetNoteStage fun(self):number
---@field GetNoteStageTime fun(self):number
---@field spellCounts table<number, number>?
---@field IncreaseSpellCount fun(self, spellID:number):number
---@field GetSpellCount fun(self, spellID:number):number
---@field ResetSpellCount fun(self, spellID:number)
---@field ResetAllSpellCounts fun(self)
---@field Schedule fun(self, delay:number, func:function, ...):FunctionContainer
---@field CheckEventForCallbacks fun(self, event:EncounterEvent)
---@field EventsRemovedInLast fun(self, seconds:number):number
---@field IterateEvents fun(self):fun():EncounterEvent
---@field IncreaseDurationCount fun(self, duration:number, margin?:number):number
---@field ResetDurationCounts fun(self)

---@alias StateText '|cff00ff88RUNNING|r' | '|cff0088ffPAUSED|r' | '|cffffff00FINISHED|r' | '|cffff0000CANCELED|r'

---@class EncounterEventPrototype
---@field IsRunning fun(self):boolean
---@field IsPaused fun(self):boolean
---@field IsFinished fun(self):boolean
---@field IsCanceled fun(self):boolean
---@field GetSpellID fun(self):number?
---@field SinceAdded fun(self):number
---@field SinceRemoved fun(self):number
---@field IsValid fun(self):boolean
---@field GetRemainingTime fun(self):number?
---@field CancelEvent fun(self) # state_changed for this event will be ignored

---@class EncounterEvent: EncounterEventPrototype
---@field addedAt number
---@field eventNum number
---@field eventID number
---@field spellId number
---@field spellName string
---@field iconId number
---@field duration number
---@field state number
---@field stateText StateText
---@field removed boolean?
---@field removedAt number?
---@field declassifiedSpellID number?
---@field count number?
---@field track number?
---@field validated boolean?
---@field fakeEvent boolean?

---@class EncounterWarningData
---@field severity number # non secret
---@field duration number # non secret
---@field shouldPlaySound boolean # non secret
---@field shouldShowChatMessage boolean # non secret
---@field shouldShowWarning boolean # non secret
---@field iconFileID number # secret
---@field tooltipSpellID number # secret
---@field text string # secret
---@field isDeadly boolean # secret
---@field targetName string # secret
---@field casterName string # secret
---@field targetGUID string # secret
---@field casterGUID string # secret

---@class EncounterTimelineEventInfoInternal
---@field id number # Instance ID for this event
---@field source number # Source that this event came from
---@field spellName string # `secret` Spell name associated with this event. For script events, this may instead be the contents of the 'overrideName' field if it wasn't empty
---@field spellID number # `secret` Spell ID associated with this event
---@field iconFileID number # `secret` Icon file ID associated with this event
---@field duration number # Base duration of this event at the point that it was queued onto the timeline
---@field maxQueueDuration number # Hold duration for this event after it reaches the end of the timeline. During this period, the event will sit in the queued track of the timeline until manually finished or this added duration expires
---@field icons number # `secret` Bitmask of active icon states for this event
---@field severity number # `secret` Severity of this event
---@field isApproximate boolean # `secret` If true, this event is an approximation and may not occur exactly when the timeline suggests it will
---@field fakeEvent boolean # If true, this event was added via the Timeline Parser API and is not part of the encounter timeline data

---@class TimelineParser
---@field log table<number, table>
---@field bossMods table<number|string, BossMod> # key is encounterID or "encounterID_difficultyID"
---@field RegisterBossMod fun(self:TimelineParser, bossMod:BossModPrototype)
---@field ExportLog fun(self:TimelineParser)
---@field logWindow Frame
---@field encounterID number?
---@field encounterName string?
---@field difficultyID number?
---@field groupSize number?
---@field events table<number, EncounterEvent>?
---@field eventIDToEvent table<number, EncounterEvent>?
---@field removedEvents table<number, EncounterEvent>?
---@field bossMod BossMod?
---@field HandlesStageEvents fun(self:TimelineParser, encounterID:number, difficultyID:number):boolean # returns true if the boss mod for the given encounter/difficulty has overrideStageEvents set to true, meaning that other modules should ignore stage changes from BW/DBM for this encounter/difficulty
local TimelineParser = CreateFrame("Frame")
AddonDB.TimelineParser = TimelineParser

TimelineParser.C = {}

TimelineParser.C.EVENT_ADDED = "|cff00ff88EVENT_ADDED|r"
TimelineParser.C.EVENT_STATE_CHANGED = "|cffffff00EVENT_CHANGED|r"
TimelineParser.C.EVENT_REMOVED = "|cffff0000EVENT_REMOVED|r"

TimelineParser.C.STATE_RUNNING = "|cff00ff88RUNNING|r"
TimelineParser.C.STATE_PAUSED = "|cff0088ffPAUSED|r"
TimelineParser.C.STATE_FINISHED = "|cffffff00FINISHED|r"
TimelineParser.C.STATE_CANCELED = "|cffff0000CANCELED|r"
TimelineParser.C.STATE_UNKNOWN = "|cff880088UNKNOWN|r"

TimelineParser.log = {}
function TimelineParser:Log(...)
	self.log[#self.log+1] = { GetTime(), ... }
end

local function LogForSpell(spellID, icon, name)
	if not spellID then
		return "|cffff0000<no spellID>|r"
	end
	if not icon then
		icon = C_Spell.GetSpellTexture(spellID) or "unknown"
	end

	if not name then
		name = C_Spell.GetSpellName(spellID) or "unknown"
	end

	local secretText = issecretvalue(spellID) and "|cffff8800<s>|r" or ""
	return secretText .. " |T" .. (icon or "") .. ":0|t " .. name  .. " (" .. spellID .. ")"
end

local function LogForSpellEvent(event)
	return LogForSpell(event.declassifiedSpellID or event.spellId, event.iconId, event.spellName)
end

function TimelineParser:LogForSpellEvent(event)
	return LogForSpellEvent(event)
end

-- local trackNames = {}
-- for k, v in pairs(Enum.EncounterTimelineTrack) do
-- 	trackNames[v] = k
-- end
-- local function LogEventTrack(track)
-- 	if not track then return "<no track>" end
-- 	if issecretvalue(track) then
-- 		return "|cffff8800<s>" .. track .. "|r"
-- 	end
-- 	return trackNames[track] or ("<unknown track " .. tostring(track) .. ">")
-- end

local function BoolToStr(value)
	local res = tostring(value)
	local prefix = issecretvalue(value) and "|cffff8800<s>|r" or "|cffffffff"
	return prefix .. res .. "|r"
end

local function concat_all(...)
	local res = ""
	local totalVarargs = select("#", ...)
	for i = 1, totalVarargs do
		local v = select(i, ...)
		if type(v) == "boolean" then
			v = BoolToStr(v)
		end
		if type(v) == "nil" then
			v = "<nil?>"
		end
		res = res .. tostring(v)
		if i ~= totalVarargs then
			res = res .. " "
		end
	end
	return res
end

local function FormatTime(t)
	return format("%02d:%02d.%03d", t/60, t%60, t%1*1000)
end

local function stripColorCodes(str)
	return str:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", "")
end

local function trailingSpaces(str, totalLength)
	local currentLength = #stripColorCodes(str)
	if currentLength >= totalLength then
		return str
	end
	return str .. string.rep(" ", totalLength - currentLength)
end

---@param event EncounterEvent
---@return number
local function GetEventTimeRemaining(event)
	if event.fakeEvent then
		return event.duration - (GetTime() - event.addedAt)
	else
		return C_EncounterTimeline.GetEventTimeRemaining(event.eventID)
	end
end

---@param event EncounterEvent
---@return number
local function GetEventState(event)
	if event.fakeEvent then
		return event.state or 0
	else
		return C_EncounterTimeline.GetEventState(event.eventID)
	end
end

-- /tmlnexport slash command
SlashCmdList["TMLNEXPORT"] = function()
	TimelineParser:ExportLog()
end
SLASH_TMLNEXPORT1 = "/tmlnexport"

local seenLogEvents = {}
local logEventsFilter = {
	AURA_ADDED = true,
	USC_START = true,
	USC_SUCC = true,
}
function TimelineParser:ExportLog(doStartAutoScroll)
	local log = {}
	local timeOffset = 0
	local stageOffset = 0
	for i, entry in ipairs(self.log) do
		local event = entry[2]
		seenLogEvents[event] = true
		if event == "BOSS_PULL" then
			timeOffset = entry[1]
			stageOffset = entry[1]
		elseif event == "SET_STAGE" then
			stageOffset = entry[1]
		end
		if not logEventsFilter[event] then
			log[#log + 1] = FormatTime(entry[1] - timeOffset) .. " " .. FormatTime(entry[1] - stageOffset) .. " " .. trailingSpaces(event, 14) .. concat_all(unpack(entry, 3))
		end
	end

	if not self.logWindow then
		local SharedMedia = LibStub("LibSharedMedia-3.0")
		local monoFont = SharedMedia:Fetch("font", "Fira Mono Medium")

		local function ScrollListLineEnter(self)
			GameTooltip:SetOwner(self, "ANCHOR_CURSOR_RIGHT")
			GameTooltip:SetText(self.text:GetText(), 1, 1, 1, 1)
			GameTooltip:Show()

			local mainFrame = self.mainFrame
			if mainFrame.HoverListValue then
				mainFrame:HoverListValue(true,self.index,self)
				mainFrame.HoveredLine = self
			end

			if mainFrame.EnableHoverAnimation then
				if not self.anim then
					self.anim = self:CreateAnimationGroup()
					self.anim:SetLooping("NONE")
					self.anim.timer = self.anim:CreateAnimation()
					self.anim.timer:SetDuration(.25)
					self.anim.timer.line = self
					self.anim.timer.main = mainFrame
					self.anim.timer:SetScript("OnUpdate", function(self,elapsed)
						local p = self:GetProgress()
						local cR,cG,cB,cA = self.fR + (self.tR - self.fR) * p, self.fG + (self.tG - self.fG) * p, self.fB + (self.tB - self.fB)* p, self.fA + (self.tA - self.fA) * p
						self.cR, self.cG, self.cB, self.cA = cR,cG,cB,cA
						self.line.AnimTexture:SetColorTexture(cR,cG,cB,cA)
					end)
					self.HighlightTexture:SetVertexColor(0,0,0,0)
					self.anim.timer.cR, self.anim.timer.cG, self.anim.timer.cB, self.anim.timer.cA = .5, .5, .5, .2

					self.anim:SetScript("OnFinished", function(self, requested)
						if self.timer.HideOnEnd then
							local t = self:GetParent().AnimTexture
							t:Hide()
							t:SetColorTexture(.5, .5, .5, .2)
							self.timer.cR, self.timer.cG, self.timer.cB, self.timer.cA = .5, .5, .5, .2
						end
					end)

					self.AnimTexture = self:CreateTexture()
					self.AnimTexture:SetPoint("LEFT",0,0)
					self.AnimTexture:SetPoint("RIGHT",0,0)
					self.AnimTexture:SetHeight(mainFrame.LINE_TEXTURE_HEIGHT or 15)
					self.AnimTexture:SetColorTexture(self.anim.timer.cR, self.anim.timer.cG, self.anim.timer.cB, self.anim.timer.cA)
				end
				if self.anim:IsPlaying() then
					self.anim:Stop()
				end
				local t = self.anim.timer
				t.fR, t.fG, t.fB, t.fA = t.cR, t.cG, t.cB, t.cA
				if mainFrame.LINE_TEXTURE_COLOR_HL then
					t.tR, t.tG, t.tB, t.tA = unpack(mainFrame.LINE_TEXTURE_COLOR_HL)
				else
					t.tR, t.tG, t.tB, t.tA = 1, 1, 1, 1
				end
				t.HideOnEnd = false
				self.anim:Play()
				self.AnimTexture:Show()
			end
		end
		local function ScrollListLineLeave(self)
			GameTooltip:Hide()

			local mainFrame = self.mainFrame
			if mainFrame.HoverListValue then
				mainFrame:HoverListValue(false,self.index,self)
			end
			mainFrame.HoveredLine = nil

			if mainFrame.EnableHoverAnimation then
				if self.anim:IsPlaying() then
					self.anim:Stop()
				end
				local t = self.anim.timer
				t.fR, t.fG, t.fB, t.fA = t.cR, t.cG, t.cB, t.cA
				t.tR, t.tG, t.tB, t.tA = .5, .5, .5, 0
				t.HideOnEnd = true
				self.anim:Play()
			end
		end
		local function ScrollList_AddLine(self,i)
			local line = CreateFrame("Button",nil,self.Frame.C)
			self.List[i] = line
			line:SetPoint("TOPLEFT",0,-(i-1)*(self.LINE_HEIGHT or 16))
			line:SetPoint("BOTTOMRIGHT",self.Frame.C,"TOPRIGHT",0,-i*(self.LINE_HEIGHT or 16))

			if not self.T then
				line.text = ELib:Text(line,"List"..tostring(i),self.fontSize or 12):Point("LEFT",(self.isCheckList and 24 or 3)+(self.LINE_PADDING_LEFT or 0),0):Point("RIGHT",-3,0):Size(0,self.LINE_HEIGHT or 16):Color():Shadow()
				if self.fontName then
					line.text:Font(self.fontName,self.fontSize or 12)
				end
				line:SetFontString(line.text)
				line.text:SetFont(monoFont, self.fontSize or 12, "")
				line:SetPushedTextOffset(2, -1)
			end

			line.background = line:CreateTexture(nil, "BACKGROUND")
			line.background:SetPoint("TOPLEFT")
			line.background:SetPoint("BOTTOMRIGHT")

			line.HighlightTexture = line:CreateTexture()
			line.HighlightTexture:SetTexture(self.LINE_TEXTURE or "Interface\\QuestFrame\\UI-QuestLogTitleHighlight")
			if not self.LINE_TEXTURE_IGNOREBLEND then
				line.HighlightTexture:SetBlendMode("ADD")
			end
			line.HighlightTexture:SetPoint("LEFT",0,0)
			line.HighlightTexture:SetPoint("RIGHT",0,0)
			line.HighlightTexture:SetHeight(self.LINE_TEXTURE_HEIGHT or 15)
			if self.LINE_TEXTURE_COLOR_HL then
				line.HighlightTexture:SetVertexColor(unpack(self.LINE_TEXTURE_COLOR_HL))
			else
				line.HighlightTexture:SetVertexColor(1,1,1,1)
			end
			line:SetHighlightTexture(line.HighlightTexture)

			line.PushedTexture = line:CreateTexture()
			line.PushedTexture:SetTexture(self.LINE_TEXTURE or "Interface\\QuestFrame\\UI-QuestLogTitleHighlight")
			if not self.LINE_TEXTURE_IGNOREBLEND then
				line.PushedTexture:SetBlendMode("ADD")
			end
			line.PushedTexture:SetPoint("LEFT",0,0)
			line.PushedTexture:SetPoint("RIGHT",0,0)
			line.PushedTexture:SetHeight(self.LINE_TEXTURE_HEIGHT or 15)
			if self.LINE_TEXTURE_COLOR_P then
				line.PushedTexture:SetVertexColor(unpack(self.LINE_TEXTURE_COLOR_P))
			else
				line.PushedTexture:SetVertexColor(1,1,0,1)
			end
			line:SetDisabledTexture(line.PushedTexture)

			line.iconRight = line:CreateTexture()
			line.iconRight:SetPoint("RIGHT",-3,0)
			line.iconRight:SetSize(self.LINE_HEIGHT or 16,self.LINE_HEIGHT or 16)

			line.mainFrame = self
			line.id = i
			line:SetScript("OnEnter",ScrollListLineEnter)
			line:SetScript("OnLeave",ScrollListLineLeave)

			return line
		end
		local function Widget_Update(self)
			local val = floor(self.Frame.ScrollBar:GetValue() / (self.LINE_HEIGHT or 16)) + 1
			local j = 0
			for i=val,#self.L do
				j = j + 1
				local line = self.List[j]
				if not line then
					line = ScrollList_AddLine(self,j)
				end
				if not self.T then
					if type(self.L[i]) == "table" then
						line.text:SetText(self.L[i][1])
						line.text:SetWordWrap(false)
					else
						line.text:SetText(self.L[i])
						line.text:SetWordWrap(false)
					end
				else
					for k=1,#self.T do
						line['text'..k]:SetText(self.L[i][k] or "")
					end
				end
				if self.isCheckList then
					line.chk:SetChecked(self.C[i])
				elseif not self.T then
					if not self.dontDisable then
						if i ~= self.selected then
							line:SetEnabled(true)
							line.ignoreDrag = false
						else
							line:SetEnabled(nil)
							line.ignoreDrag = true
						end
					end
					if self.LDisabled then
						if self.LDisabled[i] then
							line:SetEnabled(false)
							line.ignoreDrag = true
							line.text:Color(.5,.5,.5,1)
							line.PushedTexture:SetAlpha(0)
						else
							line.text:Color()
							line.PushedTexture:SetAlpha(1)
						end
					end
				end
				if self.IconsRight then
					local icon = self.IconsRight[i]
					if type(icon)=='table' then
						if icon.isAtlas then
							line.iconRight:SetAtlas(icon[1])
						else
							line.iconRight:SetTexture(icon[1])
						end
						if icon[2] then
							line.iconRight:SetSize(icon[2],icon[2])
						end
					elseif icon then
						line.iconRight:SetTexture(icon)
						line.iconRight:SetSize(self.LINE_HEIGHT or 16,self.LINE_HEIGHT or 16)
					else
						line.iconRight:SetTexture("")
					end
				end
				if i % 2 == 0 then
					line.background:SetColorTexture(1, 1, 1, .05)
				else
					line.background:SetColorTexture(0, 0, 0, 0)
				end
				line:Show()
				line.index = i
				line.table = self.L[i]
				if (j >= #self.L) or (j >= self.linesPerPage) then
					break
				end
			end
			for i=(j+1),#self.List do
				self.List[i]:Hide()
			end
			self.Frame.ScrollBar:Range(0,max(0,#self.L * (self.LINE_HEIGHT or 16) - 1 - self:GetHeight()),self.LINE_HEIGHT or 16,true):UpdateButtons()

			if (self:GetHeight() / (self.LINE_HEIGHT or 16) - #self.L) > 0 then
				self.Frame.ScrollBar:Hide()
				self.Frame.C:SetWidth( self.Frame:GetWidth() )
			else
				self.Frame.ScrollBar:Show()
				self.Frame.C:SetWidth( self.Frame:GetWidth() - (self.SCROLL_WIDTH or 16) )
			end

			if self.UpdateAdditional then
				self.UpdateAdditional(self,val)
			end

			if self.HoveredLine then
				local hovered = self.HoveredLine
				ScrollListLineLeave(hovered)
				ScrollListLineEnter(hovered)
			end

			return self
		end

		---@class ELib
		local ELib, L = MRT.lib, MRT.L
		---@class MLib
		local MLib = AddonDB.MLib

		self.logWindow = MLib:Popup(L["Timeline Parser Log"]):Size(1200, 706):CreateTitleBackground(26)

		self.logWindow.scrollFrame = ELib:ScrollList(self.logWindow):Point("TOPLEFT", self.logWindow, "TOPLEFT", 10, -34):Size(1180, 666):HideBorders()
		self.logWindow.scrollFrame.Update = Widget_Update
		self.logWindow.scrollFrame:SetScript("OnShow", Widget_Update)
		self.logWindow.scrollFrame.LINE_HEIGHT = 18

		self.logWindow.scrollFrame.LINE_TEXTURE = "Interface\\Addons\\MRT\\media\\White"
		self.logWindow.scrollFrame.LINE_TEXTURE_IGNOREBLEND = true
		self.logWindow.scrollFrame.LINE_TEXTURE_HEIGHT = 18
		self.logWindow.scrollFrame.LINE_TEXTURE_COLOR_HL = {1,1,1,.5}
		self.logWindow.scrollFrame.LINE_TEXTURE_COLOR_P = {1,.82,0,.6}

		self.logWindow.scrollFrame.Frame.ScrollBar:Size(12, 0)
		self.logWindow.scrollFrame.Frame.ScrollBar.thumb:SetHeight(20)
		MLib:Border(self.logWindow.scrollFrame, 1, .24, .25, .30, 1)

		self.logWindow.filterDropdown = ELib:DropDown(self.logWindow, 200, -1):Size(220,20):Point("TOPLEFT",5,-2):SetText(LR["Filters"])
		function self.logWindow.filterDropdown:SetValue(event, index)
			logEventsFilter[event] = not logEventsFilter[event]
			self.checkButton:SetChecked(not logEventsFilter[event])
			self:GetParent().List[index].checkState = not logEventsFilter[event]
			TimelineParser:ExportLog()
		end
		function self.logWindow.filterDropdown:PreUpdate()
			self.List = {}
			for event in pairs(seenLogEvents) do
				self.List[#self.List+1] = {
					checkable = true,
					text = event,
					arg1 = event,
					arg2 = #self.List+1,
					checkState = not logEventsFilter[event],
					func = self.SetValue
				}
			end
			sort(self.List, function(a,b) return a.text < b.text end)
		end

		local function scrollDown()
			local scrollBar = self.logWindow.scrollFrame.Frame.ScrollBar
			if not scrollBar.GetMinMaxValues then scrollBar = scrollBar.slider end
			local min,max = scrollBar:GetMinMaxValues()
			local val = scrollBar:GetValue()
			local clickRange = scrollBar.clickRange
			if (val + clickRange) > max then
				scrollBar:SetValue(max)
			else
				scrollBar:SetValue(val + clickRange)
			end
		end

		local function isAtTheBottom()
			local scrollBar = self.logWindow.scrollFrame.Frame.ScrollBar
			if not scrollBar.GetMinMaxValues then scrollBar = scrollBar.slider end
			local min,max = scrollBar:GetMinMaxValues()
			local val = scrollBar:GetValue()
			return (val + 1) >= max
		end

		local function stopAutoScroll()
			self.logWindow:SetScript("OnUpdate", nil)
			if self.logWindow.autoScrollTimer then
				self.logWindow.autoScrollTimer:Cancel()
				self.logWindow.autoScrollTimer = nil
			end
		end

		local function startAutoScroll()
			self.logWindow:SetScript("OnUpdate", function(self, elapsed)
				self.t = (self.t or 0) + elapsed
				if self.t > 0.02 then
					self.t = 0
					scrollDown()
					if isAtTheBottom() then
						stopAutoScroll()
						if self.wasAutoOpened then
							C_Timer.After(1, function()
								self:Hide()
							end)
						end
					end
				end
			end)
		end

		self.logWindow.autoScrollCheckbox = ELib:Check(self.logWindow, "Auto-scroll", VMRT.Reminder.TPAutoScroll):Point("LEFT", self.logWindow.filterDropdown, "RIGHT", 10, 0):OnClick(function(_self)
			VMRT.Reminder.TPAutoScroll = _self:GetChecked() or nil
			if _self:GetChecked() then
				startAutoScroll()
			else
				stopAutoScroll()
			end
		end)

		self.logWindow.autoOpenCheckbox = ELib:Check(self.logWindow, "Auto-open on boss end", VMRT.Reminder.TPAutoOpen):Point("LEFT", self.logWindow.autoScrollCheckbox, "RIGHT", 100, 0):OnClick(function(_self)
			VMRT.Reminder.TPAutoOpen = _self:GetChecked() or nil
		end)

		self.logWindow:HookScript("OnHide", function()
			stopAutoScroll()
			self.logWindow.wasAutoOpened = false
		end)

		function self.logWindow.OnShow()
			if VMRT.Reminder.TPAutoScroll then
				stopAutoScroll()
				self.logWindow.autoScrollTimer = C_Timer.NewTimer(1, startAutoScroll)
			end
		end

		if doStartAutoScroll then
			stopAutoScroll()
			self.logWindow.autoScrollTimer = C_Timer.NewTimer(1, startAutoScroll)
		end
	end

	self.logWindow:Show()
	self.logWindow.scrollFrame.L = log

	-- for i = 1, 500 do
	-- 	log[#log+1] = FormatTime(0) .. " " .. FormatTime(0) .. " " .. trailingSpaces("No log data", 14) .. " No log data " .. i
	-- end

	self.logWindow.scrollFrame:Update()
end

TimelineParser:SetScript("OnEvent", function(self, event, ...)
	self[event](self, ...)
end)

TimelineParser:RegisterEvent("ENCOUNTER_START")
TimelineParser:RegisterEvent("ENCOUNTER_END")
TimelineParser:RegisterEvent("ENCOUNTER_TIMELINE_EVENT_ADDED")
TimelineParser:RegisterEvent("ENCOUNTER_TIMELINE_EVENT_STATE_CHANGED")
TimelineParser:RegisterEvent("ENCOUNTER_TIMELINE_EVENT_REMOVED")
TimelineParser:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT")
-- TimelineParser:RegisterEvent("ENCOUNTER_TIMELINE_EVENT_TRACK_CHANGED")
TimelineParser:RegisterEvent("ENCOUNTER_WARNING")
function TimelineParser:ENCOUNTER_START(encounterID, encounterName, difficultyID, groupSize)
	self.encounterID = encounterID
	self.encounterName = encounterName
	self.difficultyID = difficultyID
	self.groupSize = groupSize

	self.events = {}
	self.eventIDToEvent = {}
	self.removedEvents = {}

	TimelineParser:Log("BOSS_PULL", date("%Y-%m-%d %H:%M:%S"), "ID: " .. encounterID, "Name: " .. encounterName, "diffID: " .. difficultyID, "groupSize: " .. groupSize)

	self.bossMod = self:GetBossMod(encounterID, difficultyID)
	if self.bossMod then
		AddonDB:FireCallback("TimelineParser_EncounterStarted", encounterID, encounterName, difficultyID, groupSize)

		self.bossMod.encounterStartTime = GetTime()
		self.bossMod.spellCounts = {}
		if self.bossMod.onEncounterStart then
			self.bossMod:onEncounterStart(encounterID, encounterName, difficultyID, groupSize)
		end
		if AddonDB.IsDev then
			self:RegisterEvent("UNIT_AURA")
			self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
			self:RegisterEvent("UNIT_SPELLCAST_START")
		else
			if self.bossMod.logUNIT_AURA then
				self:RegisterEvent("UNIT_AURA")
			end
			if self.bossMod.logUNIT_SPELLCAST_SUCCEEDED then
				self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
			end
			if self.bossMod.logUNIT_SPELLCAST_START then
				self:RegisterEvent("UNIT_SPELLCAST_START")
			end
		end
	else
		-- reset stage if no boss mod found
		AddonDB:FireCallback("TimelineParser_StageChanged", 1)
		AddonDB:FireCallback("TimelineParser_NoteStageChanged", 1)
	end
end

function TimelineParser:ENCOUNTER_END(encounterID, encounterName, difficultyID, groupSize, success)
	TimelineParser:Log("BOSS_END", date("%Y-%m-%d %H:%M:%S"), "ID: " .. encounterID, "Name: " .. encounterName, "diffID: " .. difficultyID, "groupSize: " .. groupSize, "success: " .. success)

	if self.bossMod then
	 	if self.bossMod.onEncounterEnd then
			self.bossMod:onEncounterEnd(encounterID, encounterName, difficultyID, groupSize, success)
	 	end
		if self.bossMod.__TIMERS then
			for _, timer in pairs(self.bossMod.__TIMERS) do
				if type(timer) == "userdata" and timer.Cancel then
					timer:Cancel()
				end
			end
			self.bossMod.__TIMERS = nil
		end
		for event in self.bossMod:IterateEvents() do
			if (event:IsRunning() or event:IsPaused()) and event:IsValid() then
				AddonDB:FireCallback("TimelineParser_EventCanceled", event.eventID, event.declassifiedSpellID)
			end
		end
		AddonDB:FireCallback("TimelineParser_EncounterEnded", encounterID, encounterName, difficultyID, groupSize, success)
	end

	self.encounterID = nil
	self.encounterName = nil
	self.difficultyID = nil
	self.groupSize = nil

	self.events = {}
	self.eventIDToEvent = {}
	self.removedEvents = {}

	self.bossMod = nil
	self:UnregisterEvent("UNIT_AURA")
	self:UnregisterEvent("UNIT_SPELLCAST_SUCCEEDED")
	self:UnregisterEvent("UNIT_SPELLCAST_START")
	if VMRT.Reminder.TPAutoOpen then
		self:ExportLog(true)
		self.logWindow.wasAutoOpened = true
		self.logWindow:Show()
	end
end


---@return StateText
local function GetStateText(state)
	if state == 0 then
		return TimelineParser.C.STATE_RUNNING
	elseif state == 1 then
		return TimelineParser.C.STATE_PAUSED
	elseif state == 2 then
		return TimelineParser.C.STATE_FINISHED
	elseif state == 3 then
		return TimelineParser.C.STATE_CANCELED
	else
		return TimelineParser.C.STATE_UNKNOWN .. "(" .. (state or "?") .. ")"
	end
end

local EVENT_PROTOTYPE = {
	__index = {
		IsRunning = function(self)
			return self.state == 0
		end,
		IsPaused = function(self)
			return self.state == 1
		end,
		IsFinished = function(self)
			return self.state == 2
		end,
		IsCanceled = function(self)
			return self.state == 3
		end,
		GetSpellID = function(self)
			return self.declassifiedSpellID
		end,
		SinceAdded = function(self)
			return GetTime() - self.addedAt
		end,
		SinceRemoved = function(self)
			if not self.removedAt then return math.huge end
			return GetTime() - self.removedAt
		end,
		IsValid = function(self)
			return self.validated == true
		end,
		GetRemainingTime = function(self)
			return GetEventTimeRemaining(self)
		end,
		CancelEvent = function(self)
			self.state = 3
			self.stateText = TimelineParser.C.STATE_CANCELED
			self.stateChangedAt = GetTime()
			self.manuallyCanceled = true

			TimelineParser:Log(TimelineParser.C.EVENT_STATE_CHANGED, "#" .. self.eventNum, LogForSpellEvent(self), self.stateText, "(canceled by boss mod)")
			if self.declassifiedSpellID and self:IsValid() then
				AddonDB:FireCallback("TimelineParser_EventCanceled", self.eventID, self.declassifiedSpellID)
			end
		end,
	},
}
local function NewEvent(t)
	return setmetatable(t, EVENT_PROTOTYPE)
end

local EVENT_SOURCE_ENCOUNTER = Enum.EncounterTimelineEventSource.Encounter
local EVENT_SOURCE_TIMELINE_PARSER = -1
---@param eventInfo EncounterTimelineEventInfoInternal
function TimelineParser:ENCOUNTER_TIMELINE_EVENT_ADDED(eventInfo)
	if not self.encounterID then return end
	-- Not Secrets
	local eventID = eventInfo.id
	local source = eventInfo.source
	local duration = eventInfo.duration
	-- local track -- 0 = Queued, 1 = Short, 2 = Medium, 3 = Long, 4 = Indeterminate
	-- local maxQueueDuration = eventInfo.maxQueueDuration

	-- Secrets
	local spellId = eventInfo.spellID
	local spellName = eventInfo.spellName
	local iconId = eventInfo.iconFileID
	-- local isApproximate = eventInfo.isApproximate
	-- local severity = eventInfo.severity
	-- local icons = eventInfo.icons

	if source ~= EVENT_SOURCE_ENCOUNTER and source ~= EVENT_SOURCE_TIMELINE_PARSER then -- Only encounter events are handled, ignore script and editmode events
		return
	end

	local eventNum = #self.events + 1
	---@type EncounterEvent
	local event = NewEvent{
		addedAt = GetTime(),
		eventNum = eventNum,
		eventID = eventID,
		spellId = spellId,
		spellName = spellName,
		iconId = iconId,
		duration = duration,
		-- track = track,
		fakeEvent = eventInfo.fakeEvent,
	}

	event.state = GetEventState(event) -- 0 = Running, 1 = Paused, 2 = Finished, 3 = Canceled
	event.stateText = GetStateText(event.state)

	tinsert(self.events, event)
	self.eventIDToEvent[eventID] = event
	TimelineParser:Log(TimelineParser.C.EVENT_ADDED, "#" .. eventNum, LogForSpellEvent(event), "dur: " .. duration, event.stateText, "icon: " .. iconId)
	if self.bossMod then
		if not issecretvalue(spellId) and spellId then
			self.bossMod:SetSpellID(event, spellId)
		else
			if self.bossMod.onEventAdded then
				self.bossMod:onEventAdded(event)
			end
		end
		self.bossMod.lastAddedEvent = event
	end
end

function TimelineParser:ENCOUNTER_TIMELINE_EVENT_STATE_CHANGED(eventID)
	if not self.encounterID then return end
	local event = self.eventIDToEvent[eventID]
	if not event then
		return
	end

	if event.manuallyCanceled then return end

	local state = GetEventState(event) -- 0 = Running, 1 = Paused, 2 = Finished, 3 = Canceled
	local stateText = GetStateText(state)
	event.state = state
	event.stateText = stateText
	event.stateChangedAt = GetTime()

	TimelineParser:Log(TimelineParser.C.EVENT_STATE_CHANGED, "#" .. event.eventNum, LogForSpellEvent(event), stateText)

	if self.bossMod then
		if self.bossMod.onEventStateChanged then
			self.bossMod:onEventStateChanged(event, state)
		end
		if event.declassifiedSpellID and event:IsValid() then
			if stateText == TimelineParser.C.STATE_PAUSED then
				AddonDB:FireCallback("TimelineParser_EventPaused", eventID, event.declassifiedSpellID)
			elseif stateText == TimelineParser.C.STATE_RUNNING then
				AddonDB:FireCallback("TimelineParser_EventResumed", eventID, event.declassifiedSpellID, GetEventTimeRemaining(event) or 0)
			elseif stateText == TimelineParser.C.STATE_CANCELED or stateText == TimelineParser.C.STATE_FINISHED then
				AddonDB:FireCallback("TimelineParser_EventCanceled", eventID, event.declassifiedSpellID)
				if stateText == TimelineParser.C.STATE_FINISHED then
					AddonDB:FireCallback("TimelineParser_EventFinished", eventID, event.declassifiedSpellID, event.count or 1)
				end
			end
		end
		self.bossMod.lastStateChangedEvent = event
	end
end

function TimelineParser:ENCOUNTER_TIMELINE_EVENT_REMOVED(eventID)
	if not self.encounterID then return end
	local event = self.eventIDToEvent[eventID]
	if not event then
		return
	end

	event.removed = true
	event.removedAt = GetTime()

	local hasSpellID = event.declassifiedSpellID ~= nil
	local eventNum = (hasSpellID and "|cffffffff#" or "|cffff0088#") .. event.eventNum .. "|r"
	TimelineParser:Log(TimelineParser.C.EVENT_REMOVED, eventNum, LogForSpellEvent(event), "sinceAdded: " .. format("%.2f", event.removedAt - event.addedAt))

	tinsert(self.removedEvents, event)

	if self.bossMod then
		if self.bossMod.onEventRemoved then
			self.bossMod:onEventRemoved(event)
		end
		self.bossMod.lastRemovedEvent = event
	end
end

-- we could use this event to filter out fake events from timeline
-- but this event is dependant on various cvars and if timeline is turned off
-- this event doesn't fire at all
-- function TimelineParser:ENCOUNTER_TIMELINE_EVENT_TRACK_CHANGED(eventID)
-- 	if not self.encounterID then return end
-- 	local event = self.eventIDToEvent[eventID]
-- 	if not event then
-- 		return
-- 	end

-- 	local track = C_EncounterTimeline.GetEventTrack(eventID)
-- 	event.track = track

-- 	TimelineParser:Log("TRACK_CHANGED", "#" .. event.eventNum, LogForSpellEvent(event), "new track: " .. LogEventTrack(track))

-- 	local bossMod = self.bossMod
-- 	if bossMod then
-- 		bossMod:CheckEventForCallbacks(event)
-- 	end
-- end

function TimelineParser:ENCOUNTER_WARNING(info)
	if not self.encounterID then return end
	-- non secret
	-- local severity = info.severity
	-- local duration = info.duration
	-- local shouldPlaySound = info.shouldPlaySound
	-- local shouldShowChatMessage = info.shouldShowChatMessage
	-- local shouldShowWarning = info.shouldShowWarning

	-- secret
	-- local icon = info.iconFileID
	-- local spellID = info.tooltipSpellID
	-- local text = info.text
	-- local isDeadly = info.isDeadly
	-- local targetName = info.targetName
	-- local casterName = info.casterName
	-- local targetGUID = info.targetGUID
	-- local casterGUID = info.casterGUID


	TimelineParser:Log("|cffff8800WARNING|r", LogForSpell(info.tooltipSpellID, info.iconFileID),
		"text:", info.text,
		"caster:", info.casterName or "???",
		"target:", info.targetName or "???"
	)
	TimelineParser:Log("|cffff8800WARNING2|r",
		"dur:", info.duration,
		"sev:", info.severity,
		"SPS:", BoolToStr(info.shouldPlaySound),
		"SSCM:", BoolToStr(info.shouldShowChatMessage),
		"SSW:", BoolToStr(info.shouldShowWarning)
	)
	if self.bossMod and self.bossMod.onEncounterWarning then
		self.bossMod:onEncounterWarning(info)
	end
end

function TimelineParser:UNIT_AURA(unit, updateInfo)
	if not self.encounterID then return end
	if updateInfo.addedAuras then
		if (IsInRaid() and not unit:find("^raid")) or (not IsInRaid() and not unit:find("party") and unit ~= "player") then
			return
		end
		for i, auraInfo in ipairs(updateInfo.addedAuras) do
			if not C_UnitAuras.IsAuraFilteredOutByInstanceID(unit, auraInfo.auraInstanceID, self.UNIT_AURA_FILTER or "HARMFUL") then
				local isBoss = not C_UnitAuras.IsAuraFilteredOutByInstanceID(unit, auraInfo.auraInstanceID, "HARMFUL|BOSS")
				local isRaid = not C_UnitAuras.IsAuraFilteredOutByInstanceID(unit, auraInfo.auraInstanceID, "HARMFUL|RAID")
				TimelineParser:Log("AURA_ADDED", LogForSpell(auraInfo.spellId, auraInfo.icon, auraInfo.name), AddonDB:ClassColorName(unit), "Boss:", BoolToStr(isBoss), "Raid:", BoolToStr(isRaid), "InstanceID:", auraInfo.auraInstanceID)
			end
		end
	end
end

function TimelineParser:UNIT_SPELLCAST_SUCCEEDED(unit, castGUID, spellID)
	if not self.encounterID then return end
	if unit:find("^boss") then
		local name = AddonDB:ClassColorName(unit)
		TimelineParser:Log("USC_SUCC", LogForSpell(spellID), name, AddonDB:UnitGUID(unit))
	end
end

function TimelineParser:UNIT_SPELLCAST_START(unit, castGUID, spellID)
	if not self.encounterID then return end
	if unit:find("^boss") then
		local name = AddonDB:ClassColorName(unit)
		TimelineParser:Log("USC_START", LogForSpell(spellID), name, AddonDB:UnitGUID(unit))
	end
end

function TimelineParser:INSTANCE_ENCOUNTER_ENGAGE_UNIT()
	if not self.encounterID then return end
	local bossUnits = {}
	for i = 1, 5 do
		local unit = "boss" .. i
		if UnitExists(unit) then
			tinsert(bossUnits, unit)
		end
	end
	TimelineParser:Log("ENGAGE_UNIT", unpack(bossUnits))
	if self.bossMod and self.bossMod.onUnitEngage then
		self.bossMod:onUnitEngage()
	end
end

function TimelineParser:HandlesStageEvents(encounterID, difficultyID)
	if not encounterID then return false end
	local bossMod = self:GetBossMod(encounterID, difficultyID)
	return bossMod and bossMod.overrideStageEvents
end


TimelineParser.bossMods = {}

---@class BossMod
local BossModMixin = {}

function BossModMixin:GetEncounterTime()
	if not self.encounterStartTime then
		return 0
	end
	return GetTime() - self.encounterStartTime
end

function BossModMixin:IsTimeEqual(time1, time2, withinMargin)
	return math.abs(time1 - time2) < (withinMargin or 0.1)
end

function BossModMixin:ResetSpellCount(spellID)
	self.spellCounts[spellID] = 0
end

function BossModMixin:ResetAllSpellCounts()
	self.spellCounts = {}
end

function BossModMixin:IncreaseSpellCount(spellID)
	self.spellCounts[spellID] = (self.spellCounts[spellID] or 0) + 1
	return self.spellCounts[spellID]
end

-- we only increase spell count when even has declassifiedSpellID and it exists more than 0.2 seconds since event was added
-- so this function will tipically return spell count for the previous spell
-- if called immediately after SetSpellID
function BossModMixin:GetSpellCount(spellID)
	return self.spellCounts[spellID] or 0
end

function BossModMixin:SetSpellID(event, spellID, ...)
	assertsafe(spellID ~= nil, "bossMod:SetSpellID(event, spellID) - spellID is nil")
	if event.declassifiedSpellID then
		TimelineParser:Log("|cff880088SPELLID_ALREADY_SET|r", "#" .. event.eventNum, LogForSpell(spellID), "already set to", LogForSpell(event.declassifiedSpellID))
	end
	event.declassifiedSpellID = spellID
	TimelineParser:Log("|cff0088ffSET_SPELLID|r", "#" .. event.eventNum, LogForSpell(spellID), "count:", self:GetSpellCount(spellID), ...)
	self:CheckEventForCallbacks(event)
end

-- we only want to send callbacks if event has declassifiedSpellID and it wasn't cancelled in first 0.2 seconds
-- there are cases where events are canceled imediately after being added, so delaying the callback by 0.2 seconds
-- helps filter out some of those
function BossModMixin:CheckEventForCallbacks(event)
	if event:IsValid() then
		return
	end

	local spellID = event:GetSpellID()
	if spellID then
		if event:SinceAdded() > 0.2 and not (event:IsCanceled() or event:IsFinished())  then
			event.validated = true
			event.count = self:IncreaseSpellCount(spellID)
			AddonDB:FireCallback("TimelineParser_SpellIDDeclassified", event.eventID, spellID, GetEventTimeRemaining(event), event.count)
		else
			self:Schedule(0.2, self.CheckEventForCallbacks, self, event)
		end
	end
end

function BossModMixin:SetStage(stage)
	self.currentStage = stage
	self.currentStageChangedAt = GetTime()
	TimelineParser:Log("SET_STAGE", "stage: " .. stage)
	local isFirstStageOnTheFight = false -- used to reset global stage counter because MRT increments it on onw ENCOUNTER_START
	if self:GetEncounterTime() < 1 then
		isFirstStageOnTheFight = true
	end
	AddonDB:FireCallback("TimelineParser_StageChanged", stage, isFirstStageOnTheFight)
	if self.onStageChanged then
		self:onStageChanged(stage)
	end
end

function BossModMixin:GetStage()
	return self.currentStage
end

function BossModMixin:GetStageTime()
	if not self.currentStageChangedAt then
		return 0
	end
	return GetTime() - self.currentStageChangedAt
end

function BossModMixin:SetNoteStage(stage)
	self.currentNoteStage = stage
	self.currentNoteStageChangedAt = GetTime()
	TimelineParser:Log("SET_NOTE_STAGE", "stage: " .. stage)
	AddonDB:FireCallback("TimelineParser_NoteStageChanged", stage)
end

function BossModMixin:GetNoteStage()
	return self.currentNoteStage
end

function BossModMixin:GetNoteStageTime()
	if not self.currentNoteStageChangedAt then
		return 0
	end
	return GetTime() - self.currentNoteStageChangedAt
end

function BossModMixin:IterateEvents()
	if not TimelineParser.events then
		return function() end
	end
	local index = #TimelineParser.events + 1
	return function()
		index = index - 1
		return TimelineParser.events[index]
	end
end

do
	local function run(self)
		local func = self.func
		local args = self.args
		func(SafeUnpack(args))
	end
	function BossModMixin:Schedule(delay, func, ...)
		self.__TIMERS = self.__TIMERS or {}
		local timer = C_Timer.NewTimer(delay, run)
		timer.func = func
		timer.args = SafePack(...)
		tinsert(self.__TIMERS, timer)
		return timer
	end
end

function BossModMixin:EventsAddedInLast(seconds)
	local count = 0
	for event in self:IterateEvents() do
		if GetTime() - event.addedAt <= seconds then
			count = count + 1
		end
	end
	return count
end

function BossModMixin:EventsRemovedInLast(seconds)
	local count = 0
	for i = #TimelineParser.removedEvents, 1, -1 do
		local event = TimelineParser.removedEvents[i]
		if GetTime() - event.removedAt <= seconds then
			count = count + 1
		end
	end
	return count
end

function BossModMixin:EventsCanceledInLast(seconds)
	local count = 0
	for event in self:IterateEvents() do
		if event:IsCanceled() and GetTime() - (event.stateChangedAt or math.huge) <= seconds then
			count = count + 1
		end
	end
	return count
end

function BossModMixin:EventsFinishedInLast(seconds)
	local count = 0
	for event in self:IterateEvents() do
		if event:IsFinished() and GetTime() - (event.stateChangedAt or math.huge) <= seconds then
			count = count + 1
		end
	end
	return count
end

function BossModMixin:EventsPausedInLast(seconds)
	local count = 0
	for event in self:IterateEvents() do
		if event:IsPaused() and GetTime() - (event.stateChangedAt or math.huge) <= seconds then
			count = count + 1
		end
	end
	return count
end

function BossModMixin:AddEvent(spellId, duration)
	self.customEventId = (self.customEventId or 0) + 1
	---@type EncounterTimelineEventInfoInternal
	local eventInfo = {
		id = "C_" .. tostring(self.customEventId), -- timeline apis do not error when we pass a string into them, so use this to avoid conflicts with real event ids
		source = EVENT_SOURCE_TIMELINE_PARSER,
		spellID = spellId,
		spellName = C_Spell.GetSpellName(spellId) or "Unknown Spell",
		iconFileID = C_Spell.GetSpellTexture(spellId) or 136243,
		duration = duration,
		maxQueueDuration = 5,
		icons = -1,
		severity = -1,
		isApproximate = true,
		fakeEvent = true,
		state = 0,
	}
	TimelineParser:ENCOUNTER_TIMELINE_EVENT_ADDED(eventInfo)
	self:Schedule(duration, function()
		local event = TimelineParser.eventIDToEvent[eventInfo.id]
		if event and not (event:IsCanceled() or event:IsFinished()) then
			event.state = 2
			TimelineParser:ENCOUNTER_TIMELINE_EVENT_STATE_CHANGED(event.eventID)
		end
	end)

	return eventInfo.id
end

function BossModMixin:IncreaseDurationCount(duration, margin)
	margin = margin or 0.1
	local roundedDuration
	if margin == 0 then
		roundedDuration = duration
	else
		roundedDuration = math.floor(duration / margin + 0.5) * margin
	end

	self.durationCounts = self.durationCounts or {}
	self.durationCounts[roundedDuration] = (self.durationCounts[roundedDuration] or 0) + 1
	return self.durationCounts[roundedDuration]
end

function BossModMixin:ResetDurationCounts()
	self.durationCounts = {}
end

---@param bossMod BossModPrototype
function TimelineParser:RegisterBossMod(bossMod)
	local key
	if bossMod.difficultyID then
		key = bossMod.encounterID .. "_" .. bossMod.difficultyID
	else
		key = bossMod.encounterID
	end
	local existingBossMod = self.bossMods[key]
	if existingBossMod then
		if existingBossMod.version and bossMod.version and existingBossMod.version >= bossMod.version then
			return
		end
	end

	if bossMod.difficultyID == 8 then
		self.bossMods[bossMod.encounterID .. "_".. 23] = bossMod
	end
	self.bossMods[key] = bossMod

	Mixin(bossMod, BossModMixin)
end


function TimelineParser:GetBossMod(bossID, difficultyID)
	local key = bossID .. (difficultyID and ("_" .. difficultyID) or "")
	if self.bossMods[key] then
		return self.bossMods[key]
	end
	return self.bossMods[bossID]
end

--- Test encounter from MOTHERLODE

TimelineParser:RegisterBossMod({
	version = 1,
	encounterID = 3463,
	name = "Беатриса Скороправкс",
	s = {
		THE_BIG_ONE = 1280946,
		GLACIAL_RAY = 1280958,
		STATIC_JOLT = 1280960,
	},
	onEncounterStart = function(self, encounterID, encounterName, difficultyID, groupSize)
		self:SetStage(1)
		self:Schedule(20, self.SetStage, self, 2)
		self:Schedule(40, self.SetStage, self, 3)
		self:Schedule(60, self.SetStage, self, 4)
		self:Schedule(80, self.SetStage, self, 5)
		self:Schedule(100, self.SetStage, self, 6)
		self:Schedule(8, self.AddEvent, self, 642, 15)
	end,
	onEventAdded = function(self, event)
		if self:GetEncounterTime() < 1 then
			if self:IsTimeEqual(event.duration, 25) then
				self:SetSpellID(event, self.s.THE_BIG_ONE) -- Большой бум
			elseif self:IsTimeEqual(event.duration, 15) then
				self:SetSpellID(event, self.s.GLACIAL_RAY) -- Ледниковый луч
			elseif self:IsTimeEqual(event.duration, 5) then
				self:SetSpellID(event, self.s.STATIC_JOLT) -- Статический разряд
			end
		end
	end,
	onEventStateChanged = function(self, event, newState)
		if event:IsFinished() then
			local spellID = event:GetSpellID()
			if spellID then
				if self.lastAddedEvent and self:IsTimeEqual(self.lastAddedEvent.addedAt, GetTime()) then
					self:SetSpellID(self.lastAddedEvent, spellID)
				end
			end
		end

	end,
	onEventRemoved = function(self, event)

	end,
})



-- tazavesh first boss
TimelineParser:RegisterBossMod({
	version = 1,
	encounterID = 2425,
	name = "Зо'фекс Часовой",
	s = {
		CHARGED_SLASH = 1236348,
		IMPOUND_CONTRABAND = 346006,
		ARMED_SECURITY = 346204,
		INTERROGATION = 348350,
	},
	onEncounterStart = function(self, encounterID, encounterName, difficultyID, groupSize)
		self:SetStage(1)
		-- self:Schedule(6, self.SetStage, self, 2)
		-- self:Schedule(8, self.AddEvent, self, 642, 15)
		self.pullTimers = {
			[33] = self.s.INTERROGATION,
			[15] = self.s.IMPOUND_CONTRABAND,
			[12] = self.s.CHARGED_SLASH,
			[7] = self.s.ARMED_SECURITY,
		}
	end,
	onEventAdded = function(self, event)
		if self:GetEncounterTime() < 1 then
			for time, spellID in pairs(self.pullTimers) do
				if self:IsTimeEqual(event.duration, time) then
					self:SetSpellID(event, spellID)
				end
			end
		end
	end,
	onEventStateChanged = function(self, event, newState)
		local spellID = event:GetSpellID()
		if spellID then
			if self.lastAddedEvent and self:IsTimeEqual(self.lastAddedEvent.addedAt, GetTime()) then
				self:SetSpellID(self.lastAddedEvent, spellID)
			end
		end
	end,
	onEventRemoved = function(self, event)

	end,
})

-- nighthold first boss
TimelineParser:RegisterBossMod({
	version = 1,
	encounterID = 1849,
	name = "Скорпирон",
	s = {

	},
	onEncounterStart = function(self, encounterID, encounterName, difficultyID, groupSize)
		self:SetNoteStage(1)
		-- self:Schedule(20, self.SetNoteStage, self, 2)
		-- self:Schedule(40, self.SetNoteStage, self, 1)
		-- self:Schedule(60, self.SetNoteStage, self, 3)
		-- self:Schedule(120 + 25 + 188 + 20, self.SetNoteStage, self, 5)

		self:SetStage(1)
		self:Schedule(120, self.SetStage, self, 1.5)
		self:Schedule(120 + 25, self.SetStage, self, 2)
		self:Schedule(120 + 25 + 188, self.SetStage, self, 2.5)
		self:Schedule(120 + 25 + 188 + 20, self.SetStage, self, 3)

		self.mythicTimers = {
			[1244221]={9.8,74.8,138.4,150.4,195.6,252.6,321.2,365.3,439.3,472.1,cast=4}, -- Dread Breath
			[1265131]={11.8,39.3,56.3,89.4,106.3,187.1,204.1,237.1,254.6,287.1,351.8,384.8,401.8,441.3,451.8,476.6,cast=1.5}, -- Vaelwing
			[1245645]={16.3,41.3,66.3,87.3,116.4,185,215.1,235.1,264.1,289.1,361.8,382.8,411.8,432.8,cast=1.5}, -- Rakfang
			[1245391]={12.8,62.8,112.8,211.6,260.6,313.1,358.3,408.3,cast=4}, -- Gloom
			[1244917]={36.3,76.3,169.1,204.1,244.1,284.1,305.6,371.8,416.9,451.8,cast=2.5}, -- Void Howl
			[1262623]={32.8,82.8,142.4,180.6,230.6,280.6,378.3,428.3,cast=4}, -- Nullbeam
			[1244672]={38.4,88.4,147.9,186.1,236.1,286.1,383.8,433.8}, -- Nullzone
			[1248847]={127.8,296.5,463,cast=5}, -- Radiant Barrier
		}

		local function scheduleNext(spellID)
			local times = self.mythicTimers[spellID]
			local t = tremove(times, 1)
			if t then
				t = t - self:GetEncounterTime() - (self.mythicTimers[spellID].cast or 0)
				self:AddEvent(spellID, t)
				self:Schedule(t, scheduleNext, spellID)
			end
		end

		for spell in pairs(self.mythicTimers) do
			scheduleNext(spell)
		end
	end,
	onEventAdded = function(self, event)

	end,
	onEventStateChanged = function(self, event, newState)

	end,
	onEventRemoved = function(self, event)

	end,
})
