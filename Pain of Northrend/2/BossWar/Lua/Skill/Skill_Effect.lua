--魅惑
function Skill_Effect_Charm(u,target)
    local Parameter,BaseProbability=1,5
    local Probability=GetUpgradeAbilityLevel(u,Constant.Skill.Charm)*Parameter+BaseProbability
    if GetRandomInt(1,100)<=Probability then
        DestroyEffect(AddSpecialEffectTarget("Abilities/Spells/Other/Charm/CharmTarget.mdl", target, "origin"))
        SetUnitOwner(target,GetOwningPlayer(u),true)
        IncreaseAbilityProficiency(u,Constant.Skill.Charm)
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
                local Height=GetUnitFlyHeight(BaseTarget)
                local Lightning=AddLightningEx("CLSB", false, StartX, StartY,Height,NewX,NewY,Height)
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

--毒
function Skill_Effect_Pison(u,Target)
    local DamageParameter=1
    local Damage=GetUpgradeAbilityLevel(u,Constant.Skill.Poison)*DamageParameter
    local TimeParameter=1
    local Time,NowTime=GetUpgradeAbilityLevel(u,Constant.Skill.Poison)*TimeParameter,0
    Units[u].Skill_Pison_PisonPoint=Units[u].Skill_Pison_PisonPoint-1
    IncreaseAbilityProficiency(u,Constant.Skill.Poison)
    --绑定特效到单位
    local Effect=AddSpecialEffectTarget("Abilities/Weapons/PoisonSting/PoisonStingTarget.mdl", Target, "origin")
    gcudLua.TimerFunction(1, function()
        if Constant.GameOver or not gcudLua.UnitIsAlive(Target) or NowTime>=Time then
            DestroyEffect(Effect)
            DestroyTimer(GetExpiredTimer())
        else
            NowTime=NowTime+1
            UnitDamageTarget(u,Target, Damage, false, false,ATTACK_TYPE_MELEE,DAMAGE_TYPE_POISON, WEAPON_TYPE_WHOKNOWS)
        end
    end)
end

--磐石
function Skill_Effect_Rock(u,DamageValue)
    local Rate=65
    local DamageReduceParamter=1
    local DamageReduce=GetUpgradeAbilityLevel(u,Constant.Skill.Rock)*DamageReduceParamter
    if GetRandomInt(1,100)<=Rate then
        BlzSetEventDamage(DamageValue-DamageReduce)
        if DamageValue>DamageReduce then
            IncreaseAbilityProficiency(u,Constant.Skill.Rock)
        end
    end
end

--魔法禁用
function Skill_Effect_BanMagic(u,Target,ManaCost)
    local DamageParameter=10
    local Damage=GetUpgradeAbilityLevel(u,Constant.Skill.BanMagic)*DamageParameter+ManaCost
    UnitDamageTarget(u,Target,Damage,false,false,ATTACK_TYPE_NORMAL,DAMAGE_TYPE_MAGIC,WEAPON_TYPE_WHOKNOWS)
    IncreaseAbilityProficiency(u,Constant.Skill.BanMagic)
end

--震击
function Skill_Effect_Shock(u)
    local DamageParameter,Rate,Radius=10,15,300
    local Damage=GetUpgradeAbilityLevel(u,Constant.Skill.Shock)*DamageParameter
    if GetRandomInt(1,100)<=Rate then
        local X,Y=GetUnitX(u),GetUnitY(u)
        local p=GetOwningPlayer(u)
        DestroyEffect(AddSpecialEffect("Abilities/Spells/Human/Thunderclap/ThunderClapCaster.mdl",X,Y))
        gcudLua.EnumUnitsInRangeDoActionAtCoordinate(X,Y,Radius,function (Target)
            if IsUnitEnemy(Target,p) and gcudLua.UnitIsAlive(Target) and IsUnitType(Target,UNIT_TYPE_GROUND) then
                UnitDamageTarget(u,Target,Damage,false,false,ATTACK_TYPE_NORMAL,DAMAGE_TYPE_NORMAL,WEAPON_TYPE_WHOKNOWS)
            end
        end)
        IncreaseAbilityProficiency(u,Constant.Skill.Shock)
    end
end

--撕裂之爪,攻击时减少护甲,持续物理伤害
function Skill_Effect_TearingClam(u,Target)
    local ReduceArmor,Damage,Duration,NowTime=1.5,45,30,0
    local Effect=AddSpecialEffectTarget("Objects/Spawnmodels/Human/HumanBlood/BloodElfSpellThiefBlood.mdl", Target, "origin")
    gcudLua.ModifyUnitArmor(Target,ReduceArmor,false)
    gcudLua.TimerFunction(1,function ()
        if Constant.GameOver or not gcudLua.UnitIsAlive(Target) or NowTime >=Duration then
            gcudLua.ModifyUnitArmor(Target,ReduceArmor,true)
            DestroyEffect(Effect)
            DestroyTimer(GetExpiredTimer())
        else
            --法术攻击,破坏伤害(流血)
            UnitDamageTarget(u,Target,Damage,false,false,ATTACK_TYPE_NORMAL,DAMAGE_TYPE_DEMOLITION,WEAPON_TYPE_WHOKNOWS)
            NowTime=NowTime+1
        end
    end)
end