module("ColunaSetas", package.seeall)
require("dancar/MolduraSeta")
require("dancar/Seta")

function ColunaSetas.load(x,y, altura, largura, tecla, partitura,caminho_img_moldura, caminho_img_seta)
  local coluna_seta ={}
  coluna_seta.x =x
  coluna_seta.y =y
  coluna_seta.altura = altura
  coluna_seta.largura = largura
  coluna_seta.caminho_img_seta = caminho_img_seta
  coluna_seta.molduraSeta = MolduraSeta.load(coluna_seta.x, coluna_seta.altura -200 , caminho_img_moldura)
  coluna_seta.setas = {}
  coluna_seta.tecla = tecla
  coluna_seta.pontos = 0
  coluna_seta.setas_nao_tocadas = 0
  coluna_seta.porcentagem_de_acertos = 100
  coluna_seta.partitura_desta_coluna = ColunaSetas.filtrarPartitura(tecla, partitura)
  coluna_seta.tempo = 0
  
  return coluna_seta
end

function ColunaSetas.update(dt, coluna_setas)
  MolduraSeta.update( dt, coluna_setas.molduraSeta)
  coluna_setas.tempo = coluna_setas.tempo +dt
  if coluna_setas.partitura_desta_coluna[1] ~= nil then
    if math.floor((coluna_setas.partitura_desta_coluna[1]*10)) ==  math.floor((coluna_setas.tempo *10)) then
      print(coluna_setas.partitura_desta_coluna[1])
      ColunaSetas.addNovaSeta(coluna_setas,coluna_setas.partitura_desta_coluna[1], 10)
      table.remove(coluna_setas.partitura_desta_coluna, 1)
    end
  end
  
  for chave, valor in pairs( coluna_setas.setas) do
    Seta.update(dt,valor)
    -- remove a seta se passar do limite possivel

    if( love.keyboard.isDown(coluna_setas.tecla)) then

      ColunaSetas.keypressed(coluna_setas , chave,valor)
    end

    if(valor.y >  coluna_setas.altura) then
      ColunaSetas.removeSeta(coluna_setas, chave)
      coluna_setas.porcentagem_de_acertos =  coluna_setas.porcentagem_de_acertos -20
      coluna_setas.setas_nao_tocadas = coluna_setas.setas_nao_tocadas+1
    end
  end
end

function ColunaSetas.draw(coluna_setas)
  MolduraSeta.draw( coluna_setas.molduraSeta)
  for chave, valor in pairs( coluna_setas.setas) do
    Seta.draw(valor)
  end
end

function ColunaSetas.addNovaSeta(coluna_setas, segundos, velocidade)
  table.insert( coluna_setas.setas, Seta.load(coluna_setas.x, -1, coluna_setas.caminho_img_seta, segundos,velocidade))
end

function ColunaSetas.removeSeta(coluna_setas, chave)
  table.remove(coluna_setas.setas, chave)
end


function ColunaSetas.molduraEstaColidindoComSeta(moldura,seta)
  return (moldura.y  - seta.altura) <= seta.y and (moldura.y+moldura.altura+seta.altura) > seta.y 
end

function ColunaSetas.filtrarPartitura(tecla, partitura)
  partituraColuna = {}
  for chave, valor in pairs(partitura) do
    if valor.tecla == tecla then
      table.insert( partituraColuna, valor.segundo)
    end
  end
  return partituraColuna
end


function ColunaSetas.keypressed(coluna_setas,  index_seta,seta )
  --print("tecla='".. coluna_setas.tecla.. "'".. ", segundo=".. coluna_setas.tempo)

  if ColunaSetas.molduraEstaColidindoComSeta(coluna_setas.molduraSeta,  seta)  then
    ColunaSetas.removeSeta(coluna_setas, index_seta)
    coluna_setas.pontos = coluna_setas.pontos+1
    if coluna_setas.porcentagem_de_acertos <100 then
      coluna_setas.porcentagem_de_acertos =  coluna_setas.porcentagem_de_acertos +20
    end
  end
end