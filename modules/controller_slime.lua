----------------------------------------------------------------------
-- DEPENDENCIES
----------------------------------------------------------------------

local h_str = require "modules.h_str"
local utility = require "modules.utility"
local dcolors = require "dcolors.dcolors"

----------------------------------------------------------------------
-- PROPERTIES
----------------------------------------------------------------------

local controller = {}

local draw_rays = false
local ray_origin_offset = vmath.vector3(0, -0.5, 0)
local ray_length = vmath.vector3(2, 3.5, 0)
local ray_destinations =
{
	vmath.vector3(-ray_length.x, -ray_length.y, 0),
	vmath.vector3(ray_length.x, -ray_length.y, 0),
	vmath.vector3(-ray_length.x, ray_length.y, 0),
	vmath.vector3(ray_length.x, ray_length.y, 0)
}
local ray_masks =
{
	hash("collision_solid"),
	hash("collision_brittle"),
	hash("collision_character")
}

----------------------------------------------------------------------
-- LOCAL FUNCTIONS
----------------------------------------------------------------------

local function walk(self, dt)
	
end

local function fall(self, dt)
	
end

local function collide(self)
	
end

local function animate(self)
	local animation = self.animation
	if self.direction == 1 then
		animation = h_str.animation_idle_right
	elseif self.direction == -1 then
		animation = h_str.animation_idle_left
	end
	if self.animation ~= animation then
		self.animation = animation
		sprite.play_flipbook(msg.url(nil, nil, "sprite"), animation)
	end
end

----------------------------------------------------------------------
-- MODULE FUNCTIONS
----------------------------------------------------------------------

function controller.init(self)
	self.velocity = vmath.vector3()
	self.grounded = false
	self.direction = 1
	self.animation = h_str.animation_idle_right
end

function controller.fixed_update(self, dt)
	walk(self, dt)
	fall(self, dt)
	go.set_position(go.get_position() + self.velocity * dt)
	collide(self)
	animate(self)
end

return controller