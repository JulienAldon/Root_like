extends Control

class_name SelectionUnique

var entity: Node2D

@export var icon: TextureRect
@export var health: Label

@export var unit_container: UnitInformationUi
@export var building_container: BuildingInformationUi

func clear_informations():
	self.hide()

func update_informations(selection: Node2D):
	self.show()
	entity = selection
	icon.texture = entity.icon
	if entity.is_in_group("building") and "action_controller" in entity:
		building_container.set_informations(entity)
		building_container.show()
		unit_container.hide()
	else:
		unit_container.set_informations(selection.display_name, [])
		building_container.hide()
		unit_container.show()
	
func _process(_delta):
	if entity and is_instance_valid(entity):
		if "health" in entity:
			health.show()
			health.text = str(floor(entity.health.health)) + "/" +str(entity.health.max_health)
		else:
			var text = "owner : "
			var player_text = "None"
			if entity.controlled_by != 0:
				player_text = GameManager.Players[entity.controlled_by]["name"]
			health.text = text + player_text
