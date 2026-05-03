class_name UIWeaponSelector
extends Control

## Referensi ke slot senjata (Button).
@onready var slots: Array[Node] = [
	$"Control/List 1", # Index 0: Atas
	$"Control/List 3", # Index 1: Kiri
	$"Control/List 4", # Index 2: Kanan
	$"Control/List 2"  # Index 3: Bawah
]

## Referensi ke ItemSelect component di Player.
var item_select: ItemSelect

func _ready() -> void:
	visible = false
	
	var player = get_tree().get_first_node_in_group("Player")
	if player:
		item_select = player.get_node("ItemSelect")
	
	# Hubungkan signal untuk setiap button slot
	for i in range(slots.size()):
		var slot = slots[i]
		if slot is Button:
			slot.pressed.connect(_on_slot_pressed.bind(i))
	
	_update_highlights()

func _input(event: InputEvent) -> void:
	var toggle_pressed = false
	if InputMap.has_action("toggle_weapon_selector"):
		if event.is_action_pressed("toggle_weapon_selector"):
			toggle_pressed = true
	
	if not toggle_pressed and event is InputEventKey and event.pressed and event.keycode == KEY_I:
		toggle_pressed = true
		
	if toggle_pressed:
		visible = !visible
		if visible:
			_update_highlights()
		get_viewport().set_input_as_handled()

## Callback saat Button ditekan
func _on_slot_pressed(index: int) -> void:
	var panel = slots[index].get_node("Panel")
	if panel: panel.modulate = Color(2, 2, 2)
	
	if item_select:
		item_select.WeaponChange(index)
		_update_highlights()
	
	get_tree().create_timer(0.1).timeout.connect(func(): visible = false)

func _update_highlights() -> void:
	if not item_select: return
		
	var current = item_select.current_index
	for i in range(slots.size()):
		var panel = slots[i].get_node("Panel")
		if panel:
			panel.modulate = Color.GREEN if i == current else Color.WHITE
