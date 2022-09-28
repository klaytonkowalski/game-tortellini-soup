local h_str = require "modules.h_str"
local utility = require "modules.utility"
local dcolors = require "dcolors.dcolors"

local controller = {}

local fall_speed = 300
local max_fall_speed = 600

local jump_speed = 100
local max_jump_count = 2

local walk_speed = 300
local walk_ground_decay = 450
local walk_air_decay = 150
local max_walk_speed = 50

local draw_ray_vectors = true

local ray_length = vmath.vector3(3, 4, 0)
local ray_vectors =
{
	vmath.vector3(-ray_length.x, -ray_length.y, 0),
	vmath.vector3(ray_length.x, -ray_length.y, 0),
	vmath.vector3(-ray_length.x, ray_length.y, 0),
	vmath.vector3(ray_length.x, ray_length.y, 0)
}
local ray_masks =
{
	hash("collision_tilemap")
}

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
			if result.normal.x ~= 0 then
				self.velocity.x = 0
			end
			if result.normal.y > 0 then
				self.velocity.y = 0
				self.input.up = 0
				self.jump_count = 0
				self.grounded = true
			elseif result.normal.y < 0 then
				self.velocity.y = 0
			end
		end
	end
end

function controller.init(self)
	self.input = { left = 0, right = 0, up = 0 }
	self.velocity = vmath.vector3()
	self.grounded = false
	self.jump_count = 0
end

function controller.update(self, dt)
	local direction = self.input.left + self.input.right
	if direction ~= 0 then
		self.velocity.x = utility.clamp(self.velocity.x + walk_speed * direction * dt, -max_walk_speed, max_walk_speed)
	elseif self.velocity.x > 0 then
		self.velocity.x = utility.clamp(self.velocity.x - (self.grounded and walk_ground_decay or walk_air_decay) * dt, 0, max_walk_speed)
	elseif self.velocity.x < 0 then
		self.velocity.x = utility.clamp(self.velocity.x + (self.grounded and walk_ground_decay or walk_air_decay) * dt, -max_walk_speed, 0)
	end
	if self.input.up ~= 0 then
		if self.jump_count < max_jump_count then
			self.velocity.y = jump_speed
			self.input.up = 0
			self.jump_count = self.jump_count + 1
		end
	end
	if not self.grounded then
		self.velocity.y = utility.clamp(self.velocity.y - fall_speed * dt, -max_fall_speed, max_fall_speed)
	end
	go.set_position(go.get_position() + self.velocity * dt)
	collide(self)
end

function controller.on_input(self, action_id, action)
	if action.pressed then
		if action_id == h_str.key_w then
			self.input.up = 1
		elseif action_id == h_str.key_a then
			self.input.left = -1
		elseif action_id == h_str.key_d then
			self.input.right = 1
		end
	elseif action.released then
		if action_id == h_str.key_w then
			self.input.up = 0
		elseif action_id == h_str.key_a then
			self.input.left = 0
		elseif action_id == h_str.key_d then
			self.input.right = 0
		end
	end
end

return controller