--用于设置无法在table直接定义的数据
function BindExtraConstant()
    BindExtraConstant = nil
    --Ai动作区域
    Constant.AiArea=Rect(0, 0, 2000, 2000)
    --特定单位
    Constant.Unit.Speller=gcudLua.CreateUnitAtCoordinate(gcudLua.NeutralPlayer,Constant.UnitType.Speller,0,0)
    Constant.Unit.WeaponShoper=gcudLua.CreateUnitAtCoordinate(gcudLua.NeutralPlayer,Constant.UnitType.WeaponShoper,Constant.Coordinate.WeaponShoper[1],Constant.Coordinate.WeaponShoper[2])
    Constant.Unit.ArmorShoper=gcudLua.CreateUnitAtCoordinate(gcudLua.NeutralPlayer,Constant.UnitType.ArmorShoper,Constant.Coordinate.ArmorShoper[1],Constant.Coordinate.ArmorShoper[2])
    Constant.Unit.GroceryShoper=gcudLua.CreateUnitAtCoordinate(gcudLua.NeutralPlayer,Constant.UnitType.GroceryShoper,Constant.Coordinate.GroceryShoper[1],Constant.Coordinate.GroceryShoper[2])
    Constant.Unit.ReviveStone=gcudLua.CreateUnitAtCoordinate(gcudLua.NeutralPlayer,Constant.UnitType.ReviveStone,Constant.Coordinate.ReviveStone[1],Constant.Coordinate.ReviveStone[2])
    --感觉真赶工,居然没法直接获取技能名称
    Constant.HeroSkillLists[gcudLua.StringToInteger("N001")]={
        {Id=Constant.Skill.Charm,Name="魅惑",Level=1,Proficiency=0},
        {Id=gcudLua.StringToInteger("A001"),Name="性感",Level=1,Proficiency=0},
    }
end