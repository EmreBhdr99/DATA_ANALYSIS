

---Session 09----

---EXISTS - NOT EXISTS



---- Apple - Pre-Owned iPad 3 - 32GB - White �r�n�n hi� sipari� verilmedi�i eyaletleri bulunuz.
--Eyalet m��terilerin ikamet adreslerinden al�nacakt�r.


-- A�a��daki �r�n� sat�n alan m��terilerin eyalet listesi
select	distinct C.state
from	product.product P,
		sale.order_item I,
		sale.orders O,
		sale.customer C
where	P.product_name = 'Apple - Pre-Owned iPad 3 - 32GB - White' and
		P.product_id = I.product_id and
		I.order_id = O.order_id and
		O.customer_id = C.customer_id
;


---- A�a��daki �r�n� sat�n almayan m��terilerin eyalet listesi
select	distinct [state]
from	sale.customer C2
where	not exists (
			select	1           ---Select blo�una ne yaz�ld���n�n �nemi yok.
			from	product.product P,
					sale.order_item I,
					sale.orders O,
					sale.customer C
			where	P.product_name = 'Apple - Pre-Owned iPad 3 - 32GB - White' and
					P.product_id = I.product_id and
					I.order_id = O.order_id and
					O.customer_id = C.customer_id and
					C2.state = C.state
		)
;

--Burkes Outlet ma�aza sto�unda bulunmay�p,
-- Davi techno ma�azas�nda bulunan �r�nlerin stok bilgilerini d�nd�ren bir sorgu yaz�n.

select ps.product_id, ps.store_id, ps.quantity,ss.store_name
from sale.store ss, product.stock ps
where ss.store_id = ps.store_id and ss.store_name = 'Davi techno Retail' and
    NOT EXISTS(
			   select 1
			   from sale.store B , product.stock A
			   where B.store_id = A.store_id and B.store_name ='Burkes Outlet' and
					A.quantity>0 and A.product_id = ps.product_id
			  )
;

--��z�m2

select ps.product_id, ps.store_id, ps.quantity,ss.store_name
from sale.store ss, product.stock ps
where ss.store_id = ps.store_id and ss.store_name = 'Davi techno Retail' and
    EXISTS(
			   select 1
			   from sale.store B , product.stock A
			   where B.store_id = A.store_id and B.store_name ='Burkes Outlet' and
					A.quantity=0 and A.product_id = ps.product_id
			  )
;

-- Brukes Outlet storedan al�n�p The BFLO Store ma�azas�ndan hi� al�nmayan �r�n var m�?
-- Varsa bu �r�nler nelerdir?
-- �r�nlerin sat�� bilgileri istenmiyor, sadece �r�n listesi isteniyor.

SELECT P.product_name, p.list_price, p.model_year
FROM product.product P
WHERE NOT EXISTS (
		SELECt	I.product_id
		FROM	sale.order_item I,
				sale.orders O,
				sale.store S
		WHERE	I.order_id = O.order_id AND S.store_id = O.store_id
				AND S.store_name = 'The BFLO Store'
				and P.product_id = I.product_id)
	AND
	EXISTS (
		SELECt	I.product_id
		FROM	sale.order_item I,
				sale.orders O,
				sale.store S
		WHERE	I.order_id = O.order_id AND S.store_id = O.store_id
				AND S.store_name = 'Burkes Outlet'
				and P.product_id = I.product_id)
;

--��z�m2

SELECT	distinct I.product_id
		FROM	sale.order_item I,
				sale.orders O,
				sale.store S
		WHERE	I.order_id = O.order_id AND S.store_id = O.store_id
				AND S.store_name = 'Burkes Outlet'
except
		SELECt	distinct I.product_id
		FROM	sale.order_item I,
				sale.orders O,
				sale.store S
		WHERE	I.order_id = O.order_id AND S.store_id = O.store_id
				AND S.store_name = 'The BFLO Store'
;

--- Common Table Expression (CTE)


