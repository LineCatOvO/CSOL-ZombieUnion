-- 生化盟战Lua脚本（In Development）

--Author：LineCatOvO
print("game" .. "已加载")
AuthorDebug = false         --DEBUG模式开关，开启则输出控制台信息
Game.Rule.breakable = false --地图是否可破坏
SelfDamage = false          --对自己的伤害是否有效
AccidentDamage = false      --是否计算意外伤害
CircleDamage = "CircleDamage"
GroupHealthRestore = "HealthRestore"
ShockWave = "ShockWave"
WantChange = false
TimeExpired = false
Skill5Time = 15         --5技能持续时间
Skill5BadTime = 4       --5技能DEBUFF时间
Skill6Time = 10         --6技能时间
Skill5CoolDownTime = 45 --5技能冷却时间
Skill6CoolDownTime = 60 --6技能冷却时间
SkillGCoolDownTime = {} --各个僵尸的技能冷却时间表
SkillGCoolDownTime[Game.MODEL.NORMAL_ZOMBIE] = 15
SkillGCoolDownTime[Game.MODEL.LIGHT_ZOMBIE] = 30
SkillGCoolDownTime[Game.MODEL.HEAVY_ZOMBIE] = 30
SkillGTime[Game.MODEL.NORMAL_ZOMBIE] = 8
SkillGTime[Game.MODEL.LIGHT_ZOMBIE] = 8
SkillGTime[Game.MODEL.HEAVY_ZOMBIE] = 0

--玩家信息集合(一般格式为:时间/玩家名)
SkillGTime = {}      --各个僵尸的技能持续时间表
SpawnTime = {}       --各个玩家的重生时间刻
LastTime = {}        --上一次Update结束时间
Skill5 = {}          --5技能时间刻(时间/玩家名)
Skill6 = {}          --6技能时间刻(时间/玩家名)
SkillG = {}          --G技能时间刻(时间/玩家名)
Skill5StartTime = {} --5技能开始时间(时间/玩家名)
Skill6StartTime = {} --6技能开始时间(时间/玩家名)
SkillGStartTime = {} --7技能开始时间(时间/玩家名)

GameTime = 0         --当前游戏时间
TDM = Game.Rule
TDM.name = "團隊死鬥"
TDM.desc = "使用Lua制作的團隊死鬥模式"
--文字表
G = "G"
DamageEnhance = "DamageEnhance"
SpeedBoost = "SpeedBoost"


--To do:使用统一的表（PlayerEffectList）和方法(AttachEffect),将移速更改和禁止移动整合到一起
PlayerEffectList = {}
function AttachEffect(effect, player, effectInfo)
    function checkAvaliable(e, info) --effect,effectInfo,检查信息是否无误，是否无冲突
        local functionTable = {
            ["ChangeSpeed"] = function()
                if (PlayerEffectList[player.name] and PlayerEffectList[player.name].effect == "ChangeSpeed")
                then
                    if (PlayerEffectList[player.name].allowOverride)
                    then
                        return false
                    end
                end
            end,
            ["TrapPlayer"] = function()

            end
        }
        return true
    end

    function AddEffectRequest(e, p, info) --effect,player,effectInfo
        local functionTable = {
            ["ChangeSpeed"] = function()
                --speed,allowOverride,effect,time
                --speed：限制范围
                --allowOverride：0：禁止；1：允许；2：允许更高；3：允许更低；
                --effect：效果名字，是什么照着写就行
                --time：>=0：正常计算时长；-1：无限时长
            end,
            ["TrapPlayer"] = function()

            end
        }
    end

    local functionTable = {
        ["ChangeSpeed"] = function()
            --先检查信息是否无误，是否无冲突，整合进checkAvaliable
            if (checkAvaliable(effect, effectInfo)) then
                AddEffectRequest(effect, player, effectInfo)
            end
        end,
        ["TrapPlayer"] = function()

        end
    }
end

SpeedList = {}
function ChangeSpeed(player, speed, time, reset) --申请移速更改（僵尸不能改移速，这个基本废了）
    if SpeedList[player.name] ~= nil then
        Print("错误！有多个速度改变函数出现了并行！本次加速" .. speed .. "持续" .. time .. "秒已停止")
        return
    else
        SpeedList[player.name] = {
            speed = speed,
            time = time,
            reset = reset
        }
    end
