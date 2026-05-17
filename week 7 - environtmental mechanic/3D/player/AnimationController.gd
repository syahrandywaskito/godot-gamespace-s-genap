class_name AnimationController
extends Node

@export var body_path: NodePath
@export var animation_player_path: NodePath

@export_group("Input")
@export var left_action: StringName = &"left"
@export var right_action: StringName = &"right"
@export var up_action: StringName = &"up"
@export var down_action: StringName = &"down"
@export var use_input_for_state: bool = true

@export_group("Animations")
@export var idle_animation: StringName = &"idle"
@export var walk_animation: StringName = &"walk"
@export var movement_threshold: float = 0.1
@export_range(0.0, 2.0, 0.01) var animation_blend_time: float = 0.18

@onready var body: CharacterBody3D = get_node_or_null(body_path) as CharacterBody3D
@onready var animation_player: AnimationPlayer = get_node_or_null(animation_player_path) as AnimationPlayer


func _ready() -> void:
	if body == null:
		push_warning("AnimationController: body_path tidak valid.")
	
	if animation_player == null:
		push_warning("AnimationController: animation_player_path tidak valid.")
	
	var is_ready := body != null and animation_player != null
	set_physics_process(is_ready)
	
	if is_ready:
		_sync_animation(true)


func _physics_process(_delta: float) -> void:
	_sync_animation()


func _sync_animation(force: bool = false) -> void:
	var target_animation := idle_animation
	var is_moving := _is_move_input_active()
	
	if not use_input_for_state:
		var horizontal_velocity := body.velocity
		horizontal_velocity.y = 0.0
		is_moving = horizontal_velocity.length() > movement_threshold
	
	if is_moving:
		target_animation = walk_animation
	
	if not force and animation_player.current_animation == target_animation and animation_player.is_playing():
		return
	
	animation_player.play(target_animation, animation_blend_time)


func _is_move_input_active() -> bool:
	var move_input := Input.get_vector(left_action, right_action, up_action, down_action)
	return move_input.length() > movement_threshold
