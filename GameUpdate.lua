--In Game Module
print("gameupdate" .. "已加载")
function Game.Rule:OnUpdate(time) --此Update来自Game.Rule，每秒刷新约10次
    GameTime = time
end

function Update(player) --此update来自UI.Signal，每秒刷新约100次
    local ttime = GameTime
    if SpawnTime[player.name] == 0 then
        SpawnTime[player.name] = ttime
    end
    if LastTime[player.name] == nil then
        LastTime[player.name] = 0
    end
    if Skill5[player.name] == nil then
        Skill5[player.name] = -1
    end
    if Skill6[player.name] == nil then
        Skill6[player.name] = -1
    end
    if SkillG[player.name] == nil then
        SkillG[player.name] = -1
    end
    Print(player.name .. " 5 技能状态" .. Skill5[player.name], 2)
    Print(player.name .. " 6 技能状态" .. Skill6[player.name], 2)
    Print(player.name .. " G 技能状态" .. SkillG[player.name], 2)
    SkillExpireManager(player)
    UpdateShowSkillByArmor(player)
    UpdateRunSkill5(player)
    EffectUpdater()
    LastTime[player.name] = ttime
end
