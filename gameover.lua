-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------
local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

local background
local btnMenu
local btnPlay
local lose

local function onMenuBtnRelease()
	storyboard.gotoScene ( "menu")
	
	return true	
end

local function onPlayBtnRelease()
	storyboard.gotoScene ( "play" )
	
	return true	
end


local backgroundMusic = audio.loadStream("sound/Menu.mp3")
local backgroundMusicChannel = audio.play( backgroundMusic, { channel=1, loops=-1, fadein=5000 }  )

--local function buttonHit(event)
--	storyboard.gotoScene (  event.target.destination, {effect = "flipFadeOutIn"} )
--	return true
--end

function scene:createScene( event )
	local group = self.view

	background = display.newImage("imagens/bgmenu.jpg")	
	--group:insert(background)

	local params = event.params
	
	lose = display.newText("Pontuação: " .. params.pontuacao, 55, 230, nil, 32)
	lose:setTextColor(0,0,0)

	btnMenu = display.newImage('imagens/btmenu.png')
	btnMenu.x = display.screenOriginX + 230
	btnMenu.y = display.screenOriginY + 330

	btnPlay = display.newImage('imagens/btiniciar.png')
	btnPlay.x = display.screenOriginX + 230
	btnPlay.y = display.screenOriginY + 395
	
	btnMenu:addEventListener('tap', onMenuBtnRelease)
	btnPlay:addEventListener('tap', onPlayBtnRelease)
	
	--group:insert( background )
	--group:insert( btnEntrar )
	--group:insert( btnRestart )
	
end

function scene:enterScene( event )
	local group = self.view
	storyboard.removeScene('play')
end

function scene:exitScene( event )
	local group = self.view
	lose:removeSelf()
	background:removeSelf()
	btnMenu:removeSelf()
	btnPlay:removeSelf()
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