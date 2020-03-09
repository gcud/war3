--设置游戏面板文本
function SetGameBoardValue(RowIndex, ColumnIndex, Value)
    MultiboardSetItemValue(MultiboardGetItem(Constant.GameBoard, RowIndex, ColumnIndex), Value)
end

--注册任意单位事件
function RegisterAnyUnitEvent(t, e)
    for i = 1, #Constant.Group.Players do
        TriggerRegisterPlayerUnitEvent(t, Constant.Group.Players[i], e, nil)
    end
    --特别为中立被动和敌对注册
    TriggerRegisterPlayerUnitEvent(t, Base.NEUTRAL_AGGRESSIVE, e, nil)
    TriggerRegisterPlayerUnitEvent(t, Base.NEUTRAL_PASSIVE, e, nil)
end

--击杀统计
function KillSummary(Killer, Dead)
    local DeadPlayer = GetOwningPlayer(Dead)
    if (DeadPlayer ~= Base.NEUTRAL_AGGRESSIVE and DeadPlayer ~= Base.NEUTRAL_PASSIVE) then
        local DeadPlayerLine = Constant.PlayerData[DeadPlayer]["PlayerLine"]
        --损失单位
        Constant.PlayerData[DeadPlayer]["LoseUnit"] = Constant.PlayerData[DeadPlayer]["LoseUnit"] + 1
        SetGameBoardValue(DeadPlayerLine, 6, Constant.PlayerData[DeadPlayer]["LoseUnit"])
        --损失英雄
        if (IsHero(Dead)) then
            Constant.PlayerData[DeadPlayer]["LoseHero"] = Constant.PlayerData[DeadPlayer]["LoseHero"] + 1
            SetGameBoardValue(DeadPlayerLine, 2, Constant.PlayerData[DeadPlayer]["LoseHero"])
        end
        --损失建筑
        if (IsStructure(Dead)) then
            Constant.PlayerData[DeadPlayer]["LoseStructure"] = Constant.PlayerData[DeadPlayer]["LoseStructure"] + 1
            SetGameBoardValue(DeadPlayerLine, 4, Constant.PlayerData[DeadPlayer]["LoseStructure"])
        end
    end
    if (Killer ~= nil) then
        local KillerPlayer = GetOwningPlayer(Killer)
        if (KillerPlayer ~= Base.NEUTRAL_AGGRESSIVE and KillerPlayer ~= Base.NEUTRAL_PASSIVE) then
            local KillerPlayerLine = Constant.PlayerData[KillerPlayer]["PlayerLine"]
            --击杀单位
            Constant.PlayerData[KillerPlayer]["KillUnit"] = Constant.PlayerData[KillerPlayer]["KillUnit"] + 1
            SetGameBoardValue(KillerPlayerLine, 5, Constant.PlayerData[KillerPlayer]["KillUnit"])
            if (IsHero(Dead)) then
                Constant.PlayerData[KillerPlayer]["KillHero"] = Constant.PlayerData[KillerPlayer]["KillHero"] + 1
                SetGameBoardValue(KillerPlayerLine, 1, Constant.PlayerData[KillerPlayer]["KillHero"])
            end
            --摧毁建筑
            if (IsStructure(Dead)) then
                Constant.PlayerData[KillerPlayer]["DestroyStructure"] = Constant.PlayerData[KillerPlayer]["DestroyStructure"] + 1
                SetGameBoardValue(KillerPlayerLine, 3, Constant.PlayerData[KillerPlayer]["DestroyStructure"])
            end
            --反补
            if (IsPlayerAlly(KillerPlayer, DeadPlayer)) then
                Constant.PlayerData[KillerPlayer]["KillAllianceUnit"] = Constant.PlayerData[KillerPlayer]["KillAllianceUnit"] + 1
                SetGameBoardValue(KillerPlayerLine, 8, Constant.PlayerData[KillerPlayer]["KillAllianceUnit"])
                if (IsHero(Dead)) then
                    Constant.PlayerData[KillerPlayer]["KillAllianceHero"] = Constant.PlayerData[KillerPlayer]["KillAllianceHero"] + 1
                    SetGameBoardValue(KillerPlayerLine, 7, Constant.PlayerData[KillerPlayer]["KillAllianceHero"])
                end
            end
        end
    end
