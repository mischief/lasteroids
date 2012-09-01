-- local setmetatable = setmetatable
module(..., package.seeall)

-- table of all units
local units = {}

-- unique id
local id = 0

-- default name, sprite, coordinates, x scale, y scale
local name = "unit"
local sprite = "lander_plain.png"
local x = 300
local y = 300
local xscale = 1.00
local yscale = 1.00
local rotation = math.rad(0)

-- other defaults
local hp = 100
local maxhp = 100
local armor = 1
local armorclass = 1
local shield = 10
local speed = 50

-- make a new unit
--  t is a table of:
--    name, sprite, x, y, xscale, yscale, rot
--    hp, maxhp, speed
--    armor, armorclass, shield

new = function(t)

  local myself = t or {}

  -- members
  myself.id = id
  id = id + 1
  units[myself.id] = myself

  myself.name = myself.name or name

  myself.sprite = myself.sprite or sprite
  myself.image = love.graphics.newImage(myself.sprite)

  myself.x = myself.x or x
  myself.y = myself.y or y

  myself.xscale = myself.xscale or xscale
  myself.yscale = myself.yscale or yscale

  myself.rotation = myself.rot or rotation

  myself.hp = myself.hp or hp
  myself.maxhp = myself.maxhp or maxhp
  myself.speed = myself.speed or speed
  myself.armor = myself.armor or armor
  myself.armorclass = myself.armorclass or armorclass
  myself.shield = myself.shield or shield

  myself.body = love.physics.newBody(world, myself.x, myself.y, "dynamic")
  myself.shape = love.physics.newRectangleShape(-(0.5*myself.image:getWidth() * myself.xscale), -(0.5*myself.image:getHeight() * myself.yscale), myself.image:getWidth()*myself.xscale, myself.image:getHeight()*myself.xscale)

  myself.fixture = love.physics.newFixture(myself.body, myself.shape, 1)
  myself.fixture:setUserData(myself.name .. ' ' .. myself.id)
  myself.fixture:setRestitution(0)
  myself.fixture:setFriction(0)

  -- methods
  myself.getId = function()
    return myself.id
  end

  myself.getLoc = function()
    return myself.x, myself.y
  end

  myself.update = function()
  end

  -- stupid bug, uncomment destroy
  myself.destroy = function()
    --myself.body:destroy()
    units[myself.getId()] = nil
  end

--  setmetatable(myself, myself)
--  myself.__index = myself

  return myself
end

getUnits = function()
  return units
end

