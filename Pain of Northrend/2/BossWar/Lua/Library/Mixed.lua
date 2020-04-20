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