begin tran

update sales.SalesOrderDetail

	set UnitPriceDiscount += 0.02
	where SalesOrderID = 43662;

select *
from sales.SalesOrderDetail
where SalesOrderID = 43662;


commit

rollback