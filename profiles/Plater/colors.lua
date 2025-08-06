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

        -- Eco-Dome Al'dani
        [234883] = priorityTarget,
        [234893] = boss,
        [234933] = boss,
        [234935] = boss,
        [234955] = priorityTarget,
        [234957] = casters,
        [234962] = important,
        [236995] = priorityTarget,
        [237514] = boss,
        [242631] = priorityTarget,
        [244302] = important,
        [324870] = neutral,

        -- Operation: Floodgate
        [226396] = boss,
        [226398] = boss,
        [226402] = boss,
        [226403] = priorityTarget,
        [226404] = boss,
        [228424] = casters,
        [229069] = casters,
        [229251] = priorityTarget,
        [229686] = casters,
        [230740] = priorityTarget,
        [230748] = important,
        [231176] = important,
        [231197] = priorityTarget,
        [231223] = priorityTarget,
        [231312] = casters,
        [231325] = priorityTarget,
        [231380] = casters,
        [231496] = casters,

        -- Priory of the Sacred Flame
        [206696] = priorityTarget,
        [206697] = casters,
        [206698] = casters,
        [206704] = important,
        [206710] = important,
        [207939] = boss,
        [207940] = boss,
        [207946] = boss,
        [211289] = casters,
        [212826] = important,
        [212827] = important,
        [212831] = important,
        [217658] = priorityTarget,
        [221760] = casters,
        [239834] = important,
        [239836] = important,
        [239833] = important,

        -- The Dawnbreaker
        [210966] = priorityTarget,
        [211087] = boss,
        [211089] = boss,
        [211261] = important,
        [211262] = important,
        [211263] = important,
        [211341] = important,
        [213885] = priorityTarget,
        [213892] = casters,
        [213893] = casters,
        [213932] = casters,
        [213934] = priorityTarget,
        [213937] = boss,
        [214761] = priorityTarget,
        [214762] = priorityTarget,
        [223994] = casters,
        [225605] = casters,
        [228539] = casters,
        [228540] = casters,

        -- Ara-Kara, City of Echoes
        [213179] = boss,
        [214840] = priorityTarget,
        [215405] = boss,
        [215407] = boss,
        [216293] = casters,
        [216333] = priorityTarget,
        [216338] = priorityTarget,
        [216340] = important,
        [216364] = casters,
        [216619] = priorityTarget,
        [217039] = priorityTarget,
        [217531] = important,
        [217533] = important,
        [218324] = important,
        [220599] = casters,
        [223253] = casters,
        [228015] = priorityTarget,

        -- Halls of Atonement
        [164185] = boss,
        [164218] = boss,
        [164557] = important,
        [164562] = priorityTarget,
        [164563] = important,
        [165408] = boss,
        [165410] = boss,
        [165414] = casters,
        [165415] = neutral,
        [165529] = casters,
        [165913] = neutral,
        [167607] = priorityTarget,
        [167612] = priorityTarget,
        [167876] = priorityTarget,
        [167892] = neutral,

        -- Tazavesh: So'leah's Gambit
        [176551] = casters,
        [177716] = casters,
        [178139] = priorityTarget,
        [178141] = priorityTarget,
        [178142] = casters,
        [179386] = priorityTarget,
        [179388] = casters,
        [179733] = important,
        [180431] = priorityTarget,
        [180432] = casters,
        [180433] = priorityTarget,
        
        -- Tazavesh: Streets of Wonder
        [175616] = boss,
        [175646] = boss,
        [175806] = boss,
        [176395] = casters,
        [176555] = boss,
        [176556] = boss,
        [176565] = casters,
        [176563] = boss,
        [176705] = boss,
        [177816] = casters,
        [177817] = casters,
        [178388] = priorityTarget,
        [179269] = priorityTarget,
        [179841] = casters,
        [180091] = priorityTarget,
        [180335] = casters,
        [180336] = casters,
        [184910] = priorityTarget,
    }
end

