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
	encounterID = 2563,
	difficultyID = 8,
	name = "Заросшее дерево",
	s = {
		GERMINATE = 388796,
		BURST_FORTH = 388923,
		BARKBREAKER = 388544,
		BRANCH_OUT = 388567,
	},
	onEncounterStart = function(self, encounterID, encounterName, difficultyID, groupSize)
		self:SetStage(1)
	end,
	onEventAdded = function(self, event)
		if self:GetStageTime() < 3 then
			if self:IsTimeEqual(event.duration, 54) then
				self:SetSpellID(event, self.s.BURST_FORTH) -- Взрывной рост
			elseif self:IsTimeEqual(event.duration, 30) then
				self:SetSpellID(event, self.s.BRANCH_OUT) -- Ответвление
			elseif self:IsTimeEqual(event.duration, 18) then
				self:SetSpellID(event, self.s.GERMINATE) -- Прорастание
			elseif self:IsTimeEqual(event.duration, 9) then
				self:SetSpellID(event, self.s.BARKBREAKER) -- Пробивание коры
			end
		end
	end,
	onEventStateChanged = function(self, event, newState)
		if event:SinceAdded() < 0.5 then -- фейк таймеры
			return
		end
		local spellID = event:GetSpellID()
		if spellID then
			if spellID == self.s.BURST_FORTH then
				self:SetStage(1)
			elseif self.lastAddedEvent and self:IsTimeEqual(self.lastAddedEvent.addedAt, GetTime()) then
				self:SetSpellID(self.lastAddedEvent, spellID)
			end
		end
	end,
	onEventRemoved = function(self, event)

	end,
})


TimelineParser:RegisterBossMod({
	version = 1,
	encounterID = 2564,
	difficultyID = 8,
	name = "Кроут",
	s = {
		OVERPOWERING_GUST = 377034,
		SAVAGE_PECK = 376997,
		DEAFENING_SCREECH = 377004,
	},
	onEncounterStart = function(self, encounterID, encounterName, difficultyID, groupSize)
		self:SetStage(1)
	end,
	onEventAdded = function(self, event) -- после первого перевода босс сломался и ничего не кастил, но по идее эти таймеры покрывают весь файт
		if self:IsTimeEqual(event.duration, 20) then
			self:SetSpellID(event, self.s.OVERPOWERING_GUST) -- Взрывной рост
		elseif self:IsTimeEqual(event.duration, 14) then
			self:SetSpellID(event, self.s.DEAFENING_SCREECH) -- Ответвление
		elseif self:IsTimeEqual(event.duration, 5) then
			self:SetSpellID(event, self.s.SAVAGE_PECK) -- Прорастание
		end
	end,
	onEventStateChanged = function(self, event, newState)
		if event:SinceAdded() < 0.5 then -- фейк таймеры
			return
		end

		if event:IsCanceled() and self:GetStageTime() < 10 then
			self:SetStage(self:GetStage() + 1)
		elseif event:GetSpellID() == self.s.OVERPOWERING_GUST and event:IsFinished() then
			-- there are 4 seconds window betwen OVERPOWERING_GUST and rescheduling
			-- of another set of timers in which boss could be phased, so check if any event
			-- was added 5 seconds after OVERPOWERING_GUST and if not
			self:Schedule(5, function()
				if self.lastAddedEvent and self.lastAddedEvent:SinceAdded() > 5 then
					self:SetStage(self:GetStage() + 1)
				end
			end)
		end
	end,
	onEventRemoved = function(self, event)

	end,
})

TimelineParser:RegisterBossMod({
	version = 1,
	encounterID = 2562,
	difficultyID = 8,
	name = "Вексам",
	s = {
		ARCANE_EXPULSION = 385958,
		ARCANE_FISSURE = 388537,
		ARCANE_ORBS = 387691,
		MANA_BOMBS = 386173,
	},
	onEncounterStart = function(self, encounterID, encounterName, difficultyID, groupSize)
		self:SetStage(1)
	end,
	onEventAdded = function(self, event)
		if self:GetStageTime() < 2 then
			if self:IsTimeEqual(event.duration, 40) then
				self:SetSpellID(event, self.s.ARCANE_FISSURE) -- Магический разлом
			elseif self:IsTimeEqual(event.duration, 15) then
				self:SetSpellID(event, self.s.MANA_BOMBS) -- Манабомбы
			elseif self:IsTimeEqual(event.duration, 5) then
				self:SetSpellID(event, self.s.ARCANE_EXPULSION) -- Волна тайной магии
			elseif self:IsTimeEqual(event.duration, 2) then
				self:SetSpellID(event, self.s.ARCANE_ORBS) -- Чародейные сферы
			end
		end
	end,
	onEventStateChanged = function(self, event, newState)
		if event:SinceAdded() < 0.5 then -- фейк таймеры
			return
		end
		local spellID = event:GetSpellID()
		if spellID then
			if spellID == self.s.ARCANE_FISSURE then
				self:Schedule(3, self.SetStage, self, 1)
			elseif self.lastAddedEvent and self:IsTimeEqual(self.lastAddedEvent.addedAt, GetTime()) then
				self:SetSpellID(self.lastAddedEvent, spellID)
			end
		end
	end,
	onEventRemoved = function(self, event)

	end,
})

TimelineParser:RegisterBossMod({
	version = 1,
	encounterID = 2565,
	difficultyID = 8,
	name = "Эхо Дорагосы",
	s = {
		ENERGY_BOMB = 374341,
		ASTRAL_BLAST = 1282251,
		ARCANE_MISSILES = 373325,
		POWER_VACUUM = 388820,
	},
	onEncounterStart = function(self, encounterID, encounterName, difficultyID, groupSize)
		self:SetStage(1)
	end,
	onEventAdded = function(self, event)
		if self:GetStageTime() < 2 then
			if self:IsTimeEqual(event.duration, 28) then
				self:SetSpellID(event, self.s.POWER_VACUUM) -- Энергетический вакуум
			elseif self:IsTimeEqual(event.duration, 14) then
				self:SetSpellID(event, self.s.ENERGY_BOMB) -- Энергетическая бомба
			elseif self:IsTimeEqual(event.duration, 9) then
				self:SetSpellID(event, self.s.ASTRAL_BLAST) -- Астральный взрыв
			elseif self:IsTimeEqual(event.duration, 7) then
				self:SetSpellID(event, self.s.ARCANE_MISSILES) -- Чародейные снаряды
			end
		end
	end,
	onEventStateChanged = function(self, event, newState)
		if event:SinceAdded() < 0.5 then -- фейк таймеры
			return
		end
		local spellID = event:GetSpellID()
		if spellID then
			if spellID == self.s.POWER_VACUUM then
				self:Schedule(4, self.SetStage, self, 1)
			elseif self.lastAddedEvent and self:IsTimeEqual(self.lastAddedEvent.addedAt, GetTime()) then
				self:SetSpellID(self.lastAddedEvent, spellID)
			end
		end
	end,
	onEventRemoved = function(self, event)

	end,
})
