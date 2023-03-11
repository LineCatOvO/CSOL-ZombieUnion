---@diagnostic disable: lowercase-global
-- 團隊死鬥Lua示範(界面)
print("ui".."已加载")
-- 在伺服器中進行同步的分數變量
ScoreCT = UI.SyncValue.Create("ScoreCT")
ScoreTR = UI.SyncValue.Create("ScoreTR")
MaxKill = UI.SyncValue.Create("MaxKill")
MS= UI.SyncValue.Create("MS")


-- 生成計分板
screen = UI.ScreenSize()
center = {x = screen.width / 2, y = screen.height / 2}

scoreBG = UI.Box.Create()
scoreBG:Set({x = center.x - 100, y = 0, width = 200, height = 50, r = 255, g = 255, b = 255, a = 150})

goalBG = UI.Box.Create()
goalBG:Set({x = center.x - 50, y = 0, width = 100, height = 50, r = 40, g = 40, b = 40, a = 150})

goalLabel = UI.Text.Create()
goalLabel:Set({text='00', font='large', align='center', x = center.x - 50, y = 10, width = 100, height = 50, r = 80, g = 255, b = 80})

ctLabel = UI.Text.Create()
ctLabel:Set({text='00', font='medium', align='left', x = center.x - 95, y = 20, width = 50, height = 50, r = 80, g = 80, b = 255})

trLabel = UI.Text.Create()
trLabel:Set({text='00', font='medium', align='right', x = center.x + 45, y = 20, width = 50, height = 50, r = 255, g = 80, b = 80})

-- 每當同步變量時更新計分板
function ScoreCT:OnSync()
    local str = string.format("%02d", self.value)
    ctLabel:Set({text = str})
end

function ScoreTR:OnSync()
    local str = string.format("%02d", self.value)
    trLabel:Set({text = str})
end

function MaxKill:OnSync()
    local str = string.format("%02d", self.value)
    goalLabel:Set({text = str})
end

function UI.Event:OnChat(inputs)
    if inputs=="kill" then
        UI.Signal(666)
    end
    if inputs=="finish" then
        UI.Signal(9999)
    end
    if inputs=="test" then
        print("Star")
        UI.Signal(114514)
    end
end

--按下数字键时发送信号
function UI.Event:OnInput(inputs)
    if inputs[UI.KEY.L] == true then
        if inputs[UI.KEY.NUM1] == true then
            UI.Signal(1)
        elseif inputs[UI.KEY.NUM2] == true then
            UI.Signal(2)
        elseif inputs[UI.KEY.NUM3] == true then
            UI.Signal(3)
        elseif inputs[UI.KEY.NUM4] == true then
            UI.Signal(4)
        elseif inputs[UI.KEY.NUM7] == true then
            UI.Signal(7)
        elseif inputs[UI.KEY.NUM8] == true then
            UI.Signal(8)
        elseif inputs[UI.KEY.NUM9] == true then
            UI.Signal(9)
        elseif inputs[UI.KEY.NUM0] == true then
            UI.Signal(0)
        elseif inputs[UI.KEY.Q] == true then
            UI.Signal(11)
        elseif inputs[UI.KEY.W] == true then
            UI.Signal(12)
        elseif inputs[UI.KEY.E] == true then
            UI.Signal(13)
        elseif inputs[UI.KEY.R] == true then
            UI.Signal(14)
        elseif inputs[UI.KEY.U] == true then
            UI.Signal(15)
        elseif inputs[UI.KEY.I] == true then
            UI.Signal(16)
        elseif inputs[UI.KEY.O] == true then
            UI.Signal(17)
        elseif inputs[UI.KEY.P] == true then
            UI.Signal(18)
        elseif inputs[UI.KEY.J] == true then
            UI.Signal(19)
        elseif inputs[UI.KEY.K] == true then
            UI.Signal(20)
        end
    elseif inputs[UI.KEY.NUM5] == true then
        UI.Signal(5)
    elseif inputs[UI.KEY.NUM6] == true then
        UI.Signal(6)
    elseif inputs[UI.KEY.G] == true then
        UI.Signal(21)
    end
end