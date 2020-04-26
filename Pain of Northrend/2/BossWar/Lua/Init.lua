-- 初始化玩家
function InitPlayers()
    InitPlayers = nil
    --基地
    for i = 1, #gcudLua.Players do
        local p = gcudLua.Players[i]
        --绑定玩家特有数据
        PlayerData[p] = {
            PlayerLine = 0,
            DisplayName = "|cff" .. gcudLua.GetPlayerColorString(i-1) ..GetPlayerName(p) .. "|r",
            LoseUnit = 0,
            LoseHero = 0,
            KillUnit = 0,
            KillBoss = 0,
            DropRate = 0,
            SkillInfo={}
        }
        NowHero[p] = {
            Unit = nil,
            ReviveTime = 0
        }
        if (GetPlayerController(p) == MAP_CONTROL_COMPUTER) then
            RegisterAi(p)
        else
            PlayerData[p].SelectedUnit = nil
        end
        gcudLua.ModifyPlayerGold(p, Constant.Value.StartGold, true)
    end
    --为怪物玩家绑定数据
    PlayerData[gcudLua.MonsterPlayer] = {
        DisplayName = "|cff444444怪物|r",
    }
    --关闭中立敌对自带的奖励
    SetPlayerState(gcudLua.MonsterPlayer, PLAYER_STATE_GIVES_BOUNTY, 0)
end

--初始化玩家英雄
function InitPlayerHero()
    InitPlayerHero=nil
    local Max=#UnitType.HeroList
    for i = 1, #gcudLua.Players do
        gcudLua.CreateUnitAtCoordinate(gcudLua.Players[i], UnitType.HeroList[GetRandomInt(1,Max)],Constant.Coordinate.Revive[1] ,Constant.Coordinate.Revive[2])
    end
end

-- 初始化提示
function InitTips()
    -- 任务面板
    InitTips = nil
    local Tips = CreateQuest()
    QuestSetTitle(Tips, "命令")
    QuestSetIconPath(Tips,"ReplaceableTextures/CommandButtons/BTNBloodElfSupplyWagon.blp")
    QuestSetDescription(Tips, [[常用命令(在命令前要加-)
vcl 查看命令列表
ms 查看移动速度
vai 查看技能信息]])
    Tips = CreateQuest()
    QuestSetTitle(Tips, "更新日志")
    QuestSetIconPath(Tips,
                     "ReplaceableTextures/WorldEditUI/StartingLocation.blp")
    QuestSetDescription(Tips, Constant.Version..[[
第一版
]])
    Tips = CreateQuest()
    QuestSetTitle(Tips, "已知问题")
    QuestSetIconPath(Tips,"ReplaceableTextures/CommandButtons/BTNAuraOfDarkness.blp")
    QuestSetDescription(Tips, [[目前对技能信息的显示不好]])
    Tips = CreateQuest()
    QuestSetTitle(Tips, "开源声明")
    QuestSetIconPath(Tips, "ReplaceableTextures/CommandButtons/BTNLament.blp")
    QuestSetDescription(Tips,"我所有的地图都是开源的,你可以随意修改和发布,但有必要加上原作者gcud")
    QuestSetRequired(Tips, false)
    Tips = CreateQuest()
    QuestSetTitle(Tips, "联系我")
    QuestSetIconPath(Tips, "ReplaceableTextures/WorldEditUI/BlizzardLogo.blp")
    QuestSetDescription(Tips,"我所有地图,资料和工具都在我的微云分享里,地址是https://share.weiyun.com/5EefuQM,如果你有什么意见,建议或是想问我的,你可以加我的微信号gcudzy,你需要注明你的来意,或者你也可以发送邮件到gcudfun@163.com")
    QuestSetRequired(Tips, false)
    Tips = CreateQuest()
    QuestSetTitle(Tips, "杂谈")
    QuestSetIconPath(Tips,"ReplaceableTextures/CommandButtons/BTNBoneChimes.blp")
    QuestSetDescription(Tips, [[]])
    QuestSetRequired(Tips, false)
    -- 文字提示
    gcudLua.DisplayMessage("诺森德之殇2Boss战",nil,true,30)
    gcudLua.DisplayMessage(Constant.Version,nil,true,30)
    gcudLua.DisplayMessage("gcud",nil,true,30)
    gcudLua.TimerFunctionOnce(30, function()
        gcudLua.DisplayMessage([[|cff00ff00我所有的地图都是开源的,你可以随意修改和发布,但有必要加上原作者gcud
你可以在https://share.weiyun.com/5EefuQM上找到我所有的地图,资料和工具
如果你有什么意见,建议或是想问我的,你可以加我的微信号gcudzy,你需要注明你的来意,你也可以发送邮件到gcudfun@163.com|r]])
    end)
end

-- 进行初始化
function GameInit()
    GameInit = nil
    InitPlayers()
    InitAllTrigger()
    InitMonster()
    InitPlayerHero()
    InitTips()
    InitDebug()
    -- ClearInvalidVariable()
    gcudLua.DebugMessage("初始化完成")
end

-- 开始
function Start()
    Start = nil
    -- 游戏要用0秒触发器开始而不是计时器,这时候游戏对象还没有创建
    local t = CreateTrigger()
    TriggerRegisterTimerEvent(t, 0, false)
    TriggerAddAction(t, function()
        DestroyTrigger(t)
        -- 初始化基础库
        gcudLua.Init()
        InitConstant()
        GameInit()
    end)
end

-- 开始游戏
Start()