end

--资源奖励
function SourceReward(Killer, Dead)
    if (Killer ~= nil) then
        local KillerPlayer = GetOwningPlayer(Killer)
        --不是怪物和商人,非建筑,是敌人
        if (not IsStructure(Dead) and KillerPlayer ~= Base.NEUTRAL_AGGRESSIVE and KillerPlayer ~= Base.NEUTRAL_PASSIVE and IsUnitEnemy(Dead, KillerPlayer)) then
            local Level = GetUnitLevel(Dead)
            local RewardGold, RewardLumber = 0, 0
            if (IsHero(Dead)) then
                RewardGold = Level * Constant.Value.KillHeroRewardGold
                RewardLumber = Level * Constant.Value.KillHeroRewardLumber
            else
                local UnitType = GetUnitTypeId(Dead)
                local ExtraGold, ExtraLumber = 0, 0
                if (UnitType == Constant.UnitType.GoblinMiner) then
                    ExtraGold = 750
                    ExtraLumber = 250
                elseif (UnitType == Constant.UnitType.IronGoblin) then
                    ExtraGold = 500
                    ExtraLumber = 750
                elseif (UnitType == Constant.UnitType.LumberTruck) then
                    ExtraGold = 250
                    ExtraLumber = 500
                end
                RewardGold = GetRandomInt(1, Level * (Constant.Value.KillUnitRewardGold + ExtraGold))
                RewardLumber = GetRandomInt(1, Level * (Constant.Value.KillUnitRewardLumber + ExtraLumber))
                if (InOrderedTable(KillerPlayer, Constant.Group.AiPlayers)) then
                    RewardGold = RewardGold * Constant.Value.AiKillReward
                    RewardLumber = RewardLumber * Constant.Value.AiKillReward
                end
            end
            ModifyPlayerGold(KillerPlayer, RewardGold, true)
            ModifyPlayerLumber(KillerPlayer, RewardLumber, true)
        end
    end
end

--击杀提示
function KillTip(Killer, Dead)
    local DeadPlayer = GetOwningPlayer(Dead)
    if (DeadPlayer ~= Base.NEUTRAL_PASSIVE and DeadPlayer ~= Base.NEUTRAL_AGGRESSIVE) then
        if (IsHero(Dead)) then
            local DeadString = Constant.PlayerData[DeadPlayer]["DisplayName"] .. "的英雄[" .. GetUnitName(Dead) .. "]等级" .. GetUnitLevel(Dead)
            if (Killer == nil) then
                DisplayMessage(DeadString .. "|cFF0000FF自杀|r了")
            else
                local UnitTypeString = "单位"
                if (IsHero(Killer)) then
                    UnitTypeString = "英雄"
                end
                local KillType = "|cFFff0000击杀|r"
                if (IsUnitAlly(Killer, DeadPlayer)) then
                    KillType = "|cff00ff00反补|r"
                end
                DisplayMessage(Constant.PlayerData[GetOwningPlayer(Killer)]["DisplayName"] .. "的" .. UnitTypeString .. "[" .. GetUnitName(Killer) .. "]等级" .. GetUnitLevel(Killer) .. KillType .. "了" .. DeadString)
            end
        else
            local UnitType = GetUnitTypeId(Dead)
            if (UnitType == Constant.UnitType.GoblinMiner or UnitType == Constant.UnitType.IronGoblin or UnitType == Constant.UnitType.LumberTruck) then
                local DeadString = Constant.PlayerData[DeadPlayer]["DisplayName"] .. "的[" .. GetUnitName(Dead) .. "]"
                if (Killer == nil) then
                    DisplayMessage(DeadString .. "|cFF0000FF自杀|r了")
                else
                    local UnitTypeString = "单位"
                    if (IsHero(Killer)) then
                        UnitTypeString = "英雄"
                    end
                    DisplayMessage(Constant.PlayerData[GetOwningPlayer(Killer)]["DisplayName"] .. "的" .. UnitTypeString .. "[" .. GetUnitName(Killer) .. "]等级" .. GetUnitLevel(Killer) .. "|cFFff0000消灭|r了" .. DeadString)
                end
            end
        end
    end
