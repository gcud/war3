--神圣之光
function Skill_HolyBolt(u, Skill)
    local p = GetOwningPlayer(u)
    local OrderString = "holybolt"
    EnumUnitsInRangeDoActionAtCoordinate(GetUnitX(u), GetUnitY(u), GetUnitSkillNowSpellDistance(u, Skill), function(Target)
        if (UnitIsAlive(Target) and IsHero(Target)) then
            if (IsUnitEnemy(Target, p)) then
                if (IsUnitType(Target, UNIT_TYPE_UNDEAD) and not IsUnitType(Target, UNIT_TYPE_MAGIC_IMMUNE)) then
                    IssueTargetOrder(u, OrderString, Target)
                    return true
                end
            elseif (GetUnitHPRate(Target) < 0.5 and not IsUnitType(Target, UNIT_TYPE_UNDEAD)) then
                IssueTargetOrder(u, OrderString, Target)
                return true
            end
        end
    end)
end

--虚无
function Skill_Banish(u, Skill)
    local p = GetOwningPlayer(u)
    local OrderString = "banish"
    EnumUnitsInRangeDoActionAtCoordinate(GetUnitX(u), GetUnitY(u), GetUnitSkillNowSpellDistance(u, Skill), function(Target)
        if (gcudFilter({ "Hero", "EnemyUnit", "Visible", "Alive", "NotMagicImmune" }, { MainUnit = Target, MainPlayer = p }) and not UnitHaveSkill(Target, Constant.Buff.Banish)) then
            IssueTargetOrder(u, OrderString, Target)
            return true
        end
    end)
end

--风暴之锤
function Skill_StormBolt(u, Skill)
    local p = GetOwningPlayer(u)
    local OrderString = "thunderbolt"
    EnumUnitsInRangeDoActionAtCoordinate(GetUnitX(u), GetUnitY(u), GetUnitSkillNowSpellDistance(u, Skill), function(Target)
        if (gcudFilter({ "Hero", "EnemyUnit", "Visible", "Alive", "NotMagicImmune" }, { MainUnit = Target, MainPlayer = p })) then
            IssueTargetOrder(u, OrderString, Target)
            return true
        end
    end)
end

--医疗波
function Skill_HealingWave(u, Skill)
    local p = GetOwningPlayer(u)
    local OrderString = "healingwave"
    EnumUnitsInRangeDoActionAtCoordinate(GetUnitX(u), GetUnitY(u), GetUnitSkillNowSpellDistance(u, Skill), function(Target)
        if (gcudFilter({ "Hero", "AllianceUnit", "Alive" }, { MainUnit = Target, MainPlayer = p }) and GetUnitHPRate(Target) < 0.5) then
            IssueTargetOrder(u, OrderString, Target)
            return true
        end
    end)
end

--妖术
function Skill_Hex(u, Skill)
    local p = GetOwningPlayer(u)
    local OrderString = "hex"
    EnumUnitsInRangeDoActionAtCoordinate(GetUnitX(u), GetUnitY(u), GetUnitSkillNowSpellDistance(u, Skill), function(Target)
        if (gcudFilter({ "Hero", "EnemyUnit", "Visible", "Alive", "NotMagicImmune" }, { MainUnit = Target, MainPlayer = p }) and not UnitHaveSkill(Target, Constant.Buff.Hex)) then
            IssueTargetOrder(u, OrderString, Target)
            return true
        end
    end)
end

--战争践踏
function Skill_WarStomp(u, Skill)
    local p = GetOwningPlayer(u)
    local OrderString = "stomp"
    EnumUnitsInRangeDoActionAtCoordinate(GetUnitX(u), GetUnitY(u), GetUnitSkillNowSpellEffectRange(u, Skill), function(Target)
        if (gcudFilter({ "Hero", "EnemyUnit", "Visible", "Alive", "NotMagicImmune" }, { MainUnit = Target, MainPlayer = p }) and not UnitHaveSkill(Target, Constant.Buff.Stun)) then
            IssueImmediateOrder(u, OrderString)
            return true
        end
    end)
end

--闪电链
function Skill_ChainLightning(u, Skill)
    local p = GetOwningPlayer(u)
    local OrderString = "chainlightning"
    EnumUnitsInRangeDoActionAtCoordinate(GetUnitX(u), GetUnitY(u), GetUnitSkillNowSpellDistance(u, Skill), function(Target)
        if (gcudFilter({ "Hero", "EnemyUnit", "Visible", "Alive", "NotMagicImmune" }, { MainUnit = Target, MainPlayer = p })) then
            IssueTargetOrder(u, OrderString, Target)
            return true
        end
    end)
end

--死亡契约
function Skill_DeathPact(u, Skill)
    if (GetUnitHPRate(u) < 0.5) then
        local p = GetOwningPlayer(u)
        local OrderString = "deathpact"
        EnumUnitsInRangeDoActionAtCoordinate(GetUnitX(u), GetUnitY(u), GetUnitSkillNowSpellDistance(u, Skill), function(Target)
            if (IsUnitType(Target, UNIT_TYPE_UNDEAD) and gcudFilter({ "Visible", "Alive", "NotStructure", "NotHero", "NotMagicImmune" }, { MainUnit = Target, MainPlayer = p })) then
                IssueTargetOrder(u, OrderString, Target)
                return true
            end
        end)
    end
end

