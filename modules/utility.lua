----------------------------------------------------------------------
-- DEPENDENCIES
----------------------------------------------------------------------

local h_str = require "modules.h_str"

----------------------------------------------------------------------
-- PROPERTIES
----------------------------------------------------------------------

local utility = {}

----------------------------------------------------------------------
-- MODULE FUNCTIONS
----------------------------------------------------------------------

function utility.clamp(value, min, max)
	if value < min then
		return min
	end
	if value > max then
		return max
	end
	return value
end

function utility.round(value)
	return math.floor(value + 0.5)
end

function utility.next_index(index, length)
	index = (index + 1) % (length + 1)
	if index == 0 then
		index = 1
	end
	return index
end

function utility.previous_index(index, length)
	index = index - 1
	if index == 0 then
		index = length
	end
	return index
end

function utility.tile_position(pixel_position, offset, tile_width, tile_height)
	return vmath.vector3(math.floor((pixel_position.x + offset.x) / tile_width + 1), math.floor((pixel_position.y + offset.y) / tile_height + 1), 0)
end

function utility.pixel_position(tile_position, offset, tile_width, tile_height)
	return vmath.vector3((tile_position.x - 1) * tile_width - offset.x, (tile_position.y - 1) * tile_height - offset.y, 0)
end

function utility.distance(from, to)
	return vmath.vector3(to.x - from.x, to.y - from.y, 0)
end

function utility.unit_distance(from, to)
	return vmath.normalize(utility.distance(from, to))
end

function utility.angle(from, to)
	return math.deg(math.atan2(to.y - from.y, to.x - from.x))
end

function utility.start_event(id)
	msg.post(msg.url("collection_main", "/event", "script"), h_str.message_start_event, { id = id })
end

function utility.start_sound(id)
	msg.post(msg.url("collection_main", "/sound", "script"), h_str.message_start_sound, { id = id })
end

function utility.stop_sound(id)
	msg.post(msg.url("collection_main", "/sound", "script"), h_str.message_stop_sound, { id = id })
end

return utility