end

--金矿再生
function GoldMineRegenerate()
    TimerFunctionOnce(Constant.Time.GoldMineRegenerate, function()
        local u = CreateUnitAtRandomPosition(Base.NEUTRAL_PASSIVE, Constant.UnitType.GoldMine)
        table.insert(Constant.Group.GoldMines, u)
        local RandomValue = math.ceil(Constant.Value.GeneralGoldMineGold * Constant.Value.GoldMineRandomRate)
        SetResourceAmount(u, GetRandomInt(Constant.Value.GeneralGoldMineGold - RandomValue, Constant.Value.GeneralGoldMineGold + RandomValue))
    end)
end

--清除单位数据
function ClearUnitData(u)
    if (GetOwningPlayer(u) == Base.NEUTRAL_AGGRESSIVE) then
        OrderTableRemoveItem(Constant.Group.CenterMonster, u)
    end
    if (GetUnitTypeId(u) == Constant.UnitType.GoldMine) then
        OrderTableRemoveItem(Constant.Group.GoldMines, u)
    end
    if (IsHero(u)) then
        OrderTableRemoveItem(Constant.Group.AllStructureRepairHero, u)
    end
end

--获取Ai玩家名
function GetAiPlayerName(Index)
    return Constant.AiPlayerName[Index]
end

--获取玩家颜色
function GetPlayerColorString(Index)
    return Constant.PlayerColor[Index]
end

--获取单位组随机单位
function GetGroupRandomUnit(g)
    return BlzGroupUnitAt(g, GetRandomInt(0, BlzGroupGetSize(g) - 1))
end

--研究科技
function AiPlayerResearch(p, r, ut)
    local g = CreateGroup()
    GroupEnumUnitsOfPlayer(g, p, nil)
    ForGroup(g, function()
        local u = GetEnumUnit()
        if (GetUnitTypeId(u) ~= ut or not UnitIsAlive(u)) then
            GroupRemoveUnit(g, u)
        end
    end)
    local Number = BlzGroupGetSize(g)
    if (Number > 0) then
        IssueImmediateOrderById(GetGroupRandomUnit(g), r)
    end
    DestroyGroup(g)
end

--检查闲置命令
function CheckIdleCommand(Command, Race)
    if (Race == RACE_HUMAN or Race == RACE_ORC) then
        return Command == 0 or Command == Constant.Command.Harvest or Command == Constant.Command.ResumeHarvesting
    elseif (Race == RACE_UNDEAD) then
        return Command == 0 or Command == Constant.Command.Harvest
    else
        return Command == 0 or Command == Constant.Command.Smart
    end
end

--获取玩家闲置的建造者
function GetPlayerIdleBuilders(p)
    local NowRace = GetPlayerRace(p)
    local BuilderType = Constant.UnitType.Worker[NowRace]
    local Builders = {}
    local g = CreateGroup()
    GroupEnumUnitsOfPlayer(g, p, nil)
    ForGroup(g, function()
        local u = GetEnumUnit()
        local NowCommand = GetUnitCurrentOrder(u)
        if (GetUnitTypeId(u) == BuilderType and UnitIsAlive(u) and CheckIdleCommand(NowCommand, NowRace)) then
            table.insert(Builders, u)
        end
    end)
    DestroyGroup(g)
    return Builders
end

--建造建筑
function Build(u, ut)
    local X, Y = GetUnitX(u), GetUnitY(u)
    for i = 1, Constant.Value.BuildTryMax do
        if (IssueBuildOrderById(u, ut, GetRandomReal(X - 1000, X + 1000), GetRandomReal(Y - 1000, Y + 1000))) then
            break
        end
    end
