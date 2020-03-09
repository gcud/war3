--初始化怪物
function InitMonster()
    InitMonster=nil
    InitPowerMonster()
    InitCenterMonster()
    InitRandomMonster()
end

--初始化精英怪物
function InitPowerMonster()
    InitPowerMonster=nil
    TimerFunctionOnce(Constant.Time.PowerMonster,function()
        local Coordinate=Constant.Coordinate.PowerMonster
        for i=1,#Constant.PowerMonster do
            local Info=Constant.PowerMonster[i]
            for j=1,Info["Number"] do
                CreateUnitAtCoordinate(Base.NEUTRAL_AGGRESSIVE,Info["Id"],Coordinate[1],Coordinate[2])
            end
        end
        --清理坐标常量
        Constant.Coordinate.PowerMonster=nil
        --清理时间常量
        Constant.Time.PowerMonster=nil
        --清理类型和数量
        Constant.PowerMonster=nil
    end)
end

--初始化中心怪物
function InitCenterMonster()
    InitCenterMonster=nil
    TimerFunction(Constant.Time.CenterMonsterCreateInterval,function()
        if (Constant.GameOver) then
            DestroyTimer(GetExpiredTimer())
        else
            if (#Constant.Group.CenterMonster < Constant.Number.CenterMonster and GetPlayerUnitsCount(Base.NEUTRAL_AGGRESSIVE)<Constant.Number.AllMonster) then
                for i = 1, #Constant.UnitType.CenterMonster do
                    table.insert(Constant.Group.CenterMonster,CreateUnitAtCoordinate(Base.NEUTRAL_AGGRESSIVE,Constant.UnitType.CenterMonster[i],0,0))
                end
            end
        end
    end)
end

--初始化随机怪物
function InitRandomMonster()
    InitRandomMonster=nil
    TimerFunctionOnce(Constant.Time.RandomMonster,function ()
        DisplayMessage("从现在开始，以10分钟为一个周期，每秒会在地图随机位置产生怪物",nil,true,30)
        TimerFunction(Constant.Time.RandomMonsterCreateInterval,function ()
            if(Constant.GameOver)then
                DestroyTimer(GetExpiredTimer())
            else
                local Count=0
                TimerFunction(1,function ()
                    if(Constant.GameOver)then
                        DestroyTimer(GetExpiredTimer())
                    else
                        if(Count<Constant.Number.AllMonster and GetPlayerUnitsCount(Base.NEUTRAL_AGGRESSIVE)<Constant.Number.AllMonster)then
                            CreateUnitAtRandomPosition(Base.NEUTRAL_AGGRESSIVE,Constant.UnitType.GeneralMonster[GetRandomInt(1,#Constant.UnitType.GeneralMonster)])
                            Count=Count+1
                        else
                            DestroyTimer(GetExpiredTimer())
                        end
                    end
                end)
            end
        end)
        --清理时间常量
        Constant.Time.RandomMonster=nil
    end)
end