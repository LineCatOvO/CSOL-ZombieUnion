--In GameUpcate
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
    SkillExpireManager(player)
    -- if Skill5[player.name] == nil then
    --     Skill5[player.name] = -1
    -- end
    -- if Skill6[player.name] == nil then
    --     Skill6[player.name] = -1
    -- end
    -- if SkillG[player.name] == nil then
    --     SkillG[player.name] = -1
    -- end
    Print(player.name .. " 技能状态", 2)
    Print(Skill5[player.name] .. " " .. Skill6[player.name] .. " " .. SkillG[player.name], 2)
    UpdateShowSkillByArmor(player)
    EffectUpdater()
    LastTime[player.name] = ttime
end
