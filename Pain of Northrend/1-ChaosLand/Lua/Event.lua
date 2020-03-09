function InitEvent()
    InitEvent = nil
    InitDamageEvent()
    InitDieEvent()
    InitEnterMapEvent()
    InitLearnSkillEvent()
    InitSpellEvent()
    InitChatEvent()
    InitAttackEvent()
    InitLevelUpEvent()
    InitGetItemEvent()
    InitOwnerChangeEvent()
    InitSelectUnitEvent()
end

--伤害事件
function InitDamageEvent()
    InitDamageEvent = nil
    local t = CreateTrigger()
    RegisterAnyUnitEvent(t, EVENT_PLAYER_UNIT_DAMAGED)
    TriggerAddAction(t, function()
        local DamageSource = GetEventDamageSource()
        local DamageTarget = BlzGetEventDamageTarget()
        --攻击伤害
        if (IsAttackDamage()) then
            --阴影之击
            if (UnitHaveSkill(DamageSource, Constant.Skill.ShadowAttack)) then
                Skill_Effect_ShadowAttack(DamageTarget)
            end
        end
        --将死伤害
        if (IsHero(DamageTarget) and GetUnitHP(DamageTarget) < (GetEventDamage() + 100) and InOrderedTable(GetTriggerPlayer(), Constant.Group.AiPlayers)) then
            HeroAi_Dying(DamageTarget)
        end
        --全建筑维修
        if (IsStructure(DamageTarget) and GetUnitHPRate(DamageTarget) < 0.6 and not UnitHaveSkill(DamageTarget, Constant.Buff.AllStructureRepair)) then
            Skill_AllStructureRepair(DamageTarget)
        end
    end)
end

--死亡事件
function InitDieEvent()
    InitDieEvent = nil
    local t = CreateTrigger()
    RegisterAnyUnitEvent(t, EVENT_PLAYER_UNIT_DEATH)
    TriggerAddAction(t, function()
        local Dead, Killer = GetDyingUnit(), GetKillingUnit()
        KillSummary(Killer, Dead)
        SourceReward(Killer, Dead)
        KillTip(Killer, Dead)
        if (IsHero(Dead)) then
            local p = GetTriggerPlayer()
            if (InOrderedTable(p, Constant.Group.AiPlayers)) then
                Ai_ReBornHero(p, Dead)
            end
        else
            if (GetUnitTypeId(Dead) == Constant.UnitType.GoldMine) then
                GoldMineRegenerate()
            elseif(GetOwningPlayer(Dead) == Base.NEUTRAL_AGGRESSIVE and InOrderedTable(Dead, Constant.Group.CenterMonster)) then
                MonsterDropItem(GetUnitX(Dead), GetUnitY(Dead), GetUnitLevel(Dead))
            end
            ClearUnitData(Dead)
        end
    end)
end

--进入地图
function InitEnterMapEvent()
    InitEnterMapEvent = nil
    local t = CreateTrigger()
    local TemporaryRegion = CreateRegion()
    RegionAddRect(TemporaryRegion, Base.MAP_AREA)
    TriggerRegisterEnterRegion(t, TemporaryRegion, nil)
    TriggerAddAction(t, function()
        local u = GetEnteringUnit()
        if (UnitHaveSkill(u, Constant.Skill.SilenceAura)) then
            Skill_Effect_SilenceAura(u)
        end
        if (IsHero(u)) then
            local p = GetOwningPlayer(u)
            if (InOrderedTable(p, Constant.Group.AiPlayers)) then
                Constant.PlayerData[p]["HeroNumber"]=Constant.PlayerData[p]["HeroNumber"]+1
                RegisterHeroAi(u)
            end
        end
    end)
end

--学习技能
function InitLearnSkillEvent()
    InitLearnSkillEvent = nil
    local t = CreateTrigger()
    RegisterAnyUnitEvent(t, EVENT_PLAYER_HERO_SKILL)
    TriggerAddAction(t, function()
        local Skill = GetLearnedSkill()
        local Hero=GetLearningUnit()
        if (Skill == Constant.Skill.AttributeMod) then
            Skill_Effect_AttributeMod(Hero)
        end
        if(GetUnitAbilityLevel(Hero,Skill)==1 and InOrderedTable(GetTriggerPlayer(),Constant.Group.AiPlayers))then
            InitSkill(Hero,Skill)
        end
    end)
end

