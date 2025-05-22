function (self, unitId, unitFrame, envTable, modTable)
    
    local casters = modTable.config.casters
    local priorityTarget = modTable.config.priorityTarget
    local neutral = modTable.config.neutral
    local important = modTable.config.important
    
    envTable.BuffDebuffColors = {
        --[373011] = shrouded,
    }
    
    envTable.NpcColors = {
        --["Thunderlord Windreader"] = "red", --using regular mob name and color it as red
        --["thunderlord crag-leaper"] = {1, 1, 0}, --using lower case and coloring it spitful
        --[75790] = "#00FF00", --using the ID of the unit and using green as color
        
        -- Cinderbrew Meadery
        [210966] = priorityTarget,

        -- Darkflame Cleft
        [210966] = priorityTarget,

        -- Operation: Floodgate
        [210966] = priorityTarget,

        -- The Motherlode
        [210966] = priorityTarget,

        -- Priory of the Sacred Flame
        [210966] = priorityTarget,

        -- The Rookery
        [207198] = caster,
        [209801] = priorityTarget,

        -- Theater of Pain
        [160495] = casters,
        [163086] = priorityTarget,
        [164461] = casters,
        [164463] = casters,
        [164506] = casters,
        [164510] = priorityTarget,
        [169893] = casters,
        [169927] = priorityTarget,
        [170690] = casters,
        [170850] = priorityTarget,
        [170882] = casters,
        [174197] = casters,
        [174210] = casters,
        [194197] = casters,

        -- Mechagon: Workshop
        [144294] = casters,
        [144295] = casters,
        [144298] = priorityTarget,
        [151579] = neutral,
        [151613] = important,
        [151657] = casters

        -- Raid: Undermine(d)
    }
end

