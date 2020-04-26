function InitEvent()
    InitEvent = nil
    InitDamageEvent()
    InitDieEvent()
    InitEnterMapEvent()
    InitSpellEvent()
    InitChatEvent()
    --InitAttackEvent()
    --InitLevelUpEvent()
    InitGetItemEvent()
    InitSelectUnitEvent()
    --InitUseItemEvent()
end

-- 伤害事件
function InitDamageEvent()
    InitDamageEvent = nil
    local t = CreateTrigger()
    RegisterAnyUnitEvent(t, EVENT_PLAYER_UNIT_DAMAGING)
    TriggerAddAction(t, function()
        local DamageValue = GetEventDamage()
        -- 只处理正数伤害
        if DamageValue > 0 then
            local DamageTarget,DamageSource=BlzGetEventDamageTarget(),GetEventDamageSource()
            local DamageTargetPlayer,DamageSourcePlayer=GetTriggerPlayer(),GetOwningPlayer(DamageSource)
            --伤害抗性处理,目前只处理Boss
            if IsUnitType(DamageTarget,UNIT_TYPE_GIANT) then
                --目前只处理毒伤害
                if BlzGetEventDamageType()==DAMAGE_TYPE_POISON and Units[DamageTarget].Resistance~=nil and Units[DamageTarget].Resistance.Poison>0 then
                    DamageValue=DamageValue*(1-Units[DamageTarget].Resistance.Poison)
                    BlzSetEventDamage(DamageValue)
                end
            end
            --物理伤害
            if gcudLua.IsPhysicalDamage() then
                --磐石
                if gcudLua.UnitHaveSkill(DamageTarget, Constant.Skill.Rock) then
                    Skill_Effect_Rock(DamageTarget,DamageValue)
                end
                --攻击伤害
                if gcudLua.IsAttackDamage() then
                    --魅惑
                    if gcudLua.UnitHaveSkill(DamageSource, Constant.Skill.Charm) then
                    if IsUnitEnemy(DamageSource,DamageTargetPlayer) and  GetUnitLevel(DamageSource)>=GetUnitLevel(DamageTarget) and not IsUnitType(DamageTarget,UNIT_TYPE_GIANT) and not IsUnitType(DamageTarget,UNIT_TYPE_MECHANICAL) then
                            Skill_Effect_Charm(DamageSource, DamageTarget)
                        end
                    --闪电攻击
                    elseif gcudLua.UnitHaveSkill(DamageSource, Constant.Skill.LightningAttack) then
                        if  IsUnitEnemy(DamageSource,DamageTargetPlayer)then
                            Skill_Effect_LightningAttack(DamageSource,DamageSourcePlayer,DamageTarget,DamageValue)
                        end
                    --毒
                    elseif gcudLua.UnitHaveSkill(DamageSource,Constant.Skill.Poison)then
                        if IsUnitEnemy(DamageSource,DamageTargetPlayer) and Units[DamageSource].Skill_Pison_PisonPoint>0  and not IsUnitType(DamageTarget,UNIT_TYPE_MECHANICAL) then
                            Skill_Effect_Pison(DamageSource, DamageTarget)
                        end
                    --震击
                    elseif gcudLua.UnitHaveSkill(DamageSource,Constant.Skill.Shock)then
                        if IsUnitEnemy(DamageSource,DamageTargetPlayer)then
                            Skill_Effect_Shock(DamageSource)
                        end
                    --撕裂之爪
                    elseif gcudLua.UnitHaveSkill(DamageSource,Constant.Skill.TearingClaw)then
                        if IsUnitEnemy(DamageSource,DamageTargetPlayer)then
                            Skill_Effect_TearingClam(DamageSource,DamageTarget)
                        end
                    end
                end
            end
        end
    end)
end

-- 死亡事件
function InitDieEvent()
    InitDieEvent = nil
    local t = CreateTrigger()
    RegisterAnyUnitEvent(t, EVENT_PLAYER_UNIT_DEATH)
    TriggerAddAction(t, function()
        local Dead, Killer = GetDyingUnit(), GetKillingUnit()
        local DeadPlayer, KillerPlayer = GetTriggerPlayer(),GetOwningPlayer(Killer)
        if DeadPlayer==gcudLua.MonsterPlayer and IsUnitEnemy(Dead, KillerPlayer) then
            KillReward(KillerPlayer, Dead)
        end
        --Action_KillSummary(Dead, Killer, DeadPlayer, KillerPlayer)
        if (gcudLua.IsHero(Dead)) then
            --Action_KillTip(Dead, Killer, DeadPlayer, KillerPlayer)
            Action_HeroTimerRevive(Dead, DeadPlayer)
            if IsUnitType(Killer,UNIT_TYPE_GIANT) then
                BossStrong(Killer,GetUnitLevel(Dead))
            end
        else
            ClearUnitData(Dead)
        end
    end)
end

