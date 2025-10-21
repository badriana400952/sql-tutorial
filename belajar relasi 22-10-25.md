# relasi
```
COALESCE(json_agg(nama), '[]') // mirip ternari COALESCE(true, false)

```
```
json_agg() // untuk membuat array []
```
```
json_build_object('key', value) // untuk membuat object { key: value }
```
```
left join users on users.maduid= madu.id
group by madu.nama, madu.jenis,madu.harga, madu.stok
```
```
select madu.nama, madu.jenis, madu.harga, madu.stok,
coalesce((),'[]')
from madu
left join users on users.maduid= madu.id
group by madu.nama, madu.jenis,madu.harga, madu.stok
```

### nested level 1
```
select users.name, users.username, users.password,
COALESCE(
	json_agg(
		json_build_object(
          'id', produk.id,
          'nama',produk.nama,
          'desk', produk.desk,
          'harga', produk.harga
          ) 
	) filter(where produk.id is not null),'[]'
) as produk_list
from users
left join produk on produk.userid = users.id
group by users.id, users.name, users.username, users.password;
```
### nested level 2
```
SELECT 
  madu.id,
  madu.nama,
  COALESCE(
    (
      SELECT json_agg(
        json_build_object(
          'id', u.id,
          'username', u.username,
          'produk_list', COALESCE(
            (
              SELECT json_agg(
                json_build_object('id', p.id, 'nama', p.nama)
              )
              FROM produk p
              WHERE p.userid = u.id
            ),
            '[]'
          )
        )
      )
      FROM users u
      WHERE u.maduid = madu.id
    ),
    '[]'
  ) AS user_list
FROM madu;

```

```
select * from madu
select * from users
select * from produk
select madu.id, madu.nama, madu.jenis, madu.harga, madu.stok,
COALESCE(
	json_agg(
		json_build_object(
		'name', users.name, 
		'uasename',users.username,
		'createdat',users.createdat,
		'produks', coalesce(
					(
						select json_agg(
							json_build_object(
								'nama',produk.nama,
								'desk',produk.desk,
								'harga',produk.harga,
								'jumlah',produk.jumlah
							)
						) from produk where produk.userid = users.id
					), '[]'
		)
		)
	) filter(where users.id is not null), '[]'
) as madu_user
from madu
left join users on users.maduid = madu.id
group by madu.id, madu.nama, madu.jenis, madu.harga, madu.stok

//hasil
{
  "id": 1,
  "nama": "Madu Hutan",
  "jenis": "Asli",
  "harga": 50000,
  "stok": 50,
  "madu_user": [
    {
      "name": "Andi",
      "username": "andi123",
      "createdat": "2025-10-01T10:00:00",
      "produks": [
        { "nama": "Madu Botol A", "desk": "Madu hutan murni", "harga": 55000, "jumlah": 10 },
        { "nama": "Madu Mini A", "desk": "Madu 100ml", "harga": 20000, "jumlah": 15 }
      ]
    },
    {
      "name": "Budi",
      "username": "budi456",
      "createdat": "2025-10-02T11:00:00",
      "produks": [
        { "nama": "Madu Botol B", "desk": "Madu campuran", "harga": 45000, "jumlah": 20 }
      ]
    }
  ]
}


```
### sekarang ke nested 3

buat table etalase
```
### create table etalase (
	id SERIAL PRIMARY KEY,
	nama_etalase VARCHAR(255),
	no_etalase INT
)
```
```
insert into etalase(nama_etalase,no_etalase) 
values('madu banten',1123)
```
lupa tambah produkid
```
alter table etalase add column idproduk int
```


sekarang mulai
buat templat nya agar bisa memahami

### level 1
```
select madu.nama, madu.jenis, madu.harga, madu.stok,
coalesce()
from madu
left join users on users.maduid= madu.id
group by madu.nama, madu.jenis,madu.harga, madu.stok
```
```
select madu.nama, madu.jenis, madu.harga, madu.stok,
coalesce(
  json_agg(),
	'[]'
)
from madu
left join users on users.maduid= madu.id
group by madu.nama, madu.jenis,madu.harga, madu.stok
```
```
select madu.nama, madu.jenis, madu.harga, madu.stok,
coalesce(
	json_agg(
		json_build_object(
			'id',users.id,
			'name',users.name,
			'username',users.username,
			'createdat',users.createdat
		)
	) filter(where users.id is not null),'[]'
)
from madu
left join users on users.maduid= madu.id
group by madu.nama, madu.jenis,madu.harga, madu.stok
```
### level 2
```
select madu.nama, madu.jenis, madu.harga, madu.stok,
coalesce(
	json_agg(
		json_build_object(
			'id',users.id,
			'name',users.name,
			'username',users.username,
			'createdat',users.createdat,
			'produk_user', coalesce(
					(
						select json_agg(
						json_build_object(
							'nama',produk.nama,
							'desk',produk.desk,
							'harga',produk.harga,
							'jumlah',produk.jumlah
					) from produk where produk.userid=users.id
					),'[]'
				)
		) 
	) filter(where users.id is not null),'[]'
)
from madu
left join users on users.maduid= madu.id
group by madu.nama, madu.jenis,madu.harga, madu.stok

```
### level 3
```
select madu.nama, madu.jenis, madu.harga, madu.stok,
coalesce(
	json_agg(
		json_build_object(
			'id',users.id,
			'name',users.name,
			'username',users.username,
			'createdat',users.createdat,
			'produk_user', coalesce(
					(
						select json_agg(
						json_build_object(
							'nama',produk.nama,
							'desk',produk.desk,
							'harga',produk.harga,
							'jumlah',produk.jumlah,
							'etalases', coalesce(
								(
									select json_agg(
											json_build_object(
												'nama_etalase',etalase.nama_etalase,
												'no_etalase',etalase.no_etalase
											)
									) from etalase where etalase.idproduk = produk.id
								),'[]'
							)
						)
					) from produk where produk.userid=users.id
					),'[]'
				)
		) 
	) filter(where users.id is not null),'[]'
)
from madu
left join users on users.maduid= madu.id
group by madu.nama, madu.jenis,madu.harga, madu.stok

```
hasil

```
[
  {
    "id": 2,
    "name": "adrians",
    "username": "dirgantara",
    "createdat": "2025-10-20",
    "produk_user": [
      {
        "nama": "kopi susu",
        "desk": "kopi susu kosu",
        "harga": 5000,
        "jumlah": 12,
        "etalases": []
      },
      {
        "nama": "josu",
        "desk": "josu",
        "harga": 5000,
        "jumlah": 12,
        "etalases": [
          {
            "nama_etalase": "madu banten",
            "no_etalase": 1123
          },
          {
            "nama_etalase": "madu kalimantan",
            "no_etalase": 2231
          }
        ]
      }
    ]
  }
]
```
