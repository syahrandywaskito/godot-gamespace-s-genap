## Mengelola logika pergerakan dan interaksi dasar pemain.
##
## Menangani input pergerakan (WASD) dan mendelegasikan rotasi senjata mengikuti mouse.
extends CharacterBody2D

## Kecepatan lari pemain.
@export var speed: float = 300.0

## Referensi ke komponen senjata.
@onready var weapon = $Weapon
## Referensi ke komponen kesehatan.
@onready var health_component = $HealthComponent
## Referensi ke UI HealthBar di HUD.
@onready var health_bar = $PlayerHUD/Control/HealthBar

func _ready():
	add_to_group("Player")
	if health_component:
		health_component.health_changed.connect(_on_health_changed)
		if health_bar:
			health_bar.max_value = health_component.max_health
			health_bar.value = health_component.current_health

func _physics_process(delta):
	# Ambil input pergerakan
	var direction = Input.get_vector("left", "right", "up", "down")
	
	if direction:
		velocity = direction * speed
	else:
		velocity = velocity.move_toward(Vector2.ZERO, speed)

	# Arahkan senjata mengikuti mouse
	var mouse_direction = (get_global_mouse_position() - global_position).normalized()
	if weapon and weapon.has_method("update_rotation"):
		weapon.update_rotation(mouse_direction, delta)

	move_and_slide()

## Memanggil fungsi damage pada HealthComponent pemain.
func take_damage(amount):
	if health_component and health_component.has_method("take_damage"):
		health_component.take_damage(amount)

func _on_health_changed(current, _max):
	if health_bar:
		health_bar.value = current
