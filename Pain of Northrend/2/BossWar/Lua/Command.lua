-- 注册命令
function CommandHandle(p, Message)
    if (string.sub(Message, 1, 1) == "-") then
        local Parameters = gcudLua.StringSplit(string.sub(Message, 2), " ")
        local Command = Parameters[1]
        if (Command == "vcl") then
            Command_vcl(p)
        elseif (Command == "ms") then
            Command_ms(p)
        elseif (Command == "vai") then
            Command_vai(p) 
        end
    end
end

function Command_vcl(p)
    gcudLua.DisplayMessage([[命令列表(所有命令必须在前面添加-)
    [常用]
查看命令列表
vcl
查看选中单位移动速度
ms
查看自己技能信息
vai
]], p)
gcudLua.TimerFunctionOnce(10, function()
    gcudLua.DisplayMessage([[所有命令只有在输入正确时才有响应]], p)
    end)
end

function Command_ms(p)
    gcudLua.DisplayMessage("移动速度" ..GetUnitMoveSpeed(PlayerData[p].SelectedUnit), p)
end



function Command_vai(p)
    local SkillList=Units[PlayerData[p].SelectedUnit].SkillList
    if SkillList==nil then
        gcudLua.DisplayMessage("此单位没有技能信息", p)
    else
        for i = 1, #SkillList do
            local Info=""
            if SkillList[i].Proficiency~=nil then
                Info=":等级"..SkillList[i].Level..",熟练度"..SkillList[i].Proficiency
            end
            gcudLua.DisplayMessage(SkillList[i].Name..Info,p)
        end
    end
end