end

function UpdateChangeSpeed(player) --实时刷新玩家速度的函数
    if SpeedList[player.name] ~= nil then
        if SpeedList[player.name].speed ~= -1 then
            if SpeedList[player.name].time ~= 0 then
                if SkillG[player.name] < SpeedList[player.name].time then
                    player.maxspeed = SpeedList[player.name].speed
                else
                    if SpeedList[player.name].reset then
                        player.maxspeed = 1
                    end
                    SpeedList[player.name] = nil
                    return
                end
            else
                player.maxspeed = SpeedList[player.name].speed
                if SpeedList[player.name].reset then
                    player.maxspeed = 1
                end
                SpeedList[player.name] = nil
                return
            end
        end
    end
end

TrapList = {} --“鬼手”技能对象列表
function Trap(Me)
    --使用鬼手技能的函数（大肥：拉个最近的人直接出鬼手，锁他三秒）
    local NearestPlayer = Game.Player:Create(1) --存储最近的玩家的变量
    if NearestPlayer == Me then                 --如果这个玩家是自己
        NearestPlayer = Game.Player:Create(2)   --那就换一个
    end
    for i = 1, 24 do                            --标准的遍历比较
        local player = Game.Player:Create(i)    --选一个人
        if player ~= player and player ~= nil then
            local NowDistance =                 --目前的最近距离
                ((NearestPlayer.position.x - Me.position.x) ^ 2
                    + (NearestPlayer.position.y - Me.position.y) ^ 2
                    + (NearestPlayer.position.z - Me.position.z) ^ 2) ^ 0.5
            local SelectedDistance = --选中的人的距离
                ((player.position.x - Me.position.x) ^ 2
                    + (player.position.y - Me.position.y) ^ 2
                    + (player.position.z - Me.position.z) ^ 2) ^ 0.5
            if NowDistance > SelectedDistance then --如果新的比旧的近
                NearestPlayer = player             --把选择的玩家换成新的
            end                                    --最后就能遍历出最近的玩家了
        end
    end
    if NearestPlayer == nil or (((NearestPlayer.position.x - Me.position.x) ^ 2
            + (NearestPlayer.position.y - Me.position.y) ^ 2
            + (NearestPlayer.position.z - Me.position.z) ^ 2) ^ 0.5) > 13 then
        return false
    end --距离超过13则不工作
    --把最近的人困住五秒
    SkillG[Me.name] = 0
    SkillGStartTime[Me.name] = GameTime
    TrapList[Me.name] = {                 --Me是执行者
        victimname = NearestPlayer.name,  --victim是受害者
        time = 5,
        position = NearestPlayer.position --离得最近的倒霉蛋的位置
    }
    return true
end

function UpdateTrapPlayer(player)
    if TrapList[player.name] ~= nil then
        local victim = FindEntityByName(TrapList[player.name].victimname)
        Print(victim:ToPlayer().name .. "233")
        if SkillG[player.name] < TrapList[player.name].time and IfSkillActive(G, player) and FindEntityByName(player.name).health > 0 then
            Print(victim:ToPlayer().name)
            victim:ToPlayer().maxspeed = 0.01;
        else
            TrapList[player.name] = nil
            victim:ToPlayer().maxspeed = 1.0;
            return
        end
    end
end

InvisibleList = {}
function BeInvisible(player, time) --玩家隐身技能函数
    if InvisibleList[player.name] ~= nil then
        Print("错误！有多个隐身函数出现了并行！已停止")
        return
    else
        InvisibleList[player.name] = {
            time = time
        }
    end
end

function UpdateInvisible(player)
    if InvisibleList[player.name] ~= nil then
        if InvisibleList[player.name].time ~= 0 then
            if SkillG[player.name] < InvisibleList[player.name].time and SkillG[player.name] ~= -1 then
                player:SetRenderFX(18)
            else
                player:SetRenderFX(Game.RENDERFX.NONE)
                InvisibleList[player.name] = nil
                return
            end
        end
    end
end

function ZombieSpeedBoost(player)
    ChangeSpeed(player, 1.3, 10, true)
end

function LightZombieSpeedBoost(player)
    ChangeSpeed(player, 3, 10, true)
end

-- 目標分數
local MaxKill = Game.SyncValue.Create("MaxKill")
MaxKill.value = 50

