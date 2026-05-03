class_name CoinDropComponent
extends Node

@export var coin_scene: PackedScene = null

func spawn_coin(last_pos: Vector2, pool: Node2D) -> void:
	var coin = coin_scene.instantiate() as Coin
	coin.global_position = last_pos
	pool.add_child(coin)
