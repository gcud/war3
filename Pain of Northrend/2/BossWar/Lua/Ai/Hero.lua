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
                if HpRate<Constant.Value.AiHeroFleeHpRate or gcudLua.GetUnitHP(NowHero[p].Unit)<Constant.Value.AiHeroFleeHpMin then
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
        if gcudLua.UnitHaveSkill(u, Constant.Skill.BuyItem) and gcudLua.InventoryAddItemAble(h) then
            Ai_Hero_BuyItem(p,u)
        end
    end)
end

function Ai_Hero_BuyItem(p,Shopper)
    Ai_Hero_BuyGrocery(p,Shopper)
    Ai_Hero_BuyArmor(p,Shopper)
    Ai_Hero_BuyWeapon(p,Shopper)
end

function Ai_Hero_BuyWeapon(p,Shopper)
    --精炼铁剑
    if gcudLua.GetPlayerGold(p)>=ItemTypeData[Constant.ItemType.ConciseIronSword].Gold then
        IssueNeutralImmediateOrderById(p, Shopper, Constant.ItemType.ConciseIronSword)
    else
        IssueNeutralImmediateOrderById(p, Shopper, Constant.ItemType.GoodIronSword)
    end
end

function Ai_Hero_BuyArmor(p,Shopper)
    --皮泽洛头盔
    if gcudLua.GetPlayerGold(p)>=ItemTypeData[Constant.ItemType.PizaloLeatherHelmet].Gold then
        IssueNeutralImmediateOrderById(p, Shopper, Constant.ItemType.PizaloLeatherHelmet)
    else
        IssueNeutralImmediateOrderById(p, Shopper, Constant.ItemType.GoodLeatherHelmet)
    end
end

function Ai_Hero_BuyGrocery(p,Shopper)
    --生命护身符
    IssueNeutralImmediateOrderById(p, Shopper, Constant.ItemType.LifeAmulet)
end