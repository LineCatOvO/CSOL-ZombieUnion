function Game.Rule:OnKilled (victim, killer)
    print("Get33232")
    killer:Signal(ShowKillIconSignal)
end