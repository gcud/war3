function Ai_Hero_Init(h,p)
    Ai_Hero_TimerAction(p)
    Ai_Hero_BindInRange(h,p)
end

function Ai_Hero_TimerAction(p)
    gcudLua.TimerFunction(0.5,function ()
        if(Constant.GameOver)then
            DestroyTimer(GetExpiredTimer())
        else
            if gcudLua.UnitIsAlive(NowHero[p].Unit)  then
                local NowOrder=GetUnitCurrentOrder(NowHero[p].Unit)
                local HpRate=gcudLua.GetUnitHPRate(NowHero[p].Unit)
                --逃跑
                if (HpRate<Constant.Value.AiHeroFleeHpRate or gcudLua.GetUnitHP(NowHero[p].Unit)<Constant.Value.AiHeroFleeHpMin) and GetUnitLevel(NowHero[p].Unit)>=Constant.Value.AiHeroFleeMinLevel then
                    if  NowOrder~=gcudLua.CommandIds.Move and not IsUnitInRange(NowHero[p].Unit,Constant.Unit.ReviveStone,Constant.Value.SafeDistance) then
                        IssuePointOrder(NowHero[p].Unit,"move",GetRandomReal(Constant.Coordinate.Revive[1]-450,Constant.Coordinate.Revive[1]+450),GetRandomReal(Constant.Coordinate.Revive[2]-450,Constant.Coordinate.Revive[2]+450))
                    end
                --回复血量
                elseif HpRate<Constant.Value.AiHeroRecoverHpRate and IsUnitInRange(NowHero[p].Unit,Constant.Unit.ReviveStone,Constant.Value.SafeDistance) then
                    --什么也不要干
                else
                    if NowOrder==0  then
                    --进攻
                        IssuePointOrder(NowHero[p].Unit,"attack",gcudLua.GetRandomX(),gcudLua.GetRandomY())
                    end
                end
            end
        end
    end)
end

function Ai_Hero_BindInRange(h,p)
    local t=CreateTrigger()
    TriggerRegisterUnitInRange(t,h,500,nil)
    TriggerAddAction(t,function ()
        local u=GetTriggerUnit()
        --商人
        if gcudLua.UnitHaveSkill(u, Constant.Skill.BuyItem)then
             if gcudLua.InventoryAddItemAble(h) then
                Ai_Hero_BuyItem(p,u)
             else
                Ai_Hero_Inventory_Full_Action(h,p)
             end
        end
    end)
end

function Ai_Hero_BuyItem(p,Shopper)
    Ai_Hero_BuyGrocery(p,Shopper)
    Ai_Hero_BuyArmor(p,Shopper)
    Ai_Hero_BuyWeapon(p,Shopper)
end

function Ai_Hero_BuyWeapon(p,Shopper)
    --胜利之剑
    if gcudLua.GetPlayerGold(p)>=ItemTypeData[Constant.ItemType.VictorySword].Gold then
        IssueNeutralImmediateOrderById(p, Shopper, Constant.ItemType.VictorySword)
    else
        IssueNeutralImmediateOrderById(p, Shopper, Constant.ItemType.ConciseIronSword)
    end
end

function Ai_Hero_BuyArmor(p,Shopper)
    --奈芬哈尔头盔
    if gcudLua.GetPlayerGold(p)>=ItemTypeData[Constant.ItemType.NefrharHelmet].Gold then
        IssueNeutralImmediateOrderById(p, Shopper, Constant.ItemType.NefrharHelmet)
    else
        IssueNeutralImmediateOrderById(p, Shopper, Constant.ItemType.PizaloHelmet)
    end
end

function Ai_Hero_BuyGrocery(p,Shopper)    
    --医疗宝石
    if gcudLua.GetPlayerGold(p)>=ItemTypeData[Constant.ItemType.HealingGem].Gold then
        IssueNeutralImmediateOrderById(p, Shopper, Constant.ItemType.HealingGem)
    else
        IssueNeutralImmediateOrderById(p, Shopper, Constant.ItemType.LifeAmulet)
    end
end

function Ai_Hero_Inventory_Full_Action(h,p)
    --卖护甲
    if GetUnitArmorDamageRate(h)>Constant.Value.AiArmorRateCheck then
        for i = 0, 5 do
            local Item=UnitItemInSlot(h,i)
            if Item~=nil then
                local ItemType=GetItemTypeId(Item)
                if ItemType==Constant.ItemType.PizaloHelmet then
                    AiSellItem(i,ItemType,p)
                    break
                elseif ItemType==Constant.ItemType.NefrharHelmet then
                    AiSellItem(Item,ItemType,p)
                    break
                end
            end
        end
    end
    --卖增加生命值
    if gcudLua.UnitHaveTypeItem(h,Constant.ItemType.HealingGem) then
        for i = 0, 5 do
            local Item=UnitItemInSlot(h,i)
            if Item~=nil then
                local ItemType=GetItemTypeId(Item)
                if ItemType==Constant.ItemType.LifeAmulet then
                    AiSellItem(i,ItemType,p)
                    break
                end
            end
        end
    end
    --卖加攻击力
    if gcudLua.UnitHaveTypeItem(h,Constant.ItemType.VictorySword) then
        for i = 0, 5 do
            local Item=UnitItemInSlot(h,i)
            if Item~=nil then
                local ItemType=GetItemTypeId(Item)
                if ItemType==Constant.ItemType.ConciseIronSword then
                    AiSellItem(i,ItemType,p)
                    break
                end
            end
        end
    end
end