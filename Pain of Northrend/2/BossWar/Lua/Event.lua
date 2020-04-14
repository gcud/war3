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
    --RegisterAnyUnitEvent(t, EVENT_PLAYER_UNIT_DAMAGING)
    RegisterAnyUnitEvent(t, EVENT_PLAYER_UNIT_DAMAGED)
    TriggerAddAction(t, function()
        local DamageValue = GetEventDamage()
        -- 只处理正数伤害
        if DamageValue > 0 then
            local DamageTarget,DamageSource=BlzGetEventDamageTarget(),GetEventDamageSource()
            local DamageTargetPlayer,DamageSourcePlayer=GetTriggerPlayer(),GetOwningPlayer(DamageSource)
            --攻击伤害
            if gcudLua.IsAttackDamage() then
                if gcudLua.UnitHaveSkill(DamageSource, Constant.Skill.Charm) and IsUnitEnemy(DamageSource,DamageTargetPlayer) and  GetUnitLevel(DamageSource)>=GetUnitLevel(DamageTarget) and not IsUnitType(DamageTarget,UNIT_TYPE_GIANT) and not IsUnitType(DamageTarget,UNIT_TYPE_MECHANICAL) then
                    Skill_Effect_Charm(DamageSource, DamageTarget,DamageSourcePlayer)
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
            Strike={Rate=0,Random=0}
        }
        if (gcudLua.IsHero(u)) then
            local p = GetOwningPlayer(u)
            if (gcudLua.InOrderedTable(p, gcudLua.AiPlayers)) then
                -- ToDo:注册Ai
                -- RegisterHeroAi(u)
            end
            --SkillInit(u, p)
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
        if (p ~= gcudLua.MonsterPlayer) then
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
