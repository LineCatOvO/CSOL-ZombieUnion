--In UI Module
Show1KillIconSignal=19191
Show2KillIconSignal=19192
Show3KillIconSignal=19193
Show4KillIconSignal=19194
--我们假设。。。
local KillBoxTable="512个box"
local Kill1Icon="配置全部box的数据的表"
local Kill2Icon="配置全部box的数据的表"
local Kill3Icon="配置全部box的数据的表"
local Kill4Icon="配置全部box的数据的表"
local FadeOutNum=2--控制Kill图标淡出速度
ShowKillTimePeriod=0
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