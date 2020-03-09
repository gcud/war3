function RegisterAi(p)
    local Race = GetPlayerRace(p)
    Ai_Race(p, Race)
    Ai_Research(p, Race)
    Ai_BuyWork(p)
    Ai_GoblinMinerMining(p)
    Ai_Build(p, Race)
    Ai_BuyHero(p)
end

function Ai_Race(p, Race)
    if (Race == RACE_ORC) then
        StartMeleeAI(p, "orc.ai")
    elseif (Race == RACE_UNDEAD) then
        StartMeleeAI(p, "undead.ai")
    elseif (Race == RACE_NIGHTELF) then
        StartMeleeAI(p, "elf.ai")
    else
        StartMeleeAI(p, "human.ai")
    end
end

function Ai_Research(p, Race)
    TimerFunction(60, function()
        if (InOrderedTable(p, Constant.Group.AiPlayers) and Constant.GameOver == false) then
            if (GetPlayerGold(p) >= Constant.Value.AiResearchMinGold and GetPlayerLumber(p) >= Constant.Value.AiResearchMinLumber) then
                local Research = Constant.PlayerData[p]["Research"]
                if (Research < 4) then
                    local Finished = true
                    local ResearchList = Constant.Research[Race][Research]
                    for i = 1, #ResearchList do
                        local NowResearch = ResearchList[i]["Item"]
                        if (GetPlayerTechCount(p, NowResearch, true) < Constant.Value.ResearchMaxLevel) then
                            local Structure = ResearchList[i]["Structure"]
                            if (type(Structure) == "table") then
                                for j = 1, 10 do
                                    AiPlayerResearch(p, NowResearch, Structure[j])
                                end
                            else
                                AiPlayerResearch(p, NowResearch, Structure)
                            end
                            Finished = false
                        end
                    end
                    if (Finished) then
                        Constant.PlayerData[p]["Research"] = Constant.PlayerData[p]["Research"] + 1
                    end
                else
                    DestroyTimer(GetExpiredTimer())
                end
            end
        else
            DestroyTimer(GetExpiredTimer())
        end
    end)
end