-- Jerald Berray isimli m��terinin son sipari�inden �nce sipari� vermi� 
--ve Austin �ehrinde ikamet eden m��terileri listeleyin.

with tbl as  ( 
select max(so.order_date) JeraldLastOrder
from sale.orders so,sale.customer sc
where so.customer_id = sc.customer_id and sc.first_name ='Jerald' and sc.last_name= 'Berray'
             )
select *             ---tbl ile birlikte �al��t�r�l�r.
from sale.orders so, sale.customer sc, tbl c
where so.customer_id = sc.customer_id and c.JeraldLastOrder >so.order_date and sc.city = 'Austin'


-- Herbir markan�n sat�ld��� en son tarihi bir CTE sorgusunda,
-- Yine herbir markaya ait ka� farkl� �r�n bulundu�unu da ayr� bir CTE sorgusunda tan�mlay�n�z.
-- Bu sorgular� kullanarak  Logitech ve Sony markalar�na ait son sat�� tarihini ve toplam �r�n say�s�n� (product tablosundaki) ayn� sql sorgusunda d�nd�r�n�z.


with tbl as(
	select	br.brand_id, br.brand_name, max(so.order_date) LastOrderDate
	from	sale.orders so, sale.order_item soi, product.product pr, product.brand br
	where	so.order_id=soi.order_id and
			soi.product_id = pr.product_id and
			pr.brand_id = br.brand_id
	group by br.brand_id, br.brand_name
),
tbl2 as(
	select	pb.brand_id, pb.brand_name, count(*) count_product
	from	product.brand pb, product.product pp
	where	pb.brand_id=pp.brand_id
	group by pb.brand_id, pb.brand_name
)
select	*
from	tbl a, tbl2 b
where	a.brand_id=b.brand_id and
		a.brand_name in ('Logitech', 'Sony')
;


---Recursive CTE

-- 0'dan 9'a kadar herbir rakam bir sat�rda olacak �ekide bir tablo olu�turun.

with cte AS (
	select 0 rakam
	union all
	select rakam + 1
	from cte
	where rakam < 9
)
select * from cte;

-- 2020 ocak ay�n�n herbir tarihi bir sat�r olacak �ekilde 31 sat�rl� bir tablo olu�turunuz.
with ocak as (
	select	cast('2020-01-01' as date) tarih
	union all
	select	cast(DATEADD(DAY, 1, tarih) as date) tarih
	from ocak
	where tarih < '2020-01-31'
)
select * from ocak
;

with cte AS (
	select cast('2020-01-01' as date) AS gun
	union all
	select DATEADD(DAY,1,gun)
	from cte
	where gun < EOMONTH('2020-01-01')
)
select gun AS tarih, day(gun) gun, month(gun) ay, year(gun) yil,
	EOMONTH(gun) ayinsongunu
from cte;

--Write a query that returns all staff with their manager_ids. (use recursive CTE)

with cte as (
	select	staff_id, first_name, manager_id
	from	sale.staff
	where	staff_id = 1
	union all
	select	a.staff_id, a.first_name, a.manager_id
	from	sale.staff a, cte b
	where	a.manager_id = b.staff_id
)
select *
from	cte
;

--2018 y�l�nda t�m ma�azalar�n ortalama cirosunun alt�nda ciroya sahip ma�azalar� listeleyin.
--List the stores their earnings are under the average income in 2018.

WITH T1 AS (
SELECT	c.store_name, SUM(list_price*quantity*(1-discount)) Store_earn
FROM	sale.orders A, SALE.order_item B, sale.store C
WHERE	A.order_id = b.order_id
AND		A.store_id = C.store_id
AND		YEAR(A.order_date) = 2018
GROUP BY C.store_name
),
T2 AS (
SELECT	AVG(Store_earn) Avg_earn
FROM	T1
)
SELECT *
FROM T1, T2
WHERE T2.Avg_earn > T1.Store_earn
;