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
	encounterID = 3056,
	difficultyID = 8,
	name = "Алозар",
	s = {
		FLAMING_UPDRAFT = 466556,
		BURNING_GALE = 467040,
		SEARING_BEAK = 466064,
	},
	onEncounterStart = function(self, encounterID, encounterName, difficultyID, groupSize)
		self:SetStage(1)
	end,
	onEventAdded = function(self, event)
		if self:GetEncounterTime() < 1 then
			if self:IsTimeEqual(event.duration, 15.5) then
				self:SetSpellID(event, self.s.FLAMING_UPDRAFT) -- Взметающий огонь
			elseif self:IsTimeEqual(event.duration, 15) then
				self:SetSpellID(event, self.s.BURNING_GALE) -- Обжигающий порыв
			elseif self:IsTimeEqual(event.duration, 10) then
				self:SetSpellID(event, self.s.SEARING_BEAK) -- Раскаленный клюв
			elseif self:IsTimeEqual(event.duration, 6) then
				self:SetSpellID(event, self.s.FLAMING_UPDRAFT) -- Взметающий огонь
			end
		-- таймеры для этого босса были поломаны в моем тесте, постоянно перезапускаясь,
		-- поэтому трудно правильно пропарсить таймеры
		elseif self:GetStageTime() > 20 and self:GetStageTime() < 27 then
			if self:IsTimeEqual(event.duration, 30) then
				self:SetSpellID(event, self.s.BURNING_GALE) -- Обжигающий порыв
			-- elseif self:IsTimeEqual(event.duration, 15.5) then -- фейк таймер
			-- 	self:SetSpellID(event, self.s.FLAMING_UPDRAFT) -- Взметающий огонь
			-- elseif self:IsTimeEqual(event.duration, 13) then -- фейк таймер
			-- 	self:SetSpellID(event, self.s.SEARING_BEAK) -- Раскаленный клюв
			elseif self:IsTimeEqual(event.duration, 10) then
				self:SetSpellID(event, self.s.SEARING_BEAK) -- Раскаленный клюв
			elseif self:IsTimeEqual(event.duration, 6) then
				self:SetSpellID(event, self.s.FLAMING_UPDRAFT) -- Взметающий огонь
			end
		elseif self:IsTimeEqual(event.duration, 15.5) then
			self:SetSpellID(event, self.s.FLAMING_UPDRAFT) -- Взметающий огонь
		elseif self:IsTimeEqual(event.duration, 13) then
			self:SetSpellID(event, self.s.SEARING_BEAK) -- Раскаленный клюв
		end
	end,
	onEventStateChanged = function(self, event, newState)
		if event:SinceAdded() < 0.5 then -- фейк таймеры
			return
		end
		local spellID = event:GetSpellID()
		if event:IsFinished() then
			if spellID == self.s.BURNING_GALE then -- Обжигающий порыв ресетает фазу
				self:SetStage(1)
			end
		end
	end,
	onEventRemoved = function(self, event)

	end,
})

-- Изнуряющий визг 472736
-- Брызги желчи 472745
-- Разрубание костей 472888
-- Проктятие тьмы 474105
TimelineParser:RegisterBossMod({
	version = 1,
	encounterID = 3057,
	difficultyID = 8,
	name = "Дряхлый дуэт",
	s = {
		DEBILITATING_SHRIEK = 472736,
		CURSE_OF_DARKNESS = 474105,
		BONE_HACK = 472888,
		SPLATTERING_SPEW = 472745,
	},
	onEncounterStart = function(self, encounterID, encounterName, difficultyID, groupSize)
		self:SetStage(1)
	end,
	onEventAdded = function(self, event)
		if self:IsTimeEqual(event.duration, 48) then
			self:SetSpellID(event, self.s.DEBILITATING_SHRIEK) -- Изнуряющий визг
		elseif self:IsTimeEqual(event.duration, 22.666) then
			self:SetSpellID(event, self.s.CURSE_OF_DARKNESS) -- Проктятие тьмы
		elseif self:IsTimeEqual(event.duration, 17.333) then
			self:SetSpellID(event, self.s.BONE_HACK) -- Разрубание костей
		elseif self:IsTimeEqual(event.duration, 8) then
			self:SetSpellID(event, self.s.SPLATTERING_SPEW) -- Брызги желчи
		elseif self:IsTimeEqual(event.duration, 27.333) then
			self:SetSpellID(event, self.s.SPLATTERING_SPEW) -- Брызги желчи
		end
	end,
	onEventStateChanged = function(self, event, newState)
		if event:SinceAdded() < 0.5 then -- фейк таймеры
			return
		end
		local spellID = event:GetSpellID()
		if spellID == self.s.DEBILITATING_SHRIEK then -- Изнуряющий визг ресетает фазу
			self:SetStage(1)
		-- elseif spellID == self.s.SPLATTERING_SPEW then -- Брызги желчи перезапускет себя на 1м касте за фазу
		-- 	if self.lastAddedEvent and self:IsTimeEqual(self.lastAddedEvent.addedAt, GetTime()) then
		-- 		self:SetSpellID(self.lastAddedEvent, spellID)
		-- 	end
		end
	end,
	onEventRemoved = function(self, event)

	end,
})

