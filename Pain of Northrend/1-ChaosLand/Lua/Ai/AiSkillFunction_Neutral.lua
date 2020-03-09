--叉妆闪电
function Skill_ForkedLightning(u, Skill)
    local p = GetOwningPlayer(u)
    local OrderString = "banish"
    EnumUnitsInRangeDoActionAtCoordinate(GetUnitX(u), GetUnitY(u), GetUnitSkillNowSpellDistance(u, Skill), function(Target)
        if (gcudFilter({ "Hero", "EnemyUnit", "Visible", "Alive", "NotMagicImmune" }, { MainUnit = Target, MainPlayer = p })) then
            IssueTargetOrder(u, OrderString, Target)
            return true
        end
    end)
end

--恐怖嚎叫
function Skill_HowlOfTerror(u, Skill)
    local p = GetOwningPlayer(u)
    local OrderString = "howlofterror"
    EnumUnitsInRangeDoActionAtCoordinate(GetUnitX(u), GetUnitY(u), GetUnitSkillNowSpellEffectRange(u, Skill), function(Target)
        if (gcudFilter({ "Hero", "EnemyUnit", "Visible", "Alive", "NotMagicImmune" }, { MainUnit = Target, MainPlayer = p }) and not UnitHaveSkill(Target, Constant.Buff.HowlOfTerror)) then
            IssueImmediateOrder(u, OrderString)
            return true
        end
    end)
end

--末日审判
function Skill_Doom(u, Skill)
    local p = GetOwningPlayer(u)
    local OrderString = "doom"
    EnumUnitsInRangeDoActionAtCoordinate(GetUnitX(u), GetUnitY(u), GetUnitSkillNowSpellDistance(u, Skill), function(Target)
        if (gcudFilter({ "Hero", "EnemyUnit", "NotInvulnerable", "Visible", "Alive" }, { MainUnit = Target, MainPlayer = p }) and not UnitHaveSkill(Target, Constant.Buff.Doom)) then
            IssueTargetOrder(u, OrderString, Target)
            return true
        end
    end)
end

--沉默魔法
function Skill_Silence(u, Skill)
    local p = GetOwningPlayer(u)
    local OrderString = "silence"
    EnumUnitsInRangeDoActionAtCoordinate(GetUnitX(u), GetUnitY(u), GetUnitSkillNowSpellDistance(u, Skill), function(Target)
        if (gcudFilter({ "Hero", "EnemyUnit", "Visible", "Alive", "NotMagicImmune" }, { MainUnit = Target, MainPlayer = p }) and not UnitHaveSkill(Target, Constant.Buff.Silence)) then
            IssuePointOrder(u, OrderString, GetUnitX(Target), GetUnitY(Target))
            return true
        end
    end)
end

--火焰呼吸
function Skill_BreathOfFire(u, Skill)
    local p = GetOwningPlayer(u)
    local OrderString = "breathoffire"
    EnumUnitsInRangeDoActionAtCoordinate(GetUnitX(u), GetUnitY(u), GetUnitSkillNowSpellDistance(u, Skill), function(Target)
        if (gcudFilter({ "Hero", "EnemyUnit", "Visible", "Alive", "NotMagicImmune" }, { MainUnit = Target, MainPlayer = p })) then
            IssuePointOrder(u, OrderString, GetUnitX(Target), GetUnitY(Target))
            return true
        end
    end)
end

--灵魂燃烧
function Skill_SoulBurn(u, Skill)
    local p = GetOwningPlayer(u)
    local OrderString = "soulburn"
    EnumUnitsInRangeDoActionAtCoordinate(GetUnitX(u), GetUnitY(u), GetUnitSkillNowSpellDistance(u, Skill), function(Target)
        if (gcudFilter({ "Hero", "EnemyUnit", "Visible", "Alive", "NotMagicImmune" }, { MainUnit = Target, MainPlayer = p }) and not UnitHaveSkill(Target, Constant.Buff.SoulBurn)) then
            IssueTargetOrder(u, OrderString, Target)
            return true
        end
    end)
end

--生命汲取
function Skill_LifeDrain(u, Skill)
    local p = GetOwningPlayer(u)
    local OrderString = "drain"
    EnumUnitsInRangeDoActionAtCoordinate(GetUnitX(u), GetUnitY(u), GetUnitSkillNowSpellDistance(u, Skill), function(Target)
        if (gcudFilter({ "Hero", "EnemyUnit", "Visible", "Alive", "NotMagicImmune" }, { MainUnit = Target, MainPlayer = p })) then
            IssueTargetOrder(u, OrderString, Target)
            return true
        end
    end)
end

--醉酒云雾
function Skill_StrongDrink(u, Skill)
    local p = GetOwningPlayer(u)
    local OrderString = "drunkenhaze"
    EnumUnitsInRangeDoActionAtCoordinate(GetUnitX(u), GetUnitY(u), GetUnitSkillNowSpellDistance(u, Skill), function(Target)
        if (gcudFilter({ "Hero", "EnemyUnit", "Visible", "Alive", "NotMagicImmune" }, { MainUnit = Target, MainPlayer = p }) and not UnitHaveSkill(Target, Constant.Buff.StrongDrink)) then
            IssueTargetOrder(u, OrderString, Target)
            DebugMessage(GetPlayerName(p) .. "的" .. GetUnitName(u) .. "向" .. GetUnitName(Target) .. "施放醉酒云雾")
            return true
        end
    end)
end

--全建筑维修
function Skill_AllStructureRepair(Structure)
    for i = 1, #Constant.Group.AllStructureRepairHero do
        local u = Constant.Group.AllStructureRepairHero[i]
        if (UnitIsAlive(u) and IsUnitAlly(Structure, GetOwningPlayer(u)) and UnitSkillIsCollDown(u, Constant.Skill.AllStructureRepair) and UnitSkillNowMagicalIsEnough(u, Constant.Skill.AllStructureRepair)) then
            if (IssueImmediateOrder(u, "thunderclap")) then
                break
            end
        end
    end
end