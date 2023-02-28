-- 團隊死鬥Lua示範(遊戲模式)
MySpeed=Game.SyncValue:Create("MS")
AuthorDebug=false
Game.Rule.breakable=false
local SelfDamage=false
local AccidentDamage=false
local Skill5={}
local Skill6={}
local SkillG={}
local LastTime={}
local GameTime=0
local TDM = Game.Rule
TDM.name = "團隊死鬥"
TDM.desc = "使用Lua制作的團隊死鬥模式"
--僵尸技能表
G="G"
DamageEnhance="DamageEnhance"
SpeedBoost="SpeedBoost"
local SpeedList={}
function ChangeSpeed(player,speed,time,reset)
    if SpeedList[player.name]~=nil then
        Print("错误！有多个速度改变函数出现了并行！本次加速"..speed.."持续"..time.."秒已停止")
        return
    else
        SpeedList[player.name]={
            speed=speed,
            time=time,
            reset=reset
        }
    end
end

function UpdateChangeSpeed(player)
    if SpeedList[player.name]~=nil then
    if SpeedList[player.name].speed~=-1 then
        if SpeedList[player.name].time~=0 then
            if SkillG[player.name]<SpeedList[player.name].time then
                player.maxspeed=SpeedList[player.name].speed
            else
                if SpeedList[player.name].reset then
                    player.maxspeed=1
                end
                SpeedList[player.name]=nil
                return
            end
        else
            player.maxspeed=SpeedList[player.name].speed
            if SpeedList[player.name].reset then
                player.maxspeed=1
            end
            SpeedList[player.name]=nil
            return
        end
    end
end
end
local TrapList={}
function Trap(Me)--大肥：拉个最近的人直接出鬼手，锁他三秒
    local NearestPlayer=Game.Player:Create(1)--存储最近的玩家的变量
    if NearestPlayer==Me then--如果这个玩家是自己
        NearestPlayer=Game.Player:Create(2)--那就换一个
    end
    for i=1,24 do--标准的遍历比较
        local player=Game.Player:Create(i)--选一个人
        if player~=player and player~=nil then
            local NowDistance=--目前的最近距离
            ((NearestPlayer.position.x-player.position.x)^2
            +(NearestPlayer.position.y-player.position.y)^2
            +(NearestPlayer.position.z-player.position.z)^2)^0.5
            local SelectedDistance=--选中的人的距离
            ((player.position.x-player.position.x)^2
            +(player.position.y-player.position.y)^2
            +(player.position.z-player.position.z)^2)^0.5
            if NowDistance>SelectedDistance then--如果新的比旧的近
                NearestPlayer=player--把选择的玩家换成新的
            end--最后就能遍历出最近的玩家了
        end
    end
    if NearestPlayer==nil or (((NearestPlayer.position.x-Me.position.x)^2
    +(NearestPlayer.position.y-Me.position.y)^2
    +(NearestPlayer.position.z-Me.position.z)^2)^0.5)>8 then return false end
    local victimposition=NearestPlayer.position--离得最近的倒霉蛋的位置
    NearestPlayer.position=victimposition--把最近的人困住五秒
    if TrapList[NearestPlayer.name]~=nil then
        TrapList[NearestPlayer.name]={
            playername=NearestPlayer.name,
            time=3,
            position=victimposition
        }
return true
    end
end

function UpdateTrapPlayer(player)
    if TrapList[player.name]~=nil then
        if TrapList[player.name].time~=0 then
            if SkillG[player.name]<TrapList[player.name].time then
                TrapList.player.position.x=TrapList.position.x
            TrapList.player.position.y=TrapList.position.y
            else
                TrapList[player.name]=nil
                return
            end
        else
            TrapList[player.name]=nil
            return
        end
    end
end

local InvisibleList={}
function BeInvisible(player,time)
    if InvisibleList[player.name]~=nil then
        Print("错误！有多个隐身函数出现了并行！已停止")
        return
    else
        InvisibleList[player.name]={
            time=time
        }
    end
end

