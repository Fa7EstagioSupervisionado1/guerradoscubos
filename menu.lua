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
-- Logo abaixo indicaremos para onde serão apontados os links Start Game e Credits

local function buttonHit(event)
	storyboard.gotoScene (  event.target.destination, {effect = "flipFadeOutIn"} )
	return true
end


function scene:createScene( event )
	local group = self.view

	-- Criando objetos e adicionando-os ao "grupo", indicaremos para onde serão apontados os links de cada um deles.
	
	background = display.newImage("imagens/bgmenu.jpg")	
	group:insert(background)

	--btnMenu = display.newImage('imagens/btmenu.png', 30, 195, 0, 0)
	--btnPlay = display.newImage('imagens/btiniciar.png', 30, 295, 0, 0)
	
	local playBtn = display.newImage('imagens/btiniciar.png')--display.newText(  "Inicio", 0, 0, "Helvetica", 30 )
	--playBtn:setFillColor(0,0,0)
	playBtn.x = display.screenOriginX + 235
	playBtn.y = display.screenOriginY + 190
	playBtn.destination = "play" 
	playBtn:addEventListener("tap", buttonHit)
	group:insert(playBtn)
	
	local creditsBtn = display.newImage('imagens/btcreditos.png')
	--creditsBtn:setFillColor(0,0,0)
	creditsBtn.x = display.screenOriginX + 235
	creditsBtn.y = display.screenOriginY + 245
	creditsBtn.destination = "creditos" 
	creditsBtn:addEventListener("tap", buttonHit)
	group:insert (creditsBtn)

	--[[local directionsBtn = display.newText(  "Instrução", 0, 0, "Helvetica", 30 )
	directionsBtn:setFillColor(0,0,0)
	directionsBtn.x = display.screenOriginX + 240
	directionsBtn.y = display.screenOriginY + 280
	directionsBtn.destination = "gamecredits" 
	directionsBtn:addEventListener("tap", buttonHit)
	group:insert (directionsBtn)]]--
	
end


-- Chamada imediata após a mudança de tela
function scene:enterScene( event )
	local group = self.view
	storyboard.removeScene('gameover')

-- nesse trecho é inserido os códigos de áudio, tempo, scores, etc..

end


-- Chamado quando a cena está prestes a se mover fora da tela:
function scene:exitScene( event )
	local group = self.view
	audio.stop()
	-- Insere aqui os códigos para parar os eventos de áudio, tempo, scores, etc..

end


-- chamado para remoção da tela
function scene:destroyScene( event )
	local group = self.view

-- Insere aqui os códigos para remover os listeners, widgets, salvar o status, etc..

end



-- Evento "createScene" é despachado se a visão de cena não existe.
scene:addEventListener( "createScene", scene )

-- Evento "enterScene" é despachado sempre que transição de cena terminar.
scene:addEventListener( "enterScene", scene )

-- Evento "exitScene" é despachado antes da transição da cena seguinte começar.
scene:addEventListener( "exitScene", scene )

-- Evento "destroyScene" é despachado antes vista é descarregado, o que pode ser 
-- descarregadas automaticamente em situações de pouca memória, ou explicitamente através de uma chamada para 
-- Storyboard.purgeScene () ou storyboard.removeScene ().
scene:addEventListener( "destroyScene", scene )


---------------------------------------------------------------------------------

return scene