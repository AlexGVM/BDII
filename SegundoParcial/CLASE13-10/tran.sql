update sales.SalesOrderDetail

set UnitPriceDiscount= 3.00
where SalesOrderID = 43689; 


--no deja hacer update hasta que no se le hace commit o rollback a la transaccion como tal