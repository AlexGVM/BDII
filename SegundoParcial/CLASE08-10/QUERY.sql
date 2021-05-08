select *
from sales.salesOrderHeader

--create or alter procedure sales.spIngresaVenta
			--@pOrderDate date, @pCustomerID int
--as 
begin


	insert sales.SalesOrderHeader
	(OrderDate, DueDate, CustomerID, BillToAddressID,ShipToAddressID, ShipMethodID)
	values
	('08/10/2020','10/10/2020',2,1,1,1)


end


--eliminar triggers de sales order header  y detail



create or alter procedure sales.spIngresaVenta
			@pOrderDate date, @pCustomerID int, @pProductos int

as 
begin

declare @var_ciclo int 


as 
begin tran


	INSERT INTO sales.SalesOrderHeader
	(OrderDate, DueDate, CustomerID, BillToAddressID,ShipToAddressID, ShipMethodID)

	VALUES (@pOrderDate,@pOrderDate, @pCustomerID,1,1,1)


	if @@ERROR = 0
	begin
	--continuar
	commit
	set @var_ciclo=1

	while (@var_ciclo <= @pProductos)
	begin 
		set @var_ciclo+=1
	end

	print 'todo ok'
	end
	else 
	begin
	rollback;
	print 'error'
	end

	--------------------------------------------para este ejercicio se usa este----------------------------------
	inserto el header ---> commit
	inserto los N detalles --> commit por cada uno
	actualizo el header -->commit
	-------------------------------------------------------------------------------------------------------------

	---------------------------------------------------ESTE ES EL QUE MÁS SE USA-----------------------------
	|inserto el header																				         |
	|inserto los N detalles																				     |
	|actualizo el header																					 |
	|--- commit                                                                                              |
	---------------------------------------------------------------------------------------------------------
	--Todas las transacciones terminan con un commit o con un rollback