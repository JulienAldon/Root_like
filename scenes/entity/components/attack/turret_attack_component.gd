extends AttackComponent

class_name TurretAttackComponent

@export var collision: CollisionShape2D
@export var range_delimiter: ColorRect

func apply_damage() -> void:
	pass

func attack_target() -> void:
	super()
	attack_style.apply_damage(target, network.controlled_by)

func _process(_delta) -> void:
	range_delimiter.scale = Vector2(stats.get_range() / 100, stats.get_range() / 100)
	range_delimiter.position = Vector2(-stats.get_range(), -stats.get_range())
	collision.shape.radius = stats.get_range()
	if Engine.get_process_frames() % 20 == 0:
		nearby_targets = compute_nearby_target()

func compute_nearby_target() -> Array:
	var res = super()
	return res.filter(func(el): return el.controlled_by != network.controlled_by and el is not Outpost)
