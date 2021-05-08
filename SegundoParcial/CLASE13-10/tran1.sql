set transaction isolation level serializable 


begin tran;


select *
from sales.Currency
where CurrencyCode like 'B%'
commit tran;
waitfor delay '00:00:10'

select *
from sales.Currency
where CurrencyCode like 'B%'
