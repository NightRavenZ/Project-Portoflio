extends PanelContainer

var _weapon : Weapon

@export var weapon : Weapon:
	set(value):
		_weapon = value

		if value == null:
			$TextureRect.texture = null
			return

		$TextureRect.texture = value.texture
		$Cooldown.wait_time = value.cooldown
	get:
		return _weapon
		



func _on_cooldown_timeout() -> void:
	if weapon: 
		$Cooldown.wait_time = weapon.cooldown
		weapon.activate(owner, owner.nearest_enemy, get_tree())
