--local unit = require("unit")
--local ai = require("ai")
--local math = math
module(..., package.seeall)

bless = function(self)

  local state_idle = {
    enter = function() self.timer = 0 end,
    execute = function(owner)

      --local hx, hy = hero.body:getX(), hero.body:getY()
      local hx, hy = hero.body:getWorldCenter()
      local ex, ey = owner.unit.body:getX(), owner.unit.body:getY()

      local deg = math.atan2(hy - ey, hx - ex)
      self.unit.body:setAngle(deg+math.rad(90))

    end,
    exit = function() end,
  }

  self.fsm.state = state_idle

  return self
end

new = function(t)

  local self = t or {}

  self.name = "Lander"

  self.hp = 100
  self.maxhp = 100

  self.rot = math.rad(180)
  self.xscale = 0.50
  self.yscale = 0.50

  self.sprite = "lander_plain.png"

  return bless(ai.new(unit.new(self)))
end

