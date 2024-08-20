module("Lobo", package.seeall)

function Lobo.load(x,y, caminho_img)
  local lobo ={}
  lobo.x =x
  lobo.y =y
  lobo.img = love.graphics.newImage(caminho_img)
  lobo.largura = lobo.img:getWidth();
  lobo.altura = lobo.img:getHeight();
  lobo.quadros = {};
  table.insert(lobo.quadros, love.graphics.newQuad(0,0,136*2,368*2,lobo.img:getDimensions() ));
  table.insert(lobo.quadros, love.graphics.newQuad(136*2,0,140*2,368*2,lobo.img:getDimensions()));
  table.insert(lobo.quadros, love.graphics.newQuad(276*2,0,107*2,368*2,lobo.img:getDimensions()));
  table.insert(lobo.quadros, love.graphics.newQuad(383*2,0,82*2,368*2,lobo.img:getDimensions()));
  table.insert(lobo.quadros, love.graphics.newQuad(465*2,0,139*2,368*2,lobo.img:getDimensions()));
  table.insert(lobo.quadros, love.graphics.newQuad(604*2,0,120*2,368*2,lobo.img:getDimensions()));
  table.insert(lobo.quadros, love.graphics.newQuad(724*2,0,138*2,368*2,lobo.img:getDimensions()));
  table.insert(lobo.quadros, love.graphics.newQuad(862*2,0,200*2,368*2,lobo.img:getDimensions()));
  lobo.passo = 1
  lobo.tempo = 0.01
  return lobo
end

function Lobo.update(dt, lobo)
  lobo.tempo = lobo.tempo +dt
  if(lobo.tempo  + dt > 0.2) then
   lobo.tempo = 0.01
    lobo.passo = lobo.passo +1
    if lobo.quadros[lobo.passo] == nil then
      lobo.passo = 1
    end
  end
  return lobo
end

function Lobo.draw(lobo)
  --love.graphics.rectangle('fill',seta.x , seta.y,  seta.largura ,seta.altura)
  
  love.graphics.draw(lobo.img , lobo.quadros[lobo.passo], lobo.x, lobo.y )
  
end