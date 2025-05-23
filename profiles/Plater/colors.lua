function (self, unitId, unitFrame, envTable, modTable)
    
    local casters = modTable.config.casters
    local priorityTarget = modTable.config.priorityTarget
    local neutral = modTable.config.neutral
    local important = modTable.config.important
    local boss = modTable.config.boss
    
    envTable.BuffDebuffColors = {
        --[373011] = shrouded,
    }
    
    envTable.NpcColors = {
        --["Thunderlord Windreader"] = "red", --using regular mob name and color it as red
        --["thunderlord crag-leaper"] = {1, 1, 0}, --using lower case and coloring it spitful
        --[75790] = "#00FF00", --using the ID of the unit and using green as color
        
        -- Cinderbrew Meadery
        [1] = priorityTarget,

        -- Darkflame Cleft
        [2] = priorityTarget,

        -- Operation: Floodgate
        [3] = priorityTarget,

        -- The Motherlode
        [4] = priorityTarget,

        -- Priory of the Sacred Flame
        [206696] = priorityTarget,
        [206697] = casters,
        [206698] = casters,
        [207939] = boss,
        [207940] = boss,
        [207946] = boss,
        [211289] = casters,
        [212826] = important,
        [212827] = important,
        [212831] = important,
        [217658] = priorityTarget,
        [221760] = casters,
        [239836] = important,
        [239833] = important,

        -- The Rookery
        [207205] = boss,
        [207207] = boss,
        [207198] = casters,
        [209230] = boss,
        [209801] = priorityTarget,
        [212739] = priorityTarget,
        [212786] = priorityTarget,
        [212793] = casters,
        [214421] = priorityTarget,
        [214439] = casters,

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