--施法
function InitSpellEvent()
    InitSpellEvent = nil
    local t = CreateTrigger()
    RegisterAnyUnitEvent(t, EVENT_PLAYER_UNIT_SPELL_EFFECT)
    TriggerAddAction(t, function()
        local Skill = GetSpellAbilityId()
        if (Skill == Constant.Skill.Repair) then
            Skill_Effect_Repair(GetSpellAbilityUnit())
        elseif (Skill == Constant.Skill.AllStructureRepair) then
            Skill_Effect_AllStructureRepair(GetSpellAbilityUnit())
        elseif (Skill == Constant.Skill.Wall) then
            Skill_Effect_Wall(GetSpellAbilityUnit())
        end
    end)
end

--输入聊天信息
function InitChatEvent()
    InitChatEvent = nil
    local t = CreateTrigger()
    for i = 1, #Constant.Group.UserPlayers do
        TriggerRegisterPlayerChatEvent(t, Constant.Group.UserPlayers[i], "", false)
    end
    TriggerAddAction(t, function()
        local p=GetTriggerPlayer()
        if(InOrderedTable(p,Constant.Group.UserPlayers))then
            CommandHandle(p, GetEventPlayerChatString())
        end
    end)
end

--被攻击
function InitAttackEvent()
    InitAttackEvent = nil
    local t = CreateTrigger()
    RegisterAnyUnitEvent(t, EVENT_PLAYER_UNIT_ATTACKED)
    TriggerAddAction(t, function()
        local u = GetTriggerUnit()
        local p = GetTriggerPlayer()
        if (not IsStructure(u) and InOrderedTable(p, Constant.Group.AiPlayers) and  not BlzIsUnitInvulnerable(u)) then
            local hp = GetUnitHP(u)-Constant.Value.KillDyingDamageFix
            if (hp < 100 or hp < GetUnitLevel(GetAttacker()) * Constant.Value.KillDyingDamageRate) then
                Ai_KillDying(p, u, hp)
            end
        end
    end)
end

--升级
function InitLevelUpEvent()
    InitLevelUpEvent = nil
    local t = CreateTrigger()
    RegisterAnyUnitEvent(t, EVENT_PLAYER_HERO_LEVEL)
    TriggerAddAction(t, function()
        local Hero = GetTriggerUnit()
        local p = GetTriggerPlayer()
        if (InOrderedTable(p, Constant.Group.AiPlayers)) then
            HeroAi_LearnSkill(Hero)
        end
    end)
end

--获得物品
function InitGetItemEvent()
    InitGetItemEvent = nil
    local t = CreateTrigger()
    RegisterAnyUnitEvent(t, EVENT_PLAYER_UNIT_PICKUP_ITEM)
    TriggerAddAction(t, function()
        local Item = GetManipulatedItem()
        local Number = GetItemCharges(Item)
        if (Number > 0) then
            local ItemType = GetItemTypeId(Item)
            for i = 0, 5 do
                local NowItem = UnitItemInSlot(GetManipulatingUnit(), i)
                if (GetItemTypeId(NowItem) == ItemType and NowItem ~= Item) then
                    SetItemCharges(Item, GetItemCharges(NowItem) + Number)
                    RemoveItem(NowItem)
                    break
                end
            end
            if (ItemType == Constant.ItemType.Base or ItemType == Constant.ItemType.MostBase and InOrderedTable(GetTriggerPlayer(), Constant.Group.AiPlayers)) then
                HeroAi_UseBaseItem(GetTriggerUnit())
            end
        else

        end
    end)
end

--改变玩家
function InitOwnerChangeEvent()
    InitOwnerChangeEvent=nil
    local t=CreateTrigger()
    RegisterAnyUnitEvent(t,EVENT_PLAYER_UNIT_CHANGE_OWNER)
    TriggerAddAction(t,function ()
        if(GetTriggerPlayer()==Base.NEUTRAL_AGGRESSIVE)then
            --从中心怪物组移除
            OrderTableRemoveItem(Constant.Group.CenterMonster,GetTriggerUnit())
        end
    end)
end

--选择单位
function InitSelectUnitEvent()
    InitSelectUnitEvent = nil
    local t = CreateTrigger()
    RegisterAnyUnitEvent(t, EVENT_PLAYER_UNIT_SELECTED)
    TriggerAddAction(t, function()
        Constant.PlayerData[GetTriggerPlayer()]["SelectedUnit"] = GetTriggerUnit()
    end)
end