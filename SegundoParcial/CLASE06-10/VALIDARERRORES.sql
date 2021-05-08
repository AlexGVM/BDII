
select *
from HumanResources.EmployeePayHistory

begin tran




update HumanResources.EmployeePayHistory
set PayFrequency = 9304
where rate between 50 and 150


if @@ERROR<> 0 

begin 
rollback ;
print 'rollback'
end
else
begin 
commit;
print 'commit'
end 