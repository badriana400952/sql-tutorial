
## 🧱 DASAR CRUD
| Operasi          | Tujuan           | Query SQL                                                                                   |
| ---------------- | ---------------- | ------------------------------------------------------------------------------------------- |
| 🔹 Create        | Tambah data baru | `INSERT INTO produk (nama, harga, jumlah, image) VALUES ($1, $2, $3, $4) RETURNING *;`      |
| 🔹 Read          | Ambil semua data | `SELECT * FROM produk ORDER BY created_at DESC;`                                            |
| 🔹 Read by ID    | Ambil 1 data     | `SELECT * FROM produk WHERE id = $1;`                                                       |
| 🔹 Update        | Ubah data        | `UPDATE produk SET nama=$1, harga=$2, jumlah=$3, updated_at=NOW() WHERE id=$4 RETURNING *;` |
| 🔹 Delete (soft) | Tandai terhapus  | `UPDATE produk SET deleted_at = NOW() WHERE id=$1;`                                         |
| 🔹 Delete (hard) | Hapus permanen   | `DELETE FROM produk WHERE id=$1;`                                                           |

## 🔗 RELASI (JOIN antar tabel)

Ambil transaksi lengkap (user + produk)
```
SELECT 
  transaksi.id,
  users.name AS user_name,
  produk.nama AS produk_name,
  transaksi.jumlah,
  transaksi.total,
  transaksi.created_at
FROM transaksi
JOIN users ON transaksi.user_id = users.id
JOIN produk ON transaksi.produk_id = produk.id
ORDER BY transaksi.created_at DESC;
```
Ambil total pembelian per user
```
SELECT 
    users.name AS nama_pengguna,
    COUNT(transaksi.id) AS jumlah_transaksi,
    SUM(transaksi.total) AS total_belanja
FROM transaksi
JOIN users 
ON users.id = transaksi.user_id
GROUP BY users.name
ORDER BY total_belanja DESC;
```
Ambil transaksi 7 hari terakhir
```
ql SELECT * FROM transaksi WHERE created_at >= NOW() - INTERVAL '7 days'; 
```
## 🧩 FILTER, PENCARIAN, PAGINATION
| Tujuan                           | Query SQL                                                             |
| -------------------------------- | --------------------------------------------------------------------- |
| Cari produk nama mengandung kata | `SELECT * FROM produk WHERE nama ILIKE '%sabun%';`                    |
| Filter harga dalam rentang       | `SELECT * FROM produk WHERE harga BETWEEN 10000 AND 50000;`           |
| Filter per tahun                 | `SELECT * FROM transaksi WHERE EXTRACT(YEAR FROM created_at) = 2025;` |
| Pagination (halaman data)        | `SELECT * FROM produk ORDER BY id DESC LIMIT $1 OFFSET $2;`           |

## 📊 AGGREGATE & LAPORAN
Total transaksi per user
```
SELECT 
    user_id,
    COUNT(*) AS jumlah_transaksi,
    SUM(total) AS total_pengeluaran
FROM 
    transaksi
GROUP BY 
    user_id
ORDER BY 
    total_pengeluaran DESC;

```       
Laporan penjualan gabungan (user + produk)
```
SELECT 
    users.name AS nama_pengguna,
    produk.nama AS nama_produk,
    SUM(transaksi.total) AS total_penjualan
FROM 
    transaksi
JOIN 
    users 
ON 
    users.id = transaksi.user_id
JOIN 
    produk 
ON 
    produk.id = transaksi.produk_id
GROUP BY 
    users.name, 
    produk.nama;

```

Ambil tahun, bulan, dan hari dari tanggal transaksi
```
SELECT 
    EXTRACT(YEAR FROM created_at) AS tahun,
    EXTRACT(MONTH FROM created_at) AS bulan,
    EXTRACT(DAY FROM created_at) AS hari
FROM 
    transaksi;

```
## 🧾 AUTENTIKASI
| Tujuan                     | Query SQL                                        |
| -------------------------- | ------------------------------------------------ |
| Cek user by email (login)  | `SELECT id, password FROM users WHERE email=$1;` |
| Cek apakah email sudah ada | `SELECT 1 FROM users WHERE email=$1;`            |

## 🕓 WAKTU & TIMESTAMP
| Tujuan                    | Query SQL                                                                                             |
| ------------------------- | ----------------------------------------------------------------------------------------------------- |
| Tambah kolom timestamp    | `ALTER TABLE produk ADD COLUMN created_at TIMESTAMP DEFAULT NOW();`                                   |
| Update otomatis timestamp | *(pakai trigger)*                                                                                     |
| Ambil data bulan lalu     | `SELECT * FROM transaksi WHERE created_at >= date_trunc('month', CURRENT_DATE - interval '1 month');` |

## 🧮 VIEW (TABEL VIRTUAL)
| Tujuan                | Query SQL                                                                                                                                                                                |
| --------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Buat laporan gabungan | `sql CREATE VIEW laporan_transaksi AS SELECT t.id, u.name AS user, p.nama AS produk, t.total, t.created_at FROM transaksi t JOIN users u ON t.user_id=u.id JOIN produk p ON p.id=p.id; ` |
| Ambil data view       | `SELECT * FROM laporan_transaksi;`                                                                                                                                                       |

## ⚙️ INDEKS (OPTIMASI BESARAN DATA)
| Tujuan                             | Query SQL                                                   |
| ---------------------------------- | ----------------------------------------------------------- |
| Percepat pencarian email user      | `CREATE INDEX idx_users_email ON users(email);`             |
| Percepat filter transaksi per user | `CREATE INDEX idx_transaksi_user_id ON transaksi(user_id);` |

## 💾 STRUKTUR TABEL PRODUKSI
users
```
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100) UNIQUE NOT NULL,
    password TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    deleted_at TIMESTAMP
);

```
produk
```
CREATE TABLE produk (
    id SERIAL PRIMARY KEY,
    nama VARCHAR(150),
    harga INT,
    jumlah INT DEFAULT 0,
    image TEXT,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    deleted_at TIMESTAMP
);

```
transaksi
```
CREATE TABLE transaksi (
    id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(id),
    produk_id INT REFERENCES produk(id),
    jumlah INT,
    total INT,
    created_at TIMESTAMP DEFAULT NOW()
);


```
















## 🧠 BONUS — SUBQUERY REAL PROJECT

Ambil user dengan total belanja > 1 juta
```        
SELECT 
    users.name AS nama_pengguna,
    (
        SELECT 
            SUM(transaksi.total) 
        FROM 
            transaksi 
        WHERE 
            transaksi.user_id = users.id
    ) AS total_belanja
FROM 
    users
WHERE 
    (
        SELECT 
            SUM(transaksi.total) 
        FROM 
            transaksi 
        WHERE 
            transaksi.user_id = users.id
    ) > 1000000;


```

Ambil produk yang pernah dibeli
```        
sql SELECT DISTINCT p.* FROM produk p JOIN transaksi t ON p.id = t.produk_id;
```
