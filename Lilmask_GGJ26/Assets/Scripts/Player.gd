extends CharacterBody2D

@onready var xp_bar = $XP
@onready var level_label : Label = $Level
@onready var options_node = get_node("UI/Options")
var speed : float = 150

#Max Health/ barely changes after instantiation
var _max_health : float
var max_health : float:
	set (value):
		_max_health = value
		%Health.max_value = value
	get:
		return _max_health

var _health : float

#Constant change
var health : float:
	set(value):
		_health = value
		%Health.value = value
	get:
		return _health
		
var nearest_enemy : CharacterBody2D
var nearest_enemy_dist : float = INF

var _XP : int = 0
var XP : int:
	set(value):
		_XP = value
		if is_instance_valid(xp_bar):
			xp_bar.value = _XP
		


var total_XP : int = 0

var _lvl : int = 1
var lvl : int:
	set(value):
		_lvl = value
		if is_instance_valid(level_label):
			level_label.text = "Lv " + str(_lvl)
		if is_instance_valid(options_node):
			options_node.show_option()  # safely show options
		update_XP_bar_max()
	get:
		return _lvl


		
func _ready():
	max_health = 100
	health = max_health

func _physics_process(delta: float):
	if is_instance_valid(nearest_enemy):
		nearest_enemy_dist = nearest_enemy.seperation
	else:
		nearest_enemy_dist = INF
	
	velocity = Input.get_vector("left","right","up","down") * speed
	move_and_collide(velocity*delta)
	check_XP()
	check_HP()


func take_damage(amount):
	health -= amount
	print(health)

func _on_self_damage_body_entered(body: Node2D) -> void:
	if body.has_method("get_damage"):
		take_damage(body.get_damage())
		
func _on_timer_timeout() -> void:
	%Collision.set_deferred("disabled", true)
	%Collision.set_deferred("disabled", false)
	
func gain_XP(amount):
	XP += amount
	total_XP += amount
	print(XP)
	
	
func check_XP():
	if xp_bar == null:
		return

	if XP > xp_bar.max_value:
		XP -= xp_bar.max_value
		lvl += 1

func check_HP():
	if health <= 0:
		queue_free()
		do_something_with_delay()
		get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")




func _on_magnet_area_entered(area: Area2D) -> void:
	if area.has_method("follow"):
		area.follow(self)

func update_XP_bar_max():
	if is_instance_valid(xp_bar):
		if lvl >= 7:
			xp_bar.max_value = 40
		elif lvl >= 3:
			xp_bar.max_value = 20
		else:
			xp_bar.max_value = 10

func do_something_with_delay():
	print("Action starts")
	await get_tree().create_timer(2.0).timeout  # wait 2 seconds
	print("Action resumes after 2 seconds")
