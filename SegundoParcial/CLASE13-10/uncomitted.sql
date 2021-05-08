set transaction isolation level read uncommitted;


select *
from sales.SalesOrderDetail
where SalesOrderID = 43662; 

