module(..., package.seeall)

bless = function(myself)

  myself.timer = love.timer.getTime()

  local blow_up_state = {
    enter = function() myself.timer = love.timer.getTime() end,
    execute = function(owner)
      local etime = love.timer.getTime()
      if etime - myself.timer > 5 then
        myself.destroy()
      end
    end,
    exit = function() end,
  }

  myself.fsm.state = blow_up_state

  myself.unit.fixture:setRestitution(0.2)
  myself.unit.fixture:setFriction(0.5)

  return myself
end

new = function(t)

  local myself = t or {}

  myself.name = "laser"

  myself.hp = 1
  myself.maxhp = 1

  myself.sprite = "laser.png"

  return bless(ai.new(unit.new(myself)))
end

