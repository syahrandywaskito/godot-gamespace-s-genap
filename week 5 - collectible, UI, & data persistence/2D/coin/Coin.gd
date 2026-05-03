class_name Coin
extends Area2D

var amount: int = 0

func _ready() -> void:
	amount = randi_range(1, 20)

func get_coin() -> int:
	return amount