function Ai_Build(p, Race)
    local FoodStructureType, ShopType = Constant.UnitType.FoodStructure[Race], Constant.UnitType.Shop[Race]
    TimerFunction(Constant.Time.AiBuildInterval, function()
        if (InOrderedTable(p, Constant.Group.AiPlayers) and Constant.GameOver == false) then
            local Builders = nil
            --人口建筑
            if (GetPlayerState(p, PLAYER_STATE_RESOURCE_FOOD_CAP) < 200) then
                Builders = GetPlayerIdleBuilders(p)
                if (#Builders > 0) then
                    Build(Builders[GetRandomInt(1, #Builders)], FoodStructureType)
                end
            end
            --商店
            if (GetPlayerUnitTypeCount(p, ShopType) < Constant.Number.AiShop) then
                if (Builders == nil) then
                    Builders = GetPlayerIdleBuilders(p)
                end
                if (#Builders > 0) then
                    Build(Builders[GetRandomInt(1, #Builders)], ShopType)
                end
            end
        else
            DestroyTimer(GetExpiredTimer())
        end
    end)
end

function Ai_BuyWork(p)
    TimerFunction(Constant.Time.AiBuyWorkerInterval, function()
        if (InOrderedTable(p, Constant.Group.AiPlayers) and Constant.GameOver == false) then
            --地精矿工
            if (GetPlayerUnitTypeCount(p, Constant.UnitType.GoblinMiner) < Constant.Number.AiBuyGoblinMiner) then
                BuyWorker(p, Constant.UnitType.GoblinMiner)
            end
            --地精撕裂者
            if (GetPlayerUnitTypeCount(p, Constant.UnitType.IronGoblin) < Constant.Number.AiBuyIronGoblin) then
                BuyWorker(p, Constant.UnitType.IronGoblin)
            end
        else
            DestroyTimer(GetExpiredTimer())
        end
    end)
end

function Ai_GoblinMinerMining(p)
    TimerFunction(Constant.Time.AiGoblinMinerActionInterval, function()
        if (InOrderedTable(p, Constant.Group.AiPlayers) and Constant.GameOver == false) then
            if (GetPlayerUnitTypeCount(p, Constant.UnitType.GoblinMiner) > 0) then
                local Target = Constant.PlayerData[p]["GoblinMinerTarget"]
                --查找新目标
                if (Target == nil or not UnitIsAlive(Target) or IsUnitHidden(Target)) then
                    Constant.PlayerData[p]["GoblinMinerTarget"] = nil
                    --获取一个随机的可用金矿
                    local GoldMines={}
                    for i = 1, #Constant.Group.GoldMines do
                        local GoldMine = Constant.Group.GoldMines[i]
                        if (IsUnitVisible(GoldMine, p) and UnitIsAlive(GoldMine) and not IsUnitHidden(GoldMine)) then
                            table.insert(GoldMines,GoldMine)
                        end
                    end
                    if(#GoldMines>0)then
                        Constant.PlayerData[p]["GoblinMinerTarget"] = GoldMines[GetRandomInt(1,#GoldMines)]
                    end
                else
                    --发布采集命令
                    local Workers = {}
                    local g = CreateGroup()
                    GroupEnumUnitsOfType(g, "chaospeon", nil)
                    ForGroup(g, function()
                        local u = GetEnumUnit()
                        if (GetOwningPlayer(u) == p and UnitIsAlive(u) and not IsUnitHidden(u) and GetUnitCurrentOrder(u)==0) then
                            IssueTargetOrder(u, "harvest", Target)
                            table.insert(Workers, u)
                        end
                    end)
                    DestroyGroup(g)
                    --判断接收黄金容器
                    local Receiver = Constant.PlayerData[p]["GoblinMinerReceiver"]
                    if (Receiver == nil or not UnitIsAlive(Receiver) or not IsUnitOwnedByPlayer(Receiver, p)) then
                        Constant.PlayerData[p]["GoblinMinerReceiver"] = nil
                        --查找附近
                        local X, Y = GetUnitX(Target), GetUnitY(Target)
                        EnumUnitsInRangeDoActionAtCoordinate(X, Y, 1500, function(EnumUnit)
                            if (UnitHaveSkill(EnumUnit, Constant.Skill.ReceiveGoldAndLumber) and IsUnitOwnedByPlayer(EnumUnit, p) and UnitIsAlive(EnumUnit)) then
                                Constant.PlayerData[p]["GoblinMinerReceiver"] = EnumUnit
                                return true
                            end
                        end)
                        local WorkersNumber = #Workers
                        if (Constant.PlayerData[p]["GoblinMinerReceiver"] == nil and WorkersNumber > 0) then
                            --获取一个随机的地精矿工
                            local Builder = Workers[GetRandomInt(1, WorkersNumber)]
                            for i = 1, Constant.Value.BuildTryMax do
                                if (IssueBuildOrderById(Builder, Constant.UnitType.Warehouse, GetRandomReal(X - 1000, X + 1000), GetRandomReal(Y - 1000, Y + 1000))) then
                                    break
                                end
                            end
                        end
                    end
                end
            else
                Constant.PlayerData[p]["GoblinMinerTarget"]=nil
            end
        else
            DestroyTimer(GetExpiredTimer())
        end
    end)
end

--购买英雄
function Ai_BuyHero(p)
    TimerFunction(Constant.Time.AiRebornHeroInterval, function()
        if (InOrderedTable(p, Constant.Group.AiPlayers) and Constant.GameOver==false and Constant.PlayerData[p]["HeroNumber"] < Constant.Number.MaxHero) then
                for i = 1, #Constant.Group.Taverns do
                    IssueNeutralImmediateOrderById(p, Constant.Group.Taverns[i], Constant.UnitType.ExtraHero[GetRandomInt(1, #Constant.UnitType.ExtraHero)])
                end
        else
            DestroyTimer(GetExpiredTimer())
        end
    end)
end

--反补
function Ai_KillDying(p, u, hp)
    --我对现在的反补不满意,参与反补的单位动作明显慢了,需要发动攻击的似乎没攻击
    local IsGround = IsUnitType(u, UNIT_TYPE_GROUND)
    local DamageValue = 0
    EnumUnitsInRangeDoActionAtCoordinate(GetUnitX(u), GetUnitY(u), 600, function(Target)
        if (DamageValue < hp) then
            if (gcudFilter({ "Alive", "AllianceUnit", "NotStructure" }, { MainUnit = Target, MainPlayer = p }) and InOrderedTable(GetOwningPlayer(Target), Constant.Group.AiPlayers) and not IsUnitType(Target, UNIT_TYPE_PEON) and Target ~= u) then
                if ((IsGround and IsUnitType(Target, UNIT_TYPE_ATTACKS_GROUND)) or (not IsGround and IsUnitType(Target, UNIT_TYPE_ATTACKS_FLYING))) then
                    IssueTargetOrder(Target, "attack", u)
                    DamageValue = DamageValue + (GetUnitLevel(Target) * Constant.Value.KillDyingDamageRate)
                end
            end
        else
            return true
        end
    end)
end

--复活英雄
function Ai_ReBornHero(p, h)
    TimerFunction(Constant.Time.AiRebornHeroInterval, function()
        if (InOrderedTable(p, Constant.Group.AiPlayers) and Constant.GameOver==false) then
            if (UnitIsAlive(h)) then
                DestroyTimer(GetExpiredTimer())
            else
                local Result = false
                for i = 1, #Constant.Group.Taverns do
                    if (IssueNeutralTargetOrder(p, Constant.Group.Taverns[i], "awaken", h)) then
                        Result = true
                        break
                    end
                end
                if (not Result) then
                    local Altars = {}
                    local g = CreateGroup()
                    GroupEnumUnitsOfPlayer(g, p, nil)
                    ForGroup(g, function()
                        local Target = GetEnumUnit()
                        local ut = GetUnitTypeId(Target)
                        if (InOrderedTable(ut, Constant.UnitType.Altar) and UnitIsAlive(Target)) then
                            table.insert(Altars, Target)
                        end
                    end)
                    DestroyGroup(g)
                    if (#Altars > 0) then
                        IssueTargetOrder(Altars[GetRandomInt(1, #Altars)], "revive", h)
                    end
                end
            end
        else
            DestroyTimer(GetExpiredTimer())
        end
    end)
end