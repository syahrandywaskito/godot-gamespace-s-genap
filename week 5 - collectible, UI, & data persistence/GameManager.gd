## GameManager - Mengelola Pause dan Save System
extends Node

signal pause_toggled(is_paused: bool)
@warning_ignore("unused_signal")
signal spawn_coin(last_pos: Vector2)

var save_game: SaveGame = null
var _is_paused: bool = false
var _killed_enemy_names: Array[String] = []

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"): # ESC key
		toggle_pause()

func toggle_pause() -> void:
	_is_paused = !_is_paused
	get_tree().paused = _is_paused
	pause_toggled.emit(_is_paused)

func resume() -> void:
	if _is_paused:
		toggle_pause()

func register_killed_enemy(enemy_name: String) -> void:
	if enemy_name not in _killed_enemy_names:
		_killed_enemy_names.append(enemy_name)

func save() -> void:
	if save_game == null:
		save_game = SaveGame.new()
	
	_collect_save_data()
	var path := _get_save_path()
	var error := ResourceSaver.save(save_game, path)
	
	if error == OK:
		print("Game Saved to: ", path)
	else:
		push_error("Save failed: " + error_string(error))

func _collect_save_data() -> void:
	var player = get_tree().get_first_node_in_group("Player")
	if player == null:
		return

	save_game.player_position = player.global_position
	
	var health_comp = player.get_node_or_null("HealthComponent")
	if health_comp:
		save_game.player_hp = health_comp.current_health
		
	var stamina_comp = player.get_node_or_null("StaminaComponent")
	if stamina_comp:
		save_game.player_stamina = stamina_comp.current_stamina
		
	var coin_comp = player.get_node_or_null("CoinComponent")
	if coin_comp:
		save_game.player_coins = coin_comp.get_coin()
		
	var item_select = player.get_node_or_null("ItemSelect")
	if item_select:
		save_game.active_weapon_index = item_select.current_index
		
	save_game.killed_enemies = _killed_enemy_names.duplicate()

	# Save posisi semua enemy yang masih hidup
	save_game.enemy_positions.clear()
	for enemy in get_tree().get_nodes_in_group("enemy"):
		if enemy.name not in _killed_enemy_names:
			save_game.enemy_positions[enemy.name] = enemy.global_position

func load_save() -> void:
	var path := _get_save_path()
	if not ResourceLoader.exists(path):
		return
		
	save_game = ResourceLoader.load(path, "", ResourceLoader.CACHE_MODE_IGNORE)
	_apply_save_data()

func _apply_save_data() -> void:
	if save_game == null: return
	
	var player = get_tree().get_first_node_in_group("Player")
	if player == null: return
	
	player.global_position = save_game.player_position
	
	var health_comp = player.get_node_or_null("HealthComponent")
	if health_comp and health_comp.has_method("set_health"):
		call_deferred("_set_component_value", health_comp, "set_health", save_game.player_hp)

	var stamina_comp = player.get_node_or_null("StaminaComponent")
	if stamina_comp and stamina_comp.has_method("set_stamina"):
		call_deferred("_set_component_value", stamina_comp, "set_stamina", save_game.player_stamina)
		
	var coin_comp = player.get_node_or_null("CoinComponent")
	if coin_comp and coin_comp.has_method("set_coins"):
		coin_comp.set_coins(save_game.player_coins)
		
	var item_select = player.get_node_or_null("ItemSelect")
	if item_select:
		item_select.WeaponChange(save_game.active_weapon_index)
		
	_killed_enemy_names = save_game.killed_enemies.duplicate()
	_remove_killed_enemies()
	
	# Restore posisi enemy yang masih hidup
	for enemy in get_tree().get_nodes_in_group("enemy"):
		if save_game.enemy_positions.has(enemy.name):
			enemy.global_position = save_game.enemy_positions[enemy.name]

func _set_component_value(component, method_name: String, value) -> void:
	if component.has_method(method_name):
		component.call(method_name, value)

func _remove_killed_enemies() -> void:
	for enemy_name in _killed_enemy_names:
		# Cari musuh di scene berdasarkan nama
		for enemy in get_tree().get_nodes_in_group("enemy"):
			if enemy.name == enemy_name:
				enemy.queue_free()
				break

func quit_game() -> void:
	get_tree().quit()

static func _get_save_path() -> String:
	var extension := ".tres" if OS.is_debug_build() else ".res"
	return "user://save_game" + extension
