print("uiupdate".."已加载")
--In UI Module
UITime=0
local LastTime=0
function UI.Event:OnUpdate(time)
    UITime=time
    if time-LastTime>0.1 then
        UpdateRefreshKillIcon()
        UI.Signal(999)
        LastTime=time
    end
end