class_name GridMapTileEffectDatabase
extends Resource

@export var effects: Array[GridMapTileEffect] = []


func get_effect(tile_name: StringName) -> GridMapTileEffect:
	for effect in effects:
		if effect.tile_name == tile_name:
			return effect
	return null
