# relasi nested level 1

```
select madu.nama,
coalesce(
	json_agg(
		json_build_object(
      'key', user.value
	) filter(where users.id is not null),'[]'
)
from madu
left join users on users.maduid= madu.id
group by madu.nama, 
```

# relasi nested level 2

```
select madu.nama,
coalesce(
	json_agg(
		json_build_object(
      'key', user.value,
      'key', coalesce((
              select json_agg(
                json_build_object(
                  'key',produk.value,
                )
              ) from produk where produk.userid=users.id
      ),'[]')
	) filter(where users.id is not null),'[]'
)
from madu
left join users on users.maduid= madu.id
group by madu.nama, 
```

# relasi nested level 3

```
SELECT 
  madu.nama,
  COALESCE(
    json_agg(
      json_build_object(
        'key', user.value,
        'key', COALESCE(
          (
            SELECT json_agg(
              json_build_object(
                'key', produk.value,
                'key', COALESCE(
                        (
                          SELECT json_agg(
                            json_build_object( 'key', etalase.value )
                          )
                          FROM etalase WHERE etalase.idproduk = produk.id
                        ),
                        '[]'
                      )
              )
            )
            FROM produk WHERE produk.userid = users.id
          ),
          '[]'
        )
      )
    ) FILTER (WHERE users.id IS NOT NULL),
    '[]'
  )
FROM madu
LEFT JOIN users ON users.maduid = madu.id
GROUP BY madu.nama;

```
