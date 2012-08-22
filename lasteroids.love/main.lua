require("unit")
require("ai")

require("unit.lander")

-- game init code
function love.load()

  -- cursor off
  love.mouse.setVisible(false)
  local font = love.graphics.newFont(14)
  love.graphics.setFont(font)

  love.physics.setMeter(16) --the height of a meter our worlds will be 64px
  -- 9.81*64
  world = love.physics.newWorld(0, 0, true) --create a world for the bodies to exist in with horizontal gravity of 0 and vertical gravity of 9.81

  wall = {}
  wall.body = love.physics.newBody(world, 0, 0, "static")
  wall.shape = love.physics.newChainShape(true, 50, 50, love.graphics.getWidth() - 50, 50, love.graphics.getWidth() - 50, love.graphics.getHeight() - 50, 50, love.graphics.getHeight() - 50)

  wall.fixture = love.physics.newFixture(wall.body, wall.shape)

  for i=1,10 do
    local l = unit.lander.new{y=100, x=100+50*i}
    l.unit.body:setLinearVelocity(50, 100)
  end

  for i=1,10 do
    local l = unit.lander.new{y=150, x=100+50*i}
    l.unit.body:setLinearVelocity(100, 50)
  end

  hero = unit.new{name="hero", sprite="galaga_ship.png", x=650, y=650, speed=200, xscale=0.25, yscale=0.25}

end

-- keyboard keypress callback
function love.keypressed(k)

  -- quit on ESC
  if k == "escape" then
    love.event.push("quit")
  end

end

t = 0

function love.update(dt)
  world:update(dt)

  t = t + dt
  if t > 0.01 then
    t = 0
    for k,v in pairs(ai.getAIs()) do
      local u = v.unit
      v.fsm.update()
    end
  end

  if love.keyboard.isDown("lshift") then
    speedsave = hero.speed
    hero.speed = 200
  else
    hero.speed = 100
  end

  if love.keyboard.isDown("right") then
    --hero.x = hero.x + (hero.speed * dt)
    hero.body:applyForce(400, 0)
  elseif love.keyboard.isDown("left") then
    --hero.x = hero.x - (hero.speed * dt)
    hero.body:applyForce(-400, 0)
  end

  if love.keyboard.isDown("down") then
    --hero.y = hero.y + (hero.speed * dt)
    hero.body:applyForce(0, 400)
  elseif love.keyboard.isDown("up") then
    --hero.y = hero.y - (hero.speed * dt)
    hero.body:applyForce(0, -400)
  end

  if (hero.x + hero.image:getWidth() * hero.xscale) > love.graphics.getWidth() then
    hero.x = love.graphics.getWidth() - hero.image:getWidth() * hero.xscale
  end

  if hero.x < 0 then
    hero.x = 0
  end

  if (hero.y + hero.image:getHeight() * hero.yscale) > love.graphics.getHeight() then
    hero.y = love.graphics.getHeight() - hero.image:getWidth() * hero.yscale
  end

  if hero.y < 0 then
    hero.y = 0
  end

end

function love.draw()
  for k,v in pairs(unit.getUnits()) do
    love.graphics.draw(v.image, v.body:getX(), v.body:getY(), v.body:getAngle(), v.xscale, v.yscale)
  end

  local i = hero.image
  local b = hero.body

  local bbox = { b:getX(), b:getY(),
                  b:getX() + i:getWidth() * hero.xscale, b:getY(),
                  b:getX() + i:getWidth() * hero.xscale, b:getY() + i:getHeight() * hero.yscale,
                  b:getX(), b:getY() + i:getHeight() * hero.yscale
                }

  love.graphics.polygon('line', bbox)

  love.graphics.line(wall.body:getWorldPoints(wall.shape:getPoints()))

end
