function InitConstant()
    InitConstant = nil
    Constant = {
        Debug = false,
<<<<<<< HEAD
        Version = "20200510",
=======
        Version = "20200503",
>>>>>>> f386237c35231363ce1d2f1aaf7c489b1582fea5
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
            GroceryShoper={-3000,-1600},
            ReviveStone={-2500,-1700}
        },
        --时间
        Time = {
            CreateMonsterInterval=30,
            MonsterParamterIncreaseInterval=600,
            AiUnitAttackIneterval=10
        },
        --数量
        Number = {
            MaxMonster=100,
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
            AiHeroFleeMinLevel=20,
<<<<<<< HEAD
            AiArmorRateCheck=0.8,
            GetNewSkillLevelParameter=5
=======
            AiArmorRateCheck=0.8
>>>>>>> f386237c35231363ce1d2f1aaf7c489b1582fea5
        },
        --单位
        Unit = {
            Speller = nil,
            WeaponShoper=nil,
            ArmorShoper=nil,
            GroceryShoper=nil,
            ReviveStone=nil
        },
        --技能
        Skill = {
            --购买物品
            BuyItem=gcudLua.StringToInteger("Apit"),
            --魅惑
            Charm=gcudLua.StringToInteger("A000"),
            --性感
            Sexy=gcudLua.StringToInteger("A001"),
            --闪电攻击
            LightningAttack=gcudLua.StringToInteger("A002"),
            --毒
            Poison=gcudLua.StringToInteger("A003"),
            --磐石
            Rock=gcudLua.StringToInteger("A004"),
            --野兽幽魂
            BeastGhost=gcudLua.StringToInteger("A005"),
            --魔法禁用
            BanMagic=gcudLua.StringToInteger("A006"),
            --震击
            Shock=gcudLua.StringToInteger("A007"),
            --生命恢复
            LifeRecovery=gcudLua.StringToInteger("A008"),
            --撕裂之爪
            TearingClaw=gcudLua.StringToInteger("A009"),
            --魔法洪流
            MagicWave=gcudLua.StringToInteger("A00B"),
            --分裂攻击
            SplitAttack=gcudLua.StringToInteger("A00G"),
            --致命一击
            StrikeAttack=gcudLua.StringToInteger("A00H"),
            --自爆
            Boom=gcudLua.StringToInteger("A00I"),
<<<<<<< HEAD
            --剑术
            Fencing=gcudLua.StringToInteger("A00J"),
            --连击
            Batter=gcudLua.StringToInteger("A00K"),
=======
>>>>>>> f386237c35231363ce1d2f1aaf7c489b1582fea5
        },
        --物品类型
        ItemType = {
            --优良铁剑
            BetterIronSword=gcudLua.StringToInteger("I002"),
            --上等铁剑
            GoodIronSword=gcudLua.StringToInteger("I003"),
            --精炼铁剑
            ConciseIronSword=gcudLua.StringToInteger("I004"),
            --胜利之剑
            VictorySword=gcudLua.StringToInteger("I008"),
            --皮质头盔
            LeatherHelmet=gcudLua.StringToInteger("I001"),
            --上等头盔
            GoodHelmet=gcudLua.StringToInteger("I005"),
            --皮泽洛头盔
            PizaloHelmet=gcudLua.StringToInteger("I006"),
            --奈芬哈尔头盔
            NefrharHelmet=gcudLua.StringToInteger("I007"),
            --加速手套
            AccelerationGloves=gcudLua.StringToInteger("gcel"),
            --生命护身符
            LifeAmulet=gcudLua.StringToInteger("prvt"),
            --卡嘉医疗宝石
            HealingGem=gcudLua.StringToInteger("rhth"),
        },
        --Buff
        Buff = {},
        --Ai动作区域
        AiArea=nil,
        --英雄技能列表
        HeroSkillLists={},
        --属性专用
        ATTRIBUTE_ARMOR={Id=gcudLua.StringToInteger("A00A"),Field=ABILITY_ILF_DEFENSE_BONUS_IDEF,Type="Integer",CacheField="Armor"},
        ATTRIBUTE_ATTACK_POWER={Id=gcudLua.StringToInteger("A00C"),Field=ABILITY_ILF_ATTACK_BONUS,Type="Integer",CacheField="AttackPower"},
    }
    --所有单位
    Units = {}
    --玩家数据
    PlayerData = {}
    --游戏时间
    GameTime = 0
    --当前英雄
    NowHero = {}
    --物品类型数据
    ItemTypeData={}
    --单位类型数据
    UnitType = {
        --施法单位
        Speller = gcudLua.StringToInteger("e000"),
        --武器商人
        WeaponShoper=gcudLua.StringToInteger("h000"),
        --防具商人
        ArmorShoper=gcudLua.StringToInteger("n002"),
        --杂货商人
        GroceryShoper=gcudLua.StringToInteger("n003"),
        --复活石
        ReviveStone=gcudLua.StringToInteger("nbsw"),
        --英雄列表
        HeroList = {
            --苦难女王
            gcudLua.StringToInteger("N001"), 
            --闪电蜥蜴
            gcudLua.StringToInteger("N004"), 
            --血浴之母
            gcudLua.StringToInteger("N005"), 
            --岩石傀儡
            gcudLua.StringToInteger("N008"), 
            --先知
            gcudLua.StringToInteger("Ofar"), 
            --船长
            gcudLua.StringToInteger("H001"), 
            --山丘之王
            gcudLua.StringToInteger("Hmkg"), 
            --熊怪乌萨长者
            gcudLua.StringToInteger("N007"), 
            --血魔法师
            gcudLua.StringToInteger("Hblm"), 
            --领主
            gcudLua.StringToInteger("N006"), 
            --剑圣
            gcudLua.StringToInteger("Obla"), 
            --地精工兵
            gcudLua.StringToInteger("N009"), 
<<<<<<< HEAD
            --村民
            gcudLua.StringToInteger("N00A"), 
=======
>>>>>>> f386237c35231363ce1d2f1aaf7c489b1582fea5
            },
        --Boss列表
        BossList={
            {Id=gcudLua.StringToInteger("n000"),Resistance={Poison=0.65}},
        }
    }
    BindExtraConstant()
end
