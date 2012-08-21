require("ai.fsm")

module(..., package.seeall)

aicount=1
ais = {}

new = function(unit)
  local self = {}
--  setmetatable(self,self)
--  self.__index = self

  self.unit = unit

  self.fsm = ai.fsm.new(self)

  ais[aicount] = self
  aicount = aicount + 1

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

