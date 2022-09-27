local h_str = require "modules.h_str"

local controller = {}

local gravity = 4

local function collision_response(self)
	
end

function controller.init(self)
	self.velocity = vmath.vector3()
end

function controller.update(self, dt)
	self.velocity.y = self.velocity.y - gravity * dt
	go.set_position(go.get_position() + self.velocity)
end

function controller.on_input(self, action_id, action)
	if action.pressed then
		
	elseif action.released then
		
	end
end

return controller