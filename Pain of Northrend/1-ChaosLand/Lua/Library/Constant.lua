function InitConstant()
    InitConstant = nil
    Constant = {
        Debug = true,
        Version = "20200309",
        GameOver = false,
        --坐标
        Coordinate = {
            --地精实验室
            AmmoDump = { { -15700, 7300 }, { -20000, 10200 }, { 5000, 20000 }, { 19200, -21000 }, },
            --小酒馆
            Tavern = { { -7500, -21000 }, { 4600, 20000 }, { -12300, 8600 }, { 18000, -4500 }, },
            --精英怪物
            PowerMonster = { -15000, -1000 }
        },
        --时间点
        Time = {
            --富金矿
            SuperGoldMine = 600,
            --精英怪物
            PowerMonster = 1800,
            --随机怪物
            RandomMonster = 2700,
            --随机怪物创建间隔
            RandomMonsterCreateInterval = 600,
            --中心怪物创建间隔
            CenterMonsterCreateInterval = 300,
            --显示玩家单位坐标间隔
            ShowPlayerUnitsCoordinateInterval = 270,
            --金矿再生
            GoldMineRegenerate = 600,
            --未知生物命令间隔
            UnknownOrganismCommandInterVal = 10,
            --可破坏物清理间隔
            DestructableClearInterval = 1800,
            --Ai购买工人间隔
            AiBuyWorkerInterval = 60,
            --Ai地精矿工采矿作用间隔
            AiGoblinMinerActionInterval = 5,
            --Ai复活英雄间隔
            AiRebornHeroInterval = 10,
            --Ai购买英雄间隔
            AiBuyHeroInterval = 60,
            --英雄Ai使用物品间隔
            HeroAiUseItemInterval = 3,
            --Ai建造间隔
            AiBuildInterval = 60
        },
        --数量
        Number = {
            --所有怪物
            AllMonster = 300,
            --基础怪物
            BaseMonster = 200,
            --中心怪物
            CenterMonster = 200,
            --最大英雄
            MaxHero = 4,
            --海豹
            Seal = 150,
            --富金矿
            SuperGoldMine = 4,
            --最大玩家数
            MaxPlayer = 12,
            --初始矿工数量
            BaseGoldMiner = 5,
            --显示玩家单位坐标最小数量
            ShowPlayerUnitsCoordinateMin = 5,
            --ai购买地精矿工
            AiBuyGoblinMiner = 5,
            --ai购买地精撕裂者
            AiBuyIronGoblin = 1,
            --Ai商店个数
            AiShop = 5
        },
        --单位类型
        UnitType = {
            --金矿
            GoldMine = StringToInteger("ngol"),
            --地精实验室
            AmmoDump = StringToInteger("ngad"),
            --地精商店
            GoblinShop = StringToInteger("ngme"),
            --小酒馆
            Tavern = StringToInteger("ntav"),
            --施法
            Spell = StringToInteger("e000"),
            --黑市商人
            BlackStoreBusiness = StringToInteger("npng"),
            --不明生物
            UnknownOrganism = StringToInteger("ndwm"),
            --海豹
            Seal = StringToInteger("nsea"),
            --一般怪物
            GeneralMonster = {
                --蛛网怪
                StringToInteger("nnwq"), StringToInteger("nnwl"), StringToInteger("nnwr"),
                --两栖生物
                StringToInteger("nmrr"), StringToInteger("nmrm"), StringToInteger("nmrl"),
                --冰魔
                StringToInteger("nitr"), StringToInteger("nits"), StringToInteger("nitt"),
                --幽魂
                StringToInteger("nrvi"), StringToInteger("ngh1"), StringToInteger("ngh2"),
                --熊怪
                StringToInteger("nfrp"),
                --雪怪
                StringToInteger("nwna"), StringToInteger("nwen"), StringToInteger("nwns"), StringToInteger("nwnr"),
                --猛犸
                StringToInteger("nmam"), StringToInteger("nmit"), StringToInteger("nmdr"),
                --霜冻之狼
                StringToInteger("nwwf"), StringToInteger("nwwg"), StringToInteger("nwwd"),
                --无名死灵
                StringToInteger("nfor"), StringToInteger("nfot"), StringToInteger("nfod"),
                --玛格娜托
                StringToInteger("nmgw"), StringToInteger("nmgr"), StringToInteger("nmgd"),
            },
            --中心怪物
            CenterMonster = {
                StringToInteger("ngrd"), StringToInteger("nstw"), StringToInteger("nsth"),
                StringToInteger("nfra"), StringToInteger("noga"), StringToInteger("ncnk"),
                StringToInteger("nbzd"), StringToInteger("nowk"), StringToInteger("nndr"),
                StringToInteger("nerw"), StringToInteger("ninm"), StringToInteger("nina"),
                StringToInteger("ndqp"), StringToInteger("nvde"), StringToInteger("ninf"),
                StringToInteger("nbal"), StringToInteger("nggr"), StringToInteger("nwzd"),
                StringToInteger("nelb"), StringToInteger("nsgg"), StringToInteger("nrvd"),
                StringToInteger("nsll"), StringToInteger("nbdo"), StringToInteger("nadr"),
                StringToInteger("nfot"), StringToInteger("nfod"), StringToInteger("nmdr"),
                StringToInteger("nfpe"), StringToInteger("nfpu"), StringToInteger("nbwm"),
                StringToInteger("nrwm"), StringToInteger("nrvi"), StringToInteger("nwna"),
                StringToInteger("njgb"), StringToInteger("nsgb"), StringToInteger("nahy"),
                StringToInteger("ndrv"), StringToInteger("nlrv"), StringToInteger("nsoc"),
                StringToInteger("nsrw"), StringToInteger("ntrd"), StringToInteger("nsqa")
            },
            --富金矿
            SuperGoldMine = StringToInteger("n003"),
            --地精矿工
            GoblinMiner = StringToInteger("ncpn"),
            --墙
            Wall = StringToInteger("ngwr"),
            --地精撕裂者
            IronGoblin = StringToInteger("ngir"),
            --木材车
            LumberTruck = StringToInteger("hbew"),
            --人口建筑
            FoodStructure = { },
            --工人
            Worker = {},
            --仓库
            Warehouse = StringToInteger("npgr"),
            --商店
            Shop = {},
            --祭坛
            Altar = { StringToInteger("halt"), StringToInteger("oalt"), StringToInteger("uaod"), StringToInteger("eate"), },
            --英雄列表
            HeroList = {
                --圣骑士
                Paladin = StringToInteger("Hpal"),
                --大魔法师
                ArchMage = StringToInteger("Hamg"),
                --山丘之王
                MountainKing = StringToInteger("Hmkg"),
                --血魔法师
                BloodElfPrince = StringToInteger("Hblm"),
                --剑圣
                Blademaster = StringToInteger("Obla"),
                --先知
                Farseer = StringToInteger("Ofar"),
                --牛头人酋长
                TaurenChieftain = StringToInteger("Otch"),
                --暗影猎手
                ShadowHunter = StringToInteger("Oshd"),
                --死亡骑士
                DeathKnight = StringToInteger("Udea"),
                --巫妖
                Lich = StringToInteger("Ulic"),
                --恐惧魔王
                DreadLord = StringToInteger("Udre"),
                --地穴领主
                CryptLord = StringToInteger("Ucrl"),
                --丛林守护者
                KeeperOfTheGrove = StringToInteger("Ekee"),
                --月之女祭司
                PriestessOfTheMoon = StringToInteger("Emoo"),
                --恶魔猎手
                DemonHunter = StringToInteger("Edem"),
                --守望者
                Warden = StringToInteger("Ewar"),
                --娜迦女海巫
                NagaSeaWitch = StringToInteger("Nngs"),
                --修补匠
                Tinker = StringToInteger("Ntin"),
                --深渊魔王
                PitLord = StringToInteger("Nplh"),
                --火焰巨魔
                AvatarOfFlame = StringToInteger("Nfir"),
                --熊猫酒仙
                PandarenBrewmaster = StringToInteger("Npbm"),
                --驯兽师
                BeastMaster = StringToInteger("Nbst"),
                --黑暗游侠
                BansheeRanger = StringToInteger("Nbrn")
            },
            --额外英雄
            ExtraHero = { },
            --基地
            Base = {}
        },
        --单位
        Unit = { UnknownOrganism = nil, Spell = nil, BlackStoreBusiness = nil },
        --各种组
        Group = {
            CenterMonster = {},
            Players = {},
            AiPlayers = {},
            UserPlayers = {},
            Alliance = {},
            AmmoDumps = {},
            Taverns = {},
            GoldMines = {},
            --全建筑维修英雄列表
            AllStructureRepairHero = {}
        },
        --技能
        Skill = {
            --阴影之击
            ShadowAttack = StringToInteger("A010"),
            --沉默光环
            SilenceAura = StringToInteger("A00C"),
            --沉默光环实际效果
            SilenceAuraAction = StringToInteger("A00B"),
            --保护光环
            ChildAura = StringToInteger("A01C"),
            --全建筑维修特效
            AllStructureRepairEffect = StringToInteger("A01D"),
            --属性附加
            AttributeMod = StringToInteger("Aamk"),
            --送回黄金和木材
            ReceiveGoldAndLumber = StringToInteger("Argl"),
            --商店购买物品
            BuyItem = StringToInteger("Apit"),
            --修理护甲检查
            RepairArmorCheck = StringToInteger("ARac"),
            --神圣之光
            HolyBolt = StringToInteger("AHhb"),
            --虚无
            Banish = StringToInteger("AHbn"),
            --风暴之锤
            StormBolt = StringToInteger("AHtb"),
            --医疗波
            HealingWave = StringToInteger("AOhw"),
            --妖术
            Hex = StringToInteger("AOhx"),
            --战争践踏
            WarStomp = StringToInteger("AOws"),
            --闪电链
            ChainLightning = StringToInteger("AOcl"),
            --死亡契约
            DeathPact = StringToInteger("AUdp"),
            --死亡缠绕
            DeathCoil = StringToInteger("AUdc"),
            --穿刺
            Impale = StringToInteger("AUim"),
            --腐臭蜂群
            CarrionSwarm = StringToInteger("AUcs"),
            --霜冻新星
            FrostNova = StringToInteger("AUfn"),
            --黑暗仪式
            DarkRitual = StringToInteger("AUdr"),
            --刀阵旋风
            FanOfKnives = StringToInteger("AEfk"),
            --暗影突袭
            ShadowStrike = StringToInteger("AEsh"),
            --法力燃烧
            ManaBurn = StringToInteger("AEmb"),
            --纠缠根须
            EntanglingRoots = StringToInteger("AEer"),
            --叉妆闪电
            ForkedLightning = StringToInteger("ANfl"),
            --恐怖嚎叫
            HowlOfTerror = StringToInteger("ANht"),
            --末日审判
            Doom = StringToInteger("ANdo"),
            --沉默魔法
            Silence = StringToInteger("ANsi"),
            --火焰呼吸
            BreathOfFire = StringToInteger("ANbf"),
            --灵魂燃烧
            SoulBurn = StringToInteger("ANso"),
            --生命汲取
            LifeDrain = StringToInteger("ANdr"),
            --醉酒云雾
            StrongDrink = StringToInteger("ANdh"),
            --全建筑维修
            AllStructureRepair = StringToInteger("A019"),
            --铜墙铁壁
            Wall = StringToInteger("A01A"),
            --修理
            Repair = StringToInteger("A01B"),

        },
        --值
        Value = {
            --初始黄金
            StartGold = 1000,
            --初始木材
            StartLumber = 500,
            --生成金矿黄金
            GeneralGoldMineGold = 10000,
            --额外信息行索引
            ExtraInfoRowIndex = 0,
            --Ai玩家存活黄金奖励
            AiPlayerGoldReward = 17,
            --Ai玩家存活木材奖励
            AiPlayerLumberReward = 9,
            --杀死单位黄金奖励
            KillUnitRewardGold = 18,
            --杀死单位木材奖励
            KillUnitRewardLumber = 15,
            --杀死英雄黄金奖励
            KillHeroRewardGold = 75,
            --杀死英雄木材奖励
            KillHeroRewardLumber = 30,
            --Ai杀死奖励参数
            AiKillReward = 2,
            --未知生物攻击命令半径
            UnknownOrganismForceAttackRange = 2000,
            --Ai资源最小交易量
            AiSourceDealWithMin = 1000,
            --Ai资源最大交易量
            AiSourceDealWithMax = 500000,
            --Ai资源交易比率
            AiSourceDealWithRate = 0.7,
            --Ai科技研究最小黄金
            AiResearchMinGold = 3000,
            --Ai科技研究最小木材
            AiResearchMinLumber = 2000,
            --科技最大等级
            ResearchMaxLevel = 9,
            --建造最大尝试次数
            BuildTryMax = 10,
            --金矿含金量浮动比率
            GoldMineRandomRate = 0.5,
            --反补伤害比率
            KillDyingDamageRate = 8,
            --物品掉落等级因素
            DropItemLevelRate = 0.85,
            --反补伤害修正值
            KillDyingDamageFix = 50
        },
        --游戏面板
        GameBoard = nil,
        --玩家数据
        PlayerData = {},
        --命令
        Command = {
            --移动
            Move = OrderId("move"),
            --采集
            Harvest = OrderId("harvest"),
            --送回资源
            ResumeHarvesting = OrderId("resumeharvesting"),
            --右键点击
            Smart = OrderId("smart"),
            --攻击
            Attack = OrderId("attack"),
            --修理
            Repair = OrderId("repair"),
            --Ai移动
            AiMove=OrderId("AImove")

        },
        --游戏时间
        GameTime = 0,
        --Ai玩家名
        AiPlayerName = { "罪恶佣兵团", "神圣骑士团", "光明议会", "至高联盟", "毁灭者", "死亡丧钟", "恐怖深渊", "圣龙团", "拉卡萨集团", "无尽的战争", "凋零的希望", "尼古拉斯-赵四" },
        --玩家颜色
        PlayerColor = { "ff0000", "0000ff", "00ffff", "800080", "ffff00", "ffa500", "00ff00", "ffc0cb", "808080", "87cefa", "006400", "a52a2a" },
        --精英怪物
        PowerMonster = {
            --灵肉傀儡
            { Id = StringToInteger("nfgl"), Number = 2 },
            --堕落法师
            { Id = StringToInteger("odkt"), Number = 1 },
            --黑暗武士
            { Id = StringToInteger("nfov"), Number = 2 },
            --堕落牧师
            { Id = StringToInteger("nhhr"), Number = 2 },
            --恐怖阴影
            { Id = StringToInteger("ndqs"), Number = 1 },
        },
        --科技
        Research = {},
        --物品类型
        ItemType = {
            --大生命药水
            HugeHpPotion = StringToInteger("pghe"),
            --大魔法药水
            HugeManaPotion = StringToInteger("pgma"),
            --生命药水
            HpPotion = StringToInteger("phea"),
            --魔法药水
            ManaPotion = StringToInteger("pman"),
            --医疗卷轴
            HealingScroll = StringToInteger("shea"),
            --回城卷轴
            BackBase = StringToInteger("stwp"),
            --重生十字章
            ReBorn = StringToInteger("ankh"),
            --神圣药水
            ProtectPotion = StringToInteger("pdiv"),
            --小城堡
            MostBase = StringToInteger("tcas"),
            --小型的大厅
            Base = StringToInteger("tgrh"),
            --魔法护盾护身符
            DefendMagic = StringToInteger("spsh"),
            --隐形药水
            HidePotion = StringToInteger("pinv"),
            --火焰之球
            FrameBall = StringToInteger("ofir"),
            --减速之球
            SlowBall = StringToInteger("oslo"),
            --腐蚀之球
            WeakenBall = StringToInteger("ocor"),
            --毒液之球
            PoisonousBall = StringToInteger("oven"),
        },
        --学习技能
        LearnSKill = {},
        --Buff
        Buff = { Banish = StringToInteger("BHbn"), Hex = StringToInteger("BOhx"), Impale = StringToInteger("BUim"), Doom = StringToInteger("BNdo"), StrongDrink = StringToInteger("BNdh"), AllStructureRepair = StringToInteger("A01D"), Stun = StringToInteger("BPSE"), SoulBurn = StringToInteger("BMso"), Silence = StringToInteger("BNsi"), HowlOfTerror = StringToInteger("BNht"),ShadowStrike=StringToInteger("BEsh") },
    }
    BindExtraConstant()
end