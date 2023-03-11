---@diagnostic disable: lowercase-global
print("showskillicon".."已加载")
--In UI Module
ShowKillIconSignal=1
LastKillTime=0
MultiKill=1
--我们假设。。。
local FadeOutNum=6--控制Kill图标淡出速度
ShowKillTimePeriod=0
UIx=UI.ScreenSize().width/2-99
UIy=UI.ScreenSize().height/4
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
        local a=KillBoxTable[i]:Get().a
        if a>0 then
            if a-FadeOutNum>0 then
                KillBoxTable[i]:Set({a=a-FadeOutNum})
            else
                KillBoxTable[i]:Set({a=0})
            end
        end
    end
end
function ShowKill()
    if LastKillTime==0 then
        LastKillTime=UITime
    else
        if UITime-LastKillTime<5 then
            if MultiKill>3 then
                
            else
                MultiKill=MultiKill+1
            end
        else
            MultiKill=1
        end
        LastKillTime=UITime
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