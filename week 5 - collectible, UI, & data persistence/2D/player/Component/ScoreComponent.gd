class_name CoinComponent 
extends Node
## Logika Coin Component
##
## digunakana untuk menjalankan logika Score, dimana saat player membunuh musuh dia akan mendapat score setelah mengambil coin

@export var coin: int = 0

func set_coin(amount: int):
	coin += amount

## Mengatur jumlah koin secara langsung (digunakan oleh load system).
func set_coins(amount: int) -> void:
	coin = amount
	SignalBus.coin_changed.emit(coin)

func get_coin() -> int:
	return coin
