function InitDebug()
    InitDebug = nil
    if (Constant.Debug) then
        --锁定游戏速度
        SetGameSpeed(MAP_SPEED_FASTEST)
        SetMapFlag(MAP_LOCK_SPEED, true)
        --设置ai为疯狂
        SetGameDifficulty(MAP_DIFFICULTY_INSANE)
        --全图可见
        FogEnable(false)
        FogMaskEnable(false)
        local p = GetLocalPlayer()
        Debug = {
            Init = function()
                Debug.InitTips()
                Debug.InitCommand()
            end,
            InitCommand = function()
                local t = CreateTrigger()
                TriggerRegisterPlayerChatEvent(t, p, "", false)
                TriggerAddAction(t, function()
                    local Commands=StringSplit(GetEventPlayerChatString()," ")
                    local Command =Commands[1]
                    if (Command == "dc") then
                        print([[Debug命令列表
[获取所有Debug命令]
dc
[提升选中英雄等级]
uhl 等级
[杀死选中单位]
k
[设置选中单位最大魔法值]
smm 最大魔法值
[创建指定个数随机怪物]
cm 数量
]])
                    elseif(Command=="uhl")then
                        local u=Constant.PlayerData[p]["SelectedUnit"]
                        for i = 1, Commands[2] do
                            SetHeroLevel(u,GetHeroLevel(u)+1,true)
                        end
                    elseif(Command=="k")then
                        local u=Constant.PlayerData[p]["SelectedUnit"]
                        KillUnit(u)
                    elseif(Command=="smm")then
                        local u=Constant.PlayerData[p]["SelectedUnit"]
                        BlzSetUnitMaxMana(u, Commands[2])
                    elseif(Command=="cm")then
                        local x,y=GetCameraTargetPositionX(),GetCameraTargetPositionY()
                        local Max=#Constant.UnitType.GeneralMonster
                        for i = 1, Commands[2] do
                            CreateUnitAtCoordinate(Base.NEUTRAL_AGGRESSIVE,Constant.UnitType.GeneralMonster[GetRandomInt(1,Max)],x,y)
                        end
                    end
                end)
            end,
            InitTips = function()
                DisplayMessage("当前处于Debug模式,你可以输入dc来获取所有的Debug命令",nil,true)
            end
        }
        Debug.Init()
    end
end