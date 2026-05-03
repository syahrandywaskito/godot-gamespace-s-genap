## Signal Bus sebagai jembatan berkomunakasi via signal
extends Node

# UI 
@warning_ignore("unused_signal")
signal health_changed(current_health: float)

@warning_ignore("unused_signal")
signal health_setup(max_health: float)

@warning_ignore("unused_signal")
signal stamina_changed(current_stamina: float)

@warning_ignore("unused_signal")
signal coin_changed(current_coin: int)

@warning_ignore("unused_signal")
signal change_item(current_waeapon: WeaponStats)

@warning_ignore("unused_signal")
signal weapon_changed(weapon_stats: WeaponStats)

@warning_ignore("unused_signal")
signal open_item_selector

# ~
