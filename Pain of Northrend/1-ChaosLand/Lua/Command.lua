--注册命令
function CommandHandle(p,Message)
	if (string.sub(Message,1,1) == "-") then
		local Parameters=StringSplit(string.sub(Message,2)," ")
		local Command=Parameters[1]
		if (Command == "cl") then
			Command_cl(p)
		elseif (Command == "ms") then
			Command_ms(p)
		elseif (Command == "giun") then
			local TargetPlayer=Player(Parameters[2])
			local u=Constant.PlayerData[p]["SelectedUnit"]
			if (GetHandleId(TargetPlayer) > 0 and IsPlayerAlly(TargetPlayer,p) and TargetPlayer ~= Base.NEUTRAL_PASSIVE and InOrderedTable(TargetPlayer,Constant.Group.AiPlayers) and UnitIsAlive(u) and IsUnitOwnedByPlayer(u,p) and not IsHero(u)) then
				Command_giun(p,TargetPlayer,u)
			end
		elseif (Command == "neun") then
			local u=Constant.PlayerData[p]["SelectedUnit"]
			local TargetPlayer=GetOwningPlayer(u)
			if (IsPlayerAlly(TargetPlayer,p) and TargetPlayer ~= Base.NEUTRAL_PASSIVE and InOrderedTable(TargetPlayer,Constant.Group.AiPlayers) and UnitIsAlive(u) and not IsHero(u)) then
				Command_neun(p,TargetPlayer,u)
			end
		elseif (Command == "ng") then
			local TargetPlayer=Player(Parameters[2])
			local Value=math.floor(Parameters[3])
			if (Value > 0 and Value >= Constant.Value.AiSourceDealWithMin and Value <= Constant.Value.AiSourceDealWithMax and GetHandleId(TargetPlayer) > 0 and IsPlayerAlly(TargetPlayer,p) and TargetPlayer ~= Base.NEUTRAL_PASSIVE and InOrderedTable(TargetPlayer,Constant.Group.AiPlayers) and Value <= GetPlayerGold(TargetPlayer)) then
				Command_ng(p,TargetPlayer,Value)
			end
		elseif (Command == "nw") then
			local TargetPlayer=Player(Parameters[2])
			local Value=math.floor(Parameters[3])
			if (Value > 0 and Value >= Constant.Value.AiSourceDealWithMin and Value <= Constant.Value.AiSourceDealWithMax and GetHandleId(TargetPlayer) > 0 and IsPlayerAlly(TargetPlayer,p) and TargetPlayer ~= Base.NEUTRAL_PASSIVE and InOrderedTable(TargetPlayer,Constant.Group.AiPlayers) and Value <= GetPlayerLumber(TargetPlayer)) then
				Command_nw(p,TargetPlayer,Value)
			end
		elseif (Command == "gg") then
			local TargetPlayer=Player(Parameters[2])
			local Value=math.floor(Parameters[3])
			if (Value > 0 and Value >= Constant.Value.AiSourceDealWithMin and Value <= Constant.Value.AiSourceDealWithMax and Value <= GetPlayerGold(p) and GetHandleId(TargetPlayer) > 0 and IsPlayerAlly(TargetPlayer,p) and TargetPlayer ~= Base.NEUTRAL_PASSIVE and InOrderedTable(TargetPlayer,Constant.Group.AiPlayers)) then
				Command_gg(p,TargetPlayer,Value)
			end
		elseif (Command == "gw") then
			local TargetPlayer=Player(Parameters[2])
			local Value=math.floor(Parameters[3])
			if (Value > 0 and Value >= Constant.Value.AiSourceDealWithMin and Value <= Constant.Value.AiSourceDealWithMax and Value <= GetPlayerLumber(p) and GetHandleId(TargetPlayer) > 0 and IsPlayerAlly(TargetPlayer,p) and TargetPlayer ~= Base.NEUTRAL_PASSIVE and InOrderedTable(TargetPlayer,Constant.Group.AiPlayers)) then
				Command_gw(p,TargetPlayer,Value)
			end
		elseif (Command == "ci") then
			Command_ci(p)
		end
	end
end

