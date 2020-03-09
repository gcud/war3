function InitAllTrigger()
    InitAllTrigger = nil
    InitGameTimeAction()
    InitGameOverCheck()
    InitShowPlayerUnitCoordinateInfo()
    InitEvent()
end

function InitUnknownOrganism()
    InitUnknownOrganism = nil
    local t = CreateTrigger()
    TriggerRegisterUnitInRange(t, Constant.Unit.UnknownOrganism, 256, nil)
    TriggerAddAction(t, function()
        local u = GetTriggerUnit()
        local p = GetOwningPlayer(u)
        if (not IsStructure(u) and p ~= Base.NEUTRAL_AGGRESSIVE and p ~= Base.NEUTRAL_PASSIVE) then
            DestroyEffect(AddSpecialEffect("Abilities/Spells/Human/MassTeleport/MassTeleportTarget.mdl", GetUnitX(u), GetUnitY(u)))
            SetUnitX(u, GetRandomX())
            SetUnitY(u, GetRandomY())
            IssueImmediateOrder(u, "stop")
        end
    end)
    TimerFunction(Constant.Time.UnknownOrganismCommandInterVal, function()
        if (Constant.GameOver or not UnitIsAlive(Constant.Unit.UnknownOrganism)) then
            DestroyTimer(GetExpiredTimer())
            Constant.Unit.UnknownOrganism = nil
        else
            if (GetUnitCurrentOrder(Constant.Unit.UnknownOrganism) ~= Constant.Command.Move) then
                IssuePointOrder(Constant.Unit.UnknownOrganism,"move", GetRandomX(), GetRandomY())
            end
            EnumUnitsInRangeDoActionAtCoordinate(GetUnitX(Constant.Unit.UnknownOrganism), GetUnitY(Constant.Unit.UnknownOrganism), Constant.Value.UnknownOrganismForceAttackRange, function(u)
                local p = GetOwningPlayer(u)
                if (not IsStructure(u) and p ~= Base.NEUTRAL_AGGRESSIVE and p ~= Base.NEUTRAL_PASSIVE) then
                    IssueTargetOrder(u, "attack", Constant.Unit.UnknownOrganism)
                end
            end)
        end
    end)
end

function InitGameTimeAction()
    InitGameTimeAction = nil
    TimerFunction(1, function()
        if (Constant.GameOver) then
            DestroyTimer(GetExpiredTimer())
        else
            Constant.GameTime = Constant.GameTime + 1
            --清理装饰物
            if(math.fmod(Constant.GameTime,Constant.Time.DestructableClearInterval)==0)then
                EnumDestructablesInRect(Base.MAP_AREA,nil,function ()
                    local d=GetEnumDestructable()
                    if(GetDestructableLife(d)<1)then
                        RemoveDestructable(d)
                    end
                end)
            end
            --显示时间
            local Time = Constant.GameTime
            local TimeString = ""
            local Hour = math.floor(Time / 3600)
            if (Hour > 0) then
                TimeString = TimeString .. Hour .. "时"
            end
            Time = Time - (Hour * 3600)
            local Minutes = math.floor(Time / 60)
            if (Minutes > 0) then
                TimeString = TimeString .. Minutes .. "分"
            end
            Time = Time - (Minutes * 60)
            if (Time > 0) then
                TimeString = TimeString .. Time .. "秒"
            end
            SetGameBoardValue(Constant.Value.ExtraInfoRowIndex, 1, TimeString)
            SetGameBoardValue(Constant.Value.ExtraInfoRowIndex, 3, GetNowTimeString())
            --AI玩家奖励
            for i = 1, #Constant.Group.AiPlayers do
                ModifyPlayerGold(Constant.Group.AiPlayers[i], Constant.Value.AiPlayerGoldReward, true)
                ModifyPlayerLumber(Constant.Group.AiPlayers[i], Constant.Value.AiPlayerLumberReward, true)
            end
            --更新怪物数量
            SetGameBoardValue(Constant.Value.ExtraInfoRowIndex, 10, GetPlayerUnitsCount(Base.NEUTRAL_AGGRESSIVE))
            --更新玩家单位数量
            for i = 1, #Constant.Group.Players do
                local p=Constant.Group.Players[i]
                SetGameBoardValue(Constant.PlayerData[p]["PlayerLine"], 9, GetPlayerUnitsCount(p))
            end
        end
    end)
