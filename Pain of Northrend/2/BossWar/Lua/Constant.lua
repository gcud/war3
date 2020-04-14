function InitConstant()
    InitConstant = nil
    Constant = {
        Debug = true,
        Version = "20200414",
        GameOver = false,
        --坐标
        Coordinate = {
            --复活
            Revive = {-2500, -1800},
            --Boss
            Boss={2000,-1200},
            MonsterAreaLeftX=- 2944,
            MonsterAreaRightX=- 480,
            MonsterAreaDownY=192,
            MonsterAreaUpY=3488,
            WeaponShoper={-3000,-1900},
            ArmorShoper={-3000,-1750},
            ReviveStone={-2500,-1700}
        },
        --时间
        Time = {
            CreateMonsterInterval=30,
            MonsterParamterIncreaseInterval=600
            
        },
        --数量
        Number = {
            MaxMonster=150,
            CreateMonster=30
        },
        --值
        Value = {
            ReviveTimeParameter=1,
            KillBossRewardGold=30,
            KillPowerUnitRewardGold=5,
            KillUnitRewardGold=1,
            --Ai击杀奖励倍率
            AiKillReward=2,
            --怪物参数
            MonsterParameter=1,
            --最大怪物参数
            MonsterParameterMax=15,
            StartGold=10,
            --技能升级参数
            SkillUpgradeParameter=10,
            AiHeroFleeHpRate=0.1,
            SafeDistance=400,
            AiHeroFleeHpMin=100,
            AiHeroRecoverHpRate=0.8,
        },
        --单位类型
        UnitType = {
            --施法单位
            Speller = gcudLua.StringToInteger("e000"),
            --武器商人
            WeaponShoper=gcudLua.StringToInteger("h000"),
            --防具商人
            ArmorShoper=gcudLua.StringToInteger("n002"),
            --复活石
            ReviveStone=gcudLua.StringToInteger("nbsw"),
            --英雄列表
            HeroList = {
                --女妖精
                gcudLua.StringToInteger("N001"), 
                },
            },
        --单位
        Unit = {
            Speller = nil,
            WeaponShoper=nil,
            ArmorShoper=nil,
            ReviveStone=nil
        },
        --技能
        Skill = {
            --魅惑
            Charm=gcudLua.StringToInteger("A000"),
            BuyItem=gcudLua.StringToInteger("Apit")
        },
        --物品类型
        ItemType = {
            --铁剑
            IronSword=gcudLua.StringToInteger("I000"),
            --皮质头盔
            LeatherHelmet=gcudLua.StringToInteger("I001"),
        },
        --Buff
        Buff = {},
        --Ai动作区域
        AiArea=nil,
        --英雄技能列表
        HeroSkillLists={},
    }
    --所有单位
    Units = {}
    --玩家数据
    PlayerData = {}
    --游戏时间
    GameTime = 0
    --当前英雄
    NowHero = {}
    BindExtraConstant()
end