--死亡缠绕
function Skill_DeathCoil(u, Skill)
    local p = GetOwningPlayer(u)
    local OrderString = "deathcoil"
    EnumUnitsInRangeDoActionAtCoordinate(GetUnitX(u), GetUnitY(u), GetUnitSkillNowSpellDistance(u, Skill), function(Target)
        if (UnitIsAlive(Target) and IsHero(Target)) then
            if (IsUnitEnemy(Target, p)) then
                if (not IsUnitType(Target, UNIT_TYPE_MAGIC_IMMUNE) and not IsUnitType(Target, UNIT_TYPE_UNDEAD)) then
                    IssueTargetOrder(u, OrderString, Target)
                    return true
                end
            elseif (IsUnitType(Target, UNIT_TYPE_UNDEAD) and GetUnitHPRate(Target) < 0.5) then
                IssueTargetOrder(u, OrderString, Target)
                return true
            end
        end
    end)
end

--穿刺
function Skill_Impale(u, Skill)
    local p = GetOwningPlayer(u)
    local OrderString = "impale"
    EnumUnitsInRangeDoActionAtCoordinate(GetUnitX(u), GetUnitY(u), GetUnitSkillNowSpellDistance(u, Skill), function(Target)
        if (gcudFilter({ "Hero", "EnemyUnit", "Visible", "Alive", "NotMagicImmune" }, { MainUnit = Target, MainPlayer = p }) and not UnitHaveSkill(Target, Constant.Buff.Impale)) then
            IssueTargetOrder(u, OrderString, Target)
            return true
        end
    end)
end

--腐臭蜂群
function Skill_CarrionSwarm(u, Skill)
    local p = GetOwningPlayer(u)
    local OrderString = "carrionswarm"
    EnumUnitsInRangeDoActionAtCoordinate(GetUnitX(u), GetUnitY(u), GetUnitSkillNowSpellDistance(u, Skill), function(Target)
        if (gcudFilter({ "Hero", "EnemyUnit", "Visible", "Alive", "NotMagicImmune" }, { MainUnit = Target, MainPlayer = p })) then
            IssuePointOrder(u, OrderString, GetUnitX(Target), GetUnitY(Target))
            return true
        end
    end)
end

--霜冻新星
function Skill_FrostNova(u, Skill)
    local p = GetOwningPlayer(u)
    local OrderString = "frostnova"
    EnumUnitsInRangeDoActionAtCoordinate(GetUnitX(u), GetUnitY(u), GetUnitSkillNowSpellDistance(u, Skill), function(Target)
        if (gcudFilter({ "Hero", "EnemyUnit", "Visible", "Alive", "NotMagicImmune" }, { MainUnit = Target, MainPlayer = p })) then
            IssueTargetOrder(u, OrderString, Target)
            return true
        end
    end)
end

--黑暗仪式
function Skill_DarkRitual(u, Skill)
    if (GetUnitMPRate(u) < 0.5) then
        local p = GetOwningPlayer(u)
        local OrderString = "darkritual"
        EnumUnitsInRangeDoActionAtCoordinate(GetUnitX(u), GetUnitY(u), GetUnitSkillNowSpellDistance(u, Skill), function(Target)
            if (IsUnitType(Target, UNIT_TYPE_UNDEAD) and gcudFilter({ "Visible", "Alive", "NotStructure", "NotHero", "NotMagicImmune" }, { MainUnit = Target, MainPlayer = p })) then
                IssueTargetOrder(u, OrderString, Target)
                return true
            end
        end)
    end
end

--刀阵旋风
function Skill_FanOfKnives(u, Skill)
    local p = GetOwningPlayer(u)
    local OrderString = "fanofknives"
    EnumUnitsInRangeDoActionAtCoordinate(GetUnitX(u), GetUnitY(u), GetUnitSkillNowSpellEffectRange(u, Skill), function(Target)
        if (gcudFilter({ "Hero", "EnemyUnit", "Visible", "Alive" }, { MainUnit = Target, MainPlayer = p })) then
            IssueImmediateOrder(u, OrderString)
            return true
        end
    end)
end

--暗影突袭
function Skill_ShadowStrike(u, Skill)
    local p = GetOwningPlayer(u)
    local OrderString = "shadowstrike"
    EnumUnitsInRangeDoActionAtCoordinate(GetUnitX(u), GetUnitY(u), GetUnitSkillNowSpellDistance(u, Skill), function(Target)
        if (gcudFilter({ "Hero", "EnemyUnit", "Visible", "Alive" }, { MainUnit = Target, MainPlayer = p }) and not UnitHaveSkill(Target,Constant.Buff.ShadowStrike)) then
            IssueTargetOrder(u, OrderString, Target)
            return true
        end
    end)
end

--法力燃烧
function Skill_ManaBurn(u, Skill)
    local p = GetOwningPlayer(u)
    local OrderString = "manaburn"
    EnumUnitsInRangeDoActionAtCoordinate(GetUnitX(u), GetUnitY(u), GetUnitSkillNowSpellDistance(u, Skill), function(Target)
        if (gcudFilter({ "Hero", "EnemyUnit", "Visible", "Alive", "NotMagicImmune" }, { MainUnit = Target, MainPlayer = p })) then
            IssueTargetOrder(u, OrderString, Target)
            return true
        end
    end)
end

--纠缠根须
function Skill_EntanglingRoots(u, Skill)
    local p = GetOwningPlayer(u)
    local OrderString = "entanglingroots"
    EnumUnitsInRangeDoActionAtCoordinate(GetUnitX(u), GetUnitY(u), GetUnitSkillNowSpellDistance(u, Skill), function(Target)
        if (gcudFilter({ "Hero", "EnemyUnit", "Visible", "Alive", "NotMagicImmune" }, { MainUnit = Target, MainPlayer = p })) then
            IssueTargetOrder(u, OrderString, Target)
            return true
        end
    end)
end