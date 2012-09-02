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

  world:setCallbacks(function(a, b, coll)
    local aud = a:getUserData()
    local bud = b:getUserData()

    if aud and aud.unit and bud and bud.unit then
      if aud.unit.name == "laser" and bud.unit.name == "laser" then
        aud.destroy()
        bud.destroy()
      end

      if aud.unit.name == "laser" and bud.unit.name == "wall" then
        aud.destroy()
      end

      if aud.unit.name == "lander" and bud.unit.name == "laser" then
        aud.unit.hp = aud.unit.hp - 1
        if aud.unit.hp < 1 then
          aud.destroy()
        end
        bud.destroy()
      end

      if aud.name == "hero" and bud.unit.name == "laser" then
        aud.hp = aud.hp - 1
        if aud.hp < 1 then
          aud.destroy()
        end
        bud.destroy()
      end

      if aud.unit.name == "laser" and bud.name == "hero" then
        bud.hp = bud.hp - 1
        if bud.hp < 1 then
          bud.destroy()
        end
        aud.destroy()
      end
    end
  end)

  wall = {}
  wall.body = love.physics.newBody(world, 0, 0, "static")
  wall.shape = love.physics.newChainShape(true, 50, 50, love.graphics.getWidth() - 50, 50, love.graphics.getWidth() - 50, love.graphics.getHeight() - 50, 50, love.graphics.getHeight() - 50)
  wall.fixture = love.physics.newFixture(wall.body, wall.shape)

  for i=1,2 do
    local l = unit.lander.new{y=100, x=100+50*i}
  end


  hero = unit.new{name="hero", sprite="galaga_ship.png", x=250, y=250, speed=200, xscale=0.25, yscale=0.25}
  hero.fixture:setRestitution(0)
  hero.fixture:setFriction(1)
  hero.body:setAngularDamping(0.6)
  hero.fixture:setDensity(100)

end

-- keyboard keypress callback
function love.keypressed(k)

  -- quit on ESC
  if k == "escape" then
    love.event.push("quit")
  end

end

aitimer = 0
shoottimer = 0

function love.update(dt)
  world:update(dt)

--  local aidelta = love.timer.getTime()
--  if aidelta - aitimer > 0.1 then
--    aitimer = aidelta
    for k,v in pairs(ai.getAIs()) do
      v.fsm.update()
    end
--  end

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

  -- shoot
  local shootdelta = love.timer.getTime()
  if kb.isDown(" ")  and shootdelta - shoottimer > 0.125 then
    shoottimer = shootdelta
    local xcenter = hero.body:getLocalCenter()
    local x,y = hero.body:getWorldPoint(xcenter, -75)
    local l = unit.laser.new{x=x,y=y}
    l.unit.body:setAngle(angle+math.deg(90))
    l.unit.body:applyLinearImpulse(-vx/2, -vy/2)
  end

end

function love.draw()
  for k,v in pairs(unit.getUnits()) do
    local x, y, x1, y1 = v.body:getWorldPoints(v.shape:getPoints())
    love.graphics.draw(v.image, x, y, v.body:getAngle(), v.xscale, v.yscale)

    local xc, yc = v.body:getWorldCenter()
    love.graphics.print(v.name .. ':' .. v.id .. ' HP:' .. v.hp, xc+25, yc+25)

    --love.graphics.polygon('line', v.body:getWorldPoints(v.shape:getPoints()))

  end

  love.graphics.line(wall.body:getWorldPoints(wall.shape:getPoints()))

end
