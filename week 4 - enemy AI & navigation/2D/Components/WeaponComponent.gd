## Komponen untuk mengelola logika senjata, rotasi, dan serangan.
##
## Menangani visual tebasan melalui AnimationPlayer dan mengaktifkan hitbox saat menyerang.
class_name WeaponComponent
extends Node2D

## Data statistik senjata (damage, cooldown).
@export var stats: WeaponStats:
	set(value):
		stats = value
		if stats:
			if hitbox:
				hitbox.damage = stats.damage
			# Update visual if Sprite2D exists
			var sprite = get_node_or_null("WeaponPivot/Sprite2D")
			if sprite and stats.weapon_image:
				sprite.texture = stats.weapon_image

## Kecepatan penghalusan rotasi senjata.
@export var lerp_speed: float = 15.0
## Referensi ke AnimationPlayer untuk visual serangan.
@onready var animation_player: AnimationPlayer = $AnimationPlayer
## Referensi ke HitboxComponent untuk memberikan damage.
@onready var hitbox: HitboxComponent = $WeaponPivot/Hitbox

var target_rotation: float = 0.0
var can_attack: bool = true
var cooldown_timer: Timer

func _ready() -> void:
	cooldown_timer = Timer.new()
	add_child(cooldown_timer)
	cooldown_timer.one_shot = true
	cooldown_timer.timeout.connect(_on_cooldown_timeout)
	
	if hitbox:
		hitbox.monitoring = false # Nonaktifkan hitbox saat awal
		if stats:
			hitbox.damage = stats.damage

func _on_cooldown_timeout() -> void:
	can_attack = true

## Memperbarui rotasi senjata menuju [param direction] dengan penghalusan.
func update_rotation(direction: Vector2, delta: float) -> void:
	if direction.length() > 0:
		target_rotation = direction.angle()
	
	rotation = lerp_angle(rotation, target_rotation, lerp_speed * delta)

## Menjalankan urutan serangan jika tidak dalam masa cooldown.
func attack() -> void:
	if can_attack and animation_player:
		can_attack = false
		
		# Aktifkan hitbox saat menyerang
		if hitbox:
			hitbox.reset_hit_targets() # Pastikan target lama dibersihkan
			hitbox.monitoring = true
			
			# Deteksi instan saat tombol ditekan
			for body in hitbox.get_overlapping_bodies():
				hitbox._try_damage(body)
			for area in hitbox.get_overlapping_areas():
				hitbox._try_damage(area)
			
		animation_player.play("slash")
		
		# Tunggu sebentar (durasi slash) lalu matikan hitbox
		get_tree().create_timer(0.2).timeout.connect(func(): 
			if hitbox: hitbox.monitoring = false
		)
		
		if stats:
			cooldown_timer.start(stats.attack_cooldown)
		else:
			cooldown_timer.start(0.5)
