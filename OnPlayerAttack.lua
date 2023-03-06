function Game.Rule:OnPlayerAttack (victim, attacker, damage, weapontype, hitbox)
    if attacker==nil then
        if AccidentDamage~=true then
            return 0
        end
    end
    if attacker~=nil then
        print(attacker.name.."攻击了"..victim.name)
        if attacker.model~=Game.MODEL.DEFAULT then
            return damage/4
        end
        local a,b =math.modf(damage)
        if attacker==victim then
            if SelfDamage==false then--设置自己伤害自己
                return 0 end--自己对自己伤害无效
            end
        if attacker.model==Game.MODEL.DEFAULT and IfSkillActive(6,attacker) then
            a,b =math.modf(damage)
            Print(attacker.name.."的6造成伤害"..damage)
            FindEntityByName(attacker.name).maxarmor=(1000+a*3)
                return damage*3--开6的数值实现部分
        end
        FindEntityByName(attacker.name).maxarmor=(1000+a)
    end
end
