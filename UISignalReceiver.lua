--In UI Module
function UI.Event.OnSignal(signal)
    if signal==ShowKillIconSignal then
        ShowKill()
    end
end