function UpdateInvisible(player)
    if InvisibleList[player.name]~=nil then
        if InvisibleList[player.name].time~=0 then
            if SkillG[player.name]<InvisibleList[player.name].time and SkillG[player.name]~=-1 then
                player:SetRenderFX(18)
            else
                player:SetRenderFX(Game.RENDERFX.NONE)
                InvisibleList[player.name]=nil
                return
            end
        end
    end
end

function ZombieSpeedBoost(player)
    ChangeSpeed(player,1.3,10,true)
end

function LightZombieSpeedBoost(player)
    ChangeSpeed(player,3,10,true)
end

CircleDamage="CircleDamage"
GroupHealthRestore="HealthRestore"
ShockWave="ShockWave"
local WantChange=false
local TimeExpired=false

SpawnTime=0
Skill5Time=15
Skill5BadTime=4
Skill6Time=10
Skill5CoolDownTime=45
Skill6CoolDownTime=60
SkillGCoolDownTime={}
SkillGCoolDownTime[Game.MODEL.NORMAL_ZOMBIE]=15
SkillGCoolDownTime[Game.MODEL.LIGHT_ZOMBIE]=30
SkillGCoolDownTime[Game.MODEL.HEAVY_ZOMBIE]=30
SkillGTime={}
SkillGTime[Game.MODEL.NORMAL_ZOMBIE]=8
SkillGTime[Game.MODEL.LIGHT_ZOMBIE]=8
SkillGTime[Game.MODEL.HEAVY_ZOMBIE]=0

SkillGList={}
SkillGList[Game.MODEL.NORMAL_ZOMBIE]={}
SkillGList[Game.MODEL.NORMAL_ZOMBIE][G]=ZombieSpeedBoost
SkillGList[Game.MODEL.LIGHT_ZOMBIE]={}
SkillGList[Game.MODEL.LIGHT_ZOMBIE][G]=LightZombieSpeedBoost
SkillGList[Game.MODEL.HEAVY_ZOMBIE]={}
SkillGList[Game.MODEL.HEAVY_ZOMBIE][G]=Trap
SkillGList[Game.MODEL.PHYCHO_ZOMBIE]={}
SkillGList[Game.MODEL.PHYCHO_ZOMBIE][G]=CircleDamage
SkillGList[Game.MODEL.VOODOO_ZOMBIE]={}
SkillGList[Game.MODEL.VOODOO_ZOMBIE][G]=GroupHealthRestore
SkillGList[Game.MODEL.DEIMOS_ZOMBIE]={}
SkillGList[Game.MODEL.DEIMOS_ZOMBIE][G]=ShockWave
SkillGList[Game.MODEL.GANYMEDE_ZOMBIE]={}
SkillGList[Game.MODEL.STAMPER_ZOMBIE]={}
SkillGList[Game.MODEL.BANSHEE_ZOMBIE]={}
SkillGList[Game.MODEL.VENOMGUARD_ZOMBIE]={}
SkillGList[Game.MODEL.STINGFINGER_ZOMBIE]={}
SkillGList[Game.MODEL.METATRON_ZOMBIE]={}
SkillGList[Game.MODEL.LILITH_ZOMBIE]={}
SkillGList[Game.MODEL.CHASER_ZOMBIE]={}
SkillGList[Game.MODEL.BLOTTER_ZOMBIE]={}
SkillGList[Game.MODEL.RUSTYWING_ZOMBIE]={}
SkillGList[Game.MODEL.AKSHA_ZOMBIE]={}
-- 可以破壞地圖
TDM.breakable = true

-- 目標分數
local MaxKill = Game.SyncValue.Create("MaxKill")
MaxKill.value = 50

-- 團隊分數
local Score = {}
Score[Game.TEAM.CT] = Game.SyncValue.Create("ScoreCT")
Score[Game.TEAM.CT].value = 0
Score[Game.TEAM.TR] = Game.SyncValue.Create("ScoreTR")
Score[Game.TEAM.TR].value = 0

function TeamBalance()

end

