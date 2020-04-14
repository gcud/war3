function InitAllTrigger()
    InitAllTrigger = nil
    InitGameTimeAction()
    InitIncreaseMonsterParamter()
    InitEvent()
end

--频繁性的时间动作
function InitGameTimeAction()
    InitGameTimeAction = nil
    gcudLua.TimerFunction(1, function()
        if (Constant.GameOver) then
            DestroyTimer(GetExpiredTimer())
        else
            GameTime = GameTime + 1
        end
    end)
end

--增加怪物参数
function InitIncreaseMonsterParamter()
    gcudLua.TimerFunction(Constant.Time.MonsterParamterIncreaseInterval, function()
        if (Constant.GameOver) then
            DestroyTimer(GetExpiredTimer())
        else
            if Constant.Value.MonsterParameter<Constant.Value.MonsterParameterMax then
                Constant.Value.MonsterParameter=Constant.Value.MonsterParameter+1
            else
                DestroyTimer(GetExpiredTimer())
            end
        end
    end)
end