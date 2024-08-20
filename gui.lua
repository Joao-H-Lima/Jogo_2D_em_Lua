GUI = {}

function GUI:load()
    self.hearts = {}
    self.hearts.img = love.graphics.newImage('assets/heart.png')
    self.hearts.width = self.hearts.img:getWidth()
    self.hearts.height = self.hearts.img:getHeight()
    self.hearts.x = 0
    self.hearts.y = 30
    self.hearts.scale = 2
    self.hearts.spacing = self.hearts.width * self.hearts.scale + 30
end

function GUI:update(dt)
    GUI:displayHearts(player)
end

function GUI:draw(player)
    self:displayHearts(player)
end

function GUI:displayHearts(player)
    for i=1, player.health.current do
        local x = self.hearts.x + self.hearts.spacing * (i - 1)
        love.graphics.draw(self.hearts.img, x, self.hearts.y, 0, self.hearts.scale, self.hearts.scale)
    end
end
