-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------
local storyboard = require ("storyboard")
storyboard.purgeOnSceneChange = true


display.setStatusBar(display.HiddenStatusBar)

centerX = display.contentCenterX
centerY = display.contentCenterY

-- chama o menu.lua aplicando o efeito de transição
storyboard.gotoScene ( "menu", { effect = "slideDown"} )