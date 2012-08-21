--local unit = require("unit")
--local ai = require("ai")
--local math = math
module(..., package.seeall)

bless = function(self)

  local state_idle = {
    enter = function() self.timer = 0 end,
    execute = function()

      local deg = math.atan2(hero.body:getY() - self.unit.y, hero.body:getX() - self.unit.x)
      self.unit.rotation = deg+math.rad(90)

    end,
    exit = function() end,
  }

  self.fsm.state = state_idle

  return self
end

new = function(t)

  local self = t or {}

  self.hp = 100
  self.maxhp = 100

  self.rot = math.rad(180)
  self.xscale = 0.50
  self.yscale = 0.50

  self.sprite = "lander_plain.png"

  return bless(ai.new(unit.new(self)))
end

