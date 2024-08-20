module("MolduraSeta", package.seeall)

function MolduraSeta.load(x,y, caminho_img)
  local molduraSeta ={}
  molduraSeta.x =x
  molduraSeta.y =y
  molduraSeta.img =love.graphics.newImage(caminho_img)
  molduraSeta.largura = 32
  molduraSeta.altura = 32
  return molduraSeta
end

function MolduraSeta.update(dt)
end

function MolduraSeta.draw(molduraSeta)
  --love.graphics.rectangle('fill',molduraSeta.x , molduraSeta.y, molduraSeta.largura ,molduraSeta.altura)
  love.graphics.draw(molduraSeta.img , molduraSeta.x , molduraSeta.y)
end