local Player = require('player')

Spike = {img = love.graphics.newImage('assets/Spike.png')}
Spike.__index = Spike
Spike.width, Spike.height = Spike.img:getWidth(), Spike.img:getHeight()
ActiveSpikes = {}

function Spike.new(x, y)
    local instance = setmetatable({}, Spike)

    instance.x, instance.y = x, y

    instance.physics = {}
    instance.physics.body = love.physics.newBody(World, instance.x, instance.y, 'static')
    instance.physics.shape = love.physics.newRectangleShape(Spike.width, Spike.height)
    instance.physics.fixture = love.physics.newFixture(instance.physics.body, instance.physics.shape)
    instance.physics.fixture:setSensor(true)
    table.insert(ActiveSpikes, instance)

end

function Spike:update(dt)

end

function Spike:draw()
    love.graphics.draw(self.img, self.x, self.y, 0, self.scaleX, 1, self.width /2, self.height /2)
end

function Spike.updateAll(dt)
    for i,instance in ipairs(ActiveSpikes) do
        instance:update(dt)
    end
end

function Spike.drawAll()
    for i, instance in ipairs(ActiveSpikes) do
        instance:draw()
    end
end

function Spike.beginContact(a, b, collision)
    for i, instance in ipairs(ActiveSpikes) do
        if a == Player.physics.fixture or b == Player.physics.fixture then
            Player:takeDamage(1)
        end
    end
end