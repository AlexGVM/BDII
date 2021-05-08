---Alexander Villatoro 1182118
---Mario Banaay 1092518

--- 1.
ALTER PROCEDURE Sales.uspDiscount
@id int, @discount  decimal
as

BEGIN
	
	update Sales.SalesOrderDetail
	set UnitPriceDiscount = @discount
	select SOH.SalesOrderID , COUNT(SOD.SalesOrderID) as IdTotal
	from Sales.SalesOrderDetail SOD inner join Sales.SalesOrderHeader SOH
	on (SOD.SalesOrderID =  SOH.SalesOrderID)
	where SOH.SalesOrderID = @id and SOH.SalesOrderID > 2
	GROUP BY SOH.SalesOrderID
END

set transaction isolation level repeatable read;
begin tran
exec Sales.uspDiscount 43659 , 0.15 
commit

---2.



create or alter proc resumen_upstable as
set transaction isolation level read uncommitted;
select SOH.OrderDate as Año, SOD.ProductID as Producto, SOD.OrderQty as Cantidad, SOD.UnitPrice as Precio, SOD.UnitPriceDiscount as Descuentos
from Sales.SalesOrderDetail SOD inner join
Sales.SalesOrderHeader SOH on (SOD.SalesOrderDetailID = SOH.SalesOrderID)


---¿Que riesgo encuentra dentro de esta generación de datos ?

--- Los datos no van a estar 100% actualizados ya que lleva un tiempo de espera y la integridad se podria ver comprometida.

---¿Que sugerencia/cambio aplicaría a la solicitud?

--- Que no se haga a cada hora, y que se genere a un horario especifico con menor demanda de registros, para evitar comprometer la integridad de los datos
---por el nivel de aislamiento

