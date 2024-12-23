#extends CharacterBody2D
extends Node2D

class_name Entity

@export var is_active: bool = true
@export var spawned_in_editor: bool = true
@export var stats: EntityStats

@export var minimap_icon: String
@export var display_name: String
@export var str_type: String
@export var icon: CompressedTexture2D
@export var vision_range: int = 200
@export var controlled_by: int = 1
var scene: String
var attacker_id: int

func is_in_same_team(player_id):
	return controlled_by == player_id

func trigger_action(action):
	if action is Build:
		self.build.set_action_build_mode(action)
		return
	if self.action_controller:
		var player = GameManager.get_player(multiplayer.get_unique_id())
		if self.action_controller.can_queue_action() and player.can_spend_currency(action.cost):
			player.spend_currency(action.cost)
			self.action_controller.add_queue_action(action, global_position + Vector2(0, 30))
