module("Dancar", package.seeall)

require("dancar/ColunaSetas")
require("dancar/MolduraSeta")
require("dancar/Seta")
require("dancar/Lobo")
require("dancar/PartituraPokerFace")

local LG = love.graphics
local LK = love.keyboard
tela = {hor = LG.getWidth(), ver = LG.getHeight()}
local colunasDeSetas = {}
local LT =  love.timer
pontuacao = 0
qtde_a_tocar =0
qtde_notas_nao_tocadas =0
porcentagem_de_acertos = 100

musica = love.audio.newSource("dancar/Lady Gaga - Poker Face (Lyrics) (320).mp3", "stream")
partitura = PartituraPokerFace.getPartitura()

function table.map_length(t)
  local c = 0
  for k,v in pairs(t) do
    c = c+1
  end
  return c
end
function Dancar.load()

  status = 0
  plano_de_fundo  = LG.newImage("dancar/bg1.jpg")
  plano_de_fundo_vitoria = LG.newImage("dancar/VitoriaDanca.jpeg")
  plano_de_fundo_derrota = LG.newImage("dancar/GameOverDanca.jpeg")

  x_inicial = (tela.hor/2)-128
  colunasDeSetas.left = ColunaSetas.load(x_inicial+ 30, 30, tela.ver, 32, 'left', partitura, "dancar/left_moldura.png", "dancar/left_seta.png")
  colunasDeSetas.up = ColunaSetas.load(x_inicial+70, 30, tela.ver, 32, 'up', partitura,"dancar/up_moldura.png", "dancar/up_seta.png")
  colunasDeSetas.down = ColunaSetas.load(x_inicial+110, 30, tela.ver, 32, 'down', partitura,"dancar/down_moldura.png", "dancar/down_seta.png")
  colunasDeSetas.right = ColunaSetas.load(x_inicial+150, 30, tela.ver, 32, 'right', partitura,"dancar/right_moldura.png","dancar/right_seta.png")
  partitura = nil
 
 lobo = Lobo.load(x_inicial-230,tela.ver/10, "dancar/lobo/spritesheet.png")
 -- qtde_de_notas =  table.map_length( partitura)
  tempo_que_demora_chegar_na_moldura= 0 -- ((tela.ver - 200)+33 ) /10
  tempo_atual = 0
  status_inicio = 1
  --musica:play()

end

function Dancar.update(dt)
  tempo_atual = tempo_atual + dt
  
  if status_inicio == 1 then
    musica:play()
    status_inicio =0
  end
  
  if porcentagem_de_acertos < 50 then
    status = 1
  end

  
--  if colunasDeSetas.left.partitura_desta_coluna[1] == nil and colunasDeSetas.up.partitura_desta_coluna[1] == nil and colunasDeSetas.down.partitura_desta_coluna[1] == nil and colunasDeSetas.right.partitura_desta_coluna[1] == nil then
--    status = 2
--  end
  if not (musica:isPlaying()) and porcentagem_de_acertos >50 then
    status = 2
  elseif not (musica:isPlaying()) and porcentagem_de_acertos <=50 then
    status = 1
  end

  if status  == 0 then
    lobo = Lobo.update(dt, lobo)
    pontuacao = colunasDeSetas.left.pontos + colunasDeSetas.right.pontos + colunasDeSetas.up.pontos + colunasDeSetas.down.pontos
    qtde_notas_nao_tocadas =colunasDeSetas.left.setas_nao_tocadas + colunasDeSetas.right.setas_nao_tocadas + colunasDeSetas.up.setas_nao_tocadas + colunasDeSetas.down.setas_nao_tocadas

--    for chave, valor in pairs(partitura) do
--      if math.floor(valor.segundo *10) ==  math.floor((tempo_atual+tempo_que_demora_chegar_na_moldura)*10)  then
--        ColunaSetas.addNovaSeta(colunasDeSetas[valor.tecla], valor.segundo, 10)
--        table.remove(partitura, chave)
--        qtde_a_tocar =qtde_a_tocar +1
--      end
--    end



  --  porcentagem_de_acertos = 100 -(((qtde_notas_nao_tocadas*20) / qtde_de_notas)*100)
    porcentagem_de_acertos =( colunasDeSetas.left.porcentagem_de_acertos + colunasDeSetas.right.porcentagem_de_acertos + colunasDeSetas.up.porcentagem_de_acertos + colunasDeSetas.down.porcentagem_de_acertos)/4

    ColunaSetas.update(dt,colunasDeSetas.left)
    ColunaSetas.update(dt,colunasDeSetas.right)
    ColunaSetas.update(dt,colunasDeSetas.up)
    ColunaSetas.update(dt,colunasDeSetas.down)
  else
    if status ==1 then

    elseif status ==2 then

    end
    musica:stop()
  end
end

function Dancar.draw()
  if status ==0 then
    LG.draw(plano_de_fundo,0,0,0,3)
    Lobo.draw(lobo)
    ColunaSetas.draw(colunasDeSetas.left)
    ColunaSetas.draw(colunasDeSetas.right)
    ColunaSetas.draw(colunasDeSetas.up)
    ColunaSetas.draw(colunasDeSetas.down)

    LG.setColor(1,0,0)

    LG.print("Pontuação: " ..pontuacao)
    LG.print("\nPorcentagem acertos: " .. math.floor( porcentagem_de_acertos))
    LG.setColor(1,1,1)
  elseif status ==1 then
    LG.draw(plano_de_fundo_derrota, (tela.ver/2)-(plano_de_fundo_vitoria:getWidth()/10),0)
    LG.setColor(1,1,1)
    LG.print("GAME OVER")
    LG.print("\nPontuação: " ..pontuacao)
    LG.print("\n\nClique em qualquer tecla para recomeçar")
    --LG.print("\n\nPorcentagem acertos: " .. math.floor( porcentagem_de_acertos))
  elseif status ==2 then
    LG.draw(plano_de_fundo_vitoria, (tela.ver/2)-(plano_de_fundo_vitoria:getWidth()/2) ,0)
    LG.setColor(1,1,1)

    LG.print("Parabéns você ganhou")

  end
end


function Dancar.keypressed(key)
  if status == 1 then
    status = 0
    pontuacao = 0
    qtde_a_tocar =0
    qtde_notas_nao_tocadas =0
    tempo_atual = 0
    porcentagem_de_acertos = 100
    --qtde_de_notas =  table.map_length( partitura)
    tempo_que_demora_chegar_na_moldura= 0 
    partitura = PartituraPokerFace.getPartitura()
    colunasDeSetas.left = ColunaSetas.load(x_inicial+ 30, 30, tela.ver, 32, 'left', partitura, "dancar/left_moldura.png", "dancar/left_seta.png")
    colunasDeSetas.up = ColunaSetas.load(x_inicial+70, 30, tela.ver, 32, 'up', partitura,"dancar/up_moldura.png", "dancar/up_seta.png")
    colunasDeSetas.down = ColunaSetas.load(x_inicial+110, 30, tela.ver, 32, 'down', partitura,"dancar/down_moldura.png", "dancar/down_seta.png")
    colunasDeSetas.right = ColunaSetas.load(x_inicial+150, 30, tela.ver, 32, 'right', partitura,"dancar/right_moldura.png","dancar/right_seta.png")
    musica:play()
  end
end