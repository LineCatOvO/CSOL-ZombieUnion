Print("gamesignalreceiver" .. "已加载", 0)
--[[
Game的信号表
999:Update函数用
666:自杀
1~20(不包含5、6):选择僵尸
5:开5技能
6:开6技能
21:开G技能
]]
--
function Game.Rule:OnPlayerSignal(player, signal)
    if signal == 114514 then
        Print("GETchou", 2)
        Print(signal, 2)
        player:Signal(1)
    end
    if signal == 999 then
        Update(player)
    end
    if signal == 666 then
        player:Kill()
        player:Kill()
    end
    if IfCanChooseCharacter(player) then
        if signal == 1 then
            player.model = Game.MODEL.DEFAULT
            player.model = Game.MODEL.DEFAULT
            FindEntityByName(player.name).health = 400
            FindEntityByName(player.name).maxhealth = 400
            player:ShowBuymenu()
            ResetSkillGCoolDown(player)
        elseif signal == 2 then
            player.model = Game.MODEL.NORMAL_ZOMBIE
            FindEntityByName(player.name).health = 2500
            FindEntityByName(player.name).maxhealth = 2500
            ResetSkillGCoolDown(player)
        elseif signal == 3 then
            player.model = Game.MODEL.LIGHT_ZOMBIE
            FindEntityByName(player.name).health = 1300
            FindEntityByName(player.name).maxhealth = 1300
            ResetSkillGCoolDown(player)
        elseif signal == 4 then
            player.model = Game.MODEL.HEAVY_ZOMBIE
            FindEntityByName(player.name).health = 3500
            FindEntityByName(player.name).maxhealth = 3500
            ResetSkillGCoolDown(player)
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
            FindEntityByName(player.name).maxhealth=3000]]
            --
        end
    end
    if signal == 5 then
        Print(player.name .. "使用了5", 1)
        if player.model == Game.MODEL.DEFAULT then
            PerformSkill(5, player)
        end
    elseif signal == 6 then
        if player.model == Game.MODEL.DEFAULT then
            PerformSkill(6, player)
        end
    elseif signal == 21 then
        if player.model ~= Game.MODEL.DEFAULT then
            PerformSkill(G, player)
        end
    elseif signal == 300 then
        Print("added", 0)
        AttachEffect("Add", "ChangeSpeed", "LineCatOvO", {
            effect = "ChangeSpeed",
            tag = "5技能",
            speed = 1.3,
            priority = 1,
            allowOverride = 0,
            time = 15,
            allowMulti = true,
            finishCallBack =
                function()
                    AttachEffect("Add", "ChangeSpeed", "LineCatOvO", {
                        effect = "ChangeSpeed",
                        tag = "5技能反作用",
                        speed = 0.6,
                        priority = 2,
                        allowOverride = 0,
                        time = 4,
                        allowMulti = true,
                        startCallBack = nil,
                        finishCallBack = nil
                    })
                end
        })
    end
end
