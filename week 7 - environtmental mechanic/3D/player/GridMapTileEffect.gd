class_name GridMapTileEffect
extends Resource

enum EffectType {
	NONE,
	SPEED_MULTIPLIER,
	DAMAGE_OVER_TIME,
	HEAL_OVER_TIME,
}

@export var tile_name: StringName
@export var effect_type: EffectType = EffectType.NONE
@export var speed_multiplier: float = 1.0
@export var value_per_tick: float = 0.0
@export_range(0.01, 10.0, 0.01) var tick_interval: float = 0.5