-- 團隊分數
local Score = {}
Score[Game.TEAM.CT] = Game.SyncValue.Create("ScoreCT")
Score[Game.TEAM.CT].value = 0
Score[Game.TEAM.TR] = Game.SyncValue.Create("ScoreTR")
Score[Game.TEAM.TR].value = 0


function UpdateRunSkill5(player) --开5的实现函数
    if player.model == Game.MODEL.DEFAULT then
        if IfSkillActive(5, player) then
            player.maxspeed = 1.3
        elseif Skill5[player.name] ~= nil then
            if Skill5[player.name] > Skill5Time and Skill5[player.name] < Skill5Time + Skill5BadTime then
                player.maxspeed = 0.6
            else
                player.maxspeed = 1
            end
        end
    end
end

function UpdateRunSkill6(player) --开6的实现函数
    if player.model == Game.MODEL.DEFAULT then
        if IfSkillActive(6, player) then
            Active6 = true
        else
            Active6 = false
        end
    end
end

function Print(text)
    if AuthorDebug == true then
        print(text)
    end
end

function PerformSkill(skill, player)
    if player ~= nil then
        if skill == 5 then
            Print(player.name .. "尝试激活5")
            if Skill5[player.name] == -1 then
                Skill5[player.name] = 0
                Skill5StartTime[player.name] = GameTime
            end
        elseif skill == 6 then
            if Skill6[player.name] == -1 then
                Skill6[player.name] = 0
                Skill6StartTime[player.name] = GameTime
            end
        elseif skill == G then
            if SkillG[player.name] == -1 then
                if player.model == Game.MODEL.LIGHT_ZOMBIE then
                    BeInvisible(player, 8)
                    SkillG[player.name] = 0
                    SkillGStartTime[player.name] = GameTime
                elseif player.model == Game.MODEL.NORMAL_ZOMBIE then
                    ZombieSpeedBoost(player)
                    SkillG[player.name] = 0
                    SkillGStartTime[player.name] = GameTime
                elseif player.model == Game.MODEL.HEAVY_ZOMBIE then
                    Trap(player)
                    --Trap内置skillG时间重置为0,这里就不需要写了
                end
            end
        end
    end
end

function IfSkillActive(skill, player) --返回技能是否有效
    if player ~= nil then
        if skill == 5 and Skill5[player.name] ~= nil then
            if Skill5[player.name] ~= -1 and Skill5[player.name] < Skill5Time then
                Print(player.name .. "的5已激活")

                return true
            else
                return false
            end
        elseif skill == 6 and Skill6[player.name] ~= nil then
            if Skill6[player.name] ~= -1 and Skill6[player.name] < Skill6Time then
                Print(player.name .. "的6已激活")
                return true
            else
                return false
            end
        elseif skill == G and SkillG[player.name] ~= nil then
            if SkillG[player.name] ~= -1 and SkillG[player.name] < SkillGTime[player.model] then
                return true
            else
                return false
            end
        end
    end
end

function UpdateShowSkillByArmor(player)
    if player ~= nil then
        local active = 9
        local ready5 = 5
        local ready6 = 6
        local readyG = 7
        local notready = 1
        local FirstStatus = 0
        local SecondStatus = 0
        local ThirdStatus = 0
        if player.model == Game.MODEL.DEFAULT then
            if Skill5[player.name] == -1 then
                FirstStatus = ready5
            elseif IfSkillActive(5, player) then
                FirstStatus = active
            else
                local percentage, fl = math.modf((ready5 - notready) * (Skill5[player.name] - Skill5Time) /
                    (Skill5CoolDownTime))
                FirstStatus = notready + percentage
            end
            if Skill6[player.name] == -1 then
                SecondStatus = ready6
            elseif IfSkillActive(6, player) then
                SecondStatus = active
            else
                local percentage, fl = math.modf((ready6 - notready) * (Skill6[player.name] - Skill6Time) /
                    (Skill6CoolDownTime))
                SecondStatus = notready + percentage
            end
            --[[else
                if SkillGList[player.name]==-1 then
                    FirstStatus=readyG
                elseif IfSkillActive(player,G) then
                    FirstStatus=active
                else
                    FirstStatus=notready
                end]]
            --
        else
            if SkillG[player.name] == -1 then
                FirstStatus = readyG
            else
                local percentage, fl = math.modf((readyG - notready) * (SkillG[player.name]) /
                    (SkillGCoolDownTime[player.model]))
                FirstStatus = notready + percentage
            end
        end
        if IfCanChooseCharacter(player) then
            ThirdStatus = 1
        else
            ThirdStatus = 0
        end
        player.armor = FirstStatus * 100 + SecondStatus * 10 + ThirdStatus
    end
