extends Node2D

@export var player : CharacterBody2D
@export var enemy : PackedScene
@export var enemy_types : Array[Enemy]

var dist : float = 400
var can_spawn : bool = true

var _minute: int = 0

var minute: int:
	set(value):
		_minute = value
		%Minute.text = str(value)
	get:
		return _minute
		
var _second := 0

var second : int:
	set(value):
		_second = value
		if _second >= 10:
			_second -= 10
			minute += 1
		%Second.text = str(_second).lpad(2, '0')
	get:
		return _second
		
func _physics_process(delta: float) -> void:
	if get_tree().get_node_count_in_group("Enemy")<700:
		can_spawn = true
	else:
		can_spawn = false


func spawn(pos : Vector2, elite : bool = false): #takes a Vector 2 input from a func called get random pos
	if not can_spawn and not elite:
		return
		
	var enemy_instance = enemy.instantiate()#instatiate enemy
	
	enemy_instance.type = enemy_types[min(minute,enemy_types.size()-1)]
	enemy_instance.position = pos #set spawn
	enemy_instance.player_reference  = player #set player to track
	enemy_instance.elite = elite
	
	get_tree().current_scene.add_child(enemy_instance) #adds enemy instantiated to scene tree
	
func get_random_pos() -> Vector2:
	return player.position + dist * Vector2.RIGHT.rotated(randf_range(0,2 * PI)) #places enemy at random pos atleast dist pixels away with a random rotation
	
func amount(number: int = 1):
	for i in range(number):
		spawn(get_random_pos())

func _on_normal_timeout() -> void:
	second += 1
	amount(randi_range(1,10))#second

func _on_pattern_timeout() -> void:
	for i in range (5):
		spawn(get_random_pos())



func _on_elite_timeout() -> void:
	spawn(get_random_pos(),true)
