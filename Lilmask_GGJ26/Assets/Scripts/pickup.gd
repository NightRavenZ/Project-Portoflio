extends Area2D


var direction : Vector2
var speed : float = 175

@export var type : Pickups

var _player_reference : CharacterBody2D

@export var player_reference : CharacterBody2D:
	set(value):
		_player_reference = value

		if type:  # make sure type exists
			type.player_reference = value
	get:
		return _player_reference
		
var can_follow : bool = false

func _ready() -> void:
	$Sprite2D.texture = type.icon
	
func _physics_process(delta) -> void:
	if player_reference and can_follow:
		direction = (player_reference.position - position).normalized()
		position += direction * speed * delta
		
func follow(_target : CharacterBody2D):
	can_follow = true
	
func _on_body_entered(body: Node2D) -> void:
	type.activate()
	queue_free()
