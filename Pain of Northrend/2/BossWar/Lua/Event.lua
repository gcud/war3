function InitEvent()
    InitEvent = nil
    InitDamageEvent()
    InitDieEvent()
    InitEnterMapEvent()
    InitSpellEvent()
    InitChatEvent()
    InitAttackEvent()
    InitLevelUpEvent()
    InitGetItemEvent()
    InitSelectUnitEvent()
    InitUseItemEvent()
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
        -- 绑定单位数据
        Units[u] = {
            EvasionPercent = 0,
            VampiricPercent = 0,
            PhysicalDamagePercent = 0,
            PhysicalDamageValue = 0,
            MagicDamagePercent = 0,
            MagicDamageValue = 0,
            Strike={Rate=0,Random=0},
        }
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
        --SkillEffect(GetSpellAbilityId(), GetSpellAbilityUnit(),GetTriggerPlayer())
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
        local u, Attacker = GetTriggerUnit(), GetAttacker()
        local p = GetTriggerPlayer()
        -- ToDo:技能效果
    end)
end

-- 升级
function InitLevelUpEvent()
    InitLevelUpEvent = nil
    local t = CreateTrigger()
    RegisterAnyUnitEvent(t, EVENT_PLAYER_HERO_LEVEL)
    TriggerAddAction(t, function()
        local Hero = GetTriggerUnit()
        local p = GetTriggerPlayer()
        local NowLevel = GetUnitLevel(Hero)
        local UpLevel = NowHero[p].Level - NowLevel
        NowHero[p].Level = NowLevel
        -- Ai属性补偿
        if (gcudLua.InOrderedTable(p, gcudLua.AiPlayers)) then
            gcudLua.ModifyHeroStrength(Hero, Constant.Value.AiAttributeCompensate, true)
            gcudLua.ModifyHeroAgile(Hero, Constant.Value.AiAttributeCompensate, true)
            gcudLua.ModifyHeroIntelligence(Hero, Constant.Value.AiAttributeCompensate,
                                   true)
        end
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
