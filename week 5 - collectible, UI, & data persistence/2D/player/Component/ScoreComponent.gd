class_name CoinComponent 
extends Node
## Logika Coin Component
##
## digunakana untuk menjalankan logika Score, dimana saat player membunuh musuh dia akan mendapat score setelah mengambil coin

@export var coin: int = 0

func set_coin(amount: int):
	coin += amount

func get_coin() -> int:
	return coin
