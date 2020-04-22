function RegisterAi(p)
    Ai_UnitAttack(p)
end

function Ai_UnitAttack(p)
    gcudLua.TimerFunction(Constant.Time.AiUnitAttackIneterval,function ()
        if Constant.GameOver then
            DestroyTimer(GetExpiredTimer())
        else
            if gcudLua.UnitIsAlive(NowHero[p].Unit) then
                local X,Y=GetUnitX(NowHero[p].Unit),GetUnitY(NowHero[p].Unit)
                local g=CreateGroup()
                GroupEnumUnitsOfPlayer(g,p,nil)
                GroupRemoveUnit(g,NowHero[p].Unit)
                ForGroup(g,function ()
                    local u=GetEnumUnit()
                    if gcudLua.UnitIsAlive(u) and GetUnitCurrentOrder(u)==0 then
                        IssuePointOrder(u,"attack",GetRandomReal(X-500,X+500),GetRandomReal(Y-500,Y+500))
                    end
                end)
                DestroyGroup(g)
            end
        end
    end)
end