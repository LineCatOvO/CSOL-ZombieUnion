print("playerattack".."已加载")
function Game.Rule:OnPlayerAttack (victim, attacker, damage, weapontype, hitbox)
    if attacker==nil then
        if AccidentDamage~=true then
            return 0
        end
    end
    if attacker~=nil then
        print(attacker.name.."攻击了"..victim.name)
        --僵尸伤害削弱为1/2
        if attacker.model~=Game.MODEL.DEFAULT then
            damage=damage/2
        end
        --对自己伤害无效
        if attacker==victim then
            if SelfDamage==false then--设置自己伤害自己
                return 0 end--自己对自己伤害无效
        end
        --开6的数值实现部分
        if attacker.model==Game.MODEL.DEFAULT and IfSkillActive(6,attacker) then
            Print(attacker.name.."的6造成伤害"..damage*3)
                damage=damage*3--开6的数值实现部分
        end
        --拦截新版击杀图标
        
        if FindEntityByName(victim.name).health-damage>0 then

        else
            victim:kill()
            victim:kill()
            attacker:Signal(ShowKillIconSignal)
            damage=0
        end
    end
    a,b=math.modf(damage)
    FindEntityByName(attacker.name).maxarmor=(1000+a)
    return a
end
