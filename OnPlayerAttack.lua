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
        if attacker.model~=Game.MODEL.DEFAULT then
            finaldamage=finaldamage/4
        end
        local a,b =math.modf(damage)
        if attacker==victim then
            if SelfDamage==false then--设置自己伤害自己
                return 0 end--自己对自己伤害无效
            end
        if attacker.model==Game.MODEL.DEFAULT and IfSkillActive(6,attacker) then
            a,b =math.modf(damage)
            Print(attacker.name.."的6造成伤害"..damage)
                finaldamage=finaldamage*3--开6的数值实现部分
        end
        if FindEntityByName(victim.name).health-finaldamage>0 then
            FindEntityByName(attacker.name).maxarmor=(1000+finaldamage)
            return finaldamage
        else
            FindEntityByName(victim.name).health=0
            attacker:Signal(ShowKillIconSignal)
            Print("Get2233")
            finaldamage=0
        end
    end
    return finaldamage
end
