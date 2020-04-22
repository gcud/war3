--毒
function Skill_Event_Add_Pison(u)
    local LimitParameter=10
    Units[u].Skill_Pison_PisonPoint=0
    gcudLua.TimerFunction(1,function()
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
    local AddArmorParameter,AddAttackParameter,AddHpParameter=1.5,5,100
    gcudLua.TimerFunction(RefreshTime,function()
        if Constant.GameOver then
            DestroyTimer(GetExpiredTimer())
        elseif gcudLua.UnitIsAlive(u) then
            local X,Y=GetUnitX(u),GetUnitY(u)
            local Level=GetUnitLevel(u)
            local AddArmor,AddAttack,AddHp=AddArmorParameter*Level,AddAttackParameter*Level,AddHpParameter*Level
            for i =1, Number do
                if  GetPlayerUnitTypeCount(p,ut)<Number then
                    local wolf=gcudLua.CreateUnitAtCoordinate(p,ut,X,Y)
                    gcudLua.ModifyUnitArmor(wolf,AddArmor,true)
                    gcudLua.ModifyUnitAttackPower(wolf,AddAttack,true)
                    gcudLua.ModifyUnitMaxHP(wolf,AddHp,true)
                    gcudLua.ModifyUnitHP(wolf,AddHp,true)
                else
                    break
                end
            end
        end
    end)
end