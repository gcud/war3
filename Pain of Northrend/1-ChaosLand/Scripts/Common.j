//From string find position of target string,if not in will return -1
function StringFind takes string SourceString,string TargetString returns integer
    local integer Position=-1
    local integer SourceLength=StringLength(SourceString)
    local integer TargetLength=StringLength(TargetString)
    local integer NowPosition=0
    if SourceLength>0 and TargetLength>0 and SourceLength>=TargetLength then
        loop
            if NowPosition+TargetLength<=SourceLength then
                if SubString(SourceString,NowPosition,NowPosition+TargetLength)==TargetString then
                    set Position=NowPosition
                    exitwhen true
                else
                    set NowPosition=NowPosition+1
                endif
            else
                exitwhen true
            endif
        endloop
    endif
    return Position
endfunction

//check unit if have empty place
function GcudInventoryHaveEmpty takes unit Unit returns boolean
    local integer Loop=0
    loop
        exitwhen Loop>5
        if UnitItemInSlot(Unit,Loop)==null then
            return true
        endif
        set Loop=Loop+1
    endloop
    return false
endfunction

//check player if have base
function GcudFilterIsBase takes nothing returns boolean
	return IsUnitType(GetFilterUnit(),UNIT_TYPE_TOWNHALL)
endfunction

function GcudPlayerHaveBase takes player TargetPlayer returns boolean
	local group Group=CreateGroup()
	local boolean HaveBase=false
	call GroupEnumUnitsOfPlayer(Group,TargetPlayer,Filter(function GcudFilterIsBase))
	if FirstOfGroup(Group)!=null then
		set HaveBase=true
	endif
	call DestroyGroup(Group)
	return HaveBase
endfunction