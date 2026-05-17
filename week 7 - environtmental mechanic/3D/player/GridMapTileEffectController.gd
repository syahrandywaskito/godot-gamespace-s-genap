class_name GridMapTileEffectController
extends Node

@export var player_path: NodePath
@export var effect_database: GridMapTileEffectDatabase
@export_range(0.0, 5.0, 0.01) var foot_probe_height: float = 0.5
@export_range(0.1, 10.0, 0.1) var ray_length: float = 3.0

@onready var player: Player3D = get_node_or_null(player_path) as Player3D
@onready var grid_map: GridMap = get_tree().get_first_node_in_group("Gridmap")

var _active_effect: GridMapTileEffect
var _active_tile_name: StringName = &""
var _effect_tick_timer: float = 0.0


func _ready() -> void:
	if player == null:
		push_warning("GridMapTileEffectController: player_path tidak valid.")
	
	if grid_map == null:
		push_warning("GridMapTileEffectController: grid_map_path tidak valid.")
	
	if effect_database == null:
		push_warning("GridMapTileEffectController: effect_database belum diisi.")
	
	var is_ready := player != null and grid_map != null and effect_database != null
	set_physics_process(is_ready)
	
	if is_ready:
		_clear_active_effect()


func _physics_process(delta: float) -> void:
	var next_effect := _resolve_current_effect()
	
	if next_effect != _active_effect:
		_apply_effect(next_effect)
	
	if _active_effect == null:
		return
	
	match _active_effect.effect_type:
		GridMapTileEffect.EffectType.DAMAGE_OVER_TIME:
			_tick_periodic_effect(delta, false)
		GridMapTileEffect.EffectType.HEAL_OVER_TIME:
			_tick_periodic_effect(delta, true)


func _resolve_current_effect() -> GridMapTileEffect:
	var tile_name := _get_tile_name_under_player()
	if tile_name == StringName():
		return null
	return effect_database.get_effect(tile_name)


func _get_tile_name_under_player() -> StringName:
	var probe_from := player.global_position + Vector3.UP * foot_probe_height
	var probe_to := probe_from + Vector3.DOWN * ray_length
	var query := PhysicsRayQueryParameters3D.create(probe_from, probe_to)
	query.collide_with_areas = false
	query.collide_with_bodies = true
	query.exclude = [player.get_rid()]
	
	var hit := player.get_world_3d().direct_space_state.intersect_ray(query)
	if hit.is_empty():
		return StringName()
	
	var collider = hit.get("collider")
	if collider != grid_map and not (collider is Node and grid_map.is_ancestor_of(collider)):
		return StringName()
	
	var hit_position: Vector3 = hit["position"] - hit["normal"] * 0.01
	var local_hit := grid_map.to_local(hit_position)
	var cell := grid_map.local_to_map(local_hit)
	var item_id := grid_map.get_cell_item(cell)
	
	if item_id < 0 or grid_map.mesh_library == null:
		return StringName()
	
	return StringName(grid_map.mesh_library.get_item_name(item_id))


func _apply_effect(next_effect: GridMapTileEffect) -> void:
	_clear_active_effect()
	_active_effect = next_effect
	_effect_tick_timer = 0.0
	
	if _active_effect == null:
		return
	
	_active_tile_name = _active_effect.tile_name
	match _active_effect.effect_type:
		GridMapTileEffect.EffectType.SPEED_MULTIPLIER:
			player.set_external_speed_multiplier(_active_effect.speed_multiplier)
		GridMapTileEffect.EffectType.DAMAGE_OVER_TIME:
			player.set_external_speed_multiplier(1.0)
		GridMapTileEffect.EffectType.HEAL_OVER_TIME:
			player.set_external_speed_multiplier(1.0)
		_:
			player.set_external_speed_multiplier(1.0)


func _clear_active_effect() -> void:
	_active_effect = null
	_active_tile_name = &""
	_effect_tick_timer = 0.0
	
	if player != null:
		player.set_external_speed_multiplier(1.0)


func _tick_periodic_effect(delta: float, should_heal: bool) -> void:
	_effect_tick_timer += delta
	if _effect_tick_timer < _active_effect.tick_interval:
		return
	
	_effect_tick_timer = 0.0
	if should_heal:
		player.heal(_active_effect.value_per_tick)
	else:
		player.take_damage(_active_effect.value_per_tick)
