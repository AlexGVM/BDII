if (@@ERROR <> 0)  --existe una condición 
	begin
		rollback transaction;
		print'ROLLBACK'
	end
	else 
	begin
		commit transaction;
		print'commit'
		end

BEGIN TRANSACTION

Begin try
---try catch no es pesado para la base de datos

UPDATE HumanResources.EmployeePayHistory
set PayFrequency = 9304
where Rate between 50 and 150

print 'commit'

commit;
end try
begin catch

rollback;
	print 'rollback'
	select ERROR_NUMBER() AS numero, ERROR_LINE() as linea , ERROR_MESSAGE() as mes, ERROR_PROCEDURE()  as proce;
end  catch



BEGIN TRANSACTION

update Sales.SalesPerson
	set mayor = (select case when COUNT(1) > 50 then 1 else 0 end mayor from Sales.SalesOrderHeader soh  where SalesPersonID = BusinessEntityID)

if (@@ROWCOUNT > 5)  --existe una condición 
	begin
		commit transaction;
		print'commit'
	end
	else 
	begin
		rollback transaction;
		print'ROLLBACK'
		end

---Buenas practicas, no crear transacciones anidadas



BEGIN Transaction

update Person.CountryRegion
set Name  = 'otro'
where CountryRegionCode = 'AD'

if ((1+1) = 2)  --existe una condición 
	begin
		rollback transaction;
		print'ROLLBACK'
	end
	else 
	begin
		commit transaction;
		print'commit'
		end


COMMIT o ROLLBACK

select *
from Person.CountryRegion

