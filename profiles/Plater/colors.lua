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

    }
end

