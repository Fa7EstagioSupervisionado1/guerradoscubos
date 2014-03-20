-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here
--try.github.io tutorial github
--print("altura: ", display.contentHeight)contentWidth
--print("largura: ", display.contentWidth)
local fisica = require("physics")
fisica.start()
fisica.setGravity(0,0)

--Inicializando variáveis
local background = display.newImage("imagens/bg1.png", true)
background.x = display.contentWidth *0.5
background.y = display.contentHeight *0.5
local vidas = 3
local pontuacao = 0
local numTiros = 0
local tirosTable = {}
local retanguloTable = {}
local numRetangulos = 0
local maxTirosAge = 1000
local tick = 200
local died = false

--[[W = display.contentWidth  -- Pega a largura da tela
H = display.contentHeight -- Pega a altura da tela

local line1 = display.newRect( 2, background.y, 3, H-45 ) -- Retangulo lateral da Esquerda
physics.addBody(line1, "static")  -- 'Corpo' do Retangulo da Esquerda

local line2 = display.newRect( W-2, background.y, 3, H-45 ) -- Retangulo lateral da Direita
physics.addBody(line2, "static")  -- 'Corpo' do Retangulo da Direita

chao = display.newRect(0, 500, 650, 50)
chao:setFillColor(0, 0, 0)
fisica.addBody(chao, "static", {friction=1})--]]

--movimento da tela

local baseline = 280

local ceu = display.newImage( "imagens/bg1.png" )
ceu:setReferencePoint( display.CenterLeftReferencePoint )
ceu.x = 0
ceu.y = baseline-115
ceu.xScale = 1.3
ceu.yScale = 1.3

local ceu2 = display.newImage( "imagens/bg1.png" )
ceu2:setReferencePoint( display.CenterLeftReferencePoint )
ceu2.x = 610
ceu2.y = baseline-115
ceu2.xScale = 1.3
ceu2.yScale = 1.3

local tPrevious = system.getTimer()
local function move(event)
	local tDelta = (event.time - tPrevious)/4
	tPrevious = event.time

	local xOffset = ( 0.2 * tDelta )

	ceu.x = ceu.x - xOffset
	ceu2.x = ceu2.x - xOffset

	if (ceu.x + ceu.contentWidth) < 0 then
		ceu:translate( 610 * 2, 0)
	end
	if (ceu2.x + ceu2.contentWidth) < 0 then
		ceu2:translate( 610 * 2, 0)
	end
end

Runtime:addEventListener( "enterFrame", move );

--Exibindo pontuacao
local function newText()
	-- body
	textVidas = display.newText("Vidas: "..vidas, 40, 10, nil, 14)
	textPontuacao = display.newText("Pontuação: "..pontuacao, 40, 30, nil, 14)
	textVidas:setTextColor(255, 255, 255)
	textPontuacao:setTextColor(255, 255, 255)
end
		

local  function updateText()
	-- body
	textVidas.text = "Vidas: "..vidas
	textPontuacao.text = "Pontuação: "..pontuacao
end

--fisica básica de arrastar
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

--carregar a nave
local function spawnShip()
	-- body
	startfighter = display.newImage("imagens/nave2.png", true)
	startfighter.x = display.contentWidth/2
	startfighter.y = display.contentHeight - 50
	fisica.addBody (startfighter, {density=1.0, friction = 0.3, bounce=0})
	startfighter.myName="startfighter"
end

--carrega o retangulo
local function loadRetangulo()
	-- body
	numRetangulos = numRetangulos +1
	retanguloTable[numRetangulos] = display.newImage("imagens/cubo.png", true)
	fisica.addBody(retanguloTable[numRetangulos], {density=1, friction=0.4, bounce=1})
	local whereFrom = math.random(1)
	retanguloTable[numRetangulos].myName="retangulo"
		if (whereFrom==1) then
			retanguloTable[numRetangulos].x = (math.random(display.contentWidth))
			retanguloTable[numRetangulos].y = -30
			transition.to(retanguloTable[numRetangulos], {x= (math.random(display.contentWidth)), y=(display.contentHeight+100), time = (math.random(9000, 40000))})
	end	
end



--detecção de colisão
local function onCollision(event)
	-- body
	if(event.object1.myName=="startfighter" or event.object2.myName=="startfighter") then
		if(died == false) then
			died = true
			if(vidas == 1) then
				media.playEventSound("bomba.mp3")
				event.object1:removeSelf()
				event.object2:removeSelf()
				vidas=vidas -1
				local lose = display.newText("Game Over.", 160, 150, nil, 36)
				lose:setTextColor(255,255,255)
			else
				media.playEventSound("bomba.png")
				startfighter.alpha =0
				vidas = vidas-1
				cleanup()
				timer.performWithDelay(2000,weDied,1)
			end
		end
	end
	if ((event.object1.myName=="retangulo" and event.object2.myName=="tiros") or (event.object1.myName=="tiros" and event.object2.myName=="retangulo")) then
		media.playEventSound("bomba.mp3")
		event.object1:removeSelf()
		event.object1.myName=nil
		event.object2:removeSelf()
		event.object2.myName=nil
		pontuacao=pontuacao+100
	end		
end

--remove a nave pra posição inicial e faz ela piscar por 2 segundos
function weDied()
	-- piscar a nave
	startfighter.x=display.contentWidth/2
	startfighter.y=display.contentHeight - 50
	transition.to(startfighter, {alpha=1, timer=2000})
	died=false
end

--função fireshot cria e rastreia cada um dos tiros disparados pela nave.
local function fireshot(event)
	-- body
	numTiros = numTiros+1
	tirosTable[numTiros] = display.newImage("raio.png")
	fisica.addBody(tirosTable[numTiros], {density=1, friction=0})
	tirosTable[numTiros].isbullet = true
	tirosTable[numTiros].x = startfighter.x
	tirosTable[numTiros].y = startfighter.y -60
	transition.to(tirosTable[numTiros], {y=-80, time=700})
	media.playEventSound("laser.mp3")
	tirosTable[numTiros].myName="tiros"
	tirosTable[numTiros].age=0
end

--remove da memória
function cleanup( ... )
	-- body
	for i=1, table.getn(retanguloTable) do
		if(retanguloTable[i].myName~=nil) then
			retanguloTable[i]:removeSelf()
			retanguloTable[i].myName=nil
		end
	end
	for i=1, table.getn(tirosTable) do
		if(tirosTable[i].myName~=nil) then
			tirosTable[i]:removeSelf()
			tirosTable[i].myName=nil
		end
	end
end

--laço do jogo
local function gameLoop()
	-- body
	updateText()
	loadRetangulo()
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

--inicia jogo
spawnShip()
newText()

startfighter:addEventListener("touch", startDrag)
startfighter:addEventListener("tap", fireshot)
Runtime:addEventListener("collision", onCollision)
timer.performWithDelay(tick, gameLoop,0)

--local startfighter = display.newImage("nave1.png", true)

--local nave = display.newImage("nave1.png", true)