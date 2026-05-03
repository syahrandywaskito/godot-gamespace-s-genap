class_name SaveGame
extends Resource

## Posisi player di dunia
@export var player_position: Vector2 = Vector2.ZERO

## Stat karakter
@export var player_hp: float = 100.0
@export var player_stamina: float = 100.0
@export var player_coins: int = 0

## Senjata aktif (index dari weapon_list di ItemSelect)
@export var active_weapon_index: int = 0

## Enemy yang sudah mati — disimpan sebagai nama node (node.name)
@export var killed_enemies: Array[String] = []

## Posisi enemy yang masih hidup — { "nama_node": Vector2 }
@export var enemy_positions: Dictionary = {}