end

function InitGameOverCheck()
    InitGameOverCheck = nil
    TimerFunction(5, function()
        if (Constant.GameOver) then
            DestroyTimer(GetExpiredTimer())
        else
            for i = 1, #Constant.Group.Players do
                local p = Constant.Group.Players[i]
                if (GetPlayerSlotState(p) == PLAYER_SLOT_STATE_LEFT) then
                    --删除所有单位
                    local Units = CreateGroup()
                    GroupEnumUnitsOfPlayer(Units, p, nil)
                    ForGroup(Units, function()
                        local u = GetEnumUnit()
                        ClearUnitData(u)
                        RemoveUnit(u)
                    end)
                    DestroyGroup(Units)
                end
                if (GetPlayerUnitsCount(p) == 0) then
                    DisplayMessage("你的所有单位被消灭了,你失败了,但你仍然可以继续观战",p,true,60)
                    DisplayMessage( Constant.PlayerData[p]["DisplayName"] .. "的势力已经从诺森德抹除",nil,true,60)
                    SetGameBoardValue(Constant.PlayerData[p]["PlayerLine"], 9, "0")
                    SetGameBoardValue(Constant.PlayerData[p]["PlayerLine"], 10, "|cFF949596失败|r")
                    ClearPlayerData(p)
                    break
                end
            end
            --移除联盟
            for i = 1, #Constant.Group.Alliance do
                if (#Constant.Group.Alliance[i] == 0) then
                    table.remove(Constant.Group.Alliance, i)
                    break
                end
            end
            if (#Constant.Group.Alliance == 1) then
                Constant.GameOver = true
                for i = 1, #Constant.Group.Players do
                    local p = Constant.Group.Players[i]
                    DisplayMessage( Constant.PlayerData[p]["DisplayName"] .. "获得了这场游戏的胜利！",nil,false,60)
                    SetGameBoardValue(Constant.PlayerData[p]["PlayerLine"], 10, "|cFFFF0000胜利|r")
                end
                FogEnable(false)
                FogMaskEnable(false)
                TimerFunction(5, function()
                    PauseAllUnit()
                end)
            elseif (#Constant.Group.Alliance == 0) then
                Constant.GameOver = true
                PlayThematicMusic("Sound/Music/mp3Music/TragicConfrontation.mp3")
                DisplayTimedTextToPlayer(GetLocalPlayer(), 0, 0, 30, "无数贪婪的冒险者来到诺森德,妄图攫取那未知的巨大利益,但他们都失败了")
                TimerFunctionOnce(5, function()
                    DisplayTimedTextToPlayer(GetLocalPlayer(), 0, 0, 30, "诺森德仍然吹着凛冽的寒风,大雪将还未散去的血腥掩埋,等待着下一批冒险者的到来")
                end)
                TimerFunction(5, function()
                    PauseAllUnit()
                end)
            end
        end
    end)
end


--显示玩家单位坐标信息
function InitShowPlayerUnitCoordinateInfo()
    InitShowPlayerUnitCoordinateInfo = nil
    TimerFunction(Constant.Time.ShowPlayerUnitsCoordinateInterval, function()
        if (Constant.GameOver) then
            DestroyTimer(GetExpiredTimer())
        else
            for i = 1, #Constant.Group.Players do
                local p = Constant.Group.Players[i]
                local Number = GetPlayerUnitsCount(p)
                if (Number > 0 and Number < Constant.Number.ShowPlayerUnitsCoordinateMin) then
                    local g = CreateGroup()
                    GroupEnumUnitsOfPlayer(g, p, nil)
                    ForGroup(g, function()
                        local u=GetEnumUnit()
                        if(UnitIsAlive(u))then
                            PingMinimapEx(GetUnitX(u), GetUnitY(u), 5, 255, 0, 0, true)
                        end
                    end)
                    DestroyGroup(g)
                    DisplayMessage( "由于你的单位小于" .. Constant.Number.ShowPlayerUnitsCoordinateMin .. "个,位置信息已被发送给所有玩家",p,true,30)
                end
            end
        end
    end)
end