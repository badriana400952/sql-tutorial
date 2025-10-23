### Agregasi dan Grouping
```

| Fungsi    | Deskripsi               | Contoh       |        keterangan                                    |
| --------- | ----------------------- | ------------ |------------------------------------------------------|
| `SUM()`   | Menjumlahkan nilai      | `SUM(total)` | menjumlahkan semua kolom harga                       |
| `COUNT()` | Menghitung jumlah baris | `COUNT(*)`   | menghitung berapa banyak baris harga yang tidak null |
| `AVG()`   | Menghitung rata-rata    | `AVG(total)` | menghitung rata rata semua kolom pada harga          |
| `MIN()`   | Nilai terkecil          | `MIN(total)` | mencari nilai terkecil di kolom harga                |
| `MAX()`   | Nilai terbesar          | `MAX(total)` | mencari nilai terbesar di kolom harga                |

```

```
select * from produk
select sum(harga) as sum from produk
select count(harga) as count from produk
select AVG(harga) as avg from produk
select min(harga) as min from produk
select max(harga) as max from produk
```

jika kita ingin menampilkan beberapa produk tetapi menggunakan agregasi
```
cara yang salah
select sum(harga) as sum, produk.harga from produk

cara yang benar
select keranjang_id, sum(harga) as sum, min(nama) from produk group by keranjang_id


```
