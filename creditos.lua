-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------
local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

local background

local backgroundMusic = audio.loadStream("sound/Menu.mp3")
local backgroundMusicChannel = audio.play( backgroundMusic, { channel=1, loops=-1, fadein=5000 }  )

local function buttonHit(event)
	storyboard.gotoScene (  event.target.destination, {effect = "flipFadeOutIn"} )
	return true
end


function scene:createScene( event )
	local group = self.view

	background = display.newImage("imagens/bgcreditos.jpg")	
	group:insert(background)

	local backBtn = display.newImage('imagens/btmenu.png')
	backBtn.x = display.screenOriginX + 160
	backBtn.y = display.screenOriginY + 440
	backBtn.destination = "menu" 
	backBtn:addEventListener("tap", buttonHit)
	group:insert(backBtn)
	
end

function scene:enterScene( event )
	local group = self.view

end

function scene:exitScene( event )
	local group = self.view
	audio.stop()

end

function scene:destroyScene( event )
	local group = self.view

end

scene:addEventListener( "createScene", scene )
scene:addEventListener( "enterScene", scene )
scene:addEventListener( "exitScene", scene )
scene:addEventListener( "destroyScene", scene )

---------------------------------------------------------------------------------

return scene