extends Node2D

enum Entity {
}

enum CurrencyType {
	Gold,
	Faith,
	Materials,
}

var Players = {}
const entities = {
}

enum KingUnits {
	knight,
}

enum Factions {
	King,
	Mercenary,
	Farmer
}

const factions_attributes = {
	Factions.King: {
		"color": [Color.DARK_RED, Color.DARK_MAGENTA, Color.DARK_SLATE_BLUE],
		"name": "King"
	},
	Factions.Mercenary: {
		"color": [Color.DARK_VIOLET, Color.DARK_CYAN, Color.DARK_GOLDENROD],
		"name": "Mercenary"
	},
	Factions.Farmer: {
		"color": [Color.DARK_KHAKI, Color.DARK_ORANGE, Color.DARK_GRAY],
		"name": "Farmer",
	},
	-1: {
		"color": [Color.BLACK],
		"name": ""
	}
}

func set_player_experience(player_id, value):
	var player = get_node_or_null("/root/Multiplayer/Network/"+str(player_id))
	if not player:
		return null	
	player.set_experience.rpc_id(player_id, value)

func get_level_outposts():
	var node = get_node_or_null("/root/Multiplayer/Level")
	if !node:
		return null
	var level_loaded = node.get_children()
	if level_loaded.size() <= 0:
		return null
	return level_loaded[0].get_outposts()

func get_level_tilemap():
	var node = get_node_or_null("/root/Multiplayer/Level")
	if !node:
		return null
	var level_loaded = node.get_children()
	if level_loaded.size() <= 0:
		print("level not loaded")
		return null
	return level_loaded[0].get_tilemap()

func spawn_entity(scene: String, informations: Dictionary):
	if not multiplayer.is_server():
		return
	var info = informations
	var multi = get_node_or_null("/root/Multiplayer/Control")
	if !multi:
		return null
	info.merge({"scene": scene})
	multi.entity_spawner.spawn(info)

func spawn_character(scene, info):
	var spawner = get_node_or_null("/root/Multiplayer/"+str(info["controlled_by"]))
	if !spawner:
		return
	info.merge({"scene": scene})
	spawner.spawner.spawn(info)
	
@rpc("any_peer", "call_local")
func remove_entity(path):
	var entity = get_node_or_null(path)
	if not entity:
		return
	entity.queue_free()

func get_player_color(player_id):
	if player_id != 0 and player_id in Players.keys():
		return Players[player_id]["color"]
	return Color.GRAY

func get_player(player_id):
	return get_node_or_null("/root/Multiplayer/Network/"+str(player_id))
