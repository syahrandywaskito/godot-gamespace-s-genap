## Komponen untuk mendeteksi tabrakan dan memberikan damage ke target.
##
## Digunakan pada Area2D untuk mengidentifikasi objek dalam group tertentu dan memanggil fungsi take_damage.
class_name HitboxComponent
extends Area2D

## Jumlah damage yang diberikan.
@export var damage: float = 10.0
## Daftar group target yang bisa terkena damage.
@export var target_groups: Array[String] = ["Enemy"]

## Daftar target yang sudah terkena damage dalam satu sesi serangan.
var hit_targets: Array[Node] = []

func _on_body_entered(body: Node) -> void:
	_try_damage(body)

func _on_area_entered(area: Area2D) -> void:
	_try_damage(area)

## Mengosongkan daftar target yang terkena hit (dipanggil setiap awal serangan baru).
func reset_hit_targets() -> void:
	hit_targets.clear()

## Mencoba memberikan damage ke [param target] jika valid.
func _try_damage(target: Node) -> void:
	if target == owner or target in hit_targets: return 
	
	for group in target_groups:
		if target.is_in_group(group):
			var target_to_damage = null
			if target.has_method("take_damage"):
				target_to_damage = target
			elif target.get_parent().has_method("take_damage"):
				target_to_damage = target.get_parent()
			
			if target_to_damage:
				target_to_damage.take_damage(damage)
				hit_targets.append(target) # Catat agar tidak terkena hit lagi di ayunan yang sama
				break
