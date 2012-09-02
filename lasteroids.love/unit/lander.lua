module(..., package.seeall)

bless = function(self)

  local shoot_state

  local state_idle = {
    enter = function(owner) owner.timer = love.timer.getTime() end,
    execute = function(owner)

      local hx, hy = hero.body:getWorldCenter()
      local ex, ey = owner.unit.body:getX(), owner.unit.body:getY()

      local deg = math.atan2(hy - ey, hx - ex) + math.deg(90)
      if deg > math.pi/2 then
        owner.unit.body:applyAngularImpulse(5000)
      else
        owner.unit.body:applyAngularImpulse(-5000)
      end

      local etime = love.timer.getTime()

      if etime - owner.timer > 0.1 then
        owner.timer = etime
        owner.fsm.changeState(shoot_state)
      end

    end,
    exit = function() end,
  }

  shoot_state = {
    execute = function(owner)
      local angle = owner.unit.body:getAngle()
      local fvx = math.cos(angle+math.rad(90)) * 5000
      local fvy = math.sin(angle+math.rad(90)) * 5000

      local xcenter = owner.unit.body:getLocalCenter()
      local x,y = owner.unit.body:getWorldPoint(xcenter, -125)
      local l = unit.laser.new{x=x, y=y, rot=angle}
      l.unit.body:setAngle(angle+math.deg(90))
      l.unit.body:applyLinearImpulse(-fvx, -fvy)

      owner.fsm.changeState(state_idle)

    end
  }

  self.fsm.changeState(state_idle)

  self.unit.fixture:setRestitution(0)
  self.unit.fixture:setFriction(1)
  self.unit.body:setAngularDamping(2)
  self.unit.fixture:setDensity(10)

  return self
end

new = function(t)

  local self = t or {}

  self.name = "lander"

  self.hp = 10
  self.maxhp = 10

  self.xscale = 0.50
  self.yscale = 0.50

  self.sprite = "lander_plain.png"

  return bless(ai.new(unit.new(self)))
end

