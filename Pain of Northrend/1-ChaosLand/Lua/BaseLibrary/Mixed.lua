--记录日志
function Log(Message)
    Preload(Message)
    PreloadGenEnd("MapLog.txt")
end

--debug消息,支持两个参数,第二个可选参数为当前变量解释
function DebugMessage(Variable,...)
    local Parameters = { ... }
    local Name = ""
    if (#Parameters > 0) then
        Name = "[" .. Parameters[1] .. "]"
    end
    if (Variable== true) then
        Variable = "true"
    elseif (Variable == false) then
        Variable = "false"
    elseif (Variable== nil) then
        Variable= "nil"
    end
    print("|cffff0000Debug信息开始|r" .. Name ..Variable .. "|cffff0000Debug信息结束|r")
    Log(Name .. Variable)
end

--显示消息
--1消息内容,必选,字符串
--2玩家,可选,玩家,默认所有玩家
--3是否警示(以红色显示),可选,布尔,默认否
--4时长,可选,数字,默认自动,必须大于0
function DisplayMessage(Message,...)
    local Parameters = { ... }
    local p = Parameters[1]
    if (p == nil) then
        p = GetLocalPlayer()
    end
    if (Parameters[2] == true) then
        Message = "|cffff0000" .. Message .. "|r"
    end
    local Time=Parameters[3]
    if (Time~=nil and Time> 0) then
        DisplayTimedTextToPlayer(p, 0, 0,Time, Message)
    else
        DisplayTextToPlayer(p, 0, 0, Message)
    end
end

--整数转id字符串
function IntegerToString(Integer)
    return ('>I4'):pack(Integer)
end

--id字符串转整数
function StringToInteger(String)
    --必须使用变量保存返回值否则在table使用会多出一个元素5
    local Value = ('>I4'):unpack(String)
    return Value
end

--在指定坐标创建单位
function CreateUnitAtCoordinate(Owner, Id, X, Y)
    return CreateUnit(Owner, Id, X, Y, 0)
end

--判断单位拥有指定技能
function UnitHaveSkill(U, SkillId)
    return GetUnitAbilityLevel(U, SkillId) > 0
end

--判断单位是否存在
function UnitIsExist(U)
    return GetUnitState(U, UNIT_STATE_MAX_LIFE) > 0
end

--判断单位是英雄
function IsHero(U)
    return IsUnitType(U, UNIT_TYPE_HERO)
end

--设置指定玩家的镜头坐标
function SetPlayerCameraCoordinate(P, X, Y)
    if (GetLocalPlayer() == P) then
        SetCameraPosition(X, Y)
    end
end

--判断单位是否存活
function UnitIsAlive(U)
    return GetUnitState(U, UNIT_STATE_LIFE) > 0
end

--获取单位魔法值
function GetUnitMagical(U)
    return GetUnitState(U, UNIT_STATE_MANA)
end

--获取一个随机的x坐标
function GetRandomX()
    return GetRandomReal(Base.LeftX, Base.RightX)
end

--获取一个随机的y坐标
function GetRandomY()
    return GetRandomReal(Base.DownY, Base.UpY)
end

--获取一个可用的地面单位坐标
function GetAvailableGroundUnitCoordinate()
    local X, Y = GetRandomX(), GetRandomY()
    while (IsTerrainPathable(X, Y, PATHING_TYPE_WALKABILITY)) do
        X, Y = GetRandomX(), GetRandomY()
    end
    return { X, Y }
end

--给玩家在随机位置创建一个单位
function CreateUnitAtRandomPosition(Owner, Id)
    return CreateUnitAtCoordinate(Owner, Id, GetRandomX(), GetRandomY())
end

--获取指定角度和距离的偏移x坐标
function GetAngleOffsetXCoordinate(Coordinate, Angle, OffsetValue)
    return Coordinate + math.cos(Angle * Base.DEGTORAD) * OffsetValue
end

--获取指定角度和距离的偏移y坐标
function GetAngleOffsetYCoordinate(Coordinate, Angle, OffsetValue)
    return Coordinate + math.sin(Angle * Base.DEGTORAD) * OffsetValue
end

--判断此次伤害是否为攻击伤害(伤害类型为普通并且攻击类型不是法术)
function IsAttackDamage()
        return BlzGetEventAttackType() ~= ATTACK_TYPE_NORMAL and BlzGetEventDamageType() == DAMAGE_TYPE_NORMAL
end

--判断此次伤害是否为物理伤害(伤害类型为普通)
function IsPhysicalDamage()
    return BlzGetEventDamageType() == DAMAGE_TYPE_NORMAL
end

--循环计时器动作,需要自己控制销毁
function TimerFunction(Interval, Fun)
    local T = CreateTimer()
    TimerStart(T, Interval, true, function()
        Fun()
    end)
end

--一次性计时器动作
function TimerFunctionOnce(Time, Fun)
    local T = CreateTimer()
    TimerStart(T, Time, false, function()
        Fun()
        DestroyTimer(T)
    end)
end

--筛选器,和Filter类似
--FilterItems:table字符串,目前支持AliveUnit(存活单位),AllianceUnit(盟友单位,不包括中立被动单位),EnemyUnit(敌人),Structure(建筑),NotStructure(非建筑),Hero(英雄),NotHero(非英雄),NotMagicImmune(非魔免),Visible(对玩家可见),NotInvulnerable(非无敌),你可以将多数会被排除的条件放在前面来提高性能
--Parameters:table,要按照固定属性传参,所有属性可选,但要符合筛选项需要的参数,MainUnit(主单位,会被认为是判断时的首选单位参数),MainPlayer(主玩家,会被认为是判断时的首选玩家参数),MinorPlayer(次玩家,会被认为是判断时除主玩家外的玩家参数),更加明确地就需要翻阅下面的源代码,原则是按照cj函数的参数顺序,如果有不符合这个这个原则的请报告给gcud
function gcudFilter(FilterItems, Parameters)
    local Result = true;
    for i = 1, #FilterItems do
        if (Result == false) then
            break
        else
            local FilterItem = FilterItems[i]
            if (FilterItem == "AliveUnit") then
                Result = Result and UnitIsAlive(Parameters.MainUnit)
            elseif (FilterItem == "AllianceUnit") then
                Result = Result and IsUnitAlly(Parameters.MainUnit, Parameters.MainPlayer) and GetOwningPlayer(Parameters.MainUnit) ~= Base.NEUTRAL_PASSIVE
            elseif (FilterItem == "EnemyUnit") then
                Result = Result and IsUnitEnemy(Parameters.MainUnit, Parameters.MainPlayer)
            elseif (FilterItem == "Structure") then
                Result = Result and IsUnitType(Parameters.MainUnit, UNIT_TYPE_STRUCTURE)
            elseif (FilterItem == "NotStructure") then
                Result = Result and not IsUnitType(Parameters.MainUnit, UNIT_TYPE_STRUCTURE)
            elseif (FilterItem == "Hero") then
                Result = Result and IsUnitType(Parameters.MainUnit, UNIT_TYPE_HERO)
            elseif (FilterItem == "NotHero") then
                Result = Result and not IsUnitType(Parameters.MainUnit, UNIT_TYPE_HERO)
            elseif (FilterItem == "NotMagicImmune") then
                Result = Result and not IsUnitType(Parameters.MainUnit, UNIT_TYPE_MAGIC_IMMUNE)
            elseif (FilterItem == "Visible") then
                Result = Result and IsUnitVisible(Parameters.MainUnit, Parameters.MainPlayer)
            elseif (FilterItem == "NotInvulnerable") then
                Result = Result and not BlzIsUnitInvulnerable(Parameters.MainUnit)
            end
        end
    end
    return Result
end

--判断值在有序表里是否存在,不能判断nil
function InOrderedTable(Value, Table)
    for i = 1, #Table do
        if (Table[i] ~= nil and Table[i] == Value) then
            return true
        end
    end
    return false
end

--顺序表移除元素
function OrderTableRemoveItem(Table, Item)
    for i = 1, #Table do
        if (Table[i] == Item) then
            table.remove(Table, i)
            break
        end
    end
end

--选取坐标内单位做动作,你可以在函数内部返回true来停止遍历以提高性能
function EnumUnitsInRangeDoActionAtCoordinate(X, Y, Range, fun)
    local g = CreateGroup()
    GroupEnumUnitsInRange(g, X, Y, Range, nil)
    local Size=BlzGroupGetSize(g)
    if(Size>0)then
        for i = 1, Size do
            local u=BlzGroupUnitAt(g,0)
            GroupRemoveUnit(g,u)
            local IsBreak=fun(u)
            if(IsBreak)then
                break
            end
        end
    end
    DestroyGroup(g)
end

--获取玩家单位数量
function GetPlayerUnitsCount(p)
    return GetPlayerUnitCount(p) + GetPlayerStructureCount(p, true)
end

--判断单位是建筑
function IsStructure(u)
    return IsUnitType(u, UNIT_TYPE_STRUCTURE)
end

--获取单位血量
function GetUnitHP(u)
    return GetUnitState(u, UNIT_STATE_LIFE)
end

--分割字符串
function StringSplit(Str, SplitString)
    local Strings = {}
    local SplitStringLength = string.len(SplitString)
    while (true) do
        local StartIndex, EndIndex = string.find(Str, SplitString)
        if (StartIndex == nil) then
            if (Str ~= "") then
                table.insert(Strings, Str)
            end
            break
        else
            table.insert(Strings, string.sub(Str, 1, StartIndex - SplitStringLength))
            Str = string.sub(Str, EndIndex + SplitStringLength)
        end
    end
    return Strings
end

--获取玩家黄金
function GetPlayerGold(p)
    return GetPlayerState(p,PLAYER_STATE_RESOURCE_GOLD)
end

--获取玩家木材
function GetPlayerLumber(p)
    return GetPlayerState(p,PLAYER_STATE_RESOURCE_LUMBER)
end

--获取当前时间字符串
function GetNowTimeString()
    return os.date("%%Y年%%m月%%d日%%H时%%M分%%S秒")
end

--获取单位生命比
function GetUnitHPRate(u)
    local MaxHP=BlzGetUnitMaxHP(u)
    if(MaxHP>0)then
        return GetUnitState(u,UNIT_STATE_LIFE)/MaxHP
    else
        return 0
    end
end

--获取单位魔法比
function GetUnitMPRate(u)
    local MaxMP=BlzGetUnitMaxMana(u)
    if(MaxMP>0)then
        return GetUnitState(u,UNIT_STATE_MANA)/MaxMP
    else
        return 0
    end
end

--判断单位拥有指定类型物品
function UnitHaveTypeItem(u,ItemType)
    for i = 0, 5 do
        local Item=UnitItemInSlot(u,i)
        if(Item~=nil and GetItemTypeId(Item)==ItemType)then
            return true
        end
    end
    return false
end

--判断单位技能是否冷却
function UnitSkillIsCollDown(u,a)
    return BlzGetUnitAbilityCooldownRemaining(u,a)==0
end