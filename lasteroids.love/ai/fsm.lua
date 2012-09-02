module(..., package.seeall)

-- make a new state machine
new = function(owner)
  local myself = {}

  myself.owner = owner
  myself.state = {}

  myself.update = function()
    if myself.state.execute then
      myself.state.execute(myself.owner)
    end
  end

  -- set state and dont call anything
  myself.setState = function(state)
    myself.state = state
  end

  -- transisition between states and call their enter/exit methods
  myself.changeState = function(state)
    if myself.state.exit then myself.state.exit(myself.owner) end
    myself.setState(state)
    if myself.state.enter then myself.state.enter(myself.owner) end
  end

  return myself
end
