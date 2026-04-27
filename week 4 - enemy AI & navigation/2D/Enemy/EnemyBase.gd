## Base class untuk logika dasar musuh.
##
## Mengelola inisialisasi group, kematian, dan delegasi rotasi senjata berdasarkan velocity.
class_name EnemyBase
extends CharacterBody2D

## Kecepatan jalan musuh.
@export var speed: float = 200.0 
## Referensi ke komponen senjata musuh.
@export var weapon: WeaponComponent = null
## Referensi ke komponen kesehatan musuh.
@export var health_component: HealthComponent = null

## Referensi ke NavigationAgent2D untuk pathfinding.
@export var nav_agent: NavigationAgent2D = null

func _ready() -> void:
	if health_component:
		health_component.died.connect(_on_died)

func _physics_process(delta: float) -> void:
	# Arahkan senjata sesuai arah pergerakan
	if velocity.length() > 0:
		if weapon:
			weapon.update_rotation(velocity.normalized(), delta)
	
	move_and_slide()

## Mendelegasikan penerimaan damage ke HealthComponent.
func take_damage(amount: float) -> void:
	if health_component:
		health_component.take_damage(amount)

## Menghapus musuh dari scene saat mati.
func _on_died() -> void:
	queue_free()
