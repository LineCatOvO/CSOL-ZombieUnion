---@diagnostic disable: lowercase-global
--In UI Module
ShowKillIconSignal=19191
LastKillTime=0
MultiKill=0
--我们假设。。。
local FadeOutNum=2--控制Kill图标淡出速度
ShowKillTimePeriod=0
UIx=UI.ScreenSize.width/2-99
UIy=UI.ScreenSize.height/4
KillIconPosition={UIx,UIy}
_boxUseNum = 0
function _boxDraw(boxTable,setTable,pos,mult,add)
	if add == nil or add == false then _boxUseNum = 0 end
	for index,set in pairs(setTable) do
		boxTable[index+_boxUseNum]:Show()
		boxTable[index+_boxUseNum]:Set({x=pos[1]+set[1]*mult,y=pos[2]+set[2]*mult,width=set[3]*mult,height=set[4]*mult,r=set[5],g=set[6],b=set[7],a=set[8]})
	end
	_boxUseNum = _boxUseNum + #setTable
end


function UpdateRefreshKillIcon()--如果有正在显示的box，那么就逐渐把透明度降低为0。
    for i=1,#KillBoxTable do
    local mya=KillBoxTable[i]:Get(a)
        if mya~=0 then
            if UITime-ShowKillTimePeriod>0.05 then
                KillBoxTable[i]:Set({a=mya-FadeOutNum})
                ShowKillTimePeriod=UITime
            end
        end
    end
end
function ShowKill()
    if LastKillTime==0 then
        LastKillTime=UITime
    end
    if UITime-LastKillTime<5 then
        MultiKill=MultiKill+1
    else
        MultiKill=1
    end
    if MultiKill==1 then
        _boxDraw(KillBoxTable,Kill1Icon[1],KillIconPosition,1,false)
    elseif MultiKill==2 then
        _boxDraw(KillBoxTable,Kill2Icon[1],KillIconPosition,1,false)
    elseif MultiKill==3 then
        _boxDraw(KillBoxTable,Kill3Icon[1],KillIconPosition,1,false)
    elseif MultiKill==4 then
        _boxDraw(KillBoxTable,Kill4Icon[1],KillIconPosition,1,false)
    end
end