

------SESSION 14-----
---SQL PROGRAMMING---

---Stored Procedure---

---Procedure olu�turmak.
create procedure sp_sampleproc1
as
begin --procedure yi parantez i�ine al�yor gibi d���n��lebilir.

select 'hello world'

end  --begin i end ile sonland�rmam�z gerekli

;


---Procedure �al��t�rmak.
exec sp_sampleproc1

--Procedure silmek.
drop procedure sp_sampleproc1


--Procedure d�zenlemek.
alter procedure sp_sampleproc1
as
begin 
select 'hello world 2 '
end
;

--Procedure �a��rmak.
execute sp_sampleproc1
;

----Table �zerinden fonksiyon i�eren procedure olu�turmak.

CREATE TABLE ORDER_TBL 
(
ORDER_ID TINYINT NOT NULL,
CUSTOMER_ID TINYINT NOT NULL,
CUSTOMER_NAME VARCHAR(50),
ORDER_DATE DATE,
EST_DELIVERY_DATE DATE--estimated delivery date
);

INSERT INTO ORDER_TBL VALUES (1, 1, 'Adam', GETDATE()-10, GETDATE()-5 ),
						(2, 2, 'Smith',GETDATE()-8, GETDATE()-4 ),
						(3, 3, 'John',GETDATE()-5, GETDATE()-2 ),
						(4, 4, 'Jack',GETDATE()-3, GETDATE()+1 ),
						(5, 5, 'Owen',GETDATE()-2, GETDATE()+3 ),
						(6, 6, 'Mike',GETDATE(), GETDATE()+5 ),
						(7, 6, 'Rafael',GETDATE(), GETDATE()+5 ),
						(8, 7, 'Johnson',GETDATE(), GETDATE()+5 )

select *
from ORDER_TBL

----------------------------
CREATE TABLE ORDER_DELIVERY
(
ORDER_ID TINYINT NOT NULL,
DELIVERY_DATE DATE -- tamamlanan delivery date
);

SET NOCOUNT ON
INSERT ORDER_DELIVERY VALUES (1, GETDATE()-6 ),
				(2, GETDATE()-2 ),
				(3, GETDATE()-2 ),
				(4, GETDATE() ),
				(5, GETDATE()+2 ),
				(6, GETDATE()+3 ),
				(7, GETDATE()+5 ),
				(8, GETDATE()+5 )

-----------------------------
create procedure sp_sum_order
as
begin
	select count(*)
	from ORDER_TBL
end
;

execute sp_sum_order


---Procedure i�inde parametre olu�turmak.
CREATE PROCEDURE sp_wantedday_order
	(
	@DAY DATE
	)
AS
BEGIN
	SELECT	COUNT(*) AS TOTAL_ORDER
	FROM	ORDER_TBL
	WHERE	ORDER_DATE = @DAY
END
;

execute sp_wantedday_order '2022-06-22';

---Parametreler set ve select ile olu�turulmas�. (declare ile)
DECLARE
	@p1 INT,
	@p2 INT,
	@SUM INT
SET @p1 = 5

SELECT *
from ORDER_TBL
where ORDER_ID = @p1

-------------
DECLARE
	@order_id INT,
	@customer_name nvarchar(100)
SET @order_id = 5

SELECT @customer_name = customer_name
from ORDER_TBL
where ORDER_ID = @order_id

select @customer_name  --print @customer_name

---------------
select GETDATE()

declare 
	@day date

set @day = getdate()-2

execute sp_wantedday_order @day



----FONKS�YONLAR---

----Metni b�y�k harfe �eviren bir fonksiyon yazal�m.

CREATE FUNCTION fnc_uppertext
(
	@inputtext varchar (MAX)
)
RETURNS VARCHAR (MAX)
AS
BEGIN
	RETURN UPPER(@inputtext)
END
;

select dbo.fnc_uppertext('hello world');



select * 
from ORDER_TBL

