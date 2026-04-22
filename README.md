# Exter Tablet (Refactor v2)

Sistem tablet FiveM yang sudah direfactor agar **stabil, modular, dan fleksibel** untuk banyak ekosistem server:

- Framework: **QBCore, Qbox, ESX, Standalone**
- Inventory: **ox_inventory, qb-inventory, esx_inventory, qs-inventory**, atau fallback framework default
- Fuel adapter (siap pakai untuk integrasi addon): **LegacyFuel, CDN-Fuel, ox_fuel, qb-fuel**

---

## 1) Fitur Utama

- Auto-detection framework / inventory / fuel dengan fallback aman.
- Sistem callback yang konsisten lintas framework.
- Penanganan item check yang lebih ketat + null-safe.
- UI tablet dengan lifecycle yang rapi (open/close/focus/cleanup).
- Error handling untuk data NUI kosong atau tidak valid.
- Kompatibel untuk ekstensi script lain melalui export server adapter.
- Struktur modular agar mudah maintain dan minim konflik.

---

## 2) Struktur File

```text
exter-tablet/
├─ fxmanifest.lua
├─ shared/
│  ├─ config.lua          # Konfigurasi utama
│  └─ adapters.lua        # Auto detection & helper util
├─ server/
│  ├─ core.lua            # Framework/inventory/fuel bridge
│  ├─ open_server.lua     # Register item tablet + callback item
│  └─ server.lua          # Boot info
├─ client/
│  ├─ core.lua            # Client callback + notify wrapper
│  ├─ main.lua            # Logic UI, animasi, event handling
│  └─ notifications.lua   # Backward compatibility wrapper
└─ web/
```

---

## 3) Instalasi Langkah demi Langkah

1. Letakkan folder `exter-tablet` ke dalam folder `resources` server.
2. Pastikan dependency framework dan inventory sudah start terlebih dahulu.
3. Tambahkan item `tablet`, `hqchip`, `ugchip` di inventory/framework Anda (contoh ada pada bagian item setup di bawah).
4. Tambahkan ke `server.cfg`:

```cfg
ensure exter-tablet
```

5. Restart resource/server.

---

## 4) Konfigurasi

Edit file `shared/config.lua`.

### Opsi Penting

- `Config.Framework = 'auto'`
  - Pilihan manual: `qbcore`, `qbox`, `esx`, `standalone`
- `Config.Inventory = 'auto'`
  - Pilihan manual: `ox_inventory`, `qb-inventory`, `esx_inventory`, `qs-inventory`, `standalone`
- `Config.Fuel = 'auto'`
  - Pilihan manual: `LegacyFuel`, `cdn-fuel`, `ox_fuel`, `qb-fuel`, `standalone`
- `Config.TabletItem`
  - Nama item untuk membuka tablet.
- `Config.RequiredItems`
  - Item chip untuk app tertentu.

> Rekomendasi: gunakan mode `auto` kecuali environment Anda custom.

---

## 5) Setup Item per Framework / Inventory

### A. QBCore (`qb-core/shared/items.lua`)

```lua
tablet = {
    name = 'tablet',
    label = 'Pixel Tablet',
    weight = 500,
    type = 'item',
    image = 'tablet.png',
    unique = true,
    useable = true,
    shouldClose = true,
    combinable = nil,
    description = 'Tablet'
},

hqchip = {
    name = 'hqchip',
    label = 'HQ Chip',
    weight = 100,
    type = 'item',
    image = 'hqchip.png',
    unique = false,
    useable = false,
    shouldClose = true,
    combinable = nil,
    description = 'Chip akses HQ'
},

ugchip = {
    name = 'ugchip',
    label = 'Underground Chip',
    weight = 100,
    type = 'item',
    image = 'ugchip.png',
    unique = false,
    useable = false,
    shouldClose = true,
    combinable = nil,
    description = 'Chip akses Underground'
},
```

### B. Qbox

Qbox tetap menggunakan item data yang sejalan dengan QBCore (atau item pack yang Anda pakai). Pastikan:
- Nama item sesuai: `tablet`, `hqchip`, `ugchip`
- Item image ada di inventory UI Anda

### C. ESX (`es_extended` / inventory terkait)

Tambahkan item ke tabel item ESX Anda (tergantung setup database / item pack):
- `tablet`
- `hqchip`
- `ugchip`

Untuk database SQL, struktur umumnya berisi kolom:
- `name`, `label`, `weight`

### D. ox_inventory

Tambahkan item ke file item ox_inventory Anda (misalnya `data/items.lua`):

```lua
['tablet'] = {
    label = 'Pixel Tablet',
    weight = 500,
    stack = false,
    close = true,
    description = 'Tablet'
},
['hqchip'] = {
    label = 'HQ Chip',
    weight = 100,
    stack = true,
    close = true,
    description = 'Chip akses HQ'
},
['ugchip'] = {
    label = 'Underground Chip',
    weight = 100,
    stack = true,
    close = true,
    description = 'Chip akses Underground'
},
```

### E. qs-inventory / esx_inventory / lainnya

Prinsipnya sama:
- Buat item dengan nama yang konsisten dengan config.
- Pastikan weight/stack/useability sesuai inventory Anda.
- Pastikan ikon item tersedia bila UI inventory membutuhkannya.

---

## 6) Integrasi Fuel (Opsional)

Script ini tidak memaksa penggunaan fuel secara langsung, tetapi adapter detection sudah tersedia.

Anda bisa mengakses adapter terdeteksi dari server export:

```lua
local adapters = exports['exter-tablet']:GetDetectedAdapters()
print(adapters.framework, adapters.inventory, adapters.fuel)
```

Contoh use-case:
- Membuka app trucking hanya jika vehicle fuel > X
- Menyesuaikan panggilan API fuel berdasarkan `adapters.fuel`

---

## 7) Pengujian yang Disarankan (QA Checklist)

- Buka tablet via item (`tablet`) pada tiap framework target.
- Uji app yang butuh chip:
  - Tanpa chip → notifikasi muncul.
  - Dengan chip → app terbuka.
- Uji NUI:
  - Save background berhasil tersimpan KVP.
  - Tutup tablet mengembalikan focus input normal.
- Uji edge case:
  - Payload NUI kosong / `appName` nil.
  - Resource restart saat tablet terbuka.
- Uji fallback:
  - Framework standalone tanpa core.
  - Inventory auto fallback ke framework default.

---

## 8) Catatan Integrasi / Troubleshooting

1. **Tablet tidak bisa dibuka**
   - Cek item sudah terdaftar.
   - Cek urutan `ensure` dependency.
2. **Chip tidak terbaca**
   - Cocokkan nama item di config vs inventory.
   - Pastikan inventory resource dalam keadaan `started`.
3. **Notifikasi tidak muncul**
   - Periksa mode framework terdeteksi.
   - Cek error pada client console / F8.

---

## 9) Kredit

- Original concept: Exter Developments
- Refactor & compatibility layer: v2 modular rebuild

Jika Anda ingin menambah adapter inventory/fuel baru, cukup perluas map resource dan helper check di `shared/config.lua` + `server/core.lua`.
