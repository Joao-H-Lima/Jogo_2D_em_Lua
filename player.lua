-- Cria uma tabela para que possa armazenas as informações do jogador
Player = {}

function Player:load()
    local player = {}

    player.x, player.y = 100, 500                     -- Faz o controle da posição do jogador na tela
    player.width, player.height = 18, 40              -- Determina a largura e altura do jogador respectivamente
    player.xVel, player.yVel = 0, 0                   -- Define a velocidade do jogador
    player.maxSpeed = 200                             -- Define a velocidade máxima do player
    player.acceleration, player.friction = 4000, 3500 -- Determina a velocidade de aceleração e de freagem do player
    player.gravity = 1500
    player.grounded = false
    player.jumpAmount = -500
    player.jumcount = 2
    player.direction = 'right'
    player.state = 'idle'

    Player:loadAssets()

    player.physics = {}                                                                         -- Armazena todas as informações da fisica do player em uma tabela
    player.physics.body = love.physics.newBody(World, player.x, player.y, 'dynamic')            -- Define o corpo do player
    player.physics.body:setFixedRotation(true)                                                  -- Faz com que o corpo não posso rotacionar
    player.physics.shape = love.physics.newRectangleShape(player.width, player.height)
    player.physics.fixture = love.physics.newFixture(player.physics.body, player.physics.shape) -- Junta o elemento do body ao elemento da shape

    ----PARTE DE TIROS
    player.podeAtirar = true
    player.atiraMax = 0.2
    player.tempoTiro = 0
    player.imgProj = love.graphics.newImage('assets/player/tiro/projetil.png')
    player.direcao = 'direita'
    player.disparos = {}


    return player
end

function Player:loadAssets()
    self.animation = { timer = 0, rate = 0.1 }

    self.animation.run = { total = 6, current = 1, img = {} }
    for i = 1, self.animation.run.total do
        self.animation.run.img[i] = love.graphics.newImage('assets/player/run/' .. i .. '.png')
    end

    self.animation.idle = { total = 4, current = 1, img = {} }
    for i = 1, self.animation.idle.total do
        self.animation.idle.img[i] = love.graphics.newImage('assets/player/idle/' .. i .. '.png')
    end

    self.animation.jump = { total = 4, current = 1, img = {} }
    for i = 1, self.animation.jump.total do
        self.animation.jump.img[i] = love.graphics.newImage('assets/player/jump/' .. i .. '.png')
    end

    self.animation.draw = self.animation.idle.img[1]
    self.animation.width = self.animation.draw:getWidth()
    self.animation.height = self.animation.draw:getHeight()
end

function Player:update(dt)
    Player:setState()
    Player:setDirection()
    Player:animate(dt)
    Player:syncPhysics()
    Player:move(dt)
    Player:applyGravity(dt)

    -- Atualizar o timer de tiros
    player.tempoTiro = player.tempoTiro - dt
    if player.tempoTiro < 0 then
        player.podeAtirar = true
        player.tempoTiro = player.atiraMax
    end
    -- Controle de temporização de disparos
    if love.mouse.isDown(1) and player.podeAtirar then
        local novoDisparo
        if player.direction == 'right' then
            novoDisparo = { x = player.x + 2, y = player.y - 33 / 2 - player.imgProj:getHeight() / 2, direcao = 1, img =
            player.imgProj }
        elseif player.direction == 'left' then
            novoDisparo = { x = player.x - 2 - player.imgProj:getWidth(), y = player.y - 33 / 2 -
            player.imgProj:getHeight() / 2, direcao = -1, img = player.imgProj }
        end
        table.insert(player.disparos, novoDisparo)
        player.podeAtirar = false     -- Impede que novos tiros sejam criados até o próximo intervalo
    end


    -- Animação do movimento dos disparos
    for i, proj in ipairs(player.disparos) do
        proj.x = proj.x + (500 * dt * proj.direcao)
        if proj.x > Map.width * Map.tilewidth or proj.x + player.imgProj:getWidth() < 0 then
            -- Remove o disparo se atingir os limites do mapa
            table.remove(player.disparos, i)
        end
    end
end

function Player:setState()
    if not player.grounded then
        self.state = 'jump'
    elseif player.xVel == 0 then
        self.state = 'idle'
    else
        self.state = 'run'
    end
end

function Player:setDirection()
    if player.xVel < 0 then
        player.direction = 'left'
    elseif player.xVel > 0 then
        player.direction = 'right'
    end
end

function Player:animate(dt)
    self.animation.timer = self.animation.timer + dt
    if self.animation.timer > self.animation.rate then
        self.animation.timer = 0
        self:setNewFrame()
    end
end

function Player:setNewFrame()
    local anim = self.animation[self.state]
    if anim.current < anim.total then
        anim.current = anim.current + 1
    else
        anim.current = 1
    end
    self.animation.draw = anim.img[anim.current]
end

function Player:applyGravity(dt)
    if player.grounded == false then
        player.yVel = player.yVel + player.gravity * dt
    end
end

function Player:syncPhysics()
    player.x, player.y = player.physics.body:getPosition() -- Referencia as posições do body na posição do player
    player.physics.body:setLinearVelocity(player.xVel, player.yVel)
end

function Player:move(dt)
    if love.keyboard.isDown('d', 'right') then
        if player.xVel < player.maxSpeed then
            if player.x + player.acceleration * dt < player.maxSpeed then
                player.xVel = player.xVel + player.acceleration * dt
            else
                player.xVel = player.maxSpeed
            end
        end
    elseif love.keyboard.isDown('a', 'left') then
        if player.xVel > -player.maxSpeed then
            if player.x - player.acceleration * dt > -player.maxSpeed then
                player.xVel = player.xVel - player.acceleration * dt
            else
                player.xVel = -player.maxSpeed
            end
        end
    else
        self:applyFriction(dt)
    end
end

function Player:applyFriction(dt)
    if player.xVel > 0 then
        if player.xVel - player.friction * dt > 0 then
            player.xVel = player.xVel - player.friction * dt
        else
            player.xVel = 0
        end
    elseif player.xVel < 0 then
        if player.xVel + player.friction * dt < 0 then
            player.xVel = player.xVel + player.friction * dt
        else
            player.xVel = 0
        end
    end
end

function Player:beginContact(a, b, collision)
    if player.grounded == true then return end
    local nx, ny = collision:getNormal()
    if a == player.physics.fixture then
        if ny > 0 then
            self:land(collision)
        end
    elseif b == player.physics.fixture then
        if ny < 0 then
            self:land(collision)
        end
    end
end

function Player:land(collision)
    player.currentGroundCollision = collision
    player.yVel = 0
    player.grounded = true
    player.jumcount = 2
end

function Player:jump(key)
    if (key == 'w' or key == 'up') and player.jumcount > 0 then
        player.yVel = player.jumpAmount * 0.8
        player.grounded = false
        player.jumcount = player.jumcount - 1
        if player.jumcount == 1 then
            player.yVel = player.jumpAmount
        end
    end
end

function Player:endContact(a, b, collision)
    if a == player.physics.fixture or b == player.physics.fixture then
        if player.currentGroundCollision == collision then
            player.grounded = false
        end
    end
end

function Player:draw(player)
    local scaleX = 2
    if player.direction == 'left' then
        scaleX = -2
    end

    love.graphics.draw(self.animation.draw, player.x, player.y, 0, scaleX, 2, self.animation.width / 2 + 6,
        self.animation.height / 2 + 8)

    --Atualizar a lista de disparos
    for i, proj in ipairs(player.disparos) do
        love.graphics.draw(proj.img, proj.x, proj.y)
    end
end

return Player
