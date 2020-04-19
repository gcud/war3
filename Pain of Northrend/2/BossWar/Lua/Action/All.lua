-- 英雄倒计时复活,支持增加减少复活时间的技能
function Action_HeroTimerRevive(Hero, p)
    local ReviveDialog = CreateTimerDialog(nil)
    local ReviveTime=GetUnitLevel(Hero)*Constant.Value.ReviveTimeParameter
    TimerDialogSetRealTimeRemaining(ReviveDialog, ReviveTime)
    NowHero[p].ReviveTime=NowHero[p].ReviveTime+ReviveTime
    TimerDialogSetTitle(ReviveDialog, GetUnitName(Hero) .. "复活时间")
    TimerDialogDisplay(ReviveDialog, true)
    gcudLua.TimerFunction(1, function()
        if (Constant.GameOver or gcudLua.UnitIsAlive(Hero)) then
            DestroyTimerDialog(ReviveDialog)
            DestroyTimer(GetExpiredTimer())
        else
            local ReviveTime = NowHero[p].ReviveTime
            if (ReviveTime > 0) then
                TimerDialogSetRealTimeRemaining(ReviveDialog, ReviveTime)
                NowHero[p].ReviveTime = ReviveTime - 1
            else
                NowHero[p].ReviveTime = 0
                ReviveHero(Hero,  Constant.Coordinate.Revive[1],  Constant.Coordinate.Revive[2], true)
                PlayerSelectSingleUnit(p,Hero)
                gcudLua.SetPlayerCameraCoordinate(p, Constant.Coordinate.Revive[1], Constant.Coordinate.Revive[2])
            end
        end
    end)
end

--击杀奖励
function KillReward(KillerPlayer, Dead)
    local Level = GetUnitLevel(Dead)
    local RewardGold= 0
    if IsUnitType(Dead,UNIT_TYPE_GIANT) then
        RewardGold = Level * Constant.Value.KillBossRewardGold
    else
        RewardGold = GetRandomInt(1, Level * Constant.Value.KillUnitRewardGold)
    end
    if (gcudLua.InOrderedTable(KillerPlayer, gcudLua.AiPlayers)) then
        RewardGold = RewardGold * Constant.Value.AiKillReward
    end
    gcudLua.ModifyPlayerGold(KillerPlayer, RewardGold, true)
end