function Game.Rule:OnPlayerAttack (victim, attacker, damage, weapontype, hitbox)
    if attacker==nil then
        if AccidentDamage~=true then
            return 0
        end
    end
    if attacker~=nil then
        print(attacker.name.."攻击了"..victim.name)
        local a,b =math.modf(damage)
        if attacker==victim then
            if SelfDamage==false then--设置自己伤害自己
                return 0 end--自己对自己伤害无效
            end
        if attacker.model==Game.MODEL.DEFAULT and IfSkillActive(6,attacker) then
            damage=damage*3
            a,b =math.modf(damage)
            Print(attacker.name.."的6造成伤害"..damage)
            FindEntityByName(attacker.name).maxarmor=(1000+a)
                return damage--开6的数值实现部分
        end
        FindEntityByName(attacker.name).maxarmor=(1000+a)
    end
end

function UpdateRunSkill5(player)--开5的实现函数  
    if player.model==Game.MODEL.DEFAULT then
        if IfSkillActive(5,player) then
            player.maxspeed=1.3
        elseif Skill5[player.name]~=nil then
            if Skill5[player.name]>Skill5Time and Skill5[player.name]<Skill5Time+Skill5BadTime then
            player.maxspeed=0.6
        else
            player.maxspeed=1
        end
    end
    end
end

function UpdateRunSkill6(player)--开5的实现函数  
    if player.model==Game.MODEL.DEFAULT then
        if IfSkillActive(6,player) then
            Active6=true
        else
            Active6=false
        end
    end
end

function Print(text)
    if AuthorDebug==true then
    print(text)
    end
end

function PerformSkill(skill,player)
if player~=nil then
        if skill==5 then
            Print(player.name.."尝试激活5")
            if Skill5[player.name]==-1 then
                Skill5[player.name]=0
            end
        elseif skill==6 then
            if Skill6[player.name]==-1 then
                Skill6[player.name]=0
            end
        elseif skill==G then
            if SkillG[player.name]==-1 then
                if player.model==Game.MODEL.LIGHT_ZOMBIE then
                    BeInvisible(player,8)
                    SkillG[player.name]=0
                elseif player.model==Game.MODEL.NORMAL_ZOMBIE then
                    ZombieSpeedBoost(player)
                    SkillG[player.name]=0
                elseif player.model==Game.MODEL.HEAVY_ZOMBIE then
                    if(Trap(player)) then
                        SkillG[player.name]=0
                    end
                end
            end
        end
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

function IfSkillActive(skill,player)
if player~=nil then
    if skill==5 and Skill5[player.name]~=nil then
    if Skill5[player.name]~=-1 and Skill5[player.name]<Skill5Time then
        Print(player.name.."的5已激活")
        
        return true
    else
        
        return false
    end
elseif skill==6 and Skill6[player.name]~=nil then
    if Skill6[player.name]~=-1 and Skill6[player.name]<Skill6Time then
        Print(player.name.."的6已激活")
        return true
    else

        return false
    end
elseif skill==G and SkillG[player.name]~=nil then
    if SkillG[player.name]>0 then
        return true
    end
end
end
end

function UpdateShowSkillByArmor(player)
        if player~=nil then
        local active=9
        local ready5=5
        local ready6=6
        local readyG=7
        local notready=1
        local FirstStatus=0
        local SecondStatus=0
        local ThirdStatus=0
            if player.model==Game.MODEL.DEFAULT then
                if Skill5[player.name]==-1 then
                    FirstStatus=ready5
                elseif IfSkillActive(5,player) then
                    FirstStatus=active
                else
                    local percentage,fl=math.modf((ready5-notready)* (Skill5[player.name]-Skill5Time)/(Skill5CoolDownTime))
                    FirstStatus=notready+percentage
                end
                if Skill6[player.name]==-1 then
                    SecondStatus=ready6
                elseif IfSkillActive(6,player) then
                    SecondStatus=active
                else
                    local percentage,fl=math.modf((ready6-notready)* (Skill6[player.name]-Skill6Time)/(Skill6CoolDownTime))
                    SecondStatus=notready+percentage
                end
            --[[else
                if SkillGList[player.name]==-1 then
                    FirstStatus=readyG
                elseif IfSkillActive(player,G) then
                    FirstStatus=active
                else
                    FirstStatus=notready
                end]]--
            else
                if SkillG[player.name]==-1 then
                    FirstStatus=readyG
                elseif IfSkillActive(G,player) then
                    local percentage,fl=math.modf((readyG-notready)* (SkillG[player.name])/(SkillGCoolDownTime[player.model]))
                    FirstStatus=notready+percentage
                end
            end
            if IfCanChooseCharacter() then
                ThirdStatus=1
            else
                ThirdStatus=0
            end
            player.armor=FirstStatus*100+SecondStatus*10+ThirdStatus
        end
