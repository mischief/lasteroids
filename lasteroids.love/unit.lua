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

  local self = t or {}

  -- members
  self.id = id
  id = id + 1
  units[id] = self

  self.name = self.name or name

  self.sprite = self.sprite or sprite
  self.image = love.graphics.newImage(self.sprite)

  self.x = self.x or x
  self.y = self.y or y

  self.xscale = self.xscale or xscale
  self.yscale = self.yscale or yscale

  self.rotation = self.rot or rotation

  self.hp = self.hp or hp
  self.maxhp = self.maxhp or maxhp
  self.speed = self.speed or speed
  self.armor = self.armor or armor
  self.armorclass = self.armorclass or armorclass
  self.shield = self.shield or shield

  self.body = love.physics.newBody(world, self.x, self.y, "dynamic")
  self.shape = love.physics.newRectangleShape(-(0.5*self.image:getWidth() * self.xscale), -(0.5*self.image:getHeight() * self.yscale), self.image:getWidth()*self.xscale, self.image:getHeight()*self.xscale)
  --[[
  self.shape = love.physics.newChainShape(true,
    self.x                                    ,  self.y,
    self.x + self.image:getWidth()*self.xscale,  self.y,
    self.x + self.image:getWidth()*self.xscale,  self.y + self.image:getHeight()*self.yscale,
    self.x                                    ,  self.y + self.image:getHeight()*self.yscale)
    --]]

  self.fixture = love.physics.newFixture(self.body, self.shape, 1)
  self.fixture:setRestitution(1)
  self.fixture:setFriction(1)

  -- methods
  self.getId = function()
    return self.id
  end

  self.getLoc = function()
    return self.x, self.y
  end

  self.update = function()
  end

--  setmetatable(self, self)
--  self.__index = self

  return self
end

getUnits = function()
  return units
end

