--初始化基础单位
function InitBaseUnit()
    InitBaseUnit = nil
    --地精实验室
    for i = 1, #Constant.Coordinate.AmmoDump do
        local Coordinate = Constant.Coordinate.AmmoDump[i]
        table.insert(Constant.Group.AmmoDumps, CreateUnitAtCoordinate(Base.NEUTRAL_PASSIVE, Constant.UnitType.AmmoDump, Coordinate[1], Coordinate[2]))
    end
    --小酒馆
    for i = 1, #Constant.Coordinate.Tavern do
        local Coordinate = Constant.Coordinate.Tavern[i]
        table.insert(Constant.Group.Taverns, CreateUnitAtCoordinate(Base.NEUTRAL_PASSIVE, Constant.UnitType.Tavern, Coordinate[1], Coordinate[2]))
    end
    --创建海豹
    for i = 1, Constant.Number.Seal do
        CreateUnitAtRandomPosition(Base.NEUTRAL_PASSIVE, Constant.UnitType.Seal)
    end
    --单个特定单位
    Constant.Unit.UnknownOrganism = CreateUnitAtRandomPosition(Base.NEUTRAL_AGGRESSIVE, Constant.UnitType.UnknownOrganism)
    Constant.Unit.Spell = CreateUnitAtCoordinate(Base.NEUTRAL_PASSIVE, Constant.UnitType.Spell, 0, 0)
    Constant.Unit.BlackStoreBusiness = CreateUnitAtRandomPosition(Base.NEUTRAL_PASSIVE, Constant.UnitType.BlackStoreBusiness)
    --创建基础怪物
    for i = 1, Constant.Number.BaseMonster do
        CreateUnitAtRandomPosition(Base.NEUTRAL_AGGRESSIVE, Constant.UnitType.GeneralMonster[GetRandomInt(1, #Constant.UnitType.GeneralMonster)])
    end
    --为玩家创建单位
    for i = 1, #Constant.Group.Players do
        local p = Constant.Group.Players[i]
        local Race = GetPlayerRace(p)
        local StartX = GetStartLocationX(GetPlayerStartLocation(p))
        local StartY = GetStartLocationY(GetPlayerStartLocation(p))
        local GoldMineType = Constant.UnitType.GoldMine
        local BaseType = Constant.UnitType.Base[Race][1]
        local MinerType = Constant.UnitType.Worker[Race]
        if (Race == RACE_UNDEAD) then
            GoldMineType = StringToInteger("ugol")
        elseif (Race == RACE_NIGHTELF) then
            GoldMineType = StringToInteger("egol")
        end
        UnitAddAbility(CreateUnitAtCoordinate(p, BaseType, StartX, StartY), Constant.Skill.ChildAura)
        if (GoldMineType == Constant.UnitType.GoldMine) then
            CreateUnitAtCoordinate(Base.NEUTRAL_PASSIVE, GoldMineType, StartX, StartY)
        else
            SetResourceAmount(CreateUnitAtCoordinate(p, GoldMineType, StartX, StartY), Constant.Value.GeneralGoldMineGold)
        end
        for j = 1, Constant.Number.BaseGoldMiner do
            CreateUnitAtCoordinate(p, MinerType, StartX, StartY)
        end
    end
end

--初始化富金矿
function InitSuperGoldMine()
    InitSuperGoldMine = nil
    TimerFunctionOnce(Constant.Time.SuperGoldMine, function()
        for i = 1, Constant.Number.SuperGoldMine do
            table.insert(Constant.Group.GoldMines,CreateUnitAtRandomPosition(Base.NEUTRAL_PASSIVE, Constant.UnitType.SuperGoldMine))
        end
        --清理时间常量
        Constant.Time.SuperGoldMine=nil
        --清理数量常量
        Constant.Number.SuperGoldMine=nil
        --清理单位类型常量
        Constant.UnitType.SuperGoldMine=nil
    end)
end

--初始化提示
function InitTips()
    --任务面板
    InitTips = nil
    local Tips = CreateQuest()
    QuestSetTitle(Tips, "命令")
    QuestSetIconPath(Tips, "ReplaceableTextures/CommandButtons/BTNBloodElfSupplyWagon.blp")
    QuestSetDescription(Tips, [[常用命令(在命令前要加-)
ms 查看移速
ng/nw 玩家id 资源量 向电脑玩家请求黄金/木材
gg/gw 玩家id 资源量 给予AI队友黄金/木材
giun 玩家id 转让单位给玩家
neun 向AI请求转让单位
cl 命令列表]])
    Tips = CreateQuest()
    QuestSetTitle(Tips, "更新日志")
    QuestSetIconPath(Tips, "ReplaceableTextures/WorldEditUI/StartingLocation.blp")
    QuestSetDescription(Tips, [[20200309
[更改]
1.[重要]使用lua重新制作,更加丰富的地形装饰物和更多的树木
2.恐惧魔王终极技能更改为混乱之雨
3.修改了ai的部分技能使用机制
4.[重要]版本需求更改为1.31+
5.修补匠的机器人进军更改为粉碎
6.部分单位改名
7.修补匠的修理的附加附加现在会随技能等级提升,并拥有消退时间效果
8.增加了金矿数量
9.中立英雄移除炼金术士和侍僧
10.现在精英怪物所有负面效果技能无视魔免
11.增强恐怖阴影
12.所有技能快捷键恢复为默认值
13.科技最大等级更改为9
14.金矿基础含量更改为10000
15.大幅调整ai学习技能的顺序
16.其它的一些更改
[新增]
1.新增中立生物海豹
2.增加了新的怪物种类
3.新增击杀地图中心怪物掉落物品机制
4.添加了天气效果
5.再生的金矿含量随机化
6.为更多伤害和治疗型的技能添加了ai施放
7.其它的一些新增
[修正]
1.修正堕落法师沉默光环无效的问题
2.修正了部分技能提示不正确的问题
3.其它的一些修正]])
    Tips = CreateQuest()
    QuestSetTitle(Tips, "已知问题")
    QuestSetIconPath(Tips, "ReplaceableTextures/CommandButtons/BTNAuraOfDarkness.blp")
    QuestSetDescription(Tips, [[偶尔会周期性地卡顿,原因不明,不过据测试如果全选不死族似乎没有卡顿
游戏一小时后有较大几率崩溃,原因不明,可以用存档读档临时解决]])
    Tips = CreateQuest()
    QuestSetTitle(Tips, "开源声明")
    QuestSetIconPath(Tips, "ReplaceableTextures/CommandButtons/BTNLament.blp")
    QuestSetDescription(Tips, "我所有的地图都是开源的,你可以随意修改和发布,但有必要加上原作者gcud")
    QuestSetRequired(Tips, false)
    Tips = CreateQuest()
    QuestSetTitle(Tips, "联系我")
    QuestSetIconPath(Tips, "ReplaceableTextures/WorldEditUI/BlizzardLogo.blp")
    QuestSetDescription(Tips, "我所有地图,资料和工具都在我的微云分享里,地址是https://share.weiyun.com/5EefuQM,如果你有什么意见,建议或是想问我的,你可以加我的微信号gcudzy,你需要注明你的来意,或者你也可以发送邮件到gcudfun@163.com")
    QuestSetRequired(Tips, false)
    Tips = CreateQuest()
    QuestSetTitle(Tips, "杂谈")
    QuestSetIconPath(Tips, "ReplaceableTextures/CommandButtons/BTNBoneChimes.blp")
    QuestSetDescription(Tips, [[这个版本花了我太多的时间,导致我没时间去做其它图和其它事,到这个时候我想实在是要结束了,哪怕它还存在闪退和无提示崩溃这种严重的问题
为了保证地图新版本没有污染,所有数据没有采用直接的复制粘贴,而是一点点还原的,物编这块尤其是技能这块做起来最麻烦,其次是单位,花了很多时间,这个版本的平衡性有较大调整,很多技能都加大了魔耗,大致上按照1.25倍率做的,地图本来更大一些,但考虑到性能和比较空的原因又变成原来的大小
想起用lua的一个好处是只要把数据结构规划好,写ai的技能升级简直太简单,之前因为ydwe的自带ai学习技能存在循环溢出的问题一直想把ai学习技能部分自己重写,但一直苦于数据的保存和读取,字符串截取啊,哈希表嵌套啊简直头大
翻技能id时看到一个有趣的东西,本是月之女祭司的技能灼热之箭id为AHfa,而从其它的技能命名来看id都是以[A 种族首字母 技能名称]这种方式命名的,也就是说精灵的技能都是AE开头,而这个技能是AH开头,所以这个可能原来是人族技能不知什么原因改成了精灵的
另外作图的主要部分期间我感冒了,导致效率差了很多]])
    QuestSetRequired(Tips, false)
    --文字提示
    DisplayTimedTextToPlayer(GetLocalPlayer(), 0, 0, 30, [[|cFF666666诺森德之殇1-混乱大陆
	]] .. Constant.Version .. "|r")
    DisplayTimedTextToPlayer(GetLocalPlayer(), 0, 0, 30, "|cFF666666gcud|r")
    TimerFunctionOnce(30, function()
        DisplayTimedTextToPlayer(GetLocalPlayer(), 0, 0, 30, [[|cff00ff00我所有的地图都是开源的,你可以随意修改和发布,但有必要加上原作者gcud
你可以在https://share.weiyun.com/5EefuQM上找到我所有的地图,资料和工具
如果你有什么意见,建议或是想问我的,你可以加我的微信号gcudzy,你需要注明你的来意,你也可以发送邮件到gcudfun@163.com|r]])
    end)
    DisplayMessage("注意:当前版本存在稳定性和性能问题!",nil,true,60)
end

--初始化设定
function InitSetting()
    InitSetting = nil
    SetPlayerName(Base.NEUTRAL_PASSIVE, "诺森德访客")
    SetPlayerName(Base.NEUTRAL_AGGRESSIVE, "诺森德恶灵")
    Constant.PlayerData[Base.NEUTRAL_AGGRESSIVE] = { DisplayName = "|cffffffff诺森德恶灵|r" }
    --禁用施法单位的沉默光环
    BlzUnitDisableAbility(Constant.Unit.Spell, Constant.Skill.SilenceAuraAction, true, false)
    --初始化未知生物的机制
    InitUnknownOrganism()
end

--初始化玩家
function InitPlayers()
    InitPlayers = nil
    for i = 1, Constant.Number.MaxPlayer do
        local p = Player(i - 1)
        if (GetPlayerSlotState(p) == PLAYER_SLOT_STATE_PLAYING) then
            --看引用才知道英雄数量就是科技等级
            SetPlayerTechMaxAllowed(p, StringToInteger("HERO"), Constant.Number.MaxHero)
            ModifyPlayerGold(p, Constant.Value.StartGold, true)
            ModifyPlayerLumber(p, Constant.Value.StartLumber, true)
            table.insert(Constant.Group.Players, p)
            Constant.PlayerData[p] = { PlayerLine = 0, DisplayName = "|cff" .. GetPlayerColorString(i) .. GetPlayerName(p) .. "|r", LoseUnit = 0, LoseHero = 0, LoseStructure = 0, KillAllianceUnit = 0, KillAllianceHero = 0, KillUnit = 0, KillHero = 0, DestroyStructure = 0}
            if (GetPlayerController(p) == MAP_CONTROL_COMPUTER) then
                Constant.PlayerData[p]["HeroNumber"]=0
                Constant.PlayerData[p]["Research"]=1
                Constant.PlayerData[p]["GoblinMinerTarget"]=nil
                Constant.PlayerData[p]["GoblinMinerReceiver"]=nil
                table.insert(Constant.Group.AiPlayers, p)
                SetPlayerName(p, GetAiPlayerName(i))
                Constant.PlayerData[p]["DisplayName"]="|cff" .. GetPlayerColorString(i) .. GetPlayerName(p) .. "|r"
                RegisterAi(p)
            else
                Constant.PlayerData[p]["SelectedUnit"]=nil
                table.insert(Constant.Group.UserPlayers, p)
            end
        end
    end
    --分配联盟组
    local TemporaryPlayers = {}
    for i = 1, #Constant.Group.Players do
        table.insert(TemporaryPlayers, Constant.Group.Players[i])
    end
    while (#TemporaryPlayers > 0) do
        local Alliance = {}
        local FirstPlayer = TemporaryPlayers[1]
        table.remove(TemporaryPlayers, 1)
        table.insert(Alliance, FirstPlayer)
        local offset = 0
        for i = 1, #TemporaryPlayers do
            if (#TemporaryPlayers > 0) then
                local p = TemporaryPlayers[i - offset]
                if (IsPlayerAlly(p, FirstPlayer)) then
                    table.remove(TemporaryPlayers, i - offset)
                    table.insert(Alliance, p)
                    offset = offset + 1
                end
            else
                break
            end
        end
        table.insert(Constant.Group.Alliance, Alliance)
    end
end

function InitGameBoard()
    InitGameBoard = nil
    local RowLength = 1
    Constant.GameBoard = CreateMultiboard()
    MultiboardSetRowCount(Constant.GameBoard, RowLength)
    MultiboardSetColumnCount(Constant.GameBoard, 11)
    MultiboardSetTitleText(Constant.GameBoard, "|cFF666666诺森德之殇1-混乱大陆|r")
    MultiboardSetItemsStyle(Constant.GameBoard, true, false)
    MultiboardSetItemsWidth(Constant.GameBoard, 0.05)
    MultiboardMinimize(Constant.GameBoard, true)
    SetGameBoardValue(0, 0, "同盟队伍")
    SetGameBoardValue(0, 1, "杀死英雄")
    SetGameBoardValue(0, 2, "英雄死亡")
    SetGameBoardValue(0, 3, "摧毁建筑")
    SetGameBoardValue(0, 4, "损失建筑")
    SetGameBoardValue(0, 5, "杀死单位")
    SetGameBoardValue(0, 6, "损失单位")
    SetGameBoardValue(0, 7, "反补英雄")
    SetGameBoardValue(0, 8, "反补单位")
    SetGameBoardValue(0, 9, "单位数量")
    SetGameBoardValue(0, 10, "游戏状态")
    MultiboardSetItemWidth(MultiboardGetItem(Constant.GameBoard, 0, 0), 0.1)
    MultiboardDisplay(Constant.GameBoard, true)
    local RowIndex = 0
    for i = 1, #Constant.Group.Alliance do
        RowIndex = RowLength
        RowLength = RowLength + 1
        MultiboardSetRowCount(Constant.GameBoard, RowLength)
        SetGameBoardValue(RowIndex, 0, "联盟" .. i)
        for j = 1, #Constant.Group.Alliance[i] do
            RowIndex = RowLength
            RowLength = RowLength + 1
            MultiboardSetRowCount(Constant.GameBoard, RowLength)
            local p = Constant.Group.Alliance[i][j]
            Constant.PlayerData[p]["PlayerLine"] = RowIndex
            local Item = MultiboardGetItem(Constant.GameBoard, RowIndex, 0)
            MultiboardSetItemWidth(Item, 0.1)
            MultiboardSetItemValue(Item, Constant.PlayerData[p]["DisplayName"] .. "(" .. GetPlayerId(p) .. ")")
            SetGameBoardValue(RowIndex, 10, "|cFF00FF00正在游戏|r")
        end
    end
    MultiboardSetRowCount(Constant.GameBoard, RowLength + 1)
    Constant.Value.ExtraInfoRowIndex = RowLength
    SetGameBoardValue(RowLength, 0, "游戏时间")
    SetGameBoardValue(RowLength, 2, "现实时间")
    MultiboardSetItemWidth(MultiboardGetItem(Constant.GameBoard, RowLength, 3), 0.15)
    SetGameBoardValue(RowLength, 9, "怪物数量")
end

--进行初始化
function Init()
    Init = nil
    InitPlayers()
    InitAllTrigger()
    InitSuperGoldMine()
    InitTips()
    InitGameBoard()
    InitBaseUnit()
    InitMonster()
    InitSetting()
    InitDebug()
    ClearInvalidVariable()
end

--开始
function Start()
    Start = nil
    --游戏要用0秒触发器开始而不是计时器,这时候游戏对象还没有创建
    local t = CreateTrigger()
    TriggerRegisterTimerEvent(t, 0, false)
    TriggerAddAction(t, function()
        DestroyTrigger(t)
        --初始化基础库
        InitBaseConstant()
        InitConstant()
        Init()
    end)
end

--开始游戏
Start()