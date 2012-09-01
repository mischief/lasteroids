module(..., package.seeall)

-- make a new state machine
new = function(owner)
  local myself = {}
  setmetatable(myself, myself)
  myself.__index = myself

  myself.owner = owner
  myself.state = {}

  myself.update = function()
      myself.state.execute(myself.owner)
  end

  -- set state and dont call anything
  myself.setState = function(state)
    myself.state = state
  end

  -- transisition between states and call their enter/exit methods
  myself.changeState = function(state)
    if myself.state.exit then myself.state.exit(myself.owner) end
    myself.state = state
    if myself.state.enter then myself.state.enter(myself.owner) end
  end

  return myself
end
