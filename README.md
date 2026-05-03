# GODOT GAMESPACE SEMESTER GENAP

Selamat datang di repositori pembelajaran Godot Engine Semester Genap. Repositori ini berisi materi mingguan mulai dari dasar pergerakan hingga sistem AI yang kompleks.

## 1. Movement & Feel 

### Velocity & move_and_slide()
Pergerakan di Godot dipengaruhi oleh **Velocity** (Vektor kecepatan). Untuk menerapkan velocity pada `CharacterBody2D/3D` dan menangani tabrakan dengan lingkungan, digunakan fungsi `move_and_slide()`.

### Smoothing (Penghalusan)
Untuk memberikan bobot (*weight*) pada karakter agar tidak terasa kaku:
1.  **`move_toward(current, target, delta)`**: Mengubah nilai secara linier. Cocok untuk akselerasi/dekselerasi yang pasti.
2.  **`lerp(from, to, weight)`**: Mengubah nilai berdasarkan persentase. Memberikan efek pergerakan yang melambat saat mendekati target (*ease-out*).

### Coyote Time & Jump Buffer 
Mekanik untuk meningkatkan *game feel* saat melompat:
1.  **Coyote Time**: Memberikan toleransi waktu singkat bagi pemain untuk tetap bisa melompat meskipun sudah melewati ujung platform.
2.  **Jump Buffer**: Menyimpan input lompatan sesaat sebelum pemain menyentuh tanah, sehingga lompatan langsung dipicu begitu karakter mendarat.

---

## 2. Interaction System & Inventory Logic

### Sistem Deteksi: RayCast vs Area
1.  **RayCast**: Deteksi presisi menggunakan garis lurus (laser). Sangat cepat dan cocok untuk interaksi yang membutuhkan akurasi pandangan (seperti menembak atau mengambil item kecil).
2.  **Area**: Deteksi berbasis zona (aura). Mendeteksi semua objek yang masuk ke dalam radius tertentu. Cocok untuk *proximity check* atau trigger otomatis.

### Inventory Logic & Autoload
Menggunakan pola **Singleton (Autoload)** dengan `InventoryManager.gd` untuk menyimpan data item (seperti koin) yang tetap persisten meskipun pemain berpindah antar scene.

---

## 3. Projectile & Combat

### Projectile System
- **Spawning**: Teknik melakukan *instantiate* scene peluru saat tombol tembak ditekan.
- **Velocity**: Menggerakkan peluru secara konsisten ke arah tertentu.
- **Despawning**: Menghapus peluru menggunakan `VisibleOnScreenNotifier2D` atau `Timer` untuk menghemat memori.

### Damage System Dasar
Implementasi fungsi `take_damage` pada objek target (seperti `DummyTarget.gd`) untuk menerima input damage dan memperbarui bar kesehatan.

---

## 4. Enemy AI & Navigation

### Navigation System (Pathfinding)
- **NavigationRegion2D & NavigationRegion3D**: Mendefinisikan area yang bisa dilewati (*NavMesh*). Tanpa node ini, AI tidak tahu arah jalan.
- **NavigationAgent2D & NavigationAgent3D**: Bertindak sebagai GPS bagi musuh untuk menghitung jalur terpendek dan menghindari rintangan.

### Finite State Machine (FSM)
Mengatur perilaku AI agar lebih terorganisir menggunakan `enum` status (Berlaku untuk 2D dan 3D):
- **IDLE**: Diam menunggu atau saat kehilangan jejak.
- **PATROL**: Bergerak di antara titik-titik koordinat tertentu.
- **CHASE**: Mengejar pemain menggunakan navigasi cerdas.
- **ATTACK**: Berhenti dan melakukan serangan saat jarak sudah mencukupi.

### Vision System & Visual Cues
- **Line of Sight (LoS)**: Menggunakan `RayCast2D/3D` untuk memastikan musuh tidak bisa melihat pemain jika terhalang tembok.
- **Visual Cues**: Indikator status di atas kepala musuh (2D menggunakan Sprite, 3D menggunakan Label3D/Sprite3D).

### Composition Pattern
Memisahkan logika menjadi komponen-komponen mandiri yang bisa digunakan ulang:
- `HealthComponent`: Mengelola HP dan kematian.
- `HitboxComponent`: Mendeteksi tabrakan serangan dan memberikan damage.
- `WeaponComponent`: Mengatur visual senjata, rotasi, dan cooldown.
- `WeaponStats`: Resource untuk menyimpan data damage dan kecepatan senjata.

---

## 5. Collectible, UI, & Data Persistence

### Signal-Based UI Architecture
Menggunakan pola **Component Bridge → SignalBus → UI** untuk memisahkan logika permainan dari tampilan visual. Hal ini mencegah ketergantungan antar node (*Decoupling*) dan memudahkan pemeliharaan kode.
- **Component**: Menyimpan data dan logika (misal: `ItemSelect.gd`, `StaminaComponent.gd`).
- **SignalBus (Singleton)**: Bertindak sebagai pusat saraf komunikasi global.
- **UI Node**: Hanya bertugas menampilkan data yang diterima dari signal (misal: `UIWeaponDisplay.gd`).

### Singleton (Autoload) Pattern
Memanfaatkan `SignalBus.gd` sebagai Autoload untuk menangani event global seperti:
- `health_changed`, `stamina_changed`, `coin_changed`.
- `weapon_changed`: Memberitahu seluruh sistem saat pemain mengganti senjata aktif.

### Weapon Selector System
Implementasi sistem pemilihan senjata berbasis Resource (`WeaponStats`):
- **Logic**: Mengelola daftar senjata dalam array dan memperbarui stats pada `WeaponComponent` secara dinamis.
- **Interactive UI**: Menggunakan tombol transparan (`Button`) dengan visual konfirmasi (*Click Flash*) untuk memilih senjata via mouse.
