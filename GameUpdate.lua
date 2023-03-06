function Game.Rule:OnUpdate(time)
    GameTime=time
    if SpawnTime==0 then
        SpawnTime=time
    end
    
end

function Update(player)
    local time=GameTime
    if LastTime[player.name]==nil then
        LastTime[player.name]=0
    end
    if Skill5[player.name]==nil then
        Skill5[player.name]=-1
    end
    if Skill6[player.name]==nil then
        Skill6[player.name]=-1
    end
    if SkillG[player.name]==nil then
        SkillG[player.name]=-1
    end
    Print(player.name.." 5 技能状态"..Skill5[player.name])
    Print(player.name.." 6 技能状态"..Skill6[player.name])
    Print(player.name.." G 技能状态"..SkillG[player.name])
    SkillExpireManager(player)
    UpdateShowSkillByArmor(player)
    UpdateRunSkill5(player)
    UpdateChangeSpeed(player)
    UpdateTrapPlayer(player)
    UpdateInvisible(player)
    LastTime[player.name]=time

end
