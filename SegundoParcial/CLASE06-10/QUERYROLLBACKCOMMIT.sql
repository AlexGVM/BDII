select *
from sales.SalesOrderHeader

alter table sales.salesPerson add mayor integer

select *
from sales.SalesPerson


begin tran

update sales.SalesPerson 
set mayor=
(select case when count(1) > 50 then 1 else 0 end mayor
		from sales.SalesOrderHeader soh
		where SalesPersonID = BusinessEntityID)


		if (@@ROWCOUNT > 5) --condición si afecta a mas de 5 filas
		begin 
		commit ;
		print 'commit';
		end
		else
		begin
		rollback;
		print 'rollback'
		end