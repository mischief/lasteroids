require("ai.fsm")

module(..., package.seeall)

aicount=1
ais = {}

new = function(unit)
  local self = {}

  ais[aicount] = self
  aicount = aicount + 1

  self.unit = unit

  self.fsm = ai.fsm.new(self)

  self.unit.fixture:setUserData(self)

  self.destroy = function()
    self.unit.destroy()
    self.fsm.changeState({})
  end

  return self
end

getAIs = function()

  return ais

end

updateAI = function()

  for k,v in ipairs(getAIs()) do
    v.fsm.update()
  end

end

