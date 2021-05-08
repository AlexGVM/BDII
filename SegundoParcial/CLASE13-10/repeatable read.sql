set transaction isolation level repeatable read;


select *
from sales.SalesOrderDetail
where SalesOrderID = 43689; 
