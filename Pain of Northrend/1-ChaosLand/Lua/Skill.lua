--阴影之击
function Skill_Effect_ShadowAttack(DamageTarget)
    local ReduceArmor = 7
    local Duration, HeroDuration = 60, 30
    if (IsHero(DamageTarget)) then
        HeroDuration = HeroDuration
    end
    ModifyUnitArmor(DamageTarget, ReduceArmor, false)
    TimerFunctionOnce(Duration, function()
        ModifyUnitArmor(DamageTarget, ReduceArmor, true)
    end)
end

--沉默光环,不支持复活效果
function Skill_Effect_SilenceAura(u)
    local p = GetOwningPlayer(u)
    TimerFunction(3, function()
        if (UnitIsAlive(u) and Constant.GameOver == false) then
            SetUnitOwner(Constant.Unit.Spell, p, false)
            BlzUnitDisableAbility(Constant.Unit.Spell, Constant.Skill.SilenceAuraAction, false, false)
            IssuePointOrder(Constant.Unit.Spell, "silence", GetUnitX(u), GetUnitY(u))
            BlzUnitDisableAbility(Constant.Unit.Spell, Constant.Skill.SilenceAuraAction, true, false)
            SetUnitOwner(Constant.Unit.Spell, Base.NEUTRAL_PASSIVE, false)
        else
            DestroyTimer(GetExpiredTimer())
        end
    end)
end

--属性附加
function Skill_Effect_AttributeMod(u)
    local AddStrength, AddAgile, AddIntelligence = 2, 2, 3
    local Primary = BlzGetUnitIntegerField(u, UNIT_IF_PRIMARY_ATTRIBUTE)
    --力量
    if (Primary == 1) then
        AddAgile = 1
        AddIntelligence = 1
        --敏捷
    elseif (Primary == 3) then
        AddStrength = 1
        AddAgile = 3
        AddIntelligence = 1
    end
    ModifyHeroStrength(u, AddStrength, true)
    ModifyHeroAgile(u, AddAgile, true)
    ModifyHeroIntelligence(u, AddIntelligence, true)
end

--修理
function Skill_Effect_Repair(u)
    if (not UnitHaveSkill(u, Constant.Skill.RepairArmorCheck)) then
        local AddArmorParameter = 100
        local AddArmor = GetUnitAbilityLevel(u, Constant.Skill.Repair) * AddArmorParameter
        local p = GetOwningPlayer(u)
        local Delay, NowTime = 5, 0
        ModifyUnitArmor(u, AddArmor, true)
        UnitAddAbility(u, Constant.Skill.RepairArmorCheck)
        TimerFunction(1, function()
            if (InOrderedTable(p, Constant.Group.Players) and Constant.GameOver==false) then
                if (GetUnitCurrentOrder(u) == Constant.Command.Repair) then
                    NowTime = 0
                end
                if (NowTime < Delay) then
                    NowTime = NowTime + 1
                else
                    DestroyTimer(GetExpiredTimer())
                    UnitRemoveAbility(u, Constant.Skill.RepairArmorCheck)
                    ModifyUnitArmor(u, AddArmor, false)
                end
            else
                DestroyTimer(GetExpiredTimer())
                UnitRemoveAbility(u, Constant.Skill.RepairArmorCheck)
                ModifyUnitArmor(u, AddArmor, false)
            end
        end)
    end
end

--全建筑维修
function Skill_Effect_AllStructureRepair(u)
    local AddHPParameter, AddArmorParameter, RepairParameter = 1000, 50, 50
    local Duration, SkillLevel = 120, GetUnitAbilityLevel(u, Constant.Skill.AllStructureRepair)
    local AddHP, AddArmor, Repair = AddHPParameter * SkillLevel, AddArmorParameter * SkillLevel, RepairParameter * SkillLevel
    local p = GetOwningPlayer(u)
    local g = CreateGroup()
    for i = 1, #Constant.Group.Alliance do
        local Alliance = Constant.Group.Alliance[i]
        if (InOrderedTable(p, Alliance)) then
            for j = 1, #Alliance do
                local NowPlayer = Alliance[j]
                GroupEnumUnitsOfPlayer(g, NowPlayer, nil)
                ForGroup(g, function()
                    local Target = GetEnumUnit()
                    if (gcudFilter({ "Structure", "Alive" }, { MainUnit = Target })) then
                        UnitAddAbility(Target, Constant.Skill.AllStructureRepairEffect)
                        ModifyUnitArmor(Target, AddArmor, true)
                        ModifyUnitMaxHP(Target, AddHP, true)
                        ModifyUnitHP(Target, AddHP, true)
                        local NowTime = 0
                        TimerFunction(1, function()
                            if(Constant.GameOver)then
                                DestroyTimer(GetExpiredTimer())
                                if (UnitIsAlive(Target)) then
                                    UnitRemoveAbility(Target, Constant.Skill.AllStructureRepairEffect)
                                    ModifyUnitArmor(Target, AddArmor, false)
                                    ModifyUnitMaxHP(Target, AddHP, false)
                                end
                            else
                                if (NowTime < Duration and UnitIsAlive(Target)) then
                                    NowTime = NowTime + 1
                                    ModifyUnitHP(Target, Repair, true)
                                else
                                    if (UnitIsAlive(Target)) then
                                        UnitRemoveAbility(Target, Constant.Skill.AllStructureRepairEffect)
                                        ModifyUnitArmor(Target, AddArmor, false)
                                        ModifyUnitMaxHP(Target, AddHP, false)
                                    end
                                    DestroyTimer(GetExpiredTimer())
                                end
                            end
                        end)
                    end
                end)
            end
            break
        end
    end
    DestroyGroup(g)
end

--铜墙铁壁
function Skill_Effect_Wall(u)
    local AddHPParameter, AddArmorParameter = 1000, 20
    local SkillLevel = GetUnitAbilityLevel(u, Constant.Skill.Wall)
    local AddHP, AddArmor = AddHPParameter * SkillLevel, AddArmorParameter * SkillLevel
    local Wall = CreateUnitAtCoordinate(GetOwningPlayer(u), Constant.UnitType.Wall, GetSpellTargetX(), GetSpellTargetY())
    ModifyUnitMaxHP(Wall, AddHP, true)
    ModifyUnitHP(Wall, AddHP, true)
    ModifyUnitArmor(Wall, AddArmor, true)
end