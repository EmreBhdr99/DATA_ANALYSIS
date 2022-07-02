
--- SQL-6. ders_08.06.2022(session-5)

-- Ge�en dersten kalan yeri bitirece�iz
-- VIEWS
-- Database de SQL server�n y�netti�i db ler var. Bu bir disk alan�. Verilerimiz tablolarda bulunuyor
-- .. fiziksel olarak. Tablolarda ayn� �ekilde. Tablolar �zerine kurulan bir mimari var (dashborad vs) 
-- .. Bu tablolardan birinde bir de�i�iklik olursa �st katmanda b�y�k sorun olabilir.
-- .. Bu katman aras�nda stabil katmana ihtiyac�m�z var. Bu katman� sa�lad���m�z noktalardan birisi view
    --1.Bir tablonun g�r�nt�s�n� olu�turuyoruz. Bu g�r�nt� fiziksel olarak ayr� bir yer kaplam�yor. Tablolara
        -- .. ba�lant� sa�l�yor
    -- 2.Bir sorgumuz var. �ok uzun bu sorgu ama ihtiya� duyuyoruz diyelim. Bunu farkl� bir yerde bir kural olarak tan�mlarsak
       -- .. Bu view �zerinden daha rahat bir �ekilde sorgumuzu yapabiliriz
   -- CREATE VIEW view_name AS SELECT columns from tables [WHERE conditions];
-- Advantages of Views: Performance(bir uzun sorguyu view olarak kaydedip kullanma), Security, Storage, Simplicity

-- Soru: �r�n bilgilerini stok miktarlar� ile birlikte listeleyin demi�tik altta
SELECT	A.product_id, A.product_name, B.*
FROM	product.product A
LEFT JOIN product.stock B ON A.product_id = B.product_id
WHERE	A.product_id > 310;

-- Bu sorguyu bir view olarak kaydedelim
CREATE VIEW ProductStock AS
SELECT	A.product_id, A.product_name, B.*
FROM	product.product A
LEFT JOIN product.stock B ON A.product_id = B.product_id
WHERE	A.product_id > 310;

-- Hata. product_id 2 kere ge�iyor
CREATE VIEW ProductStock AS
SELECT	A.product_id, A.product_name, B.store_id,B.quantity
FROM	product.product A
LEFT JOIN product.stock B ON A.product_id = B.product_id
WHERE	A.product_id > 310;

-- Command completed sucsesfully
-- sampleretail-views-dbo.ProductStock

-- Bunu sorgular�m�n i�inde tablo olarak kullanabilirim
SELECT * FROM dbo.ProductStock
--Sorgu sonucunun ayn�s� geldi

-- Ko�ul da ekleyebiliriz
SELECT * FROM dbo.ProductStock
WHERE store_id=1

-- NOT: Bunu tek sorgu i�in yapabiliriz. Daha fazla sorgu i�in "procedure" kullanaca��z ilerde
-- NOT: ProductStock sadece bir script, as�l tabloyla olan bir ili�kisi var. Depolamada b�y�k katk�s� var
-- NOT: Bunu tablo olarak create edemez miyiz? Edebiliriz. O tablo fiziksel bir tablodur, dinamik bir tablo olmaz
-- NOT: Tablonun hep son durumu(de�i�meden �nceki(e�er de�i�tiyse)) ile ilgili bilgi almak istersem view kullanmal�y�z
-- NOT: VIEW i�erisinden ORDER BY kullanamay�z(VIEW OLU�MAYACAKTI). VIEW olu�tuktan sonra ORDER BY � kullanabiliriz
-- NOT: VIEW i�indeki sorgu i�in sampleretail-->view-->dbo.ProductStock--> sa� t�k-->design

---------------------------------
SELECT	A.product_id, A.product_name, B.store_id, B.quantity
INTO	#ProductStock
FROM	product.product A
LEFT JOIN product.stock B ON A.product_id = B.product_id
WHERE	A.product_id > 310;

