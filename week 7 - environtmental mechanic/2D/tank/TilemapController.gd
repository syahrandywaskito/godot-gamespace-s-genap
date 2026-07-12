extends Node
class_name TilemapController

@export var player_path: NodePath = NodePath("..")
@export var tilemap_layer_group: StringName = &"Tilemaps"
@export var surface_custom_data_layer: StringName = &"surface"

@export var grass_multiplier: float = 1.0
@export var dirt_multiplier: float = 1.25
@export var sand_multiplier: float = 0.65

var _player: TankPlayer2D
var _tilemap_layer: TileMapLayer
var _last_multiplier: float = -1.0

func _ready() -> void:
	_player = get_node_or_null(player_path) as TankPlayer2D
	_tilemap_layer = get_tree().get_first_node_in_group(tilemap_layer_group) as TileMapLayer
	_apply_current_tile_effect()

func _physics_process(_delta: float) -> void:
	if _player == null:
		_player = get_node_or_null(player_path) as TankPlayer2D
	if _tilemap_layer == null:
		_tilemap_layer = get_tree().get_first_node_in_group(tilemap_layer_group) as TileMapLayer
		
	_apply_current_tile_effect()

func _apply_current_tile_effect() -> void:
	if _player == null or _tilemap_layer == null:
		return
	
	var multiplier := _resolve_multiplier_from_tilemap()
	
	if is_equal_approx(multiplier, _last_multiplier):
		return

	_player.set_external_speed_multiplier(multiplier)
	_last_multiplier = multiplier

func _resolve_multiplier_from_tilemap() -> float:
	var cell := _tilemap_layer.local_to_map(_player.global_position)
	
	print("local to tilemap : " + str(_tilemap_layer.to_local(_player.global_position)))
	print("global pos player : " + str(_player.global_position))
	
	var tile_data := _tilemap_layer.get_cell_tile_data(cell)
	if tile_data == null:
		return grass_multiplier 
	
	var surface_name = tile_data.get_custom_data(surface_custom_data_layer)
	
	match str(surface_name):
		"dirt":
			return dirt_multiplier
		"sand":
			return sand_multiplier
		"grass":
			return grass_multiplier
		_:
			return grass_multiplier
