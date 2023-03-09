print("uiupdate".."已加载")
--In UI Module
UITime=0
function UI.Event:OnUpdate(time)
    UITime=time
    UpdateRefreshKillIcon()
    UI.Signal(999)
end