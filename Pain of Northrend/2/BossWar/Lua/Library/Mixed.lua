-- 注册任意单位事件
function RegisterAnyUnitEvent(t, e)
    for i = 1, #gcudLua.Players do
        TriggerRegisterPlayerUnitEvent(t, gcudLua.Players[i], e, nil)
    end
    -- 特别为中立被动和敌对注册
    TriggerRegisterPlayerUnitEvent(t, gcudLua.MonsterPlayer, e, nil)
    TriggerRegisterPlayerUnitEvent(t, gcudLua.NeutralPlayer, e, nil)
end

--玩家选择单个单位
function PlayerSelectSingleUnit(p,u)
    if (GetLocalPlayer() == p) then
        ClearSelection()
        SelectUnit(u, true)
    end
end

-- 清除单位数据
function ClearUnitData(u)
    Units[u]=nil
end

--获取怪物区域随机X坐标
function GetMonsterAreaRandomX()
    return GetRandomReal(Constant.Coordinate.MonsterAreaLeftX,Constant.Coordinate.MonsterAreaRightX)
end

--获取怪物区域随机Y坐标
function GetMonsterAreaRandomY()
    return GetRandomReal(Constant.Coordinate.MonsterAreaDownY,Constant.Coordinate.MonsterAreaUpY)
end

--获取可提升技能等级
function GetUpgradeAbilityLevel(u,a)
    local SkillList=Units[u].SkillList
    if SkillList==nil then
        return 0
    else
        for i = 1, #SkillList do
            if SkillList[i].Id==a then
                return SkillList[i].Level
            end
        end
    end
    return 0
end

--提升技能熟练度
function IncreaseAbilityProficiency(u,SkillId)
    for i = 1, #Units[u].SkillList do
        local UnitAbility=Units[u].SkillList[i]
        if UnitAbility.Id==SkillId then
            local Proficiency=UnitAbility.Proficiency+1
            Units[u].SkillList[i].Proficiency=Proficiency
            if Proficiency==UnitAbility.Level*Constant.Value.SkillUpgradeParameter then
                local Level=UnitAbility.Level+1
                Units[u].SkillList[i].Level=Level
                gcudLua.DisplayMessage(UnitAbility.Name.."提升到"..Level.."级",GetOwningPlayer(u))
            end
        end
    end
end

--添加特有技能
function AddSpecialAbility(u,Skill)
    UnitAddAbility(u,Skill.Id)
    if Skill.Event~=nil then
        Skill.Event.Add(u)
    end
end

--增强Boss
function BossStrong(Boss, DiedHeroLevel)
    local AddHpParameter,AddAttackPowerParameter,AddArmorParameter,AddHpRecoveryParameter=8,0.3,0.1,0.1
    local AddHp,AddAttackPower,AddArmor,AddHpRecovery=AddHpParameter*DiedHeroLevel,AddAttackPowerParameter*DiedHeroLevel,AddArmorParameter*DiedHeroLevel,AddHpRecoveryParameter*DiedHeroLevel
    gcudLua.ModifyUnitMaxHP(Boss,AddHp,true)
    gcudLua.ModifyUnitHP(Boss,AddHp,true)
    UnitAttribute(Boss,Constant.ATTRIBUTE_ATTACK_POWER,AddAttackPower,true)
    UnitAttribute(Boss,Constant.ATTRIBUTE_ARMOR,AddArmor,true)
    gcudLua.ModifyUnitHpRecovery(Boss,Constant.ATTRIBUTE_HP_RECOVERY,AddHpRecovery,true)
end

--单位属性
function UnitAttribute(u,AttributeType,Value,IsAdd)
    local a=BlzGetUnitAbility(u,AttributeType.Id)
    local OldValue=BlzGetAbilityIntegerLevelField(a,AttributeType.Field,0)+Units[u].Attribute[AttributeType.CacheField]
    if IsAdd then
        OldValue=OldValue+Value
    else
        OldValue=OldValue-Value
    end
    --缓存值处理
    local RealValue=math.floor(OldValue)
    Units[u].Attribute[AttributeType.CacheField]=OldValue-RealValue
    BlzSetAbilityIntegerLevelField(a,AttributeType.Field,0,RealValue)
    IncUnitAbilityLevel(u,AttributeType.Id)
    DecUnitAbilityLevel(u,AttributeType.Id)
end

--获取单位护甲护甲伤害比
function GetUnitArmorDamageRate(u)
    local Value=BlzGetUnitArmor(u)*0.06
    return Value/(Value+1)
end

--Ai卖物品
function AiSellItem(i,it,p)
    RemoveItem(i)
    gcudLua.ModifyPlayerGold(p,ItemTypeData[it].Gold,true)
end