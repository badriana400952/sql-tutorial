select * from category
select * from category order by name limit 3

-- distinct
select distinct name from category
select distinct name, id from category limit 3

-- numeric function
-- % * = - / DIV
select * from category
select id DIV 1 as 'hmmmm' from category
select 'Badriana' = 'Badriana' as hasil
select name = 'Badriana' from category


-- membuat tabel dengan auto increment 
CREATE TABLE produk (
id SERIAL PRIMARY KEY,
nama VARCHAR(222),
desk VARCHAR(222),
harga INT
)

select * from produk
-- menambahkan kolom di table
ALTER TABLE produk ADD COLUMN jumlah INT 
ALTER TABLE produk ADD COLUMN image TEXT

-- tambah data ke produk
insert into produk (
nama,desk,harga,jumlah,image
) values (
'izzah','hahahaha',5000,2,'image.jpg'
)

select * from produk
-- delete produk
DELETE FROM produk WHERE id = 3
-- lihat 1 produk
select * from produk where id = 2



-- string function
-- LOWER(),
select id, nama,desk,harga from produk
SELECT 
id, 
nama,
LOWER(desk) as "desk_lower",
LENGTH(desk) as "desk_length",
UPPER(desk) as "desk_upper",
desk,
harga
FROM produk
-- date function
ALTER TABLE produk ADD COLUMN createdat DATE
select id, nama, desk,image,createdat, EXTRACT(YEAR FROM createdat) as "tahun" from produk
select id, nama, desk,image,createdat, EXTRACT(MONTH FROM createdat) from produk
select id, nama, desk,image,createdat, EXTRACT(DAY FROM createdat) from produk
select id, nama, desk,image,createdat, YEAR(createdat) from produk




