    function (self, unitId, unitFrame, envTable, modTable)

        local markerToHex = {
            [1] = "FFEAEA0D", -- Yellow 5 Point Star
            [2] = "FFEAB10D", -- Orange Circle
            [3] = "FFCD00FF", -- Purple Diamond
            [4] = "FF06D425", -- Green Triangle
            [5] = "FFB3E3D8", -- Light Blue Moon
            [6] = "FF0CD2EA", -- Blue Square
            [7] = "FFD6210B", -- Red Cross
            [8] = "FFFFFFFF", -- White Skull
        }

        local dungeonMobNames = {

        }

        function envTable.rename(npcId, unitId)
            if unitId then
                local name = UnitName(unitId)
                local a, b, c, d, e, f = strsplit(' ', name, 5)

                local unitName

                if dungeonMobNames[npcId] then
                    unitName = dungeonMobNames[npcId]
                else
                    unitName = name ~=nil and (f or e or d or c or b or a) or nil
                end

                if unitName == nil then
                    unitName = name
                end

                -- Capitalize first word
                unitName = unitName:utf8sub(1,1):upper()..unitName:utf8sub(2)

                local marker = GetRaidTargetIndex(unitId)
                if unitId and marker == nil then
                    marker = 8
                end

                if unitId and marker then
                    unitFrame.healthBar.unitName:SetText(WrapTextInColorCode(unitName, markerToHex[marker]))
                elseif unitId then
                    unitFrame.healthBar.unitName:SetText(unitName)
                end
            end
        end
    end

