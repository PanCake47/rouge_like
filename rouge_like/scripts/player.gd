extends CharacterBody2D

const projectile_scene = preload("res://scenes/projectile.tscn")

@export var speed = 100
@export var fire_rate = 0.5
@onready var shooting_point = $ShootingPoint
@onready var fire_rate_timer = $FireRate
@onready var player_area_collision = $PlayerArea/PlayerAreaCollision
@onready var hit_timer: Timer = $HitTimer
@onready var player_collision = $PlayerCollision

func _ready():
	fire_rate_timer.wait_time = fire_rate
	fire_rate_timer.one_shot = true

func get_input():
	var input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = input_direction * speed

	if Input.is_action_pressed("shoot_up"):
		shooting_point.position = Vector2(0, -8) 
		shoot(Vector2.UP)
	elif Input.is_action_pressed("shoot_down"):
		shooting_point.position = Vector2(0, 8)
		shoot(Vector2.DOWN)
	elif Input.is_action_pressed("shoot_left"):
		shooting_point.position = Vector2(-8, 0) 
		shoot(Vector2.LEFT)
	elif Input.is_action_pressed("shoot_right"):
		shooting_point.position = Vector2(8, 0) 
		shoot(Vector2.RIGHT)

func _physics_process(_delta):
	get_input()
	move_and_slide()

func shoot(direction: Vector2):
	if fire_rate_timer.is_stopped():
		var projectile_instance = projectile_scene.instantiate()
		get_parent().add_child(projectile_instance)
		projectile_instance.position = shooting_point.global_position
		projectile_instance.direction = direction
		fire_rate_timer.start()

func _on_player_area_body_entered(body):
	print("Collision with:", body)
	player_collision.call_deferred("set", "disabled", true)
	player_area_collision.call_deferred("set", "disabled", true)
	hit_timer.start()

func _on_hit_timer_timeout():
	player_collision.call_deferred("set", "disabled", false)
	player_area_collision.call_deferred("set", "disabled", false)
