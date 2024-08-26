extends Area2D

@onready var projectile_sprite = $ProjectileSprite

var speed = 125
var damage = 20
var direction = Vector2.ZERO
var knockback_strength = 150

func _ready():
	projectile_sprite.scale = Vector2(0.4, 0.4)

func _physics_process(delta):
	if direction != Vector2.ZERO:
		position += direction * speed * delta

func _on_body_entered(body):
	if body.is_in_group("enemies"):
		body.take_damage(damage)
		apply_knockback(body)
	queue_free()

func apply_knockback(enemy):
	var knockback_dir = direction.normalized() * knockback_strength
	
	if enemy.has_method("apply_knockback"):
		enemy.apply_knockback(knockback_dir)

func _on_projectile_life_timeout():
	queue_free()
