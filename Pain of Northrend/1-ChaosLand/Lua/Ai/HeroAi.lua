--注册英雄ai
function RegisterHeroAi(h)
    HeroAi_UseItem_Time(h)
    HeroAi_RegisterInRange(h)
    --学习第1级技能
    HeroAi_LearnSkill(h)
end

--进入英雄范围,目前用于商店,此触发不会正常排泄
function HeroAi_RegisterInRange(h)
    local p = GetOwningPlayer(h)
    local t = CreateTrigger()
    TriggerRegisterUnitInRange(t, h, 450)
    TriggerAddAction(t, function()
        local u = GetTriggerUnit()
        if (UnitHaveSkill(u, Constant.Skill.BuyItem) and IssueNeutralTargetOrder(p, u, "neutralinteract", h)) then
            HeroAi_BuyItem(p, u, h)
        end
    end)
end

--定期使用物品,此触发不会正常排泄
function HeroAi_UseItem_Time(h)
    local p = GetOwningPlayer(h)
    TimerFunction(Constant.Time.HeroAiUseItemInterval, function()
        if (InOrderedTable(p, Constant.Group.AiPlayers) and Constant.GameOver==false) then
            if (UnitIsAlive(h)) then
                local HpRate, MpRate = GetUnitHPRate(h), GetUnitMPRate(h)
                if (HpRate < 0.5 or MpRate < 0.5) then
                    for i = 0, 5 do
                        local Item = UnitItemInSlot(h, i)
                        if (Item ~= nil) then
                            local ItemType = GetItemTypeId(Item)
                            --补血
                            if (HpRate < 0.5 and (ItemType == Constant.ItemType.HugeHpPotion or ItemType == Constant.ItemType.HpPotion or ItemType == Constant.ItemType.HealingScroll)) then
                                UnitUseItem(h, Item)
                                --补魔
                            elseif (MpRate < 0.5 and (ItemType == Constant.ItemType.HugeManaPotion or ItemType == Constant.ItemType.ManaPotion)) then
                                UnitUseItem(h, Item)
                            end
                        end
                    end
                end
            end
        else
            DestroyTimer(GetExpiredTimer())
        end
    end)
end

--购买物品
function HeroAi_BuyItem(p, Shopper, h)
    local UnitType = GetUnitTypeId(Shopper)
    local HasBase = HasRaceBase(p)
    if (UnitType == Constant.UnitType.BlackStoreBusiness) then
        IssueNeutralImmediateOrderById(p, Shopper, Constant.ItemType.ProtectPotion)
        IssueNeutralImmediateOrderById(p, Shopper, Constant.ItemType.ReBorn)
        if (not UnitHaveTypeItem(h, Constant.ItemType.DefendMagic)) then
            IssueNeutralImmediateOrderById(p, Shopper, Constant.ItemType.DefendMagic)
        end
        --基地
        if (not HasBase) then
            IssueNeutralImmediateOrderById(p, Shopper, Constant.ItemType.MostBase)
        end
    else
        if (UnitType == Constant.UnitType.GoblinShop) then
        else
            local HasBall = UnitHaveTypeItem(h, Constant.ItemType.FrameBall) or UnitHaveTypeItem(h, Constant.ItemType.SlowBall) or UnitHaveTypeItem(h, Constant.ItemType.WeakenBall) or UnitHaveTypeItem(h, Constant.ItemType.PoisonousBall)
            if (UnitType == Constant.UnitType.Shop[RACE_ORC]) then
                if (not HasBall) then
                    IssueNeutralImmediateOrderById(p, Shopper, Constant.ItemType.SlowBall)
                end
                if (not HasBase) then
                    IssueNeutralImmediateOrderById(p, Shopper, Constant.ItemType.Base)
                end
                IssueNeutralImmediateOrderById(p, Shopper, Constant.ItemType.HugeHpPotion)
            elseif (UnitType == Constant.UnitType.Shop[RACE_HUM]) then
                if (not HasBall) then
                    IssueNeutralImmediateOrderById(p, Shopper, Constant.ItemType.FrameBall)
                end
                IssueNeutralImmediateOrderById(p, Shopper, Constant.ItemType.HugeManaPotion)
            elseif (UnitType == Constant.UnitType.Shop[RACE_UNDEAD]) then
                if (not HasBall) then
                    IssueNeutralImmediateOrderById(p, Shopper, Constant.ItemType.WeakenBall)
                end
                IssueNeutralImmediateOrderById(p, Shopper, Constant.ItemType.HealingScroll)
            else
                if (not HasBall) then
                    IssueNeutralImmediateOrderById(p, Shopper, Constant.ItemType.PoisonousBall)
                end
            end
            --生命药水
            IssueNeutralImmediateOrderById(p, Shopper, Constant.ItemType.HpPotion)
            --魔法药水
            if(GetUnitMagical(h)<500)then
                IssueNeutralImmediateOrderById(p, Shopper, Constant.ItemType.ManaPotion)
            end
        end
    end
    --回城卷轴
    IssueNeutralImmediateOrderById(p, Shopper, Constant.ItemType.BackBase)
end

--将死
function HeroAi_Dying(h)
    --神圣护甲
    if (not IssueImmediateOrder(h, "divineshield")) then
        --疾步风
        if (not IssueImmediateOrder(h, "windwalk")) then
            for i = 0, 5 do
                local Item = UnitItemInSlot(h, i)
                if (Item ~= nil) then
                    local ItemType = GetItemTypeId(Item)
                    if (ItemType == Constant.ItemType.ProtectPotion) then
                        if (UnitUseItem(h, Item)) then
                            break
                        end
                    elseif (ItemType == Constant.ItemType.HidePotion) then
                        if (UnitUseItem(h, Item)) then
                            break
                        end
                    elseif (ItemType == Constant.ItemType.BackBase) then
                        if (UnitUseItemTarget(h, Item, Item)) then
                            break
                        end
                    end
                end
            end
        end
    end
end

function HeroAi_LearnSkill(Hero)
    local Level, HeroId = GetUnitLevel(Hero), GetUnitTypeId(Hero)
    SelectHeroSkill(Hero, Constant.LearnSKill[HeroId][Level])
end

function HeroAi_UseBaseItem(Hero)
    local p = GetOwningPlayer(Hero)
    TimerFunction(10, function()
        if ((UnitHaveTypeItem(Hero, Constant.ItemType.Base) or UnitHaveTypeItem(Hero, Constant.ItemType.MostBase)) and InOrderedTable(p, Constant.Group.AiPlayers) and Constant.GameOver==false) then
            if(UnitIsAlive(Hero))then
                for i = 0, 5 do
                    local Item = UnitItemInSlot(Hero, i)
                    local ItemType = GetItemTypeId(Item)
                    if (ItemType == Constant.ItemType.Base or ItemType == Constant.ItemType.MostBase) then
                        UnitUseItemPoint(Hero, Item, GetUnitX(Hero), GetUnitY(Hero))
                        break
                    end
                end
            end
        else
            DestroyTimer(GetExpiredTimer())
        end
    end)
end