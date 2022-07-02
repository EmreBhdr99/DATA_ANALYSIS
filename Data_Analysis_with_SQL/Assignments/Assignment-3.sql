

CREATE DATABASE ECommerceCompany;

Use ECommerceCompany;

CREATE TABLE [Visitor](
	[Visitor_ID] [int] PRIMARY KEY IDENTITY(1,1) NOT NULL,
	[Adv_Type] [nvarchar](10) NOT NULL,
	[Action] [nvarchar](50) NOT NULL,
	);

INSERT INTO Visitor([Adv_Type] ,[Action]) 
VALUES ('A', 'Left'),
	   ('A', 'Order'),
	   ('B', 'Left'),
	   ('A', 'Order'),
	   ('A', 'Review'),
	   ('A', 'Left'),
	   ('B', 'Left'),
	   ('B', 'Order'),
	   ('B', 'Review'),
	   ('A', 'Review')

select *
from Visitor

-- A'lar�n toplam say�s�

select Count(*)
from Visitor
where Adv_Type = 'A'


-- A'lar�n order say�s�

select count(*)
from Visitor
where Adv_Type = 'A' and [Action] = 'Order'

--- A'lar�n sipari� olma oran�
select (select count(*)
		from Visitor
		where Adv_Type = 'A' and [Action] = 'Order') *1.0 / (select Count(*)
															from Visitor
															where Adv_Type = 'A') *1.0



-- B'lerin say�s�
select Count(*) as BCount
from Visitor
where Adv_Type = 'B'



--- B'lerin sipari� olma say�s�
select count(*)
from Visitor
where Adv_Type = 'B' and [Action] = 'Order'


-- B'lerin sipari� olma oran�
select (select count(*)
		from Visitor
		where Adv_Type = 'B' and [Action] = 'Order') *1.0 / (select Count(*)
															from Visitor
															where Adv_Type = 'B') *1.0



-- A ve B'nin sipari� olma oran tablosu
CREATE TABLE #Answer (
						[Adv_Type] [nvarchar](10) NOT NULL,
						[Conversion_Rate] float NOT NULL
					 )

INSERT #Answer (Adv_Type,Conversion_Rate)
VALUES ( 'A',(select (select count(*)
										from Visitor
										where Adv_Type = 'A' and [Action] = 'Order') *1.0 / (select Count(*)
										from Visitor
										where Adv_Type = 'A') *1.0 )), 
						   ( 'B', (select (select count(*)
										from Visitor
										where Adv_Type = 'B' and [Action] = 'Order') *1.0 / (select Count(*)
										from Visitor
										where Adv_Type = 'B') *1.0))


SELECT * FROM #Answer
