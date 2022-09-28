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

----------------------------------------------------------------------
-- CUSTOM MESSAGES
----------------------------------------------------------------------

h_str.message_init_monarch = hash("message_init_monarch")
h_str.message_start_event = hash("message_start_event")
h_str.message_start_sound = hash("message_start_sound")
h_str.message_stop_sound = hash("message_stop_sound")

----------------------------------------------------------------------
-- COLLECTIONS
----------------------------------------------------------------------

h_str.collection_main = hash("collection_main")
h_str.collection_boot = hash("collection_boot")
h_str.collection_game = hash("collection_game")

----------------------------------------------------------------------
-- INPUT ACTIONS
----------------------------------------------------------------------

h_str.key_esc = hash("key_esc")
h_str.key_f11 = hash("key_f11")
h_str.key_w = hash("key_w")
h_str.key_a = hash("key_a")
h_str.key_s = hash("key_s")
h_str.key_d = hash("key_d")

----------------------------------------------------------------------
-- GUI NODES
----------------------------------------------------------------------

h_str.node_boot = hash("node_boot")

----------------------------------------------------------------------
-- COLLISION GROUPS
----------------------------------------------------------------------

h_str.collision_character = hash("collision_character")
h_str.collision_tilemap = hash("collision_tilemap")

----------------------------------------------------------------------
-- ANIMATION FRAMES
----------------------------------------------------------------------



return h_str