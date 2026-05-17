class_name PhysicsDetector
extends Area2D

func _ready() -> void:
	#body_entered.connect(_on_body_entered)
	#body_exited.connect(_on_body_exited)
	pass

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Physics"):
		body = body as RigidBody2D
		body.set_collision_mask_value(1, true)
		body.set_collision_layer_value(1, true)

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Physics"):
		body = body as RigidBody2D
		body.set_collision_layer_value(6, true)
		body.set_collision_layer_value(1, false)
		body.set_collision_mask_value(1, true)
		body.set_collision_mask_value(2, true)
		body.set_collision_mask_value(6, true)
