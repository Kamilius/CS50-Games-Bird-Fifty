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

function Bird:reset()
  self.x = VIRTUAL_WIDTH / 2 - (self.width / 2)
  self.y = VIRTUAL_HEIGHT / 2 - (self.height / 2)

  self.dy = 0
end

function Bird:render()
  love.graphics.draw(self.image, self.x, self.y)
end

function Bird:update(dt)
  -- apply Gravity to velocity
  self.dy = self.dy + GRAVITY * dt

  if love.keyboard.keysPressed['space'] or love.keyboard.keysPressed['lmb'] then
    self.dy = ANTI_GRAVITY
  end

  -- apply velocity to bird's current position
  self.y = self.y + self.dy
end
--[[
  AABB collision that expects a pipe which will have an X and Y
]]
function Bird:collides(pipe)
  --[[
    the 2's are left and top offsets
    the 4's are right and bottom offsets
    both offsets are used to shrink the bounding box and forgive the player
    a slight collisions
  ]]
  if (self.x + 2) + (self.width - 4) >= pipe.x and self.x <= pipe.x + PIPE_WIDTH then
      if (self.y + 2) + (self.height - 4) >= pipe.y and self.y <= pipe.y + PIPE_HEIGHT then
        return true
      end
  end

  return false
end
