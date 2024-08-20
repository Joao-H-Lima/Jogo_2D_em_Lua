Inimigo = {}

function Inimigo:load()
    local inimigo = {}

    inimigo.x, inimigo.y = love.graphics.getWidth(), 0  -- Faz o controle da posição do jogador na tela
    inimigo.width, inimigo.height = 20, 38              --Dermina a largura e altura do jogador respectivamente
    inimigo.xVel, inimigo.yVel = 0, 0                   -- Define a velocidade do jogador
    inimigo.maxSpeed = 200                              -- Define a velocidade máxima do player
    inimigo.acceleration, inimigo.friction = 4000, 3500 -- Determina a velocidade de aceleração e de freagem do player
    inimigo.gravity = 1500
    inimigo.grounded = false
    inimigo.direction = 'right'


    Inimigo:loadAssets()

    inimigo.physics = {}                                                                           -- Armazena todas as informações da fisica do player em uma tabela
    inimigo.physics.body = love.physics.newBody(World, inimigo.x, inimigo.y, 'dynamic')            -- Define o corpo do player
    inimigo.physics.body:setFixedRotation(true)                                                    -- Faz com que o corpo não posso rotacionar
    inimigo.physics.shape = love.physics.newRectangleShape(inimigo.width, inimigo.height)
    inimigo.physics.fixture = love.physics.newFixture(inimigo.physics.body, inimigo.physics.shape) -- Junta o elemento do body ao elemento da shape

    return inimigo
end

function Inimigo:loadAssets()
    self.animation = { timer = 0, rate = 0.1 }

    self.animation.LoboInimigo = { total = 11, current = 1, img = {} }
    for i = 1, self.animation.LoboInimigo.total do
        self.animation.LoboInimigo.img[i] = love.graphics.newImage('assets/LoboInimigo/' .. i .. '.png')
    end

    self.animation.draw = self.animation.LoboInimigo.img[1]
    self.animation.width = self.animation.draw:getWidth()
    self.animation.height = self.animation.draw:getHeight()
end

function Inimigo:update(dt)
    Inimigo:setState()
    --Inimigo:setDirection()
    Inimigo:animate(dt)
    Inimigo:syncPhysics()
    --Inimigo:move(dt)
    Inimigo:applyGravity(dt)
end

function Inimigo:setState()
    self.state = 'LoboInimigo'
end

function Inimigo:animate(dt)
    self.animation.timer = self.animation.timer + dt
    if self.animation.timer > self.animation.rate then
        self.animation.timer = 0
        self:setNewFrame()
    end
end

function Inimigo:setNewFrame()
    local anim = self.animation[self.state]
    if anim.current < anim.total then
        anim.current = anim.current + 1
    else
        anim.current = 1
    end
    self.animation.draw = anim.img[anim.current]
end

function Inimigo:applyGravity(dt)
    if inimigo.grounded == false then
        inimigo.yVel = inimigo.yVel + inimigo.gravity * dt
    end
end

function Inimigo:syncPhysics()
    inimigo.x, inimigo.y = inimigo.physics.body:getPosition() -- Referencia as posições do body na posição do player
    inimigo.physics.body:setLinearVelocity(inimigo.xVel, inimigo.yVel)
end

function Inimigo:beginContact(a, b, collision)
    if inimigo.grounded == true then return end
    local nx, ny = collision:getNormal()
    if a == inimigo.physics.fixture then
        if ny > 0 then
            self:land(collision)
        end
    elseif b == inimigo.physics.fixture then
        if ny < 0 then
            self:land(collision)
        end
    end
end

function Inimigo:land(collision)
    inimigo.currentGroundCollision = collision
    inimigo.yVel = 0
    inimigo.grounded = true
    inimigo.jumcount = 2
end

function Inimigo:endContact(a, b, collision)
    if a == inimigo.physics.fixture or b == inimigo.physics.fixture then
        if inimigo.currentGroundCollision == collision then
            self.grounded = false
        end
    end
end

function Inimigo:draw(inimigo)
    local scaleX = 1
    if inimigo.direction == 'right' then
        scaleX = -1
    end

    love.graphics.draw(self.animation.draw, inimigo.x, inimigo.y, 0, scaleX, 2, 0, self.animation.height / 2 + 6)
end

return Inimigo
