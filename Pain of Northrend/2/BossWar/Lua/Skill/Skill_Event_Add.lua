--毒
function Skill_Event_Add_Pison(u)
    local LimitParameter=5
    Units[u].Skill_Pison_PisonPoint=0
    gcudLua.TimerFunction(3,function()
        if Constant.GameOver then
            DestroyTimer(GetExpiredTimer())
        elseif gcudLua.UnitIsAlive(u) then
            local Value=Units[u].Skill_Pison_PisonPoint;
            if Value<LimitParameter*GetUpgradeAbilityLevel(u,Constant.Skill.Poison) then
                Value=Value+1
            end
            Units[u].Skill_Pison_PisonPoint=Value
        end
    end)
end

--野兽幽魂
function Skill_Event_Add_BeastGhost(u)
    local RefreshTime=30
    local Number=5
    local p=GetOwningPlayer(u)
    local ut=gcudLua.StringToInteger("osw2")
    local AddArmorParameter,AddAttackParameter,AddHpParameter,AddHPRecoveryParameter=1,5,50,0.5
    gcudLua.TimerFunction(RefreshTime,function()
        if Constant.GameOver then
            DestroyTimer(GetExpiredTimer())
        elseif gcudLua.UnitIsAlive(u) then
            local X,Y=GetUnitX(u),GetUnitY(u)
            local Level=GetUnitLevel(u)
            local AddArmor,AddAttack,AddHp,AddHPRecovery=AddArmorParameter*Level,AddAttackParameter*Level,AddHpParameter*Level,AddHPRecoveryParameter*Level
            for i =1, Number do
                if  GetPlayerUnitTypeCount(p,ut)<Number then
                    local wolf=gcudLua.CreateUnitAtCoordinate(p,ut,X,Y)
                    gcudLua.ModifyUnitArmor(wolf,AddArmor,true)
                    gcudLua.ModifyUnitAttackPower(wolf,AddAttack,true)
                    gcudLua.ModifyUnitMaxHP(wolf,AddHp,true)
                    gcudLua.ModifyUnitHP(wolf,AddHp,true)
                    gcudLua.ModifyUnitHpRecovery(wolf,AddHPRecovery,true)
                else
                    break
                end
            end
        end
    end)
end

--生命恢复
function Skill_Event_Add_LifeRecovery(u)
    local Ineterval,HpRate,Range,Duration,RecoveryHpParameter=5,0.5,900,15,1
    local p=GetOwningPlayer(u)
    gcudLua.TimerFunction(Ineterval,function()
        if Constant.GameOver then
            DestroyTimer(GetExpiredTimer())
        elseif gcudLua.UnitIsAlive(u) then
            local RecoveryHp=GetUpgradeAbilityLevel(u,Constant.Skill.LifeRecovery)*RecoveryHpParameter
            gcudLua.EnumUnitsInRangeDoActionAtCoordinate(GetUnitX(u),GetUnitY(u),Range,function(Target)
                if gcudLua.GetUnitHPRate(Target)<HpRate and gcudLua.gcudFilter({"AllianceUnit","AliveUnit","NotMechanical"},{MainUnit=Target,MainPlayer=p}) then
                    local NowTime=0
                    local Effect=AddSpecialEffectTarget("Abilities/Spells/NightElf/Rejuvenation/RejuvenationTarget.mdl", Target, "origin")
                    gcudLua.TimerFunction(1,function()
                        if Constant.GameOver or NowTime>=Duration or not gcudLua.UnitIsAlive(Target) then
                            DestroyEffect(Effect)
                            DestroyTimer(GetExpiredTimer())
                        else
                            NowTime=NowTime+1
                            gcudLua.ModifyUnitHP(Target,RecoveryHp,true)
                        end
                    end)
                    IncreaseAbilityProficiency(u,Constant.Skill.LifeRecovery)
                    return true
                end
            end)
        end
    end)
end