## Komponen sederhana untuk membuat objek selalu menghadap kursor mouse.
class_name LookAtMouseComponent
extends Node2D

func _process(_delta: float) -> void:
	look_at(get_global_mouse_position())