-- 进入地图
function InitEnterMapEvent()
    InitEnterMapEvent = nil
    local t = CreateTrigger()
    local TemporaryRegion = CreateRegion()
    RegionAddRect(TemporaryRegion, gcudLua.MAP_AREA)
    TriggerRegisterEnterRegion(t, TemporaryRegion, nil)
    TriggerAddAction(t, function()
        local u = GetEnteringUnit()
        --添加单位属性使用的技能
        UnitAddAbility(u,Constant.ATTRIBUTE_ARMOR.Id)
        UnitAddAbility(u,Constant.ATTRIBUTE_ATTACK_POWER.Id)
        -- 绑定单位数据
        Units[u] = {
            --EvasionPercent = 0,
            --VampiricPercent = 0,
            --PhysicalDamagePercent = 0,
            --PhysicalDamageValue = 0,
            --MagicDamagePercent = 0,
            --MagicDamageValue = 0,
            --Strike={Rate=0,Random=0},
            Attribute={Armor=0,AttackPower=0}
        }
        --设置伤害抗性,然而只有Boss才有
        if IsUnitType(u,UNIT_TYPE_GIANT) then
            local id=GetUnitTypeId(u)
            for i = 1, #UnitType.BossList do
                if UnitType.BossList[i].Id==id then
                    Units[u].Resistance=UnitType.BossList[i].Resistance
                    break
                end
            end
        end
        if (gcudLua.IsHero(u)) then
            local p = GetOwningPlayer(u)
            NowHero[p].Unit=u
            --为英雄添加第一个技能
            Units[NowHero[p].Unit].SkillList={}
            local Skill=Constant.HeroSkillLists[GetUnitTypeId(NowHero[p].Unit)][1]
            AddSpecialAbility(NowHero[p].Unit,Skill)
            UnitMakeAbilityPermanent(NowHero[p].Unit, true,Skill.Id)
            table.insert(Units[NowHero[p].Unit].SkillList,{Id=Skill.Id,Name=Skill.Name,Level=Skill.Level,Proficiency=Skill.Proficiency})
            PlayerSelectSingleUnit(p, NowHero[p].Unit)
            if GetPlayerController(p) == MAP_CONTROL_COMPUTER then
                Ai_Hero_Init(NowHero[p].Unit,p)
            end
        end
    end)
end

-- 施法
function InitSpellEvent()
    InitSpellEvent = nil
    local t = CreateTrigger()
    RegisterAnyUnitEvent(t, EVENT_PLAYER_UNIT_SPELL_EFFECT)
    TriggerAddAction(t, function()
        local Speller,Target=GetSpellAbilityUnit(),GetSpellTargetUnit()
        local AbilityId=GetSpellAbilityId()
        --魔法禁用
        if gcudLua.UnitHaveSkill(Target,Constant.Skill.BanMagic) and IsUnitEnemy(Target,GetOwningPlayer(Speller)) then
            Skill_Effect_BanMagic(Target,Speller,BlzGetAbilityManaCost(AbilityId,GetUnitAbilityLevel(Speller,AbilityId)-1))
        end
    end)
end

-- 输入聊天信息
function InitChatEvent()
    InitChatEvent = nil
    local t = CreateTrigger()
    for i = 1, #gcudLua.HumanPlayers do
        TriggerRegisterPlayerChatEvent(t, gcudLua.HumanPlayers[i], "", false)
    end
    TriggerAddAction(t, function()
        local p = GetTriggerPlayer()
        if (gcudLua.InOrderedTable(p, gcudLua.HumanPlayers)) then
            CommandHandle(p, GetEventPlayerChatString())
        end
    end)
end

-- 被攻击
function InitAttackEvent()
    InitAttackEvent = nil
    local t = CreateTrigger()
    RegisterAnyUnitEvent(t, EVENT_PLAYER_UNIT_ATTACKED)
    TriggerAddAction(t, function()
        -- local u, Attacker = GetTriggerUnit(), GetAttacker()
        -- local p = GetTriggerPlayer()
        -- ToDo:技能效果
    end)
end

-- 升级
function InitLevelUpEvent()
    InitLevelUpEvent = nil
    local t = CreateTrigger()
    RegisterAnyUnitEvent(t, EVENT_PLAYER_HERO_LEVEL)
    TriggerAddAction(t, function()
        -- local Hero = GetTriggerUnit()
        -- local p = GetTriggerPlayer()
    end)
end

-- 获得物品
function InitGetItemEvent()
    InitGetItemEvent = nil
    local t = CreateTrigger()
    RegisterAnyUnitEvent(t, EVENT_PLAYER_UNIT_PICKUP_ITEM)
    TriggerAddAction(t, function()
        local Item = GetManipulatedItem()
        local u = GetManipulatingUnit()
        local Number = GetItemCharges(Item)
        if (Number > 0) then
            -- 物品叠加
            local ItemType = GetItemTypeId(Item)
            for i = 0, 5 do
                local NowItem = UnitItemInSlot(u, i)
                if (GetItemTypeId(NowItem) == ItemType and NowItem ~= Item) then
                    SetItemCharges(Item, GetItemCharges(NowItem) + Number)
                    RemoveItem(NowItem)
                    break
                end
            end
        else
        end
    end)
end

-- 选择单位
function InitSelectUnitEvent()
    InitSelectUnitEvent = nil
    local t = CreateTrigger()
    RegisterAnyUnitEvent(t, EVENT_PLAYER_UNIT_SELECTED)
    TriggerAddAction(t, function()
        PlayerData[GetTriggerPlayer()].SelectedUnit = GetTriggerUnit()
    end)
end

-- 使用物品
function InitUseItemEvent()
    InitUseItemEvent = nil
    local t = CreateTrigger()
    RegisterAnyUnitEvent(t, EVENT_PLAYER_UNIT_USE_ITEM)
    TriggerAddAction(t, function()
    end)
end
