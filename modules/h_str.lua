----------------------------------------------------------------------
-- PROPERTIES
----------------------------------------------------------------------

local h_str = {}

----------------------------------------------------------------------
-- ENGINE MESSAGES
----------------------------------------------------------------------

h_str.acquire_input_focus = hash("acquire_input_focus")
h_str.release_input_focus = hash("release_input_focus")
h_str.draw_line = hash("draw_line")
h_str.trigger_response = hash("trigger_response")
h_str.enable = hash("enable")
h_str.disable = hash("disable")

----------------------------------------------------------------------
-- CUSTOM MESSAGES
----------------------------------------------------------------------

h_str.message_init_monarch = hash("message_init_monarch")
h_str.message_start_event = hash("message_start_event")
h_str.message_start_sound = hash("message_start_sound")
h_str.message_stop_sound = hash("message_stop_sound")
h_str.message_load_level_absolute = hash("message_load_level_absolute")
h_str.message_load_level_relative = hash("message_load_level_relative")
h_str.message_break_brittle = hash("message_break_brittle")

----------------------------------------------------------------------
-- COLLECTIONS
----------------------------------------------------------------------

h_str.collection_main = hash("collection_main")
h_str.collection_boot = hash("collection_boot")
h_str.collection_game = hash("collection_game")
h_str.collection_editor = hash("collection_editor")

----------------------------------------------------------------------
-- INPUT ACTIONS
----------------------------------------------------------------------

h_str.key_esc = hash("key_esc")
h_str.key_f11 = hash("key_f11")
h_str.key_w = hash("key_w")
h_str.key_a = hash("key_a")
h_str.key_s = hash("key_s")
h_str.key_d = hash("key_d")
h_str.key_space = hash("key_space")

h_str.gamepad_start = hash("gamepad_start")
h_str.gamepad_back = hash("gamepad_back")
h_str.gamepad_lstick_up = hash("gamepad_lstick_up")
h_str.gamepad_lstick_left = hash("gamepad_lstick_left")
h_str.gamepad_lstick_down = hash("gamepad_lstick_down")
h_str.gamepad_lstick_right = hash("gamepad_lstick_right")
h_str.gamepad_rpad_down = hash("gamepad_rpad_down")

----------------------------------------------------------------------
-- GUI NODES
----------------------------------------------------------------------

h_str.node_boot = hash("node_boot")

----------------------------------------------------------------------
-- COLLISION GROUPS
----------------------------------------------------------------------

h_str.collision_character = hash("collision_character")
h_str.collision_solid = hash("collision_solid")
h_str.collision_brittle = hash("collision_brittle")
h_str.collision_load = hash("collision_load")
h_str.collision_event = hash("collision_event")

----------------------------------------------------------------------
-- ANIMATION FRAMES
----------------------------------------------------------------------

h_str.animation_idle_right = hash("idle_right")
h_str.animation_idle_left = hash("idle_left")
h_str.animation_walk_left = hash("walk_left")
h_str.animation_walk_right = hash("walk_right")
h_str.animation_fall_left = hash("fall_left")
h_str.animation_fall_right = hash("fall_right")

return h_str