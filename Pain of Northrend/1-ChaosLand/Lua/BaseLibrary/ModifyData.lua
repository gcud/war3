--修改单位护甲
function ModifyUnitArmor(U,Value,IsAdd)
	local Armor=BlzGetUnitArmor(U)
	if (IsAdd) then
		BlzSetUnitArmor(U,Armor + Value)
	else
		BlzSetUnitArmor(U,Armor - Value)
	end
end

--修改单位生命值
function ModifyUnitHP(U,Value,IsAdd)
	local HP=GetUnitState(U,UNIT_STATE_LIFE)
	if (IsAdd) then
		SetUnitState(U,UNIT_STATE_LIFE,HP + Value)
	else
		SetUnitState(U,UNIT_STATE_LIFE,HP - Value)
	end
end

--修改单位魔法值
function ModifyUnitMagical(U,Value,IsAdd)
	local Magical=GetUnitMagical(U)
	if (IsAdd) then
		SetUnitState(U,UNIT_STATE_MANA,Magical + Value)
	else
		SetUnitState(U,UNIT_STATE_MANA,Magical - Value)
	end
end

--修改单位生命上限
function ModifyUnitMaxHP(U,Value,IsAdd)
	local MaxHP=BlzGetUnitMaxHP(U)
	if (IsAdd) then
		BlzSetUnitMaxHP(U,MaxHP + Value)
	else
		BlzSetUnitMaxHP(U,MaxHP - Value)
	end
end

--修改单位攻击力
function ModifyUnitAttackPower(U,Value,IsAdd)
	--同时修改攻击1和2的基础攻击
	local AttackPower1,AttackPower2=BlzGetUnitBaseDamage(U,0),BlzGetUnitBaseDamage(U,1)
	if (IsAdd) then
		BlzSetUnitBaseDamage(U,AttackPower1 + Value,0)
		BlzSetUnitBaseDamage(U,AttackPower2 + Value,1)
	else
		BlzSetUnitBaseDamage(U,AttackPower1 - Value,0)
		BlzSetUnitBaseDamage(U,AttackPower2 - Value,1)
	end
end

--修改英雄力量
function ModifyHeroStrength(Hero,Value,IsAdd)
	local Strength=GetHeroStr(Hero,false)
	if (IsAdd) then
		SetHeroStr(Hero,Strength + Value)
	else
		SetHeroStr(Hero,Strength - Value)
	end
end

--修改英雄敏捷
function ModifyHeroAgile(Hero,Value,IsAdd)
	local Agile=GetHeroAgi(Hero,false)
	if (IsAdd) then
		SetHeroAgi(Hero,Agile + Value)
	else
		SetHeroAgi(Hero,Agile - Value)
	end
end

--修改英雄智力
function ModifyHeroIntelligence(Hero,Value,IsAdd)
	local Intelligence=GetHeroInt(Hero,false)
	if (IsAdd) then
		SetHeroInt(Hero,Intelligence + Value)
	else
		SetHeroInt(Hero,Intelligence - Value)
	end
end


--修改玩家黄金
function ModifyPlayerGold(P,Value,IsAdd)
	local Gold=GetPlayerState(P,PLAYER_STATE_RESOURCE_GOLD)
	if (IsAdd) then
		SetPlayerState(P,PLAYER_STATE_RESOURCE_GOLD,Gold + Value)
	else
		SetPlayerState(P,PLAYER_STATE_RESOURCE_GOLD,Gold - Value)
	end
end

--修改玩家木材
function ModifyPlayerLumber(P,Value,IsAdd)
	local Gold=GetPlayerState(P,PLAYER_STATE_RESOURCE_LUMBER)
	if (IsAdd) then
		SetPlayerState(P,PLAYER_STATE_RESOURCE_LUMBER,Gold + Value)
	else
		SetPlayerState(P,PLAYER_STATE_RESOURCE_LUMBER,Gold - Value)
	end
end