SELECT * FROM #ProductStock;
-- Bu da diez ile bir ba�lant� ile olu�turulan ge�ici view. Ba�lant� kapan�nca bu gider


----------------------------

-- Hoca: Sizde buna VIEW yap�p al��t�rma yapal�m
-- Ma�aza �al��anlar�n� �al��t�klar� ma�aza bilgileriyle birlikte listeleyin
-- �al��an ad�, soyad�, ma�aza adlar�n� se�in
SELECT	A.first_name, A.last_name, B.store_name
FROM	sale.staff A
INNER JOIN sale.store B
	ON	A.store_id = B.store_id;
    
-- ��z�m
CREATE VIEW SaleStaff as
SELECT  A.first_name, A.last_name, B.store_name
FROM    sale.staff A
INNER JOIN sale.store B
    ON  A.store_id = B.store_id
    

--%% ADVANCED GROUPING FUNCTIONS
-- Table of Contents
-- Having clause
-- Grouping sets
-- Rollup
-- Cube
-- Pivot

--�rnek: bir ma�azada toplam ka� tane �r�n var(ma�aza baz�nda)
-- �rnek: A kategorisindeki �r�nlerin ortalama fiyat� vs
-- Bunlar� grouping functions la yap�yoruz
-- Group by + agregation kullanaca��z
/*
A   0     
B   5      
C   10
A   5            -----  A 15
B   10           ------ B 30
C   15           ------ C 45
A   10
B   15
C   20
*/


-- Soru: Ka� farkl� markaya ait �r�n�m var
-- Brand tablosu : 40 sat�r var. Gruplama yapmadan sayd�ral�m
-- Marka: brand , Brand tablosu ve product tablosunda var
SELECT COUNT(*) FROM product.brand

-- Hangi markadan ka� tane �r�n var
-- Gruplama yapal�m
Select brand_id, count(*) as CountOfProduct from product.product
group by brand_id

-- Count(*): Sat�r�n tamam�n� sayar, e�er eksik verisi olan sat�ra count dersek eksik kalabilir


--Dersin 2. b�l�m�

--Soru: Kategori baz�ndaki toplam �r�n say�s�
SELECT A.category_id, B.category_name, count(*) CountOfProduct 
from product.product A
INNER JOIN product.category B
on A.category_id = B.category_id
group by A.category_id, B.category_name


-------------------------
-- 1.Having Clause
-- Group by l� sorgu sonucunda olan filtrelemeleri HAVING ile yap�yoruz
-- SQL SERVER OKUMA SIRASI: FROM--> WHERE --> GROUP BY --> HAVING -- > SELECT --> ORDER BY


--Model y�l� 2016 dan b�y�k olan �r�nlerin liste fiyatlar�n�n ortalamas�n�n 
-- .. 1000 den fazla oldu�u markalar�n fiyatlar�n� listeleyin
-- INNER JOIN yerine alltaki �ekilde virg�l koyarak yapabiliriz
select	b.brand_name, avg(a.list_price) AS AvgPrice
from	product.product a, product.brand b
where	a.brand_id = b.brand_id
		and a.model_year > 2016
group by b.brand_name
having avg(a.list_price) > 1000
order by 2 DESC

-- NOT: AVG(A.list_price) a Alias vermi� olsayd�k bunu Having k�sm�nda kullanamam

--SORU: Write a query that checks if any product id is repeated in more than one row in the products table
-- Products id si 1 den fazla olan sat�r var m�
SELECT	product_id, COUNT (product_id) num_of_rows
FROM	product.product
GROUP BY product_id
HAVING COUNT (product_id) > 1

-- SORU: max liste fiyat� 4000 �st�, min liste fiyat� 500 alt�nda olan category_id leri getirin
SELECT	category_id, Min(list_price) min_ , Max(list_price) max_
FROM	product.product
GROUP BY category_id
HAVING Min(list_price) <500 or Max(list_price) > 4000

