----------------------------------------------------------------------
-- PROPERTIES
----------------------------------------------------------------------

local h_str = {}

----------------------------------------------------------------------
-- ENGINE MESSAGES
----------------------------------------------------------------------

h_str.acquire_input_focus = hash("acquire_input_focus")
h_str.release_input_focus = hash("release_input_focus")

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

----------------------------------------------------------------------
-- GUI NODES
----------------------------------------------------------------------

h_str.node_boot = hash("node_boot")

return h_str