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

### Save & Load System (Resource-Based)
Sistem persistensi data menggunakan fitur native Godot **ResourceSaver** dan **ResourceLoader** untuk menyimpan state permainan ke dalam file `.tres` (debug) atau `.res` (release).
- **SaveGame Resource**: Custom resource yang menampung data posisi player, statistik (HP, Stamina, Coin), index senjata aktif, hingga posisi musuh.
- **GameManager Logic**:
    - **Collect**: Mengumpulkan data dari berbagai komponen saat tombol Save ditekan.
    - **Apply**: Mendistribusikan kembali data yang dimuat ke komponen terkait menggunakan fungsi setter.
    - **Enemy Tracking**: Melacak nama node musuh yang telah mati agar tidak muncul kembali saat load, serta menyimpan koordinat musuh yang masih hidup.
- **Auto-Load**: Pemuatan data otomatis saat scene `TopDownWorld` siap, memastikan kontinuitas permainan bagi pemain.

---

## 6. Physics Based & Mechanic Puzzle

### RigidBody & Physics Interaction
Implementasi objek fisik menggunakan `RigidBody2D` dan `RigidBody3D`. Objek ini dipengaruhi penuh oleh engine fisika (gravitasi, massa, friksi, impuls).
- **Box Interaction**: Pemain dapat mendorong kotak fisik untuk memecahkan puzzle lingkungan.
- **Freeze & Sleep**: Mengoptimalkan performa dengan mengaktifkan mode *Sleep* pada objek diam.

### Physics Detector (Area-Based)
Menggunakan `Area2D` sebagai sensor untuk mendeteksi objek dengan group tertentu (misal: "Physics").
- **Layer & Mask Swapping**: Teknik mengubah bitmask tabrakan secara dinamis melalui script saat objek masuk ke area tertentu (seperti pintu atau sensor tekanan).
- **Condition Validation**: Mengecek apakah objek yang masuk memenuhi syarat (misal: berat minimum) sebelum memicu event puzzle.

---

## 7. Environmental Mechanic

### TileMapLayer Surface Detection (2D)
Implementasi interaksi karakter dengan lingkungan berbasis tile menggunakan node **TileMapLayer**.
- **Custom Data Layers**: Menggunakan metadata pada `TileSet` untuk menyimpan tipe permukaan (misal: "grass", "sand", "dirt").
- **Dynamic Speed Modifier**: Script `TilemapController` mendeteksi posisi player, mengonversi koordinat global ke koordinat map via `local_to_map()`, dan mengambil data permukaan untuk mengubah `speed_multiplier` tank secara real-time.

### GridMap & Raycast Detection (3D)
Penerapan mekanik lingkungan pada dunia 3D menggunakan **GridMap**.
- **Surface Database**: Sistem berbasis `Resource` untuk memetakan ID mesh pada GridMap ke efek tertentu.
- **Raycast Probing**: Menggunakan `RayCast3D` di kaki pemain untuk mendeteksi ID tile yang sedang dipijak.
- **Environmental Hazard**: Implementasi area berbahaya yang memberikan efek *Damage over Time* (lava) atau zona yang memperlambat gerakan (lumpur).

---

## 8. Finishing & Juice

### Global SoundPool (Object Pooling)
Sistem manajemen audio terpusat menggunakan teknik **Object Pooling** untuk mengoptimalkan performa dan mendukung overlapping sound.
- **Node Reuse**: Menggunakan pool `AudioStreamPlayer` yang aktif dan tidak aktif untuk menghindari *stutter* akibat instansiasi node berulang.
- **Modular Playback**: Mendukung pengaturan dinamis untuk `volume_db`, `pitch_scale`, dan output `AudioBus`.
- **Pitch Randomization**: Fitur variasi pitch otomatis (±15%) untuk mencegah efek suara terasa monoton saat dipicu berulang kali (seperti tembakan atau ledakan).

### Boost Mechanic & Visual Feedback
Implementasi sistem peningkatan kecepatan sementara dengan konsumsi sumber daya dan umpan balik visual yang responsif.
- **Fuel Management**: `BoostController` mengelola kapasitas bahan bakar, laju konsumsi, dan regenerasi otomatis saat tidak digunakan.
- **UI Synchronization**: Menghubungkan data internal ke `ProgressBar` pada HUD melalui `SignalBus` dengan update yang dihaluskan menggunakan `Tween`.
- **Squash & Stretch (Juice)**: Memberikan efek visual dinamis pada sprite tank (Scale Y: 1.5, Scale X: 0.75) saat boost aktif untuk memperkuat sensasi kecepatan.

### Game Feel & Polish
- **Camera Shake**: Integrasi guncangan kamera saat aksi kritikal (menembak/ledakan) untuk meningkatkan impak permainan.
- **Tween-Based UI**: Menggunakan interpolasi `Tween` (SINE/EASE_OUT) untuk transisi nilai UI agar terasa lebih organik dan modern.
- **Particle Integration**: Penggunaan `GPUParticles2D` untuk efek muzzle flash dan ledakan yang terintegrasi dengan logika pertempuran.
