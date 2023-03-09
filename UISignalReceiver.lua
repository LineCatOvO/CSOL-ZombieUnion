print("UIsignalreceiver".."已加载")
--In UI Module
function UI.Event.OnSignal(player,signal)
    print("get233")
    if signal==1 then
        ShowKill()
    end
end