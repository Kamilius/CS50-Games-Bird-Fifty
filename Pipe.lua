Pipe = Class{}

local PIPE_IMAGE = love.graphics.newImage('assets/images/pipe.png')

PIPE_HEIGHT = PIPE_IMAGE:getHeight()
PIPE_WIDTH = PIPE_IMAGE:getWidth()

PIPE_SPEED = 60

function Pipe:init(orientation, y)
  self.x = VIRTUAL_WIDTH
  self.y = y

  self.width = PIPE_IMAGE:getWidth()
  self.height = PIPE_HEIGHT

  self.orientation = orientation
end

function Pipe:render()
  -- y is for orientation 'bottom' by default
  local y = self.y
  -- scale on Y axis
  -- 1 - normal
  -- -1 - mirrors (flips) the image
  local sy = 1

  -- render pipe upside down, starting from top
  if self.orientation == 'top' then
    y = y + PIPE_HEIGHT
    sy = -1
  end

  love.graphics.draw(
    PIPE_IMAGE, self.x, y, 0, 1, sy)
end