function Command_cl(p)
	DisplayMessage([[命令列表(所有命令必须在前面添加-)
[常用]
ms 查看选中的第一个单位移速
cl 查看命令列表
[控制权(不可更改英雄的控制权)]
giun 玩家id 转让选择单位给AI队友
neun 向AI队友请求转让选择单位
玩家id可在游戏面板进行查看]],p)
	TimerFunctionOnce(10,function()
		DisplayMessage([[[资源]
ng 玩家id 资源量 向AI队友请求黄金
nw 玩家id 资源量 向AI队友请求木材
gg 玩家id 资源量 给予AI队友黄金
gw 玩家id 资源量 给予AI队友木材
[其它]
ci 在30秒后清理地图上的物品
所有命令只有在输入正确时才有响应]],p)
	end)
end

function Command_ms(p)
	DisplayMessage("移动速度" .. GetUnitMoveSpeed(Constant.PlayerData[p]["SelectedUnit"]),p)
end

function Command_giun(p,TargetPlayer,u)
	SetUnitOwner(u,TargetPlayer,true)
	DisplayMessage(Constant.PlayerData[p]["DisplayName"] .. "向" .. Constant.PlayerData[TargetPlayer]["DisplayName"] .. "转让了" .. GetUnitName(u) .. "的控制权",nil,true,30)
end

function Command_neun(p,TargetPlayer,u)
	SetUnitOwner(u,p,true)
	DisplayMessage(Constant.PlayerData[p]["DisplayName"] .. "向" .. Constant.PlayerData[TargetPlayer]["DisplayName"] .. "请求并获得了" .. GetUnitName(u) .. "的控制权",nil,true,30)
end

function Command_ng(p,TargetPlayer,Value)
	local RealValue=math.ceil(Value * Constant.Value.AiSourceDealWithRate)
	ModifyPlayerGold(TargetPlayer,Value,false)
	ModifyPlayerGold(p,RealValue,true)
	DisplayMessage(Constant.PlayerData[p]["DisplayName"] .. "向" .. Constant.PlayerData[TargetPlayer]["DisplayName"] .. "请求" .. Value .. "黄金,实际获得" .. RealValue,nil,true,30)
end

function Command_nw(p,TargetPlayer,Value)
	local RealValue=math.ceil(Value * Constant.Value.AiSourceDealWithRate)
	ModifyPlayerLumber(TargetPlayer,Value,false)
	ModifyPlayerLumber(p,RealValue,true)
	DisplayMessage(Constant.PlayerData[p]["DisplayName"] .. "向" .. Constant.PlayerData[TargetPlayer]["DisplayName"] .. "请求" .. Value .. "木材,实际获得" .. RealValue,nil,true,30)
end

function Command_gg(p,TargetPlayer,Value)
	local RealValue=math.ceil(Value * Constant.Value.AiSourceDealWithRate)
	ModifyPlayerGold(TargetPlayer,RealValue,true)
	ModifyPlayerGold(p,Value,false)
	DisplayMessage(Constant.PlayerData[p]["DisplayName"] .. "给予" .. Constant.PlayerData[TargetPlayer]["DisplayName"] .. Value .. "黄金,实际获得" .. RealValue,nil,true,30)
end

function Command_gw(p,TargetPlayer,Value)
	local RealValue=math.ceil(Value * Constant.Value.AiSourceDealWithRate)
	ModifyPlayerLumber(TargetPlayer,RealValue,true)
	ModifyPlayerLumber(p,Value,false)
	DisplayMessage(Constant.PlayerData[p]["DisplayName"] .. "给予" .. Constant.PlayerData[TargetPlayer]["DisplayName"] .. Value .. "木材,实际获得" .. RealValue,nil,true,30)
end

function Command_ci(p)
	DisplayMessage(Constant.PlayerData[p]["DisplayName"] .. "使用了清理地图物品命令,将会在30秒后清理地图上的物品",nil,true,30)
	TimerFunctionOnce(30,function()
		EnumItemsInRect(Base.MAP_AREA,nil,function()
			local i=GetEnumItem()
			SetWidgetLife(i,1)
			RemoveItem(i)
		end)
		DisplayMessage("地图物品已清理",nil,true,30)
	end)
end