module(..., package.seeall)

-- make a new state machine
new = function(owner)
  local self = {}
  setmetatable(self, self)
  self.__index = self

  self.owner = owner
  self.state = {}

  self.update = function()
      self.state.execute(owner)
  end

  -- set state and dont call anything
  self.setState = function(state)
    self.state = state
  end

  -- transisition between states and call their enter/exit methods
  self.changeState = function(state)
    if self.state.exit then self.state.exit(owner) end
    self.state = state
    self.state.enter(owner)
  end

  return self
end
