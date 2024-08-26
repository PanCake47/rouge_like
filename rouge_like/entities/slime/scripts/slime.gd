extends CharacterBody2D

@onready var slime_navigation = $SlimeNavigation
@onready var knockback: Timer = $Knockback

@export var target: CharacterBody2D

var max_hp = 100
var current_hp = max_hp
var speed = 90
var is_knocked_back = false

func _ready():
	add_to_group("enemies")
	set_physics_process(false)
	call_deferred("wait_for_physics")
	max_hp = current_hp

func wait_for_physics():
	await get_tree().physics_frame
	set_physics_process(true)

func take_damage(amount: int):
	current_hp -= amount
	if current_hp <= 0:
		queue_free()
		
func apply_knockback(knockback_vector: Vector2):
	is_knocked_back = true
	velocity += knockback_vector
	knockback.start()

func _on_knockback_timeout() -> void:
	is_knocked_back = false
	velocity = global_position.direction_to(slime_navigation.get_next_path_position()) * speed
	
func _physics_process(_delta):
	if not is_knocked_back:
		slime_navigation.target_position = target.global_position
		velocity = global_position.direction_to(slime_navigation.get_next_path_position()) * speed
	move_and_slide()
