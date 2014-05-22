-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- >> Transição de Telas << --
local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

----------------------------------------------------------------------------------

-- >> Dimensões de Tela << --
local _W = display.contentWidth
local _H = display.contentHeight

-----------------------------------------------------------------------------------

-- >> Iniciando fisica do jogo << --
local fisica = require("physics")
fisica.start()
fisica.setGravity(0,0)
--fisica.setDrawMode('hybrid')

-----------------------------------------------------------------------------------

-- >> Inicializando variáveis << --
local vidas = 3
local pontuacao = 0
local numTiros = 0
local tirosTable = {}
local cuboTable = {}
local cubo = 0
local maxTirosAge = 1000
local tick = 200
local died = false
local textVidas
local textPontuacao



-------------------------------------------------------------------------------------

-------------- >> BACKGROUND <<----------------

-- >> Som do Background do Play << --
local backgroundMusic = audio.loadStream("sound/Level.mp3")
local backgroundMusicChannel = audio.play( backgroundMusic, {loops= -1}  )

--------------------------------------------------------------------------------

-- >> Exibindo vidas e pontuacao << --
local function newText()
	-- body
	textVidas = display.newText("Vidas: "..vidas, 40, 10, nil, 14)
	textPontuacao = display.newText("Pontuação: "..pontuacao, 40, 30, nil, 14)
	textVidas:setTextColor(0, 0, 0)
	textPontuacao:setTextColor(0, 0, 0)
end		

local  function updateText()
	-- body
	textVidas.text = "Vidas: "..vidas
	textPontuacao.text = "Pontuação: "..pontuacao
end

----------------------------------------------------------------------------------

--[[parede esquerda
local leftWall = display.newRect(0, 0, 1, _H)
leftWall.x = 0
leftWall.y = _H/2
fisica.addBody( leftWall, "static", {density = 1.0, friction = 0.3, bounce = 0.2} )

-- parede direita
local rightWall = display.newRect(0, 0, 1, _H)
rightWall.x = _W
rightWall.y = _H/2
fisica.addBody( rightWall, "static", {density = 1.0, friction = .6, bounce = 0.2} )]]--

----------------------------------------------------------------------------------

-- >> Fisica para arrastar <<--
local function startDrag( event )
	-- body
	local t = event.target
	local phase = event.phase
	if "began" == phase then
		display.getCurrentStage():setFocus(t)
		t.isFocus = true

		--posicão inicial
		t.x0 = event.x - t.x
		t.y0 = event.y - t.y

		--torna o corpo cinemático sem gravidade
		event.target.bodyType = "kinematic"

		--para o movimento atual
		event.target:setLinearVelocity(0,0)
		event.target.angularVelocity = 0

	elseif  t.isFocus then
		if "moved" == phase then
			t.x = event.x - t.x0
			t.y = event.y - t.y0
		elseif "ended" == phase or "cancelled" == phase then
		display.getCurrentStage(): setFocus(nil)
		t.isFocus = false

		--troca o tipo de corpo para dinâmico
		if (not event.target.isPlatform) then
			event.target.bodyType = "dynamic"
		end
	end
end
return true
end

-----------------------------------------------------------------------------------

-- >> Carrega o cubo << --
local function loadCubo()
	-- body
	cubo = cubo +1
	cuboTable[cubo] = display.newImage("imagens/cubo.png", true)
	fisica.addBody(cuboTable[cubo], {density=1, friction=0, bounce=1})
	local whereFrom = math.random(1)
	cuboTable[cubo].myName="cubo"
		if (whereFrom==1) then
			cuboTable[cubo].x = (math.random(display.contentWidth))
			cuboTable[cubo].y = -30
			transition.to(cuboTable[cubo], {x= (math.random(display.contentWidth)), y=(display.contentHeight+100), time = (math.random(9000, 40000))})
		end
end

------------------------------------------------------------------------------------

-- >> Carrega o losango(bonus) << --
local  function loadLosango( ... )
	-- body
	losango = display.newImage("imagens/losango2.png", true)
	fisica.addBody(losango, {density=1, friction=0, bounce=1})
	local whereFrom = math.random(1)
	losango.myName="losango"
		if (whereFrom==1) then
			losango.x = (math.random(display.contentWidth))
			losango.y = -30
			transition.to(losango, {x= (math.random(display.contentWidth)), y=(display.contentHeight+100), time = (math.random(9000, 40000))})
		end
