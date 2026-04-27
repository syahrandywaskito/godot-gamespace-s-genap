## Komponen sensor penglihatan AI menggunakan Area3D dan RayCast3D.
##
## Menggabungkan deteksi jarak (Area3D) dengan pengecekan tembok (RayCast3D).
class_name VisionComponent3D
extends Area3D

## Jarak pandang maksimal.
@export var detection_range: float = 15.0
## Referensi RayCast untuk Line of Sight.
@onready var ray_cast: RayCast3D = $RayCast3D

var target: Node3D = null

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	
	# Setup CollisionShape dan RayCast jika belum ada
	if ray_cast:
		ray_cast.enabled = true

## Mengecek apakah target terlihat secara fisik (tidak terhalang tembok).
func can_see_target() -> bool:
	if target == null: return false
	
	# Arahkan RayCast ke target
	ray_cast.target_position = ray_cast.to_local(target.global_position + Vector3.UP) # Arahkan ke "badan" player
	ray_cast.force_raycast_update()
	
	if ray_cast.is_colliding():
		var collider = ray_cast.get_collider()
		return collider.is_in_group("Player")
	
	return false

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("Player"):
		target = body

func _on_body_exited(body: Node) -> void:
	if body == target:
		target = null
