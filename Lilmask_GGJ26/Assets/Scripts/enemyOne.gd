extends CharacterBody2D

@export var player_reference : CharacterBody2D
var damage_popup_node = preload("res://Scenes/damage.tscn")
var drops = preload("res://Scenes/pickup.tscn")
var direction : Vector2
var speed : float = 75
var damage : float
var knockback : Vector2
var seperation : float
var _elite : bool = false

var _health : float

var health : float:
	set(value):
		_health = value

		if _health <= 0:
			drop_item()
			queue_free()
	get:
		return _health


var elite : bool:
	set(value):
		_elite = value
		if value:
			$Sprite2D.material = load("res://Assets/Shader/EliteRainbow.tres")
			scale = Vector2(1.5,1.5)
	get:
		return _elite
		
	
var _type : Enemy

var type : Enemy:
	set(value):
		_type = value
		if value:
			$Sprite2D.texture = value.texture
			damage = value.damage
			health = value.health
	get:
		return _type

func _physics_process(delta):
	check_seperation(delta)
	knockback_update(delta)

func check_seperation(_delta):
	seperation = (player_reference.position-position).length()
	if seperation >= 500 and not elite:
		queue_free()
	
	if seperation < player_reference.nearest_enemy_dist:
		player_reference.nearest_enemy = self

func knockback_update(delta):
	velocity = (player_reference.position - position).normalized() * speed
	knockback = knockback.move_toward(Vector2.ZERO,200*delta)
	velocity += knockback
	
	var collider = move_and_collide(velocity * delta)
	
	if collider: #generates knockback when a body collides with enemy
		collider.get_collider().knockback = (collider.get_collider().global_position - global_position).normalized() * 50

func get_damage() -> float:
	return damage


func damage_popup(amount):
	var popup = damage_popup_node.instantiate()
	popup.text = str(amount)
	popup.position = position + Vector2(-50,-25)
	get_tree().current_scene.add_child(popup)
	
func take_damage(amount):
	var tween = get_tree().create_tween()
	tween.tween_property($Sprite2D, "modulate", Color(0,1,0.5), 0.2)
	tween.chain().tween_property($Sprite2D, "modulate", Color(1,1,1), 0.2)
	tween.bind_node(self)
	damage_popup(amount)
	health -= amount
	
func drop_item():
	if type.drops.size() == 0:
		return 
		
	var item = type.drops.pick_random()
	var item_to_drop = drops.instantiate()
	
	item_to_drop.type = item
	item_to_drop.position = position
	item_to_drop.player_reference = player_reference
	
	get_tree().current_scene.call_deferred("add_child", item_to_drop)
	
