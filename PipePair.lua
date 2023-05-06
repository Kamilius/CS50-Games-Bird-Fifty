PipePair = Class {}

local GAP_HEIGHT  = 90

function PipePair:init(y)
    self.x = VIRTUAL_WIDTH + 32
    self.y = y

    self.pipes = {
        ['upper'] = Pipe('top', self.y),
        ['lower'] = Pipe('bottom', self.y + PIPE_HEIGHT + GAP_HEIGHT)
    }

    -- wether pair is ready to be removeds
    self.remove = false
end

function PipePair:update(dt)
  -- update the pair position if it's still in view
  -- or remove the pair
  if self.x > -PIPE_WIDTH then
    self.x = self.x - PIPE_SPEED * dt
    self.pipes['upper'].x = self.x
    self.pipes['lower'].x = self.x
  else
    self.remove = true
  end
end

function PipePair:render()
  for k, pipe in pairs(self.pipes) do
    pipe:render()
  end
end
