
set transaction isolation level read uncommitted;

select *
from Sales.SalesOrderDetail
where SalesOrderID = 43662

set transaction isolation level read committed; ---se utiliza más en las transacciones

select *
from Sales.SalesOrderDetail
where SalesOrderID = 43662

-- Aislamiento 

--Primer Nivel: 

begin tran
update Sales.SalesOrderDetail
set UnitPriceDiscount += 0.02
where SalesOrderID = 43662

select *
from Sales.SalesOrderDetail
where SalesOrderID = 43662

set transaction isolation level repeatable read;

begin tran

select *
from Sales.SalesOrderDetail
where SalesOrderID = 43689

commit tran

set transaction isolation level serializable;

begin tran

select *
from Sales.Currency
where CurrencyCode like 'B%'

waitfor delay '00:00:10'

select *
from Sales.Currency
where CurrencyCode like 'B%'


begin tran

insert into Sales.Currency (CurrencyCode, name) values ('BZB', 'BBZZ')