---M��teri ad�n�n parametre olarak al�p o m��terinin al��veri�lerini d�nd�ren bir fonksiyon yaz�n�z.

create function fnc_getordersbycustomer
(
@customer_name nvarchar(100)
)
returns table
as
	return
		select *
		from ORDER_TBL
		where customer_name=@customer_name
;

select *
from dbo.fnc_getordersbycustomer('Owen')


---IF / ELSE---
---Rakamsal de�eri �ift ise �ift, ---
---tek ise Tek, ---
---e�er 0 ise S�f�r d�nd�ren bir fonksiyon yaz�n�z. ---

--select 10 % 2  --10 ifadesinin 2 ile b�l�m�nden kalan�

DECLARE
	@input int,
	@modulus int
SET @input = 5
SELECT @modulus = @input % 2
IF @input = 0
	BEGIN
	 print 'S�f�r'
	END
ELSE IF @modulus = 0
	BEGIN
	 print '�ift'
	END
ELSE print 'Tek'

---Fonksiyonu dinamik hale getirmek i�in:

create FUNCTION dbo.fnc_tekcift
(
	@input int
)
RETURNS nvarchar(max)
AS
BEGIN
	DECLARE
		-- @input int,
		@modulus int,
		@return nvarchar(max)
	-- SET @input = 100
	SELECT @modulus = @input % 2
	IF @input = 0
		BEGIN
		 set @return = 'S�f�r'
		END
	ELSE IF @modulus = 0
		BEGIN
		 set @return = '�ift'
		END
	ELSE set @return = 'Tek'
	return @return
	
END
;

select dbo.fnc_tekcift(100) A, dbo.fnc_tekcift(9) B, dbo.fnc_tekcift(0) C


---WHILE---

DECLARE
	@counter int,
	@total int

set @counter = 1
set @total = 50

while @counter <= @total
	begin
		PRINT @counter
		set @counter += 1
	end
;



--Sipari�leri, tahmini teslim tarihleri ve ger�ekle�en teslim tarihlerini k�yaslayarak
--'Late','Early' veya 'On Time' olarak s�n�fland�rmak istiyorum.
--E�er sipari�in ORDER_TBL tablosundaki EST_DELIVERY_DATE' i (tahmini teslim tarihi) 
--ORDER_DELIVERY tablosundaki DELIVERY_DATE' ten (ger�ekle�en teslimat tarihi) k���kse
--Bu sipari�i 'LATE' olarak etiketlemek,
--E�er EST_DELIVERY_DATE>DELIVERY_DATE ise Bu sipari�i 'EARLY' olarak etiketlemek,
--E�er iki tarih birbirine e�itse de bu sipari�i 'ON TIME' olarak etiketlemek istiyorum.

--Daha sonradan sipari�leri, sahip olduklar� etiketlere g�re farkl� i�lemlere tabi tutmak istiyorum.

--istenilen bir order' �n status' unu tan�mlamak i�in bir scalar valued function olu�turaca��z.
--��nk� girdimiz order_id, ��kt�m�z ise bir string de�er olan statu olmas�n� bekliyoruz.


create FUNCTION dbo.fnc_orderstatus
(
	@input int
)
RETURNS nvarchar(max)
AS
BEGIN
	declare
		@result nvarchar(100)
	-- set @input = 1
	select	@result =
				case
					when B.DELIVERY_DATE < A.EST_DELIVERY_DATE
						then 'EARLY'
					when B.DELIVERY_DATE > A.EST_DELIVERY_DATE
						then 'LATE'
					when B.DELIVERY_DATE = A.EST_DELIVERY_DATE
						then 'ON TIME'
				else NULL end
	from	ORDER_TBL A, ORDER_DELIVERY B
	where	A.ORDER_ID = B.ORDER_ID AND
			A.ORDER_ID = @input
	;
	return @result
end
;
select	dbo.fnc_orderstatus(3)
;
select	*, dbo.fnc_orderstatus(ORDER_ID) OrderStatus
from	ORDER_TBL
;

















