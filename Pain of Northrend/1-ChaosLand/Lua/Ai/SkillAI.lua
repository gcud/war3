function InitSkill(h, s)
    --由于无法获得英雄技能列表,这里只能按英雄类型绑定技能
    local SkillFun = nil
    if (s == Constant.Skill.HolyBolt) then
        SkillFun = Skill_HolyBolt
    elseif (s == Constant.Skill.StormBolt) then
        SkillFun = Skill_StormBolt
    elseif (s == Constant.Skill.Banish) then
        SkillFun = Skill_Banish
    elseif (s == Constant.Skill.ChainLightning) then
        SkillFun = Skill_ChainLightning
    elseif (s == Constant.Skill.HealingWave) then
        SkillFun = Skill_HealingWave
    elseif (s == Constant.Skill.WarStomp) then
        SkillFun = Skill_WarStomp
    elseif (s == Constant.Skill.Hex) then
        SkillFun = Skill_Hex
    elseif (s == Constant.Skill.DeathCoil) then
        SkillFun = Skill_DeathCoil
    elseif (s == Constant.Skill.DeathPact) then
        SkillFun = Skill_DeathPact
    elseif (s == Constant.Skill.FrostNova) then
        SkillFun = Skill_FrostNova
    elseif (s == Constant.Skill.DarkRitual) then
        SkillFun = Skill_DarkRitual
    elseif (s == Constant.Skill.CarrionSwarm) then
        SkillFun = Skill_CarrionSwarm
    elseif (s == Constant.Skill.Impale) then
        SkillFun = Skill_Impale
    elseif (s == Constant.Skill.EntanglingRoots) then
        SkillFun = Skill_EntanglingRoots
    elseif (s == Constant.Skill.ManaBurn) then
        SkillFun = Skill_ManaBurn
    elseif (s == Constant.Skill.FanOfKnives) then
        SkillFun = Skill_FanOfKnives
    elseif (s == Constant.Skill.ShadowStrike) then
        SkillFun = Skill_ShadowStrike
    elseif (s == Constant.Skill.ForkedLightning) then
        SkillFun = Skill_ForkedLightning
    elseif (s == Constant.Skill.AllStructureRepair) then
        --添加英雄到全建筑维修组
        table.insert(Constant.Group.AllStructureRepairHero, h)
    elseif (s == Constant.Skill.HowlOfTerror) then
        SkillFun = Skill_HowlOfTerror
    elseif (s == Constant.Skill.Doom) then
        SkillFun = Skill_Doom
    elseif (s == Constant.Skill.SoulBurn) then
        SkillFun = Skill_SoulBurn
    elseif (s == Constant.Skill.BreathOfFire) then
        SkillFun = Skill_BreathOfFire
    elseif (s == Constant.Skill.StrongDrink) then
        SkillFun = Skill_StrongDrink
    elseif (s == Constant.Skill.Silence) then
        SkillFun = Skill_Silence
    elseif (s == Constant.Skill.LifeDrain) then
        SkillFun = Skill_LifeDrain
    end
    if (SkillFun ~= nil) then
        BindHeroTimerSkill(h, s, SkillFun)
    end
end

function BindHeroTimerSkill(h, s, SkillFun)
    local p = GetOwningPlayer(h)
    TimerFunction(GetRandomReal(3, 10), function()
        if (InOrderedTable(p, Constant.Group.AiPlayers) and UnitIsExist(h) and Constant.GameOver==false) then
            local NowOrder = GetUnitCurrentOrder(h)
            --只在英雄攻击,AIMove或移动时放技能,以免干扰持续和前摇较长技能施放
            if ((NowOrder == Constant.Command.Attack or NowOrder == Constant.Command.Move or NowOrder==Constant.Command.AiMove) and UnitIsAlive(h) and UnitSkillIsCollDown(h, s) and UnitSkillNowMagicalIsEnough(h, s)) then
                SkillFun(h, s)
            end
        else
            DestroyTimer(GetExpiredTimer())
        end
    end)
end