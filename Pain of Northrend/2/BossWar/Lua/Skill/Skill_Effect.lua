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
    local DamageParameter=1.5
    local Damage=GetUpgradeAbilityLevel(u,Constant.Skill.Poison)*DamageParameter
    local TimeParameter=0.5
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
    local DamageParameter,Rate,Radius,BaseDamage=10,15,300,100
    local Damage=GetUpgradeAbilityLevel(u,Constant.Skill.Shock)*DamageParameter+BaseDamage
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

--魔法洪流
function Skill_Effect_MagicWave(u,p,X,Y)
    local CoolDown,Radius,DamageParameter,ManaMin,ManaRate,EffectNumber=15,500,5,100,0.35,50
    local NowMana=gcudLua.GetUnitMagical(u)
    if NowMana>ManaMin then
        local UseMana=NowMana*ManaRate
        local Damage=UseMana*DamageParameter
        for i = 1, EffectNumber do
            DestroyEffect(AddSpecialEffect("Abilities/Spells/Other/CrushingWave/CrushingWaveDamage.mdl",GetRandomReal(X-Radius,X+Radius),GetRandomReal(Y-Radius,Y+Radius)))
        end
        gcudLua.ModifyUnitMagical(u,UseMana,false)
        gcudLua.EnumUnitsInRangeDoActionAtCoordinate(X,Y,Radius,function (RangeUnit)
            if gcudLua.gcudFilter({"EnemyUnit","AliveUnit","NotMagicImmune"},{MainUnit=RangeUnit,MainPlayer=p}) then
                UnitDamageTarget(u,RangeUnit,Damage,false,false,ATTACK_TYPE_NORMAL,DAMAGE_TYPE_MAGIC,WEAPON_TYPE_WHOKNOWS)
            end
        end)
        Units[u].MagicWave=false
        gcudLua.TimerFunctionOnce(CoolDown,function ()
        Units[u].MagicWave=true
        end)
    end
end

--分裂攻击
function Skill_Effect_SplitAttack(u,Damage,p)
    local Radius,DamageParameter=300,1
    local Damage=Damage*DamageParameter
    gcudLua.EnumUnitsInRangeDoActionAtCoordinate(GetUnitX(u),GetUnitY(u), Radius, function (Target)
        if(gcudLua.UnitIsAlive(Target)and IsUnitEnemy(Target,p))then
            UnitDamageTarget(u,Target,Damage,false,false,ATTACK_TYPE_NORMAL,DAMAGE_TYPE_NORMAL)
        end
    end)
end

--致命一击
function Skill_Effect_StrikeAttack(u,Target,Damage)
    local Rate,DamageParameter,BaseDamage=15,0.1,200
    local Damage=Damage*GetUpgradeAbilityLevel(u,Constant.Skill.StrikeAttack)*DamageParameter+BaseDamage
    if GetRandomInt(1,100)<=Rate then
        CreateDamageTipsAtUnit(u,Damage)
        UnitDamageTarget(u,Target,Damage,false,false,ATTACK_TYPE_NORMAL,DAMAGE_TYPE_NORMAL)
        IncreaseAbilityProficiency(u,Constant.Skill.StrikeAttack)
    end
end

--自爆
function Skill_Effect_Boom(u)
    local DamageParameter,Radius,X,Y=3,500,GetUnitX(u), GetUnitY(u)
    local Damage=BlzGetUnitMaxHP(u)*DamageParameter
    DestroyEffect(AddSpecialEffect("Objects/Spawnmodels/Other/NeutralBuildingExplosion/NeutralBuildingExplosion.mdl", X, Y))
    UnitDamagePoint(u, 0, Radius,X,Y,Damage, false, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_NORMAL, WEAPON_TYPE_WHOKNOWS)
end

--剑术
function Skill_Effect_Fencing(u)
    local Rate,AddDamage=15,GetUpgradeAbilityLevel(u, Constant.Skill.Fencing)
    if GetRandomInt(1,100)<=Rate then
        BlzSetEventDamageType(DAMAGE_TYPE_DEMOLITION)
        BlzSetEventDamage(GetEventDamage()+AddDamage)
        IncreaseAbilityProficiency(u,Constant.Skill.Fencing)
        local Effect=AddSpecialEffectTarget("Abilities/Spells/Orc/TrollBerserk/HeadhunterWEAPONSLeft.mdl", u, "weapon")
        gcudLua.TimerFunctionOnce(1,function()
            DestroyEffect(Effect)
        end)
    end
end

--连击
function Skill_Effect_Batter(u,Target,Damage)
    local Rate,AttackNumberMin,AttackNumberMax=15,1,5
    local AttackNumber=GetRandomInt(AttackNumberMin,AttackNumberMax)
    if GetRandomInt(1,100)<=Rate then
        local AttackType,WeaponType,IsRange=BlzGetEventAttackType(),BlzGetEventWeaponType(),IsUnitType(u, UNIT_TYPE_RANGED_ATTACKER)
        for i = 1, AttackNumber do
            gcudLua.TimerFunctionOnce(0.1,function ()
                UnitDamageTarget(u,Target,Damage,true,IsRange,AttackType,DAMAGE_TYPE_NORMAL,WeaponType)
                DestroyEffect(AddSpecialEffectTarget("Abilities/Spells/Human/FlakCannons/FlakTarget.mdl",u,"weapon"))
            end)
        end
    end
end