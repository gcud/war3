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
    local p=GetOwningPlayer(u)
    for i = 1, #PlayerData[p].SkillInfo do
        local UnitAbility=PlayerData[p].SkillInfo[i]
        if UnitAbility.Id==a then
            return UnitAbility.Level
        end
    end
    return 0
end

--提升技能熟练度
function IncreaseAbilityProficiency(p,SkillId)
    print(GetPlayerName(p).."发动效果")
    for i = 1, #PlayerData[p].SkillInfo do
        local UnitAbility=PlayerData[p].SkillInfo[i]
        if UnitAbility.Id==SkillId then
            local Proficiency=UnitAbility.Proficiency+1
            PlayerData[p].SkillInfo[i].Proficiency=Proficiency
            local Message=UnitAbility.Name.."的熟练度提升了"
            if Proficiency==UnitAbility.Level*Constant.Value.SkillUpgradeParameter then
                local Level=UnitAbility.Level+1
                PlayerData[p].SkillInfo[i].Level=Level
                Message=Message..",技能提升到"..Level.."级"
            end
            gcudLua.DisplayMessage(Message,p)
        end
    end
end