require("unit")
require("ai")

require("unit.lander")
require("unit.laser")

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

  for i=1,2 do
    local l = unit.lander.new{y=100, x=100+250*i}
    l.unit.body:setLinearVelocity(100, 100)
  end

  for i=1,2 do
    local l = unit.lander.new{y=150, x=100+250*i}
    l.unit.body:setLinearVelocity(-100, 100)
  end

  hero = unit.new{name="hero", sprite="galaga_ship.png", x=250, y=250, speed=200, xscale=0.25, yscale=0.25}
  hero.fixture:setRestitution(0)
  hero.fixture:setFriction(1)
  --hero.body:setAngularDamping(math.huge)

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
      v.fsm.update()
    end
  end

  local force = 1000
  local kb = love.keyboard

  if kb.isDown("right") then
    hero.body:applyAngularImpulse(100)
  elseif kb.isDown("left") then
    hero.body:applyAngularImpulse(-100)
  end

  local angle = hero.body:getAngle()

  local vx = math.cos(angle+math.rad(90)) * force
  local vy = math.sin(angle+math.rad(90)) * force

  if kb.isDown("down") then
    hero.body:applyForce(vx, vy)
  elseif kb.isDown("up") then
    hero.body:applyForce(-vx, -vy)
  end

  s = 0
  s = s + dt
  -- shoot
  if kb.isDown(" ")  and s > 0.005 then
    s = 0
    local x,y = hero.body:getWorldCenter()
    local l = unit.laser.new{x=x,y=y, rot=angle}
    l.unit.body:applyForce(-vx, -vy)
  end

end

function love.draw()
  for k,v in pairs(unit.getUnits()) do
    local x, y, x1, y1 = v.body:getWorldPoints(v.shape:getPoints())
    --love.graphics.draw(v.image, v.body:getX() + (0.5 * v.image:getHeight() * v.xscale), v.body:getY() + (0.5 * v.image:getWidth() * v.yscale), v.body:getAngle(), v.xscale, v.yscale)
    love.graphics.draw(v.image, x, y, v.body:getAngle(), v.xscale, v.yscale)

    --love.graphics.polygon('line', v.body:getWorldPoints(v.shape:getPoints()))

  end

  love.graphics.line(wall.body:getWorldPoints(wall.shape:getPoints()))

end
