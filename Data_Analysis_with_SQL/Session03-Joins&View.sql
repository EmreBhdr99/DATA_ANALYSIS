


SELECT TRIM(' CHARACTER');

SELECT ' CHARACTER' ;--Ba��nda bo�luk oldu�u g�z�k�yor.

SELECT TRIM(' CHARACTER ')

SELECT TRIM(    ' CHAR ACTER ') -- ��eri yaz�lan metin tek t�rnaktan sonra ba�lar, �nceki bo�lu�un �nemi olmaz, alg�lamaz.

SELECT TRIM('ABC' FROM 'CCCCBBBAAAFRHGKDFKSLDFJKSDFACBBCACABACABCA')

SELECT TRIM('X' FROM 'ABCXXDE') -- Ba� veya sonda olmad��� i�in ayn� �ekilde ��kt� verir.

SELECT TRIM('X' FROM 'XXXXXXXXXXXXXXXABCXXDEXXXXXXXXXXXX') --Ba�tan ve sondan X d���nda bir harf g�rene kadar gidip durdu.

SELECT TRIM('ABC' FROM 'CCCBBBAAAFRASDJAMDASD�AACBBCACABAACABCA') --Ba�tan ve sondan A,B,C harflerinin d���nda harf arar, g�r�nce durur ve di�er k�sm� atar.

SELECT LTRIM ('     CHARACTER ') ---Sadece soldaki bo�luklar� temizler.


SELECT RTRIM ('     CHARACTER ') --- Sadece sa�daki bo�luklar� temizler.


---STRING, REPLACE

SELECT REPLACE('CHARACTER STRING', ' ', '/') --Metnin neresinde olursa olsun verilen ifadeyi istenen ifadeyle de�i�tirir.


SELECT REPLACE('CHARACTER STRING', 'CHARACTER STRING', 'CHARACTER')

SELECT STR (5454) -- '' olmadan verildi�i i�in SQL otomatik olarak numeric de�er olarak alg�lar.

SELECT STR(2135454654)

SELECT STR(133215.654645, 11,3) -- 11 karakterlik(default 10) text getir virg�lden sonra 3 karakteri olsun. 


SELECT STR(123134125151512) --DEFAULT OLARAK 10 KARAKTER D�ND��� VE BU �FADEN�N 10'DAN FAZLA OLDU�U ���N 10 TANE * D�ND�RD�.

SELECT LEN(STR(123134125151512)) -- DEFAULT 10 OLDU�U ���N 10 KARAKTERDEN FAZLASINI SAYMADI VE 10 YAZDIRDI.

SELECT CAST (12345 AS CHAR) --NUMERIC DE�ER� CHAR T�P�NDE TEXT OLARAK ALDIK.

SELECT CAST (123.65 AS INT) --FLOAT DE�ER� INT OLARAK ALDIK.

SELECT CONVERT(int, 30.60) -- FLOAT verilen de�eri int d�nd�rd�.

SELECT CONVERT (VARCHAR(10), '2020-10-10')

SELECT CONVERT (DATETIME, '2020-10-10' )

SELECT CONVERT (NVARCHAR, GETDATE(),112 )

SELECT CAST ('20201010' AS DATE)

SELECT CONVERT (NVARCHAR, CAST ('20201010' AS DATE),103 )

SELECT COALESCE(NULL, 'Hi', 'Hello', NULL)

--NULLIF--

SELECT NULLIF(10,10) --De�erleri kar��la�t�r�r ayn�ysa null getirir.

SELECT NULLIF(13,15) -- Ayn� de�ilse de�er d�nd�r�r.

SELECT isnull(NULLIF (10,10),20)

--ROUND--

SELECT ROUND(432.368, 2)-- Girilen de�erin virg�lden sonraki 2 karakterine g�re yuvarlad�.

SELECT ROUND(432.368, 2,0)--Sondaki 0 default de�er, 5'ten b�y�kse yukar� yuvarlar.

SELECT ROUND(432.368, 2,1)--Sondaki de�ere 0 d���nda yazarsak a�a�� yuvarlar.

SELECT ROUND(432.368, 1)

--ISNULL--

SELECT ISNULL(NULL,'ABC') --NULL OLMAYAN �FADEY� D�ND�R�R. --NULL H�� VER� YOK DEMEK.

SELECT ISNULL('','ABC') -- '' ifade bo� demek de�ildir, i�i bo� demektir ve yer kaplar.

SELECT ISNULL('CDA','ABC')

--ISNUMERIC--

SELECT ISNUMERIC(123)  --- ��ine verilen de�er say�salsa 1 d�nd�r�r.

SELECT ISNUMERIC('deneme') -- ��ine verilen de�er numeric de�ilse 0 d�nd�r�r.

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

-- �r�nlerin stok miktarlar� ve sipari� bilgilerini birlikte listeleyin
select	top 100 A.product_id, B.store_id, B.quantity, C.order_id, C.list_price
from	product.product A
FULL OUTER JOIN product.stock B
ON		A.product_id = B.product_id
FULL OUTER JOIN sale.order_item C
ON		A.product_id = C.product_id
order by B.store_id



---CROSS JOIN-----

--stock tablosunda olmay�p product tablosunda mevcut olan �r�nlerin stock tablosuna t�m storelar i�in kay�t edilmesi gerekiyor. 
--sto�u olmad��� i�in quantity leri 0 olmak zorunda
--Ve bir product id t�m store' lar�n stockuna eklenmesi gerekti�i i�in cross join yapmam�z gerekiyor.


SELECT	B.store_id, A.product_id, 0 quantity
FROM	product.product A
CROSS JOIN sale.store B
WHERE	A.product_id NOT IN (SELECT product_id FROM product.stock)
ORDER BY A.product_id, B.store_id


--VIEWS--


CREATE VIEW ProductStock as
SELECT	A.product_id, A.product_name, B.store_id,B.quantity  --Unique olanlar� d�nd�rece�i i�in B'nin hepsini almad�k, A ile kesi�meyenleri ald�k.
FROM	product.product A
LEFT JOIN product.stock B ON A.product_id = B.product_id ---VIEW'in i�inde ORDERBY kabul etmez.
WHERE	A.product_id > 310
;

SELECT *
FROM dbo.ProductStock   
WHERE store_id = 1
;

-- Ma�aza �al��anlar�n� �al��t�klar� ma�aza bilgileriyle birlikte listeleyin
-- �al��an ad�, soyad�, ma�aza adlar�n� se�in
CREATE VIEW SaleStore as
SELECT	A.first_name, A.last_name, B.store_name
FROM	sale.staff A
INNER JOIN sale.store B
	ON	A.store_id = B.store_id
;

select*from dbo.SaleStore