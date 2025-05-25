function (modTable)
    
    local customSpells = {

        -- Cinderbrew Meadery

        -- Darkflame Cleft

        -- Operation: Floodgate
        [1214780] = true,

        -- The Motherlode

        -- Priory of the Sacred Flame
        [427356] = true,

        -- The Rookery

        -- Theater of Pain

        -- Mechagon: Workshop

        -- Raid: Undermine(d)
    }
    
    local castingUnits = {}
    
    local hideUnit = function(unitFrame, needsHide)
        if modTable.config.useOpacityAlpha then
            if needsHide then
                unitFrame:SetAlpha(modTable.config.opacityAlpha)
            else
                unitFrame:SetAlpha(1)
            end
        else
            if needsHide then
                unitFrame:Hide()
            elseif not unitFrame:IsShown() then
                unitFrame:Show()
            end
        end
    end
    
    local setCastingUnit = function(nameplateToken, isCasting)
        if castingUnits ~= nil then
            if nameplateToken ~= nil then
                castingUnits[nameplateToken] = isCasting
            end
            return
        end
        castingUnits = {}
    end
    
    modTable.checkToHide = function(unitFrame)
        local needsHide = false
        for t, _ in pairs(castingUnits or {}) do
            if UnitExists(t) then
                if unitFrame.namePlateUnitToken ~= t then
                    if not modTable.updateCastState(unitFrame) then
                        if not modTable.config.hideInCombatOnly then
                            needsHide = true
                        else
                            local unitInCombat = UnitThreatSituation("player", unitFrame.unit) ~= nil or false
                            needsHide = unitInCombat
                        end
                        break
                    end
                end
            else
                setCastingUnit(t, nil)
            end
        end
        hideUnit(unitFrame, needsHide)
    end
    
    modTable.updateCastState = function(unitFrame)
        local castBar = unitFrame.castBar
        if castBar.casting or castBar.channeling then
            if modTable.config.useCustomSpells then
                local findCustomSpell = customSpells[castBar.spellID or -1]
                if findCustomSpell then
                    setCastingUnit(unitFrame.namePlateUnitToken, findCustomSpell)
                    return true
                end
            else
                setCastingUnit(unitFrame.namePlateUnitToken, true)
                return true
            end
        end
        setCastingUnit(unitFrame.namePlateUnitToken, nil)
        return false
    end
    
end



