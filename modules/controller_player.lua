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

local jump_speed = 100

local walk_speed = 300
local walk_ground_decay = 450
local walk_air_decay = 150
local max_walk_speed = 50

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

local function reset_euler_z()
	go.cancel_animations(go.get_id(), "euler.z")
	go.set(go.get_id(), "euler.z", 0)
end

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
		if self.jump_count < self.max_jump_count then
			-- If the player is dodging, then do not jump.
			-- Dodging forces zero gravity for x seconds, which would cause an abnormally high jump.
			if not self.dodging then
				reset_euler_z()
				-- If the player is already jumping, then this is a multi-jump.
				if self.jump_count > 0 then
					-- Do a barrel roll.
					go.animate(go.get_id(), "euler.z", go.PLAYBACK_ONCE_FORWARD, self.direction == 1 and -360 or 360, go.EASING_LINEAR, 1, 0, function()
						go.set(go.get_id(), "euler.z", 0)
					end)
				end
				-- If the player is diving, then cancel the dive.
				if self.diving then
					self.diving = false
					self.input.down = 0
				end
				self.velocity.y = jump_speed
				self.input.up = 0
				self.jump_count = self.jump_count + 1
			end
		end
	end
end

local function fall(self, dt)
	if not self.grounded then
		-- If the player is dodging, then force zero gravity until the dodge completes.
		if not self.dodging then
			self.velocity.y = utility.clamp(self.velocity.y - fall_speed * dt, -max_fall_speed, max_fall_speed)
		end
	end
end

local function dodge(self)
	if self.input.space ~= 0 then
		if not self.dodging then
			if self.dodge_count < self.max_dodge_count then
				self.velocity.y = 0
				self.dodge_count = self.dodge_count + 1
				self.dodging = true
				go.set(msg.url(nil, nil, "sprite"), "tint.w", 0.5)
				timer.delay(0.25, false, function()
					go.set(msg.url(nil, nil, "sprite"), "tint.w", 1)
					self.input.space = 0
					self.dodging = false
				end)
			end
		end
	end
end

local function dive(self)
	if self.input.down ~= 0 then
		if not self.diving then
			if not self.grounded then
				reset_euler_z()
				go.set(go.get_id(), "euler.z", self.direction == 1 and -180 or 180)
				self.velocity.y = -max_fall_speed
				self.input.down = 0
				self.diving = true
			end
		end
	end
end

local function collide_ground(self)
	self.velocity.y = 0
	self.input.up = 0
	self.input.down = 0
	self.jump_count = 0
	self.max_jump_count = 2
	self.grounded = true
	self.dodge_count = 0
	self.max_dodge_count = 1
	self.diving = false
	reset_euler_z()
end

local function collide(self)
	self.grounded = false
	local position = go.get_position()
	for index, ray_destination in ipairs(ray_destinations) do
		local ray_origin = position + ray_origin_offset
		local result = physics.raycast(ray_origin, ray_origin + ray_destination, ray_masks)
		if draw_rays then
			msg.post(msg.url("@render", nil, nil), h_str.draw_line, { start_point = ray_origin, end_point = ray_origin + ray_destination, color = result and dcolors.palette["green"] or dcolors.palette["red"] })
		end
		if result then
			local penetration = vmath.vector3(result.normal.x * ray_length.x, result.normal.y * ray_length.y, 0) * (1 - result.fraction)
			position = position + penetration
			go.set_position(position)
			if math.abs(result.normal.x) == 1 then
				self.velocity.x = 0
			end
			if result.normal.y > 0 then
				collide_ground(self)
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
	self.dodge_count = 0
	self.dodging = false
	self.diving = false
	self.animation = h_str.animation_idle_right
end

function controller.fixed_update(self, dt)
	walk(self, dt)
	jump(self)
	fall(self, dt)
	dodge(self)
	dive(self)
	go.set_position(go.get_position() + self.velocity * dt)
	collide(self)
	animate(self)
end

function controller.on_input(self, action_id, action)
	if action.pressed then
		if action_id == h_str.key_w or action_id == h_str.gamepad_lstick_up then
			self.input.up = 1
		elseif action_id == h_str.key_a or action_id == h_str.gamepad_lstick_left then
			self.input.left = -1
		elseif action_id == h_str.key_s or action_id == h_str.gamepad_lstick_down then
			self.input.down = -1
		elseif action_id == h_str.key_d or action_id == h_str.gamepad_lstick_right then
			self.input.right = 1
		elseif action_id == h_str.key_space or action_id == h_str.gamepad_rpad_down then
			self.input.space = 1
		end
	elseif action.released then
		if action_id == h_str.key_w or action_id == h_str.gamepad_lstick_up then
			self.input.up = 0
		elseif action_id == h_str.key_a or action_id == h_str.gamepad_lstick_left then
			self.input.left = 0
		elseif action_id == h_str.key_s or action_id == h_str.gamepad_lstick_down then
			self.input.down = 0
		elseif action_id == h_str.key_d or action_id == h_str.gamepad_lstick_right then
			self.input.right = 0
		elseif action_id == h_str.key_space or action_id == h_str.gamepad_rpad_down then
			self.input.space = 0
		end
	end
end

return controller