end

--购买工人(目前特指地精实验室)
function BuyWorker(p, ut)
    for i = 1, #Constant.Group.AmmoDumps do
        IssueNeutralImmediateOrderById(p, Constant.Group.AmmoDumps[i], ut)
    end
end

--掉落物品
function MonsterDropItem(x, y, level)
    local RandomMax = level * Constant.Value.DropItemLevelRate
    if (GetRandomReal(0, 100) < RandomMax) then
        CreateItem(ChooseRandomItemEx(ITEM_TYPE_ANY, -1), x, y)
    end
end

--是否有自己种族的基地
function HasRaceBase(p)
    local BaseType = Constant.UnitType.Base[GetPlayerRace(p)]
    if (GetPlayerUnitTypeCount(p, BaseType[1]) > 0) then
        return true
    else
        if (GetPlayerUnitTypeCount(p, BaseType[2]) > 0) then
            return true
        else
            return GetPlayerUnitTypeCount(p, BaseType[3]) > 0
        end
    end
end

--判断单位技能当前魔法是否足够
function UnitSkillNowMagicalIsEnough(u, a)
    return GetUnitMagical(u) >= BlzGetAbilityManaCost(a, GetUnitAbilityLevel(u, a) - 1)
end

--获取单位技能当前施法距离
function GetUnitSkillNowSpellDistance(u, a)
    return BlzGetAbilityRealLevelField(BlzGetUnitAbility(u, a), ABILITY_RLF_CAST_RANGE, GetUnitAbilityLevel(u, a) - 1)
end

--获取单位技能当前影响范围
function GetUnitSkillNowSpellEffectRange(u, a)
    return BlzGetAbilityRealLevelField(BlzGetUnitAbility(u, a), ABILITY_RLF_AREA_OF_EFFECT, GetUnitAbilityLevel(u, a) - 1)
end

--清除玩家数据
function ClearPlayerData(p)
    Constant.PlayerData[p] = nil
    --从玩家组移除
    OrderTableRemoveItem(Constant.Group.Players, p)
    if (GetPlayerController(p) == MAP_CONTROL_COMPUTER) then
        OrderTableRemoveItem(Constant.Group.AiPlayers, p)
    else
        OrderTableRemoveItem(Constant.Group.UserPlayers, p)
    end
    --从联盟移除
    for i = 1, #Constant.Group.Alliance do
        if (InOrderedTable(p, Constant.Group.Alliance[i])) then
            OrderTableRemoveItem(Constant.Group.Alliance[i], p)
            break
        end
    end
end

--暂停所有单位
function PauseAllUnit()
    local g = CreateGroup()
    GroupEnumUnitsInRect(g, Base.MAP_AREA, nil)
    ForGroup(g, function()
        PauseUnit(GetEnumUnit(), true)
    end)
    DestroyGroup(g)
end


--初始化后的清空无效变量
function ClearInvalidVariable()
    ClearInvalidVariable = nil
    --清理变量
    Constant.Version = nil
    Constant.Coordinate.AmmoDump = nil
    Constant.Coordinate.Tavern = nil
    Constant.Number.Seal = nil
    Constant.Number.MaxPlayer = nil
    Constant.Number.BaseGoldMiner = nil
    Constant.UnitType.AmmoDump = nil
    Constant.UnitType.Spell = nil
    Constant.UnitType.UnknownOrganism = nil
    Constant.UnitType.Seal = nil
    Constant.Value.StartGold = nil
    Constant.Value.StartLumber = nil
    Constant.AiPlayerName = nil
    Constant.PlayerColor=nil
    --清理一次性用于初始化的function
    --Ai.lua
    RegisterAi = nil
    Ai_Race = nil
    Ai_Research = nil
    Ai_Build = nil
    Ai_BuyWork = nil
    Ai_GoblinMinerMining = nil
    Ai_BuyHero = nil
    --Mixed.lua
    RegisterAnyUnitEvent=nil
    GetAiPlayerName = nil
    GetPlayerColorString = nil
end