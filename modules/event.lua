----------------------------------------------------------------------
-- DEPENDENCIES
----------------------------------------------------------------------

local h_str = require "modules.h_str"

----------------------------------------------------------------------
-- PROPERTIES
----------------------------------------------------------------------

local event = {}

local no_event = 0

----------------------------------------------------------------------
-- LOCAL FUNCTIONS
----------------------------------------------------------------------

----------------------------------------------------------------------
-- MODULE FUNCTIONS
----------------------------------------------------------------------

function event.init(self)
	if self.event_id == no_event then
		msg.post(msg.url(nil, nil, "collisionobject_event"), h_str.disable)
	end
end

function event.final(self)
	if self.ellipsis then
		go.delete(self.ellipsis)
	end
end

function event.on_message(self, message_id, message)
	if message_id == h_str.trigger_response then
		if message.enter then
			self.ellipsis = factory.create(msg.url(nil, hash("/factory_stuff"), "factory_ellipsis"), go.get_position() + vmath.vector3(0, 8, 0))
		else
			go.delete(self.ellipsis)
			self.ellipsis = nil
		end
	end
end

return event