end

------------------------------------------------------------------------------------

-- >> Detecção de colisão << --
local function onCollision(event)
	-- body

	--[[if(event.object1.myName=="barraEsquerda" and event.object2.myName=="startfighter") then

		--died = true
		--startfighter.alpha =0
		return
	end

	if(event.object1.myName=="barraDireita" and event.object2.myName=="startfighter") then

		--died = true
		--startfighter.alpha =0
		return
	end]]--
	
	--Colisão nave/losango
	if (event.object1.myName=="losango" and event.object2.myName=="startfighter") then
		event.object1:removeSelf()
		event.object1.myName=nil		
		pontuacao=pontuacao+100
		
		return
	end
	
	if (event.object1.myName=="startfighter" and event.object2.myName=="losango") then
		event.object2:removeSelf()		
		pontuacao=pontuacao+100
		
		return
	end

	-- Colisão nave/cubo
	if(event.object1.myName=="startfighter" or event.object2.myName=="startfighter") then
		if(died == false) then
			died = true
			if(vidas == 1) then
				media.playEventSound("sound/bomba.mp3")
				event.object1:removeSelf()
				event.object2:removeSelf()
				vidas=vidas -1
				local options =
				{
					effect = "fade",
					time = 400,
					params = {
								pontuacao = pontuacao
							}
			}
				storyboard.gotoScene("gameover", options)
				cleanup()
				--local lose = display.newText("Game Over", 65, 200, nil, 36)
				--lose:setTextColor(0,0,0)
			else
				media.playEventSound("sound/bomba.mp3")
				startfighter.alpha =0
				vidas = vidas-1
				cleanup()
				timer.performWithDelay(2000,weDied,1)
			end
		end
	end
	-- Colisão tiro/cubo
	if ((event.object1.myName=="cubo" and event.object2.myName=="tiros") or (event.object1.myName=="tiros" and event.object2.myName=="cubo")) then
		media.playEventSound("sound/estouro.mp3")
		event.object1:removeSelf()
		event.object1.myName=nil
		event.object2:removeSelf()
		event.object2.myName=nil
		pontuacao=pontuacao+10
	end
	
end

-----------------------------------------------------------------------------------

-- >> Função fireshot cria e rastreia cada um dos tiros disparados pela nave. << --
local function fireshot(event)
	-- body
	numTiros = numTiros+1
	tirosTable[numTiros] = display.newImage("imagens/raio.png")
	fisica.addBody(tirosTable[numTiros], {density=1, friction=0})
	tirosTable[numTiros].isbullet = true
	tirosTable[numTiros].x = startfighter.x
	tirosTable[numTiros].y = startfighter.y -60
	transition.to(tirosTable[numTiros], {y=-80, time=700})
	media.playEventSound("sound/laser.mp3")
	tirosTable[numTiros].myName="tiros"
	tirosTable[numTiros].age=0
end

------------------------------------------------------------------------------------

-- >> Remove da memória <<--
function cleanup( ... )
	-- body
	for i=1, table.getn(cuboTable) do
		if(cuboTable[i].myName~=nil) then
			cuboTable[i]:removeSelf()
			cuboTable[i].myName=nil
		end
	end
	for i=1, table.getn(tirosTable) do
		if(tirosTable[i].myName~=nil) then
			tirosTable[i]:removeSelf()
			tirosTable[i].myName=nil
		end
	end
end

-------------------------------------------------------------------------------------

-- >> Laço do jogo << --
local function gameLoop()
	-- body
	updateText()
	--remove tiros antigos para performace
	for i=1, table.getn(tirosTable) do
		if (tirosTable[i].myName ~= nil and tirosTable[i].age < maxTirosAge) then
			tirosTable[i].age = tirosTable[i].age + tick
			elseif (tirosTable[i].myName ~= nil) then
				tirosTable[i]:removeSelf()
				tirosTable[i].myName=nil
		end
	end
end

-------------------------------------------------------------------------------------

-- >> Inicia jogo << --


function createListeners()
	-- body
	

	startfighter:addEventListener("touch", startDrag)
	startfighter:addEventListener("tap", fireshot)
	Runtime:addEventListener("collision", onCollision)
	Runtime:addEventListener("enterFrame", scrollSky)
	Runtime:addEventListener("touch", toque)
	
	
