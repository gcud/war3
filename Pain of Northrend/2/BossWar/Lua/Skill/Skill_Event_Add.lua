--毒
function Skill_Event_Add_Pison(u)
    local LimitParameter=10
    Units[u].Skill_Pison_PisonPoint=0
    gcudLua.TimerFunction(1,function()
        if Constant.GameOver then
            DestroyTimer(GetExpiredTimer())
        elseif gcudLua.UnitIsAlive(u) then
            local Value=Units[u].Skill_Pison_PisonPoint;
            if Value<LimitParameter*GetUpgradeAbilityLevel(u,Constant.Skill.Poison) then
                Value=Value+1
            end
            Units[u].Skill_Pison_PisonPoint=Value
        end
    end)
end