--Her bir sipari�teki toplam fiyat.discount' � ve quantity' yi ihmal etmeyiniz.
SELECT	order_id, SUM((list_price * quantity)*(1-discount)) Net_Price 
FROM sale.order_item
GROUP BY order_id

-- Dersin 3. b�l�m�
-----
-- 2.Grouping Sets
-- Raporlama yaparken y�m gruplama sonu�lar�n�n tek bir sot

 --SELECT column1, column2, aggregate_fucntion(column3) FROM table_name
 --Group by GROUPING SETS...


-- Herbir kategorideki toplam �r�n say�s�
-- Herbir model y�l�ndaki toplam �r�n say�s�
-- Herbir kategorinin model y�l�ndaki toplam �r�n say�s�

-- grouping sets
select	category_id, model_year, count(*) CountOfProducts
from	product.product
group by
	grouping sets (
				(category_id), -- 1. group
				(model_year), -- 2. group
				(category_id, model_year) -- 3. group
	)

order by 1, 2

--NOT: "having model_year is null"  gibi filtrelemede ekleyebiliriz


---
-- 3.Rollup
--Sorgunun sonucunu istedi�imiz s�rada sonu� getirir
-- Her bir grup kombinasyonunu olu�turup ona g�re sonu� getirir
-- Select d1,d2,d3,aggregate_function(c4) FROM table_name Group by rollup(d1,d2,d3)


Select category_id,model_year, count(*) FROM product.product Group by rollup(category_id,model_year)

--Herbir marka id, herbir category id ve herbir model y�l� i�in toplam �r�n say�lar�n� getiriniz.
-- Sonu� tablosunda t�m ihtimaller bulunsun

Select category_id,brand_id,model_year, count(*) FROM product.product
Group by rollup(category_id,brand_id,model_year)

-------------------------
-- 4.CUBE
-- Roll up 1. de�i�keni al�yordu s�ral�yordu sonra 2. vs 
-- Burada da tam tersten geliyor.
-- Roll up ile yaz�m� ayn� sadece CUBE yaz�yoruz

-- Soru
Select category_id,model_year, count(*) FROM product.product Group by CUBE(category_id,model_year)

-------------------------
-- 5.PIVOT
-- Python da bir de�i�kenin i�erisindeki veriler bilmeden pivot yapabiliyorduk
-- SQL de her bir s�tun ba�l���n� tan�mlamam�z gerekiyor. Python la ayn� sonucu veriyor
-- Pivota ta��yaca��m�z s�tunlar� biliyorsak python da yap�labilir.


-- 2018 y�l�na ait 177 �r�n , 2019 model y�l�na ait, 140 �r�n varm��, 2020 y�l� 121, 2021 y�l� 82
-- Normalde bunu nas�l yap�yorduk
Select model_year,count(*) from product.product group by model_year

-- Pivot table ile 

SELECT *
FROM
			(
			SELECT product_id, Model_Year
			FROM product.product
			) A
PIVOT
(
	count(product_id)
	FOR Model_Year IN
	(
	[2018], [2019], [2020], [2021]
	)
) AS PIVOT_TABLE
;

--------------------
--3. de�i�ken i�in

SELECT *
FROM
			(
			SELECT category_id, Model_Year, product_id
			FROM product.product
			) A
PIVOT
(
	count(product_id)
	FOR Model_Year IN
	(
	[2018], [2019], [2020], [2021]
	)
) AS PIVOT_TABLE
;


------------------
SELECT *
FROM
			(
			SELECT category_id, Model_Year, product_id
			FROM product.product
			) A
PIVOT
(
	count(product_id)
	FOR Model_Year IN
	(
	[2018], [2019], [2020], [2021]
	)
) AS PIVOT_TABLE
UNION ALL
SELECT NULL, *
FROM
			(
			SELECT Model_Year, product_id
			FROM product.product
			) A
PIVOT
(
	count(product_id)
	FOR Model_Year IN
	(
	[2018], [2019], [2020], [2021]
	)
) AS PIVOT_TABLE