end
	local timeCreateCubo = 1500
	local timerGameLoop = timer.performWithDelay(tick, gameLoop,0)	
	local timerLoadLosango = timer.performWithDelay(60000, loadLosango,0)
	local timerLoadCubo = timer.performWithDelay(timeCreateCubo, loadCubo,0)
	timer.performWithDelay(9000, function() timeCreateCubo = timeCreateCubo + 1000 end)

function removeListeneres( ... )
	-- body
	startfighter:removeEventListener("touch", startDrag)
	startfighter:removeEventListener("tap", fireshot)
	Runtime:removeEventListener("collision", onCollision)
	Runtime:removeEventListener("enterFrame", scrollSky)
	Runtime:removeEventListener("touch", toque)
	

	timer.cancel(timerGameLoop)
	timerGameLoop = nil

	timer.cancel(timerLoadCubo)
	timerLoadCubo = nil

	timer.cancel(timerLoadLosango)
	timerLoadLosango = nil

end

function scene:createScene( event )
	local group = self.view

	-- >> Criação do  Background<< --
local largura = display.contentWidth;
local altura = display.contentHeight;
local bgHeight = 480
 
local background = display.newImageRect('Imagens/bgplay.png', largura, bgHeight)
background.anchorX = 0
background.anchorY = 0
background.y = display.contentCenterY
background.x = display.contentCenterX

local background1 = display.newImageRect('Imagens/bgplay.png', largura, bgHeight)
background1.anchorX = 0
background1.anchorY = 0
background1.y = background.y + bgHeight
background1.x = display.contentCenterX

local background2 = display.newImageRect('Imagens/bgplay.png', largura, bgHeight)
background2.anchorX = 0
background2.anchorY = 0
background2.y = background1.y + bgHeight
background2.x = display.contentCenterX

-- >> Rolando Fundo Da Tela (Sprite) << --

 local velocidadeBg = 0.8

 function scrollSky(event)
	background.y = background.y + velocidadeBg
	background1.y = background1.y + velocidadeBg
	background2.y = background2.y + velocidadeBg

	if (background.y - bgHeight) > altura then
		background:translate(0, -bgHeight*3)
	end

	if (background1.y - bgHeight) > altura then
		background1:translate(0, -bgHeight*3)
	end

	if (background2.y - bgHeight) > altura then
		background2:translate(0, -bgHeight*3)
	end
 end
	

function toque(evt)
	if evt.phase == "began" then
		velocidadeBg = 12
	end

	if evt.phase == "ended" then
		velocidadeBg = 1
	end
end

-- >> Carregar a nave <<--
local function carregaNave()
	-- body
	startfighter = display.newImage("imagens/nave.png", true)
	startfighter.x = display.contentWidth/2
	startfighter.y = display.contentHeight - 50
	fisica.addBody (startfighter, {density=1.0, friction = 0.3, bounce=0})
	startfighter.myName="startfighter"
end

carregaNave()
newText()

-- >> Remove a nave para posição inicial e faz ela piscar por 2 segundos <<--
function weDied()
	-- piscar a nave
	startfighter.x=display.contentWidth/2
	startfighter.y=display.contentHeight - 50
	transition.to(startfighter, {alpha=1, timer=1500})
	died=false
end

-- >> Barras laterais

--[[local barraEsquerda = display.newRect(0,0,1,_H)
barraEsquerda.myName="barraEsquerda"
local barraDireita = display.newRect(_W-1,0,1,_H)
barraDireita.myName="barraDireita"


barraEsquerda:setFillColor(0, 0, 0)
barraDireita:setFillColor(0, 0, 0)

fisica.addBody( barraEsquerda, 'static')
fisica.addBody( barraDireita, 'static')]]--

	createListeners()

group:insert(background)
group:insert(background1)
group:insert(background2)
--group:insert(barraEsquerda)
--group:insert(barraDireita)
group:insert(startfighter)

--group:insert(newText)
	
end

function scene:enterScene( event )
	local group = self.view
	storyboard.removeScene('gameover')
	storyboard.removeScene('menu')

end

function scene:exitScene( event )
	local group = self.view

	removeListeneres()
	textVidas:removeSelf()
	textPontuacao:removeSelf()
	audio.stop()
end

function scene:destroyScene( event )
	local group = self.view
	
end

scene:addEventListener( "createScene", scene )
scene:addEventListener( "enterScene", scene )
scene:addEventListener( "exitScene", scene )
scene:addEventListener( "destroyScene", scene )

return scene