end

function ResetSkillGCoolDown(player)
    SkillG[player.name] = -1
end

function SkillExpireManager(player)
    if Skill5[player.name] == nil then
        Skill5[player.name] = -1
    end
    if Skill6[player.name] == nil then
        Skill6[player.name] = -1
    end
    if SkillG[player.name] == nil then
        SkillG[player.name] = -1
    end
    if Skill5[player.name] ~= -1 then
        Skill5[player.name] = GameTime - Skill5StartTime[player.name]
        if Skill5[player.name] < Skill5Time then
            FindEntityByName(player.name):SetRenderFX(Game.RENDERFX.GLOWSHELL)
            FindEntityByName(player.name):SetRenderColor({ r = 255, g = 255, b = 0 })
        else
            FindEntityByName(player.name):SetRenderFX(Game.RENDERFX.NONE)
            FindEntityByName(player.name):SetRenderColor({ r = 255, g = 255, b = 255 })
        end
        if Skill5[player.name] > Skill5Time + Skill5CoolDownTime then
            Skill5[player.name] = -1
        end
    end
    if Skill6[player.name] ~= -1 then
        Skill6[player.name] = GameTime - Skill6StartTime[player.name]
        if Skill6[player.name] < Skill6Time then
            FindEntityByName(player.name):SetRenderFX(Game.RENDERFX.GLOWSHELL)
            FindEntityByName(player.name):SetRenderColor({ r = 255, g = 255, b = 0 })
        else
            FindEntityByName(player.name):SetRenderFX(Game.RENDERFX.NONE)
            FindEntityByName(player.name):SetRenderColor({ r = 255, g = 255, b = 255 })
        end
        if Skill6[player.name] > Skill6Time + Skill6CoolDownTime then
            Skill6[player.name] = -1
        end
    end
    if SkillG[player.name] ~= -1 then
        SkillG[player.name] = GameTime - SkillGStartTime[player.name]
        if SkillG[player.name] > SkillGCoolDownTime[player.model] then
            SkillG[player.name] = -1
        end
    end
end

function FindEntityByName(name)
    for i = 1, 512 do
        local ent = Game.GetEntity(i)
        if ent:IsPlayer() then
            local player = ent:ToPlayer()
            if player.name == name then
                return ent
            end
        end
    end
end

function IfCanChooseCharacter(player)
    if SpawnTime[player.name] == nil then
        SpawnTime[player.name] = 0
    end
    if GameTime - SpawnTime[player.name] < 5 then
        return true
    else
        return false
    end
end

function TDM:OnPlayerSpawn(player)
    ResetSkillGCoolDown(player)
    SpawnTime[player.name] = GameTime
    if LastTime[player.name] == nil then
        LastTime[player.name] = 0
    end
    if SpawnTime[player.name] == nil then
        SpawnTime[player.name] = 0
    end
    player.maxarmor = 1000
    if player.model == Game.MODEL.DEFAULT then
        FindEntityByName(player.name).health = 400
        FindEntityByName(player.name).maxhealth = 400
        player:ShowBuymenu()
    end
end

function Game.Rule:OnPlayerJoiningSpawn(player)
    ResetSkillGCoolDown(player)
    if LastTime[player.name] == nil then
        LastTime[player.name] = 0
    end
    player.maxarmor = 1000
    SpawnTime[player.name] = GameTime
end

function TDM:OnPlayerKilled(victim, killer)
    -- 自殺或墜落死亡等
    -- 给擊殺的玩家團隊1分
    local killer_team
    local point
    if victim.team == Game.TEAM.CT then
        point = Score[Game.TEAM.TR]
        killer_team = Game.TEAM.TR
    else
        point = Score[Game.TEAM.CT]
        killer_team = Game.TEAM.CT
    end
    point.value = point.value + 1

    -- 超過目標獲得勝利！
    if (point.value >= MaxKill.value) then
        self:Win(killer_team)
    end
end
