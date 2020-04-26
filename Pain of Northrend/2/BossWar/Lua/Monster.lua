-- 初始化怪物
function InitMonster()
    InitMonster = nil
    InitBoss()
    InitBaseMonster()
    InitPowerMonster()
end

--初始化精英怪物
function InitPowerMonster()
    
end

-- 初始化Boss
function InitBoss()
--目前只创建第一个
  gcudLua.CreateUnitAtCoordinate(gcudLua.MonsterPlayer,UnitType.BossList[1].Id,Constant.Coordinate.Boss[1],Constant.Coordinate.Boss[2])
end

-- 初始化基础怪物
function InitBaseMonster()
    InitBaseMonster = nil
    gcudLua.TimerFunction(Constant.Time.CreateMonsterInterval, function()
        if (Constant.GameOver) then
            DestroyTimer(GetExpiredTimer())
        else
            if(gcudLua.GetPlayerUnitsCount(gcudLua.MonsterPlayer)<Constant.Number.MaxMonster)then
                for i = 1, Constant.Number.CreateMonster do
                    gcudLua.CreateUnitAtCoordinate(gcudLua.MonsterPlayer,ChooseRandomCreep(GetRandomInt(1,Constant.Value.MonsterParameter)), GetMonsterAreaRandomX(), GetMonsterAreaRandomY())
                end
            end
        end
    end)
end