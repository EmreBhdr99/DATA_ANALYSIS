


SELECT TRIM(' CHARACTER');

SELECT ' CHARACTER' ;--Baþýnda boþluk olduðu gözüküyor.

SELECT TRIM(' CHARACTER ')

SELECT TRIM(    ' CHAR ACTER ') -- Ýçeri yazýlan metin tek týrnaktan sonra baþlar, önceki boþluðun önemi olmaz, algýlamaz.

SELECT TRIM('ABC' FROM 'CCCCBBBAAAFRHGKDFKSLDFJKSDFACBBCACABACABCA')

SELECT TRIM('X' FROM 'ABCXXDE') -- Baþ veya sonda olmadýðý için ayný þekilde çýktý verir.

SELECT TRIM('X' FROM 'XXXXXXXXXXXXXXXABCXXDEXXXXXXXXXXXX') --Baþtan ve sondan X dýþýnda bir harf görene kadar gidip durdu.

SELECT TRIM('ABC' FROM 'CCCBBBAAAFRASDJAMDASDÖAACBBCACABAACABCA') --Baþtan ve sondan A,B,C harflerinin dýþýnda harf arar, görünce durur ve diðer kýsmý atar.

SELECT LTRIM ('     CHARACTER ') ---Sadece soldaki boþluklarý temizler.


SELECT RTRIM ('     CHARACTER ') --- Sadece saðdaki boþluklarý temizler.


---STRING, REPLACE

SELECT REPLACE('CHARACTER STRING', ' ', '/') --Metnin neresinde olursa olsun verilen ifadeyi istenen ifadeyle deðiþtirir.


SELECT REPLACE('CHARACTER STRING', 'CHARACTER STRING', 'CHARACTER')

SELECT STR (5454) -- '' olmadan verildiði için SQL otomatik olarak numeric deðer olarak algýlar.

SELECT STR(2135454654)

SELECT STR(133215.654645, 11,3) -- 11 karakterlik(default 10) text getir virgülden sonra 3 karakteri olsun. 


SELECT STR(123134125151512) --DEFAULT OLARAK 10 KARAKTER DÖNDÜÐÜ VE BU ÝFADENÝN 10'DAN FAZLA OLDUÐU ÝÇÝN 10 TANE * DÖNDÜRDÜ.

SELECT LEN(STR(123134125151512)) -- DEFAULT 10 OLDUÐU ÝÇÝN 10 KARAKTERDEN FAZLASINI SAYMADI VE 10 YAZDIRDI.

SELECT CAST (12345 AS CHAR) --NUMERIC DEÐERÝ CHAR TÝPÝNDE TEXT OLARAK ALDIK.

SELECT CAST (123.65 AS INT) --FLOAT DEÐERÝ INT OLARAK ALDIK.

SELECT CONVERT(int, 30.60) -- FLOAT verilen deðeri int döndürdü.

SELECT CONVERT (VARCHAR(10), '2020-10-10')

SELECT CONVERT (DATETIME, '2020-10-10' )

SELECT CONVERT (NVARCHAR, GETDATE(),112 )

SELECT CAST ('20201010' AS DATE)

SELECT CONVERT (NVARCHAR, CAST ('20201010' AS DATE),103 )

SELECT COALESCE(NULL, 'Hi', 'Hello', NULL)

--NULLIF--

SELECT NULLIF(10,10) --Deðerleri karþýlaþtýrýr aynýysa null getirir.

SELECT NULLIF(13,15) -- Ayný deðilse deðer döndürür.

SELECT isnull(NULLIF (10,10),20)

--ROUND--

SELECT ROUND(432.368, 2)-- Girilen deðerin virgülden sonraki 2 karakterine göre yuvarladý.

SELECT ROUND(432.368, 2,0)--Sondaki 0 default deðer, 5'ten büyükse yukarý yuvarlar.

SELECT ROUND(432.368, 2,1)--Sondaki deðere 0 dýþýnda yazarsak aþaðý yuvarlar.

SELECT ROUND(432.368, 1)

--ISNULL--

SELECT ISNULL(NULL,'ABC') --NULL OLMAYAN ÝFADEYÝ DÖNDÜRÜR. --NULL HÝÇ VERÝ YOK DEMEK.

SELECT ISNULL('','ABC') -- '' ifade boþ demek deðildir, içi boþ demektir ve yer kaplar.

SELECT ISNULL('CDA','ABC')

--ISNUMERIC--

SELECT ISNUMERIC(123)  --- Ýçine verilen deðer sayýsalsa 1 döndürür.

SELECT ISNUMERIC('deneme') -- Ýçine verilen deðer numeric deðilse 0 döndürür.

--LEFT JOIN--

select *
from [product].[category]
left join [product].[product]
on [product].[category].[category_id] = [product].[product].[category_id]
order by [product].[category].[category_id],[product].[product].[product_id]


---

SELECT A.product_id,A.product_name,
	   B.category_id,B.category_name
FROM product.product AS A
INNER JOIN product.category AS B
ON A.category_id = B.category_id


SELECT A.first_name , A.last_name,
	   B.store_name
FROM sale.staff AS A
INNER JOIN sale.store AS B
ON A.store_id = B.store_id




SELECT A.product_id,A.product_name,B.product_id
FROM product.product AS A
LEFT JOIN sale.order_item AS B
ON  A.product_id = B.product_id
WHERE B.order_id is null



----- FULL OUTER JOIN

-- Ürünlerin stok miktarlarý ve sipariþ bilgilerini birlikte listeleyin
select	top 100 A.product_id, B.store_id, B.quantity, C.order_id, C.list_price
from	product.product A
FULL OUTER JOIN product.stock B
ON		A.product_id = B.product_id
FULL OUTER JOIN sale.order_item C
ON		A.product_id = C.product_id
order by B.store_id



---CROSS JOIN-----

--stock tablosunda olmayýp product tablosunda mevcut olan ürünlerin stock tablosuna tüm storelar için kayýt edilmesi gerekiyor. 
--stoðu olmadýðý için quantity leri 0 olmak zorunda
--Ve bir product id tüm store' larýn stockuna eklenmesi gerektiði için cross join yapmamýz gerekiyor.


SELECT	B.store_id, A.product_id, 0 quantity
FROM	product.product A
CROSS JOIN sale.store B
WHERE	A.product_id NOT IN (SELECT product_id FROM product.stock)
ORDER BY A.product_id, B.store_id


--VIEWS--


CREATE VIEW ProductStock as
SELECT	A.product_id, A.product_name, B.store_id,B.quantity  --Unique olanlarý döndüreceði için B'nin hepsini almadýk, A ile kesiþmeyenleri aldýk.
FROM	product.product A
LEFT JOIN product.stock B ON A.product_id = B.product_id ---VIEW'in içinde ORDERBY kabul etmez.
WHERE	A.product_id > 310
;

SELECT *
FROM dbo.ProductStock   
WHERE store_id = 1
;

-- Maðaza çalýþanlarýný çalýþtýklarý maðaza bilgileriyle birlikte listeleyin
-- Çalýþan adý, soyadý, maðaza adlarýný seçin
CREATE VIEW SaleStore as
SELECT	A.first_name, A.last_name, B.store_name
FROM	sale.staff A
INNER JOIN sale.store B
	ON	A.store_id = B.store_id
;

select*from dbo.SaleStore