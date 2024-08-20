module("Seta", package.seeall)

function Seta.load(x,y, caminho_img, segundos, velocidade)
  local seta ={}
  seta.x =x
  seta.y =y
  seta.img = love.graphics.newImage(caminho_img)
  seta.largura = 32
  seta.altura = 32
  seta.velocidade = velocidade
  seta.segundos = segundos
  return seta
end

function Seta.update(dt, seta)
--  seta.tempo = seta.tempo +dt
--  if(seta.tempo  + dt > 0.2) then
--    seta.tempo = 0.1
--    seta.y = seta.y +10
--  end
  seta.y = seta.y +seta.velocidade
  return seta
end

function Seta.draw(seta)
  --love.graphics.rectangle('fill',seta.x , seta.y,  seta.largura ,seta.altura)
  love.graphics.draw(seta.img , seta.x , seta.y)
end