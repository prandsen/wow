local GlobalAddonName = ...

---@class AddonDB
local AddonDB = select(2, ...)

if not AddonDB.is12 then return end

local MRT = GMRT
---@class Locale
local LR = AddonDB.LR

local TimelineParser = AddonDB.TimelineParser

TimelineParser:RegisterBossMod({
	version = 1,
	encounterID = 3332,
	difficultyID = 8,
	name = "Ядрохранительница Нисарра",
	s = {
		LIGHTSCAR_FLARE = 1264439,
		ECLIPSING_STEP = 1249014,
		NULL_VANGUARD = 1252703,
		DEVOUR_THE_UNWORTHY = 1271684,
		UMBRAL_SLASH = 1247937,
	},
	onEncounterStart = function(self, encounterID, encounterName, difficultyID, groupSize)
		self:SetStage(1)
		self.pullTimers = {
			[28] = self.s.LIGHTSCAR_FLARE,
			[15] = self.s.NULL_VANGUARD,
			[5] = self.s.ECLIPSING_STEP,
			[3] = self.s.UMBRAL_SLASH,
		}
	end,
	onEventAdded = function(self, event)
		if self:GetStageTime() < 2.5 then
			for time, spellID in pairs(self.pullTimers) do
				if self:IsTimeEqual(event.duration, time) then
					self:SetSpellID(event, spellID)
				end
			end
		elseif self:GetStage() == 2 and self:GetStageTime() < 8 then
			self:SetSpellID(event, self.s.DEVOUR_THE_UNWORTHY)
		end
	end,
	onEventStateChanged = function(self, event, newState)
		if event:SinceAdded() < 0.5 or event.duration > 60 then -- фейк таймеры
			return
		end

		local spellID = event:GetSpellID()
		if spellID then
			if self:GetStage() == 1 and self:GetStageTime() > 5 and self:EventsCanceledInLast(2) >= 2 then
				self:SetStage(2)
				self:Schedule(18.5, self.SetStage, self, 1)
			elseif self.lastAddedEvent and self:IsTimeEqual(self.lastAddedEvent.addedAt, GetTime()) then
				self:SetSpellID(self.lastAddedEvent, spellID)
			end
		end
	end,
	onEventRemoved = function(self, event)

	end,
	onEncounterWarning = function (self, info) -- lightscar flare
		for event in self:IterateEvents() do
			if event:IsRunning() and event:GetSpellID() == self.s.UMBRAL_SLASH then
				if event:GetRemainingTime() > 7 then
					event:CancelEvent()
				end

				return
			end
		end
	end
})

TimelineParser:RegisterBossMod({
	version = 1,
	encounterID = 3328,
	difficultyID = 8,
	name = "Главный ядротехник Казрет",
	s = {
		LEYLINE_ARRAY = 1251183,
		REFLUX_CHARGE = 1251767,
		FLUX_COLLAPSE = 1264048,
		CORESPARK_DETONATION = 1257512,
	},
	onEncounterStart = function(self, encounterID, encounterName, difficultyID, groupSize)
		self:SetStage(1)
		self.pullTimers = {
			[38] = self.s.CORESPARK_DETONATION,
			[12] = self.s.FLUX_COLLAPSE,
			[5] = self.s.REFLUX_CHARGE,
			[1] = self.s.LEYLINE_ARRAY,
		}
	end,
	onEventAdded = function(self, event)
		if self:GetEncounterTime() < 1 then
			for time, spellID in pairs(self.pullTimers) do
				if self:IsTimeEqual(event.duration, time) then
					self:SetSpellID(event, spellID)
				end
			end
		elseif self:GetEncounterTime() > 5 and self:GetStage() == 1 and self:GetStageTime() < 4 then
			-- for stage reset events have dynamic durations, so we need to identify them differently
			-- wait for 4 running events and then assign spellIDs based on their order
			local recentEvents = {}
			for evt in self:IterateEvents() do
				if evt:IsRunning() then
					tinsert(recentEvents, evt)
					if #recentEvents >= 4 then
						sort(recentEvents, function(a, b) return a.duration < b.duration end)
						-- CORESPARK_DETONATION has static duration so exclude it
						for i, e in ipairs(recentEvents) do
							if e.duration == 38 then
								self:SetSpellID(e, self.s.CORESPARK_DETONATION)
								tremove(recentEvents, i)
								break
							end
						end
						-- these events are in order so we can use it instead of duration to identify them
						for i, e in ipairs(recentEvents) do
							if i == 1 then
								self:SetSpellID(e, self.s.LEYLINE_ARRAY)
							elseif i == 2 then
								self:SetSpellID(e, self.s.REFLUX_CHARGE)
							elseif i == 3 then
								self:SetSpellID(e, self.s.FLUX_COLLAPSE)
							end
						end
						break
					end
				end
			end
		end
	end,
	onEventStateChanged = function(self, event, newState)
		if event:SinceAdded() < 0.5 or event.duration > 60 then -- фейк таймеры
			return
		end
		local spellID = event:GetSpellID()
		if spellID then
			if self:GetStage() == 1 then
				if spellID == self.s.CORESPARK_DETONATION then
					self:SetStage(2)
					self:Schedule(12, self.SetStage, self, 1)
				elseif self.lastAddedEvent and self:IsTimeEqual(self.lastAddedEvent.addedAt, GetTime()) then
					self:SetSpellID(self.lastAddedEvent, spellID)
				end
			end
		end
	end,
	onEventRemoved = function(self, event)

	end,
})

TimelineParser:RegisterBossMod({
	version = 1,
	encounterID = 3333,
	difficultyID = 8,
	name = "Лотраксион",
	s = {
		SEARING_REND = 1253950,
		BRILLIANT_DISPERSION = 1253848,
		DIVINE_GUILE = 1257567,
		FLICKER = 1255531,
	},
	onEncounterStart = function(self, encounterID, encounterName, difficultyID, groupSize)
		self:SetStage(1)
		self.pullTimers = {
			[52] = self.s.DIVINE_GUILE,
			[24] = self.s.FLICKER,
			[11] = self.s.BRILLIANT_DISPERSION,
			[2] = self.s.SEARING_REND,
		}
	end,
	onEventAdded = function(self, event)
		if self:GetStage() == 2 then
			self:SetStage(1)
		end
		if self:GetStageTime() < 1 then
			for time, spellID in pairs(self.pullTimers) do
				if self:IsTimeEqual(event.duration, time) then
					self:SetSpellID(event, spellID)
				end
			end
		end
	end,
	onEventStateChanged = function(self, event, newState)
		if event:SinceAdded() < 0.5 or event.duration > 60 then -- фейк таймеры
			return
		end
		local spellID = event:GetSpellID()
		if spellID then
			if spellID == self.s.DIVINE_GUILE then
				self:SetStage(2)
			elseif self.lastAddedEvent and self:IsTimeEqual(self.lastAddedEvent.addedAt, GetTime()) then
				self:SetSpellID(self.lastAddedEvent, spellID)
			end
		end
	end,
	onEventRemoved = function(self, event)

	end,
})
