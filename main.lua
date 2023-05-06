push = require('push')
Class = require('class')

require('Bird')
require('Pipe')
require('PipePair')

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

local background = love.graphics.newImage('assets/images/background.png')
local backgroundScroll = 0

local ground = love.graphics.newImage('assets/images/ground.png')
local groundScroll = 0

local BACKGROUND_SCROLL_SPEED = 30
local GROUND_SCROLL_SPEED = 60

local BACKGROUND_LOOPING_POINT = 413

local bird = Bird()

local pipePairs = {}
-- timer for spawning pipes
local pipeSpawnTimer = 0

local lastY = -PIPE_HEIGHT + math.random(80) + 20

local scrolling = false

function love.load()
  love.graphics.setDefaultFilter('nearest', 'nearest')

  love.window.setTitle('Fifty Bird')

  -- seed the RNG
  math.randomseed(os.time())

  push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
    vsync = true,
    fullscreen = false,
    resizable = true
  })

  love.keyboard.keysPressed = {}
end

function love.resize(w, h)
  push:resize(w, h)
end

function love.mousepressed(x, y, button)
  if button == 1 then
    love.keyboard.keysPressed['lmb'] = true
  end
end

function love.keypressed(key)
  love.keyboard.keysPressed[key] = true

  if key == 'return' then
    bird:reset()
    pipePairs = {}

    scrolling = true
  end

  if key == 'escape' then
    love.event.quit()
  end
end

function love.keyboard.wasPressed(key)
  if love.keyboard.keysPressed[key] then
    return true
  else
    return false
  end
end

function love.update(dt)
    if scrolling then
        -- background parallax effect
        backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt)
            % BACKGROUND_LOOPING_POINT

        -- ground parallax effect
        groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt)
            % VIRTUAL_WIDTH

        -- Update pipes spawn timer
        pipeSpawnTimer = pipeSpawnTimer + dt

        if pipeSpawnTimer > 2 then
            local y = math.max(-PIPE_HEIGHT + 10,
                math.min(lastY + math.random(-20, 20), VIRTUAL_HEIGHT - 90 - PIPE_HEIGHT))
            lastY = y

            table.insert(pipePairs, PipePair(y))
            pipeSpawnTimer = 0
        end

        bird:update(dt)

        -- for every pipe pair in the scene...
        for k, pair in pairs(pipePairs) do
            pair:update(dt)

            -- check to see if bird collided with pipe
            for l, pipe in pairs(pair.pipes) do
              if bird:collides(pipe) then
                -- pause the game to show collision
                scrolling = false
              end
            end

            if pair.x < -PIPE_WIDTH then
              pair.remove = true
            end
        end
    end

  -- Clear keysPressed list
  love.keyboard.keysPressed = {}
end

function love.draw()
  push:start()

  -- render background
  love.graphics.draw(background, -backgroundScroll, 0)

  for k, pair in pairs(pipePairs) do
    pair:render()
  end

  -- render ground
  love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)

  bird:render()

  push:finish()
end

