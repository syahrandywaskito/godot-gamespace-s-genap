class_name ShootRay
extends RayCast3D

@export var effect: MeshInstance3D = null

func _physics_process(_delta: float) -> void:
	if is_colliding():
		var target = get_collider()
		if target == null:
			return
		
		# Gunakan Duck Typing agar bisa menembak objek apa saja yang punya take_damage
		if Input.is_action_just_pressed("fire"):
			if target.has_method("take_damage"):
				target.take_damage(10)
