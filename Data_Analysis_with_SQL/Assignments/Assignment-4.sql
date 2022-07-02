select distinct product_id, discount, 
	sum(quantity) over(partition by product_id, discount order by discount) SumQuantity
into #MainTable
from sale.order_item
;

select * from #MainTable


/*  Uzun yol
Select *,
(case when  SumQuantity > (LAG(SumQuantity) OVER (ORDER BY product_id ASC, discount ASC)) 
			Then SumQuantity-(LAG(SumQuantity) OVER (ORDER BY product_id ASC, discount ASC)) 
		when SumQuantity < (LAG(SumQuantity) OVER (ORDER BY product_id ASC, discount ASC))
			Then SumQuantity - (LAG(SumQuantity) OVER (ORDER BY product_id ASC, discount ASC))
		when SumQuantity = (LAG(SumQuantity) OVER (ORDER BY product_id ASC, discount ASC))
			Then SumQuantity-(LAG(SumQuantity) OVER (ORDER BY product_id ASC, discount ASC))
		else Null
		end) DiscountEffect
into #DiscountEffectTable
from #MainTable
*/


select *, SumQuantity-(LAG(SumQuantity) OVER (ORDER BY product_id ASC, discount ASC)) DiscountEffect 
into #DiscountEffectTable
from #MainTable
;


select * from #DiscountEffectTable

select product_id,sum(DiscountEffect) DiscountEffectScore
into #ScoreTable
from #DiscountEffectTable
group by  product_id
;

select * from #ScoreTable

--- Score'lar�n pozitif negatif etki kar��la�t�rmas�
Select *,
(case when  DiscountEffectScore > 0
			Then 'Positive'
		when  DiscountEffectScore < 0 
			Then 'Negative'
		else 'Neutral'
		end) Discount_Effect
from #ScoreTable
;
--- ��kt� ekran�
Select product_id,
(case when  DiscountEffectScore > 0
			Then 'Positive'
		when  DiscountEffectScore < 0 
			Then 'Negative'
		else 'Neutral'
		end) Discount_Effect
from #ScoreTable
;
