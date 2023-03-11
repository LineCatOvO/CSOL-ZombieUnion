print("playerattack".."已加载")
function Game.Rule:OnPlayerAttack (victim, attacker, damage, weapontype, hitbox)
    local finaldamage=damage
    if attacker==nil then
        if AccidentDamage~=true then
            return 0
        end
    end
    if attacker~=nil then
        print(attacker.name.."攻击了"..victim.name)
        --僵尸伤害削弱为1/4
        if attacker.model~=Game.MODEL.DEFAULT then
            finaldamage=finaldamage/4
        end
        --对自己伤害无效
        local a,b =math.modf(damage)
        if attacker==victim then
            if SelfDamage==false then--设置自己伤害自己
                return 0 end--自己对自己伤害无效
        end
        --开6的数值实现部分
        if attacker.model==Game.MODEL.DEFAULT and IfSkillActive(6,attacker) then
            a,b =math.modf(damage)
            Print(attacker.name.."的6造成伤害"..damage)
                finaldamage=finaldamage*3--开6的数值实现部分
        end
        --拦截新版击杀图标
        
        if FindEntityByName(victim.name).health-finaldamage>0 then

        else
            victim:kill()
            victim:kill()
            attacker:Signal(ShowKillIconSignal)
            finaldamage=0
        end
    end
    FindEntityByName(attacker.name).maxarmor=(1000+finaldamage)
    return finaldamage
end
