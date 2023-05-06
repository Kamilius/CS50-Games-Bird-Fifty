push = require('push')
Class = require('class')

require 'Bird'
require 'Pipe'
require 'PipePair'

require 'StateMachine'
require 'states/BaseState'
require 'states/CountdownState'
require 'states/PlayState'
require 'states/ScoreState'
require 'states/TitleScreenState'

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

function love.load()
  love.graphics.setDefaultFilter('nearest', 'nearest')

  love.window.setTitle('Fifty Bird')

  -- initialize nice-looking retro text fonts
  smallFont = love.graphics.newFont('assets/fonts/font.ttf', 8)
  mediumFont = love.graphics.newFont('assets/fonts/flappy.ttf', 14)
  flappyFont = love.graphics.newFont('assets/fonts/flappy.ttf', 28)
  hugeFont = love.graphics.newFont('assets/fonts/flappy.ttf', 56)
  love.graphics.setFont(flappyFont)

  -- seed the RNG
  math.randomseed(os.time())

  push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
    vsync = true,
    fullscreen = false,
    resizable = true
  })

  -- initializing the state machine
  gStateMachine = StateMachine {
    ['title'] = function() return TitleScreenState() end,
    ['countdown'] = function() return CountdownState() end,
    ['play'] = function() return PlayState() end,
    ['score'] = function() return ScoreState() end,
  }
  gStateMachine:change('title')

  -- initialize input table
  love.keyboard.keysPressed = {}
end

function love.resize(w, h)
  push:resize(w, h)
end

function love.mousepressed(x, y, button)
  -- 1 is for the Left Mouse Button -> 'lmb'
  if button == 1 then
    love.keyboard.keysPressed['lmb'] = true
  end
end

function love.keypressed(key)
  love.keyboard.keysPressed[key] = true

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
  -- background parallax effect
  backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt)
      % BACKGROUND_LOOPING_POINT

  -- ground parallax effect
  groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt)
      % VIRTUAL_WIDTH

  -- now we just update the state machine
  gStateMachine:update(dt)

  -- Clear keysPressed list
  love.keyboard.keysPressed = {}
end

function love.draw()
  push:start()

  -- Draw state machine between background and ground
  love.graphics.draw(background, -backgroundScroll, 0)
  gStateMachine:render()
  love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)

  push:finish()
end

