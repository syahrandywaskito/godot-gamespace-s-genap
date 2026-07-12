---
tags: [gamedev, project, devlog]
status: permanent
---

# Ringkasan Projek: UKM Gamespace

> [!TIP]
> **SARI MATERI (5 DETIK)**
> *   **Tujuan**: Repositori pengajaran Godot Engine 4 Genap untuk anggota UKM GAMESPACE selama satu semester.
> *   **Repository GitHub**: [godot-gamespace-s-genap](https://github.com/syahrandywaskito/godot-gamespace-s-genap)
> *   **Struktur Pengajaran**: Kurikulum terstruktur 8 minggu mulai dari pergerakan dasar hingga finishing game feel.
> *   **Path Lokal**: `D:\GAME PROJECT\GODOT\Godot Gamespace Genap`

---

## 🔗 Link & Integrasi Proyek
*   **Repositori Utama**: [GitHub - godot-gamespace-s-genap](https://github.com/syahrandywaskito/godot-gamespace-s-genap)
*   **Hub Kurikulum**: [[Projects/UKM Gamespace/Kurikulum dan Bedah Mekanik|Kurikulum dan Bedah Mekanik]]

---

## 📅 Roadmap Materi (8 Minggu)

### [[Projects/UKM Gamespace/Week 1 Movement dan Feel|Minggu 1: Movement & Feel (2D & 3D)]]
*   Akselerasi & friction menggunakan `move_toward`.
*   Game feel: **Coyote Time** dan **Jump Buffer**.
*   3D movement: camera-relative pergerakan via basis vektor, dorong `RigidBody3D` (`apply_central_force` vs `apply_central_impulse`).

### Minggu 2: Interaction System & Inventory Logic
*   Deteksi tabrakan pasif menggunakan [[Physics/Area2D|Area2D]] (mengambil koin).
*   Deteksi aktif menggunakan [[Physics/RayCast2D|RayCast2D]] (interaksi lurus dengan tombol aksi).
*   Penerapan global `InventoryManager` dan `SignalBus`.

### Minggu 3: Projectile & Combat
*   Spawning peluru dinamis menggunakan `instantiate()` dan `preload()`.
*   Arah tembakan linear menggunakan [[Resources/Math/Trigonometri|Trigonometri]] (`cos()`, `sin()`) dari posisi mouse.
*   HUD HP Bar terpisah menggunakan [[Resources/Godot/Control/Range/RangeControls|ProgressBar]].

### Minggu 4: Enemy AI & Navigation (Component-Based)
*   Pemisahan logika nyawa menggunakan [[Resources/System Design/Composition/Composition vs Inheritance|HealthComponent]].
*   Sistem AI transisi kondisi musuh menggunakan [[Resources/System Design/FSM/Finite State Machine|EnemyStateMachine]].

### Minggu 5: Collectible, UI, & Data Persistence
*   Hemat memori spawing peluru/koin menggunakan [[Resources/System Design/Design Patterns/Creational/Object Pooling|CoinPool]].
*   Simpan data game persisten aman menggunakan custom [[Resources/System Design/Godot/Godot Resources|SaveGame]] dengan verifikasi hash SHA256 + SALT.

### Minggu 6: Physics Based & Mechanic Puzzle
*   Desain puzzle interaktif berbasis simulasi fisika penuh `RigidBody2D` dan engsel sendi (Joints).

### Minggu 7: Environmental Mechanic
*   Navigasi jalur otomatis (Pathfinding) AI musuh pada Grid menggunakan [[Level Design/TileMap|TileMap]] Navigation.

### Minggu 8: Finishing & Juiciness
*   Optimasi audio menggunakan [[Resources/System Design/Design Patterns/Creational/Object Pooling|SoundPool]].
*   Penerapan getar layar kamera (*camera shake*) untuk dampak feel pukulan/tembakan.

---
Kembali ke [[README]] | Hub Utama: [[Resources/Godot/Godot MOC|Godot MOC]]
