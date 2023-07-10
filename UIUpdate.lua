--[[
Author: LineCatOvO 10994461+linecatovo@user.noreply.gitee.com
Date: 2023-03-07 19:35:47
LastEditors: LineCatOvO 10994461+linecatovo@user.noreply.gitee.com
LastEditTime: 2023-07-11 00:36:16
FilePath: \生化盟战2\UIUpdate.lua
Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
--]]
print("uiupdate" .. "已加载")
--In UI Module
UITime = 0
local LastTime = 0
function UI.Event:OnUpdate(time)
    UITime = time
    if time - LastTime > 0.1 then
        UpdateRefreshKillIcon()
        UI.Signal(999)
        LastTime = time
    end
end
