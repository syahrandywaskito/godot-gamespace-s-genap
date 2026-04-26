## Resource untuk menyimpan data statistik dasar senjata.
##
## Memisahkan data statistik dari logika script senjata.
class_name WeaponStats
extends Resource

## Jumlah damage yang dihasilkan senjata.
@export var damage: float = 10.0
## Waktu jeda antar serangan dalam detik.
@export var attack_cooldown: float = 0.5
## Nama tampilan senjata.
@export var weapon_name: String = "Weapon"
