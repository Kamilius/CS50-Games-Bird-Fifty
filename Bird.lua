local GRAVITY = 5
local ANTI_GRAVITY = -GRAVITY / 4

Bird = Class{}

function Bird:init()
  self.image = love.graphics.newImage('assets/images/bird.png')
  self.width = self.image:getWidth()
  self.height = self.image:getHeight()

  self.x = VIRTUAL_WIDTH / 2 - (self.width / 2)
  self.y = VIRTUAL_HEIGHT / 2 - (self.height / 2)

  -- Y velocity; gravity
  self.dy = 0
end

function Bird:render()
  love.graphics.draw(self.image, self.x, self.y)
end

function Bird:update(dt)
  -- apply Gravity to velocity
  self.dy = self.dy + GRAVITY * dt

  if love.keyboard.keysPressed['space'] then
    self.dy = ANTI_GRAVITY
  end

  -- apply velocity to bird's current position
  self.y = self.y + self.dy
end
