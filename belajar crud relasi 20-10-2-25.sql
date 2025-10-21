select * from produk
select * from users

select users.name, users.username, users.password,
json_agg(
	json_build_object(
		'id', produk.id,
		'nama', produk.nama,
		'desk', produk.desk,
		'harga', produk.harga
	)
) as produk_list
from users
left join produk on produk.userid = users.id
group by users.id

insert into produk ( nama, desk, harga, jumlah, image ) values ('kangkung', 'genjer',2000,2000,'img.jpg')

select users.name, users.username, users.password,
COALESCE(
	json_agg(
		json_build_object('id', produk.id, 'nama',produk.nama, 'desk', produk.desk, 'harga', produk.harga) 
	) filter(where produk.id is not null),'[]'
) as produk_list
from users
left join produk on produk.userid = users.id
group by users.id, users.name, users.username, users.password;

select * from customer
insert into customer(id,customer_name, contact_name, addres, no_house, city, postal_code ) 
values (1, 'CustomerName', 'ContactName', 'Address', 24, 'City', 'PostakCode' )

drop table customer

select * from madu
alter table users add column maduid INT 
select * from users
select * from produk
update users set maduid=7 where id=2




-- relasi left join madu user dan produk

select madu.nama, madu.jenis, madu.harga, madu.stok, 
COALESCE(
	json_agg(
		json_build_object(
		'id', users.id,
		'username', users.username,
		'produk_data',COALESCE(
				(
					select json_agg(
						json_build_object( 'nama', produk.nama, 'desk', produk.desk, 'harga', produk.harga)
					) 
				) from produk where produk.userid = users.id	
			) ,'[]'
		) 
		LEFT JOIN produk on produk.userid = users.id
		group by user.id,users.username
	) FILTER (WHERE users.id IS NOT NULL),'[]'
) AS madu_user
from madu
left join users on users.maduid = madu.id
group by madu.nama,madu.jenis,madu.harga,madu.stok


-- madu {
-- 	users: [
-- 		{
-- 			produk : [{}]
-- 		}
-- 	]
-- }

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

create table etalase (
	id SERIAL PRIMARY KEY,
	nama_etalase VARCHAR(255),
	no_etalase INT
	
)

insert into etalase(nama_etalase,no_etalase) 
values('madu banten',1123)
insert into etalase(nama_etalase,no_etalase)
values ('madu jawa',22313)

update etalase set nama_etalase='madu kalimantan' where id=2

select * from etalase
alter table etalase add column idproduk int 


-- madu {
-- 	users: [
-- 		{
-- 			produk : [
						-- {
							-- etalases: [{}]
						-- }
            ]
-- 		}
-- 	]
-- }

select * from madu
select * from users
select * from produk
select * from etalase

update etalase set idproduk=2 where id=2


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











