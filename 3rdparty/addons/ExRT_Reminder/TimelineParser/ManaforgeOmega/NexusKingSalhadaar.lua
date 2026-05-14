local GlobalAddonName = ...

---@class AddonDB
local AddonDB = select(2, ...)

if not AddonDB.is12 then return end

local MRT = GMRT
---@class Locale
local LR = AddonDB.LR

local TimelineParser = AddonDB.TimelineParser

TimelineParser:RegisterBossMod({
	version = 3,
	encounterID = 3134,
	difficultyID = 16,
	name = "Nexus King Salhadaar",
	s = {
		-- p1
		BANISHMENT = 1227529,
		COMMAND_BESIEGE = 1225016,
		COMMAND_BEHEAD = 1225010,
		INVOKE_THE_OATH = 1224906,
		SUBJUGATION_RULE = 1224776,
		TYRANNY = 1224822,
		COALESCE_VOIDWING = 1227891,
		VENGEFUL_OATH = 1238975,
		-- p2
		KINGS_HUNGER = 1228293,
		RALLY_THE_SHADOWGUARD = 1228065,
		NETHERBREAKER = 1228113,
		SEAL_THE_FORGE = 1232327,
		-- p3
		GALACTIC_SMASH = 1226648,
		STARKILLER_SWING = 1226347,
		WORLD_IN_TWILIGHT = 1225634,
	},
	onEncounterStart = function(self, encounterID, encounterName, difficultyID, groupSize)
		self:SetStage(1)
		self.pullTimers = {
			[118] = self.s.COALESCE_VOIDWING,
			[115] = self.s.INVOKE_THE_OATH,
			[45.5] = self.s.VENGEFUL_OATH,
			[32.5] = self.s.COMMAND_BEHEAD,
			[30] = self.s.BANISHMENT,
			[13.5] = self.s.SUBJUGATION_RULE,
			[9] = {self.s.COMMAND_BESIEGE, self.s.TYRANNY},
		}

		self.stage2Timers = {
			[140] = self.s.KINGS_HUNGER,
			[45] = self.s.SEAL_THE_FORGE,
			[40] = self.s.RALLY_THE_SHADOWGUARD,
			[10] = self.s.NETHERBREAKER,
		}

		self.stage3Timers = {
			[185] = self.s.WORLD_IN_TWILIGHT,
			[35] = self.s.STARKILLER_SWING,
			[5] = self.s.GALACTIC_SMASH,
		}

		self.rescheduleDelays = {
			[self.s.COMMAND_BESIEGE] = 0.5,
			[self.s.BANISHMENT] = 0.5,
		}
		self.p2_5galacticSmashPending = false
	end,
	onEventAdded = function(self, event)
		if self:GetEncounterTime() < 1 then
			for time, spellID in pairs(self.pullTimers) do
				if self:IsTimeEqual(event.duration, time) then
					if type(spellID) == "table" then
						local sID = tremove(spellID, 1)
						if sID then
							self:SetSpellID(event, sID)
						else
							geterrorhandler()("No spellID to set for Nexus King Salhadaar timer at "..time.." seconds")
						end
						break
					else
						self:SetSpellID(event, spellID)
					end
				end
			end
		end

		if self:GetStage() == 2.5 then
			if self:GetStageTime() > 2  then
				self:SetStage(3)
				-- reset count to account for additional timer on intermission
				self:ResetSpellCount(self.s.GALACTIC_SMASH)
			elseif self.p2_5galacticSmashPending then
				self:SetSpellID(event, self.s.GALACTIC_SMASH)
				self.p2_5galacticSmashPending = false
			end
		end

		if self:GetStage() == 3 and self:GetStageTime() < 1 then
			for time, spellID in pairs(self.stage3Timers) do
				if self:IsTimeEqual(event.duration, time) then
					self:SetSpellID(event, spellID)
				end
			end
		end
	end,
	onEventStateChanged = function(self, event, newState)
		local spellID = event:GetSpellID()
		if spellID then
			if spellID == self.s.COALESCE_VOIDWING then
				self:SetStage(2)
				-- p2 events are added before p1 events are canceled
				for event in self:IterateEvents() do
					if self:IsTimeEqual(event.addedAt, GetTime()) then
						for time, sID in pairs(self.stage2Timers) do
							if self:IsTimeEqual(event.duration, time) then
								self:SetSpellID(event, sID)
							end
						end
					end
				end
			elseif spellID == self.s.KINGS_HUNGER then
				self:SetStage(2.5)
				if self:IsTimeEqual(self.lastAddedEvent.duration, 45) and self:IsTimeEqual(self.lastAddedEvent.addedAt, GetTime(), 0.3) then
					self:SetSpellID(self.lastAddedEvent, self.s.GALACTIC_SMASH)
				else
					self.p2_5galacticSmashPending = true
				end
			elseif spellID == self.s.TYRANNY or spellID == self.s.INVOKE_THE_OATH or spellID == self.s.COALESCE_VOIDWING or event:IsCanceled() then
				-- do nothing
			elseif self.lastAddedEvent and self:IsTimeEqual(self.lastAddedEvent.addedAt, GetTime(), self.rescheduleDelays[spellID]) then
				self:SetSpellID(self.lastAddedEvent, spellID)
			end
		end
	end,
	onEventRemoved = function(self, event)

	end,
})
