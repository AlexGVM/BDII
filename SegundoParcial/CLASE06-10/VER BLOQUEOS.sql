
begin try


update HumanResources.EmployeePayHistory
set PayFrequency = 9304
where rate between 50 and 150




--para ver bloqueos


sp_who

select *
from sys.sysprocesses