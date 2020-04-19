--魅惑
function Skill_Effect_Charm(u,target,p)
    local Parameter=1
    local Probability=GetUpgradeAbilityLevel(u,Constant.Skill.Charm)*Parameter
    if GetRandomInt(1,100)<=Probability then
        DestroyEffect(AddSpecialEffectTarget("Abilities/Spells/Other/Charm/CharmTarget.mdl", target, "origin"))
        SetUnitOwner(target,GetOwningPlayer(u),true)
        IncreaseAbilityProficiency(p,Constant.Skill.Charm)
    end
end

--闪电攻击
function Skill_Effect_LightningAttack(DamageSource,p,BaseTarget,Damage)
    local Number,Range,DamageReduce=5,500,0.25
    local StartX,StartY,NewX,NewY=GetUnitX(BaseTarget),GetUnitY(BaseTarget),0,0
    local GetNewTarget=function (X, Y,NowTarget)
        local ReturnUnit=nil
        local g=CreateGroup()
        GroupEnumUnitsInRange(g,X,Y,Range,nil)
        if BlzGroupGetSize(g)>0 then
            for i = 1, BlzGroupGetSize(g) do
                local Index=GetRandomInt(0,BlzGroupGetSize(g)-1)
                local u=BlzGroupUnitAt(g,Index)
                GroupRemoveUnit(g,u)  
                if u~=NowTarget and IsUnitEnemy(u,p) and gcudLua.UnitIsAlive(u) then
                    ReturnUnit=u
                    break
                end
            end
        end
        DestroyGroup(g)
        return ReturnUnit
    end
    local NowNumber=0
    gcudLua.TimerFunction(0.2, function ()
        if Constant.GameOver then
            DestroyTimer(GetExpiredTimer())
        else
            local NewTarget=GetNewTarget(StartX,StartY,BaseTarget)
            if NewTarget==nil or NowNumber==Number then
                DestroyTimer(GetExpiredTimer())
            else
                NewX,NewY= GetUnitX(NewTarget) ,GetUnitY(NewTarget)
                UnitDamageTarget(DamageSource,NewTarget, Damage, false, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_LIGHTNING, WEAPON_TYPE_WHOKNOWS)
                local Lightning=AddLightningEx("CLSB", false, StartX, StartY,BlzGetUnitZ(BaseTarget),NewX,NewY,BlzGetUnitZ(NewTarget))
                gcudLua.TimerFunctionOnce(0.5,function ()
                    DestroyLightning(Lightning)
                end)
                StartX,StartY=NewX,NewY
                BaseTarget=NewTarget
                Damage=Damage*(1-DamageReduce)
            end
            NowNumber=NowNumber+1
        end
    end)
end