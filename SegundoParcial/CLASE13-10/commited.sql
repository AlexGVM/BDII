set transaction isolation level read committed;


select *
from sales.SalesOrderDetail
where SalesOrderID = 43662; 


--hasta que se le da rollback o commit muestra los datos 