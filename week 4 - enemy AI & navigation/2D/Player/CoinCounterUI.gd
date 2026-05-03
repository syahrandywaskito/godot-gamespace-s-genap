class_name CoinCounterUI
extends Control

@onready var label: Label = $Label

func _ready() -> void:
	SignalBus.coin_changed.connect(_on_coin_changed)

func _on_coin_changed(current_coin: int) -> void:
	label.text = ": " + str(current_coin)
