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

local fall_speed = 300
local max_fall_speed = 125

local brittle_knockback = 0.5

local jump_speed = 100
local max_jump_count = 10

local walk_speed = 300
local walk_ground_decay = 450
local walk_air_decay = 150
local max_walk_speed = 50

local max_spin_count = 1

local draw_ray_vectors = false

local ray_length = vmath.vector3(2, 4, 0)
local ray_vectors =
{
	vmath.vector3(-ray_length.x, -ray_length.y, 0),
	vmath.vector3(ray_length.x, -ray_length.y, 0),
	vmath.vector3(-ray_length.x, ray_length.y, 0),
	vmath.vector3(ray_length.x, ray_length.y, 0)
}
local ray_masks =
{
	hash("collision_solid"),
	hash("collision_brittle")
}
local ray_mask_ids =
{
	solid = hash("collision_solid"),
	brittle = hash("collision_brittle")
}

----------------------------------------------------------------------
-- LOCAL FUNCTIONS
----------------------------------------------------------------------

local function walk(self, dt)
	local direction = self.input.left + self.input.right
	if direction ~= 0 then
		self.velocity.x = utility.clamp(self.velocity.x + walk_speed * direction * dt, -max_walk_speed, max_walk_speed)
		self.direction = direction
	elseif self.velocity.x > 0 then
		self.velocity.x = utility.clamp(self.velocity.x - (self.grounded and walk_ground_decay or walk_air_decay) * dt, 0, max_walk_speed)
	elseif self.velocity.x < 0 then
		self.velocity.x = utility.clamp(self.velocity.x + (self.grounded and walk_ground_decay or walk_air_decay) * dt, -max_walk_speed, 0)
	end
end

local function jump(self)
	if self.input.up ~= 0 then
		if self.jump_count < max_jump_count then
			if not self.spinning then
				self.velocity.y = jump_speed
				self.input.up = 0
				self.jump_count = self.jump_count + 1
			end
		end
	end
end

local function fall(self, dt)
	if not self.grounded then
		if not self.spinning then
			self.velocity.y = utility.clamp(self.velocity.y - fall_speed * dt, -max_fall_speed, max_fall_speed)
		end
	end
end

local function spin(self)
	if self.input.space ~= 0 then
		if not self.spinning then
			if self.grounded or self.spin_count < max_spin_count then
				go.animate(msg.url(nil, go.get_id(), nil), "euler.y", go.PLAYBACK_ONCE_PINGPONG, 90, go.EASING_LINEAR, 0.25, 0, function()
					go.set(msg.url(nil, go.get_id(), nil), "euler.y", 0)
					self.input.space = 0
					self.spinning = false
				end)
				self.velocity.y = 0
				self.spin_count = self.spin_count + 1
				self.spinning = true
			end
		end
	end
end

local function dive(self)
	if self.input.down ~= 0 then
		if not self.diving then
			if not self.grounded then
				go.set(msg.url(nil, go.get_id(), nil), "euler.z", self.direction == 1 and -180 or 180)
				self.velocity.y = -max_fall_speed
				self.input.down = 0
				self.diving = true
			end
		end
	end
end

local function collide_solid(self)
	self.velocity.y = 0
	self.input.up = 0
	self.input.down = 0
	self.jump_count = 0
	self.grounded = true
	self.spin_count = 0
	if self.diving then
		self.diving = false
		go.set(msg.url(nil, go.get_id(), nil), "euler.z", 0)
	end
end

local function collide_brittle(self)
	self.velocity.y = self.velocity.y * brittle_knockback
	msg.post(msg.url(nil, "/game", "script"), h_str.message_break_brittle)
end

local function collide(self)
	self.grounded = false
	local position = go.get_position()
	for index, ray_vector in ipairs(ray_vectors) do
		local result = physics.raycast(position, position + ray_vector, ray_masks)
		if draw_ray_vectors then
			msg.post(msg.url("@render", nil, nil), h_str.draw_line, { start_point = position, end_point = position + ray_vector, color = result and dcolors.palette["green"] or dcolors.palette["red"] })
		end
		if result then
			local penetration = vmath.vector3(result.normal.x * ray_length.x, result.normal.y * ray_length.y, 0) * (1 - result.fraction)
			position = position + penetration
			go.set_position(position)
			if math.abs(result.normal.x) == 1 then
				self.velocity.x = 0
			end
			if result.normal.y > 0 then
				if result.group == ray_mask_ids.solid then
					collide_solid(self)
				elseif result.group == ray_mask_ids.brittle then
					if self.diving then
						collide_brittle(self)
					else
						collide_solid(self)
					end
				end
			elseif result.normal.y < 0 then
				if self.velocity.y > 0 then
					self.velocity.y = 0
				end
			end
		end
	end
end

local function animate(self)
	local animation = self.animation
	if self.direction == 1 then
		if not self.grounded then
			animation = h_str.animation_fall_right
		elseif self.velocity.x ~= 0 then
			animation = h_str.animation_walk_right
		else
			animation = h_str.animation_idle_right
		end
	elseif self.direction == -1 then
		if not self.grounded then
			animation = h_str.animation_fall_left
		elseif self.velocity.x ~= 0 then
			animation = h_str.animation_walk_left
		else
			animation = h_str.animation_idle_left
		end
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
	self.input = { left = 0, right = 0, up = 0, down = 0, space = 0 }
	self.velocity = vmath.vector3()
	self.grounded = false
	self.jump_count = 0
	self.direction = 1
	self.spin_count = 0
	self.spinning = false
	self.diving = false
	self.animation = h_str.animation_idle_right
end

function controller.fixed_update(self, dt)
	walk(self, dt)
	jump(self)
	fall(self, dt)
	spin(self)
	dive(self)
	go.set_position(go.get_position() + self.velocity * dt)
	collide(self)
	animate(self)
end

function controller.on_input(self, action_id, action)
	if action.pressed then
		if action_id == h_str.key_w then
			self.input.up = 1
		elseif action_id == h_str.key_a then
			self.input.left = -1
		elseif action_id == h_str.key_s then
			self.input.down = -1
		elseif action_id == h_str.key_d then
			self.input.right = 1
		elseif action_id == h_str.key_space then
			self.input.space = 1
		end
	elseif action.released then
		if action_id == h_str.key_w then
			self.input.up = 0
		elseif action_id == h_str.key_a then
			self.input.left = 0
		elseif action_id == h_str.key_s then
			self.input.down = 0
		elseif action_id == h_str.key_d then
			self.input.right = 0
		elseif action_id == h_str.key_space then
			self.input.space = 0
		end
	end
end

return controller