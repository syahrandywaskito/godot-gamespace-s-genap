class_name CoinPool
extends Node2D

@export var coin_scene: PackedScene = null

func _ready() -> void:
	GameManager.spawn_coin.connect(_on_spawn_coin)

func _on_spawn_coin(last_pos: Vector2) -> void:
	var coin = coin_scene.instantiate() as Coin
	coin.add_to_group("Coin")
	coin.position = last_pos
	call_deferred("add_child", coin)
