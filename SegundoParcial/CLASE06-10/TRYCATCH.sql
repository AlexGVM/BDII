
select *
from HumanResources.EmployeePayHistory

begin tran

begin try


update HumanResources.EmployeePayHistory
set PayFrequency = 9304
where rate between 50 and 150


print 'rollback'
commit;


end try
begin catch
rollback;
print 'rollback'

		select ERROR_NUMBER() as numero, ERROR_LINE() as linea, ERROR_MESSAGE() as mes, ERROR_PROCEDURE() as proce;  




end catch

