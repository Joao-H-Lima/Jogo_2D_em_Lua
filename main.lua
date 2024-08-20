love.graphics.setDefaultFilter("nearest", "nearest")

local STI = require('assets.sti') -- Importa a biblioteca STI, para que possa carregar o arquivo do mapa
local Player = require('player')  -- Importa o arquivo 'player.lua' para o arquivo main
local Camera = require('camera')
local cam
local Inimigo = require('inimigo')
suit = require "suit"

require("dancar/Dancar")

local fonte = love.graphics.newFont('assets/prstartk.ttf', 50)
local imgFundo = love.graphics.newImage('assets/imgInicial.jpg')

LG = love.graphics
tela = 1

function love.load()
  LG.setFont(LG.newFont(18))
  -- CARREGAR DADOS DE DANCA
  Dancar.load()

  cam = Camera()

  Map = STI('map/map2..lua', { 'box2d' })                               -- Guarda o arquivo do mapa em uma variavel "Map" e espefica o módulo de fisica como 'box2d'
  World = love.physics.newWorld(0, 0, true)                             -- Cria uma instancia do mundo e grarda em uma variavel 'World'
  World:setCallbacks(beginContact, endContact)
  Map:box2d_init(World)                                                 -- Carrega a camada de colisão do 'Map' para o 'World'
  Map.layers.Solido.visible = false                                     -- Faz com que a camada de colisão 'Solido' não seja desenhada na tela
  Cenario = love.graphics.newImage('assets/map/2 Background/fase1.png') -- Carrega a imagem de fundo do cenário
  player = Player:load()                                                -- Função para carregar as informações do player
  inimigo = Inimigo:load()
end

function love.update(dt)
  if tela == 1 then
    suit.layout:reset(600, 500)
    suit.layout:padding(10)
    suit.Label('Wolf Hunter European', 590, 150, 200, 30, { font = fonte })

    if suit.Button('Entrar', { id = 1 }, suit.layout:row(200, 30)).hit then
      tela = 2
    elseif suit.Button('Sair', { id = 2 }, suit.layout:row(200, 30)).hit then
      love.event.quit()
    end
  end

  -- entrar jogo
  if tela == 2 then
    World:update(dt)  -- Faz com que o mundo seja atualizado e possa ter movimento
    Player:update(dt) -- Função para atualizar o player
    Inimigo:update(dt)
    cam:lookAt(player.x, player.y)

    local w = love.graphics.getWidth()
    local h = love.graphics.getHeight()

    if cam.x < w / 2 then
      cam.x = w / 2
    end

    if cam.y < h / 2 then
      cam.y = h / 2
    end

    local mapW = Map.width * Map.tilewidth
    local mapH = Map.height * Map.tileheight

    if cam.x > (mapW - w / 2) then
      cam.x = (mapW - w / 2)
    end

    if cam.y > (mapH - h / 2) then
      cam.y = (mapH - h / 2)
    end
  end

    if tela == 3 then
      Dancar.update(dt)
    end

end

function love.draw()
  if tela == 1 then
    love.graphics.draw(imgFundo, 0, 0, 0, love.graphics.getWidth() / imgFundo:getWidth(),
      love.graphics.getHeight() / imgFundo:getHeight())
    suit.draw()
  end
  if tela == 2 then
    cam:attach()
    -- Desenha o fundo da tela
    --love.graphics.draw(Cenario, 0, 0, 0, love.graphics.getWidth() / Cenario:getWidth(),
    --love.graphics.getHeight() / Cenario:getHeight())
    Map:drawLayer(Map.layers["Fundo"])
    -- Desenha o mapa com a posição inicial em (0,0) e uma escala de 2x
    Map:drawLayer(Map.layers["Chão"])
    -- Map:drawLayer(Map.layers["Solido"])

    -- As funções push e pop fazem com que todos os código dentro desses parametros não afetem o restante do código
    -- Ex: A função scale como está dentro do push e pop não vai modificar os elementos que estão fora dessas funções

    Player:draw(player)
    Inimigo:draw(inimigo)
    cam:detach()
  end
  if tela == 3 then
    Dancar.draw()
  end
end

function love.keypressed(key)
  if tela == 2 then
    Player:jump(key)
  end
  if tela == 3 then
    Dancar.keypressed(key)
  end
end

function beginContact(a, b, collision)
  Player:beginContact(a, b, collision)
end

function endContact(a, b, collision)
  Player:endContact(a, b, collision)
end
