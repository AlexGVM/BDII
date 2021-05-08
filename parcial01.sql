---Mostar la cantidad de ventas y monto total, por cada tipo de tarjeta de credito y ciudad donde se entregó
---el pedido, tomando en cuenta las ventas que excedan los 10000

	

select SC.CardType, PA.City, COUNT(sso.SalesOrderID) as [Cantidad Total], SUM(SSO.TotalDue) as [Total]
from Sales.SalesOrderHeader SSO 
    inner join sales.CreditCard SC on (SSO.CreditCardID = SC.CreditCardID)
    inner join Person.Address PA  on (SSO.BillToAddressID = PA.AddressID)
    group by SC.CardType, PA.City
    having sum(SSO.TotalDue) > 10000



	
---------------------------------------------Examen Sec1---------------------------------------------
--Para las compras en línea (carrito de compras), no debe permitir para una misma orden (shoppingCartID), 
--agregar 2 registros del mismo producto y validar que la existencia de este sea suficiente para lo que se está solicitando.


ALTER trigger sales.ti_Compras on sales.ShoppingCartItem 
instead of insert as
begin

	Declare @ProductID int
	set @ProductID = (select i.ProductID from inserted i)
	Declare @Quantity int
	set @Quantity = (select i.Quantity from inserted i)
	Declare @ShoppingCartID int
	set @ShoppingCartID = (select i.ShoppingCartID from inserted i)
	Declare @InventoryQty int
	set @InventoryQty = (select PPI.Quantity from Production.ProductInventory PPI WHERE PPI.ProductID = @ProductID)
	Declare @ShoppingCartItem int
	set @ShoppingCartItem = (select SSC.ShoppingCartItemID from sales.ShoppingCartItem SSC WHERE SSC.ShoppingCartItemID = @ShoppingCartItem)

	if exists(select * from Sales.ShoppingCartItem SCI where (SCI.ProductID = @ProductID and SCI.ShoppingCartID = @ShoppingCartID))
	BEGIN
			print 'Transacción rechazada'
			
	END
	else if @Quantity > @InventoryQty
	BEGIN
			PRINT 'No tiene espacio'
	END
	ELSE
	BEGIN
		insert into Sales.ShoppingCartItem (ShoppingCartID, Quantity, ProductID, DateCreated)
		Values (@ShoppingCartID, @Quantity, @ProductID, getdate())
	END
	
end

insert into Sales.ShoppingCartItem (ProductID, ShoppingCartID, Quantity, DateCreated)
Values (862, 14951, 3, getdate())