TimelineParser:RegisterBossMod({
	version = 1,
	encounterID = 3058,
	difficultyID = 8,
	name = "Командир Кролук",
	onEncounterStart = function(self, encounterID, encounterName, difficultyID, groupSize)
		self:SetStage(1)
	end,
	s = {
		rampage = 467620, -- Буйство
		fear = 1253026, -- Устрашающий крик
		-- fear = 1253272, -- Устрашающий крик (фейк)
		leap = 472081, -- Отчаянный прыжок
		-- leap = 1253270, -- Отчаянный прыжок (фейк)
		bladestorm = 470963, -- Вихрь клинков (нет нормального таймера)
	},
	onEventAdded = function(self, event)
		if self:IsTimeEqual(event.duration, 30) or self:IsTimeEqual(event.duration, 3) then
			if self:GetStage() == 2 then
				self:SetStage(1)
			end
			self:SetSpellID(event, self.s.rampage) -- Буйство
		elseif self:IsTimeEqual(event.duration, 18) or self:IsTimeEqual(event.duration, 45) then
			self:SetSpellID(event, self.s.fear) -- Устрашающий крик
		elseif self:IsTimeEqual(event.duration, 10) or self:IsTimeEqual(event.duration, 37) then
			self:SetSpellID(event, self.s.leap) -- Отчаянный прыжок
		elseif self:IsTimeEqual(event.duration, 0.001) then
			if self:GetStage() == 1 then
				self:SetStage(2)
			end
		elseif self:IsTimeEqual(event.duration, 8) then
			self:SetSpellID(event, self.s.bladestorm) -- Вихрь клинков
		end
	end,
	onEventStateChanged = function(self, event, newState)
		if self:GetStage() ~= 2 then
			if event:IsPaused() then
				self:SetStage(2)
			end
		end
	end,
	onEventRemoved = function(self, event)

	end,
})

TimelineParser:RegisterBossMod({
	version = 1,
	encounterID = 3059,
	difficultyID = 8,
	name = "Неупокоенное сердце",
	s = {
		BULLSEYE_WINDBLAST = 468429, -- Точный порыв
		ARROW_RAIN = 472556, -- Дождь стрел
		BOLT_GALE = 474528, -- Ураган стрел
		GUST_SHOT = 1253986, -- Выстрел ветра
		GUST_STRIKE = 472662, -- Удар ветра
	},
	onEncounterStart = function(self, encounterID, encounterName, difficultyID, groupSize)
		self:SetStage(1)
	end,
	onEventAdded = function(self, event)
		if self:GetEncounterTime() < 1 then
			if self:IsTimeEqual(event.duration, 24) then
				self:SetSpellID(event, self.s.BULLSEYE_WINDBLAST) -- Точный порыв
			elseif self:IsTimeEqual(event.duration, 9) then
				self:SetSpellID(event, self.s.ARROW_RAIN) -- Дождь стрел
			end
		-- таймеры добавляються только через 11.5 секунд после начала каста Точный порыв, берем 15 с запасом
		elseif self:GetStageTime() < 15 then
			if self:IsTimeEqual(event.duration, 53) then
				self:SetSpellID(event, self.s.BULLSEYE_WINDBLAST) -- Точный порыв
			elseif self:IsTimeEqual(event.duration, 39) then
				self:SetSpellID(event, self.s.BOLT_GALE) -- Ураган стрел
			elseif self:IsTimeEqual(event.duration, 23.5) then
				self:SetSpellID(event, self.s.GUST_SHOT) -- Выстрел ветра
			elseif self:IsTimeEqual(event.duration, 21) then
				self:SetSpellID(event, self.s.GUST_STRIKE) -- Удар ветра
			elseif self:IsTimeEqual(event.duration, 11) then
				self:SetSpellID(event, self.s.ARROW_RAIN) -- Дождь стрел
			end
		end
	end,
	onEventStateChanged = function(self, event, newState)
		if event:IsFinished() then
			local spellID = event:GetSpellID()
			if spellID == self.s.BULLSEYE_WINDBLAST then -- Точный порыв ресетает фазу
				self:SetStage(1)
			end
		end
	end,
	onEventRemoved = function(self, event)

	end,
})
