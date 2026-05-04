class_name PlayerW52D
extends CharacterBody2D


## Kecepatan lari pemain.
@export var speed: float = 300.0

## Referensi ke komponen senjata.
@onready var weapon = $Weapon

## Referensi ke komponen kesehatan.
@onready var health_component: HealthComponent = $HealthComponent
## Referensi untuk item select (digunakan untuk pemilihan item)
@onready var item_select: ItemSelect = $ItemSelect
## Referensi untuk score component (digunakan untuk pengaturan score yang didapat)
@onready var coin_component: CoinComponent = $CoinComponent
## Referensi untuk stamina comoponent (digunakan untuk penggunaan stamina)
@onready var stamina_component: StaminaComponent = $StaminaComponent

var move_multiplier: float = 1

func _ready() -> void:
	SignalBus.stamina_changed.emit(stamina_component.get_stamina())

func _physics_process(delta):
	move()
	run()
	
	# Arahkan senjata mengikuti mouse
	var mouse_direction = (get_global_mouse_position() - global_position).normalized()
	if weapon and weapon.has_method("update_rotation"):
		weapon.update_rotation(mouse_direction, delta)
	
	move_and_slide()

func move() -> void:
	# Ambil input pergerakan
	var direction = Input.get_vector("left", "right", "up", "down")
	
	if direction:
		velocity = direction * speed * move_multiplier
	else:
		velocity = velocity.move_toward(Vector2.ZERO, speed)

func run() -> void:
	if Input.is_action_pressed("run") and stamina_component.get_stamina() > 0:
		stamina_component.use_stamina()
		move_multiplier = 2
	elif Input.is_action_just_released("run") or stamina_component.get_stamina() >= 0:
		stamina_component.stamina_refill()
		move_multiplier = 1
	
	SignalBus.stamina_changed.emit(stamina_component.get_stamina())

## Memanggil fungsi damage pada HealthComponent pemain.
func take_damage(amount):
	if health_component and health_component.has_method("take_damage"):
		health_component.take_damage(amount)
		SignalBus.health_changed.emit(health_component.current_health)

## signal dari coin detector untuk mendeteksi apakah coin didapat atau tidak 
func _on_coin_area_enter(area: Area2D) -> void:
	if area.is_in_group("Coin"):
		area = area as Coin
		coin_component.set_coin(area.get_coin())
		SignalBus.coin_changed.emit(coin_component.get_coin())
		area.queue_free()