end

function ResetSkillGCoolDown(player)
    SkillG[player.name]=-1
end

function SkillExpireManager(player)
    local TimePeriod=GameTime-LastTime[player.name]
    if Skill5[player.name]==nil then
        Skill5[player.name]=-1
    end
    if Skill6[player.name]==nil then
        Skill6[player.name]=-1
    end
    if SkillG[player.name]==nil then
        SkillG[player.name]=-1
    end
    if Skill5[player.name]~=-1 then
        Skill5[player.name]=Skill5[player.name]+TimePeriod
        if Skill5[player.name]<Skill5Time then
            FindEntityByName(player.name):SetRenderFX(Game.RENDERFX.GLOWSHELL)
            FindEntityByName(player.name):SetRenderColor({r=255,g=255,b=0})
        else
            FindEntityByName(player.name):SetRenderFX(Game.RENDERFX.NONE)
            FindEntityByName(player.name):SetRenderColor({r=255,g=255,b=255})
        end
        if Skill5[player.name]>Skill5Time+Skill5CoolDownTime then
            Skill5[player.name]=-1
        end
    end
    if Skill6[player.name]~=-1 then
        Skill6[player.name]=Skill6[player.name]+TimePeriod
        if Skill6[player.name]<Skill6Time then
            FindEntityByName(player.name):SetRenderFX(Game.RENDERFX.GLOWSHELL)
            FindEntityByName(player.name):SetRenderColor({r=255,g=255,b=0})
        else
            FindEntityByName(player.name):SetRenderFX(Game.RENDERFX.NONE)
            FindEntityByName(player.name):SetRenderColor({r=255,g=255,b=255})
        end
        if Skill6[player.name]>Skill6Time+Skill6CoolDownTime then
            Skill6[player.name]=-1
        end
    end
    if SkillG[player.name]~=-1 then
            SkillG[player.name]=SkillG[player.name]+TimePeriod
        if SkillG[player.name]>SkillGCoolDownTime[player.model] then
            SkillG[player.name]=-1
        end
    end

end

function TDM:OnUpdate(time)
    GameTime=time
    if SpawnTime==0 then
        SpawnTime=time
    end
    
end

function FindEntityByName(name)
for i=1,1024 do
    local ent=Game.GetEntity(i)
    if ent:IsPlayer() then
        local player=ent:ToPlayer()
        if player.name==name then
            return ent
        end
end
end
end

function IfCanChooseCharacter()
    if GameTime-SpawnTime<5 then
        return true
    else
        return false
    end
end

