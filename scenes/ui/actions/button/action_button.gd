extends PanelContainer

class_name ActionButton

@export var cooldown_background: Control
@export var cooldown_label: Label
@export var cooldown: Timer
@export var button: Button
@export var hover_texture: TextureRect
@export var icon: TextureRect
@export var key: InputEventAction
@export var parent_panel: ActionPanel

var action: Action

var can_start: bool = true

signal ActionButtonPressed

func hide_cooldown_status():
	cooldown_background.visible = false
	cooldown_label.visible = false

func show_cooldown_background():
	cooldown_background.visible = true
	cooldown_label.visible = true

func set_action_icon(_action: Action):
	self.show()
	action = _action
	icon.texture = _action.icon
	cooldown.wait_time = _action.cooldown.wait_time
	
func cooldown_finished():
	can_start = true
	
func _ready():
	cooldown.timeout.connect(cooldown_finished)
	if key:
		var shortcut = Shortcut.new()
		shortcut.set_events([key])
		button.set_shortcut(shortcut)

#func get_cost_tooltip(action):
	#var text:
	#for cost in action.cost:

func _process(_delta):
	if can_buy():
		button.disabled = false
		icon.modulate = Color(1, 1, 1, 1)
		#button.tooltip_text = action.description
	else:
		icon.modulate = Color(1, 1, 1, 0.3)
		#button.tooltip_text = "Not enough currency"
		button.disabled = true

	if cooldown.time_left != 0:
		cooldown_label.text = str(cooldown.time_left).substr(0, 3)
	elif cooldown.time_left == 0:
		hide_cooldown_status()

func _on_button_pressed():
	if can_start and can_buy():
		cooldown.start()
		can_start = false
		ActionButtonPressed.emit(action)
		show_cooldown_background()

func can_buy():
	if not is_instance_valid(action):
		return false
	var player_id = multiplayer.get_unique_id()
	if "entity" in parent_panel and parent_panel.entity:
		player_id = parent_panel.entity.controlled_by
	var _player = GameManager.get_player(player_id)
	return _player.can_queue_action(action)

func _on_button_mouse_entered():
	if can_buy():
		hover_texture.show()

func _on_button_mouse_exited():
	hover_texture.hide()
