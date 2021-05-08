create or alter procedure sales.pIngresaVentadetalle as
begin

	

end



create or alter procedure sales.spIngresaVenta @pOrderDate date, @pCustomerID int, @pProductos int as
BEGIN

	declare @var_ciclo int
	
begin tran

	insert into Sales.SalesOrderHeader
	(OrderDate,DueDate,CustomerID,BillToAddressID,ShipToAddressID,ShipMethodID)
	values (@pOrderDate, @pOrderDate,@pCustomerID ,1,1,1) --mes/dia/año

	if(@@ERROR = 0)
	BEGIN
		commit
		set @var_ciclo = 0
		while(@var_ciclo <= @pProductos)
		begin

			print 'Hola'



			set @var_ciclo += 1
		end
	END 
	else
	BEGIN
		rollback;
		-
			print 'todo ok'

	END

END