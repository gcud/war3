library gcud
function gcudGetCoordinateDistance takes real x1,real y1,real x2,real y2 returns real
return SquareRoot((x1-x2)*(x1-x2)+(y1-y2)*(y1-y2))
endfunction
function gcudR2I takes real i returns integer
local integer j=R2I(i)
if(S2I(SubString(R2S(i),2,3))>4) then
set j=j+1
endif
return j
endfunction
function gcudGetCoordinateAngle takes real x1,real y1,real x2,real y2 returns real
return 57.29578 *Atan2(y2-y1,x2-x1)
endfunction
endlibrary