
----SESSION 10---

---WINDOWS FUNCTION--

--�r�nlerin stock say�lar�n� bulunuz

--1.YOL:
select pp.product_id, sum(quantity)
from product.product pp, product.stock ps
where pp.product_id = ps.product_id
group by pp.product_id

--2.YOL:
SELECT product_id, SUM(quantity) as total_stock
FROM product.stock
GROUP BY product_id
ORDER BY product_id

--WF �LE ��Z�M:

select distinct product_id,  
		sum(quantity) over(partition by product_id) sumWF
from product.stock
order by product_id


-- Markalara g�re ortalama �r�n fiyatlar�n� hem Group By hem de Window Functions ile hesaplay�n�z.

select brand_id, avg(list_price) avg_price
from product.product 
group by brand_id
;

select distinct brand_id, 
		avg(list_price) over(partition by brand_id) as avg_price
from product.product 
;

select *, 
		count(*) over(partition by brand_id) CountofProduct,
		max(list_price) over(partition by brand_id) maxListPrice
from product.product 
order by brand_id, product_id

select *, 
		count(*) over(partition by brand_id) CountofProductBrand,
		count(*) over(partition by category_id) CountofProductCategory
from product.product
order by brand_id, product_id


--Window function ile olu�turdu�unuz kolonlar birbirinden ba��ms�z hesaplan�r. 
--Dolay�s�yla ayn� select blo�u i�inde farkl� partitionlar tan�mlayarak yeni kolonlar olu�turabilirsiniz.


select  product_id, brand_id, category_id, model_year,
		count(*) over(partition by brand_id ) CountofProductinBrand,
		count(*) over(partition by category_id ) CountofProductinCategory
from product.product
order by brand_id, category_id, model_year


select distinct brand_id, category_id,
		count(*) over(partition by brand_id ) CountofProductinBrand,
		count(*) over(partition by category_id ) CountofProductinCategory
from product.product
order by brand_id, category_id



-- Window Frames

-- Windows frame i anlamak i�in birka� �rnek:
-- Herbir sat�rda i�lem yap�lacak olan frame in b�y�kl���n� (sat�r say�s�n�) tespit edip window frame in nas�l olu�tu�unu a�a��daki sorgu sonucuna g�re konu�al�m.


SELECT	category_id, product_id,
		COUNT(*) OVER() NOTHING,
		COUNT(*) OVER(PARTITION BY category_id) countofprod_by_cat,
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id) countofprod_by_cat_2,
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) prev_with_current,
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) current_with_following,
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) whole_rows,
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) specified_columns_1,
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN 2 PRECEDING AND 3 FOLLOWING) specified_columns_2
FROM	product.product
ORDER BY category_id, product_id
;


-- Herbir kategorideki en ucuz �r�n�n fiyat�n� sorgulay�n�z.

select	distinct category_id, min(list_price) over(partition by category_id) cheapest_by_cat
from	product.product
;

-- Product tablosunda toplam ka� farkl� product bulundu�unu sorgulay�n�z.

SELECT DISTINCT count(*) OVER () count_product
FROM product.product

-- How many different product in the order_item table?

SELECT DISTINCT product_id, count(*) OVER(PARTITION BY product_id) number_of_product
FROM sale.order_item
;

select count(distinct product_id) UniqueProduct
from sale.order_item
;

select  count(distinct product_id) over() UniqueProduct --!!!�al��m�yor ��nk� DISTINCT WF (Win Frame) de �al�lmaz. GROUPBy yapmal�.
from    sale.order_item

select distinct count(*) over()
from (select distinct product_id,  count(*) over(partition by product_id) as number_of_product
from sale.order_item) as a

-- Write a query that returns how many different products are in each order?
-- Her sipari�te ka� farkl� �r�n oldu�unu d�nd�ren bir sorgu yaz�n�z.

--Group by ile ��z�m
select	order_id, count(distinct product_id) UniqueProduct,
		sum(quantity) TotalProduct
from	sale.order_item
group by order_id
;

-- Window Function ile ��z�m

select distinct [order_id]
	,sum(quantity) over(partition by [order_id]) total_product
	,count(product_id) over(partition by [order_id]) total_product
from [sale].[order_item]

-- How many different product are in each brand in each category?
-- Herbir kategorideki herbir markada ka� farkl� �r�n�n bulundu�unu sorgulay�n�z.

select distinct category_id,brand_id,count(*) over(partition by brand_id, category_id) CountOfProduct
from product.product
;



--Brand name ile birlikte sorgulanm�� hali.
select	A.*, B.brand_name
from	(
		select	distinct category_id, brand_id,
				count(*) over(partition by brand_id, category_id) CountOfProduct
		from	product.product
		) A, product.brand B
where	A.brand_id = B.brand_id
;

select	distinct category_id, A.brand_id,
		count(*) over(partition by A.brand_id, A.category_id) CountOfProduct,
		B.brand_name
from	product.product A, product.brand B
where	A.brand_id = B.brand_id
;