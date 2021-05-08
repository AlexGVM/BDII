--No permitir ingresar una tarjeta de credito con diferencia de fechas de expiración menor a 30 dias.

select * 
into sales.Tarjeta 
from sales.CreditCard

select * 
into sales.Venta
from sales.SalesOrderDetail

select *
into production.Inventario
from production.ProductInventory


CREATE TRIGGER tu_tarjeta ON Sales.CreditCard 
AFTER INSERT AS

	DECLARE @año  INT 
	DECLARE @mes		INT 

	SET @mes = (SELECT ExpMonth FROM inserted)
    SET @año = (SELECT ExpYear FROM inserted)

	if(@año <= year(GETDATE()) and @mes >= (MONTH(GETDATE()) + 1))
	begin

	delete from Sales.CreditCard
	where CreditCardID = (SELECT CreditCardID from inserted)

	print 'Menor a 30 dias'

	end;
	else
	begin

	print 'Tarjeta ingresada exitosamente';
	end;


-- Actualizar el inventario del producto al vender cada uno de ellos.
--Al momento que se confirma y/o cancela la venta.


create trigger tu_venta on Production.Inventario after update
as 

	declare @cantidadvendida int
	set @cantidadvendida = (select OrderQty from sales.SalesOrderDetail)

	update Production.Inventario

	if update(Quantity)
	begin
	update Production.Inventario
	set Quantity = Inventario.Quantity - @cantidadvendida
	from inserted
	end;
	


select *
from Production.Inventario

select *
from sales.Venta


select *
from sales.ShoppingCartItem



select *
from sales.Venta



select *
from sales.Tarjeta