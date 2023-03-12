print("UIsignalreceiver".."已加载")
--In UI Module
function UI.Event.OnSignal(player,signal)
    if signal==1 then
        ShowKill()
    end
end