function TDM:OnPlayerSignal(player,signal)
    
    if signal==999 then
        Update(player)
    end
    if signal==666 then
        player:Kill()
        player:Kill()
    end
    if IfCanChooseCharacter() then
        if signal==9999 then
            self:Win(Game.TEAM.CT)
        end
        if signal==1 then
            player.model=Game.MODEL.DEFAULT
            player.model=Game.MODEL.DEFAULT
            FindEntityByName(player.name).health=400
            FindEntityByName(player.name).maxhealth=400
            player:ShowBuymenu()
            ResetSkillGCoolDown()
        elseif signal==2 then
            player.model=Game.MODEL.NORMAL_ZOMBIE
            FindEntityByName(player.name).health=2500
            FindEntityByName(player.name).maxhealth=2500
            ResetSkillGCoolDown()
        elseif signal==3 then
            player.model=Game.MODEL.LIGHT_ZOMBIE
            FindEntityByName(player.name).health=1300
            FindEntityByName(player.name).maxhealth=1300
            ResetSkillGCoolDown()
        elseif signal==4 then
            player.model=Game.MODEL.HEAVY_ZOMBIE
            FindEntityByName(player.name).health=3500
            FindEntityByName(player.name).maxhealth=3500
            ResetSkillGCoolDown()
        --[[elseif signal==19 then
            player.model=Game.MODEL.PHYCHO_ZOMBIE
            FindEntityByName(player.name).health=2000
            FindEntityByName(player.name).maxhealth=2000
        elseif signal==20 then
            player.model=Game.MODEL.VOODOO_ZOMBIE
            FindEntityByName(player.name).health=1500
            FindEntityByName(player.name).maxhealth=1500
        elseif signal==7 then
            player.model=Game.MODEL.DEIMOS_ZOMBIE
            FindEntityByName(player.name).health=3000
            FindEntityByName(player.name).maxhealth=3000
        elseif signal==8 then
            player.model=Game.MODEL.GANYMEDE_ZOMBIE
            FindEntityByName(player.name).health=3000
            FindEntityByName(player.name).maxhealth=3000
        elseif signal==9 then
            player.model=Game.MODEL.STAMPER_ZOMBIE
            FindEntityByName(player.name).health=3000
            FindEntityByName(player.name).maxhealth=3000
        elseif signal==0 then
            player.model=Game.MODEL.BANSHEE_ZOMBIE
            FindEntityByName(player.name).health=3000
            FindEntityByName(player.name).maxhealth=3000
        elseif signal==11 then
            player.model=Game.MODEL.VENOMGUARD_ZOMBIE
            FindEntityByName(player.name).health=3000
            FindEntityByName(player.name).maxhealth=3000
        elseif signal==12 then
            player.model=Game.MODEL.STINGFINGER_ZOMBIE
            FindEntityByName(player.name).health=3000
            FindEntityByName(player.name).maxhealth=3000
        elseif signal==13 then
            player.model=Game.MODEL.METATRON_ZOMBIE
            FindEntityByName(player.name).health=3000
            FindEntityByName(player.name).maxhealth=3000
        elseif signal==14 then
            player.model=Game.MODEL.LILITH_ZOMBIE
            FindEntityByName(player.name).health=3000
            FindEntityByName(player.name).maxhealth=3000
        elseif signal==15 then
            player.model=Game.MODEL.CHASER_ZOMBIE
            FindEntityByName(player.name).health=3000
            FindEntityByName(player.name).maxhealth=3000
        elseif signal==16 then
            player.model=Game.MODEL.BLOTTER_ZOMBIE
            FindEntityByName(player.name).health=3000
            FindEntityByName(player.name).maxhealth=3000
        elseif signal==17 then
            player.model=Game.MODEL.RUSTYWING_ZOMBIE
            FindEntityByName(player.name).health=3000
            FindEntityByName(player.name).maxhealth=3000
        elseif signal==18 then
            player.model=Game.MODEL.AKSHA_ZOMBIE
            FindEntityByName(player.name).health=3000
            FindEntityByName(player.name).maxhealth=3000]]--
        end
    end
    if signal==5 then
        Print(player.name.."使用了5")
        if player.model==Game.MODEL.DEFAULT then
            PerformSkill(5,player)

        end
    elseif signal==6 then
        if player.model==Game.MODEL.DEFAULT then
            PerformSkill(6,player)
        end
    elseif signal==21 then
        if player.model~=Game.MODEL.DEFAULT then
            PerformSkill(G,player)
        end
    end
end

function TDM:OnPlayerSpawn(player)
    ResetSkillGCoolDown(player)
    SpawnTime=GameTime
    if LastTime[player.name]==nil then
        LastTime[player.name]=0
    end
    player.maxarmor=1000
    if player.model==Game.MODEL.DEFAULT then
            FindEntityByName(player.name).health=400
            FindEntityByName(player.name).maxhealth=400
        player:ShowBuymenu()
    end
end
function Game.Rule:OnPlayerJoiningSpawn (player)
    ResetSkillGCoolDown(player)
    if LastTime[player.name]==nil then
        LastTime[player.name]=0
    end
    player.maxarmor=1000
    SpawnTime=GameTime
end

function TDM:OnPlayerKilled(victim, killer)
    -- 自殺或墜落死亡等
    if killer == nil then
        return
    end

    -- 给擊殺的玩家團隊1分
    local killer_team = killer.team
    local point = Score[killer_team]
    point.value = point.value + 1

    -- 超過目標獲得勝利！
    if (point.value >= MaxKill.value) then
        self:Win(killer_team)
    end
end