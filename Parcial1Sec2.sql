---Al realizar una calificación/revisión de un producto comprado por los clientes, no debe permitir ingresar más de una revisión para una misma fecha y 
---correo siempre y cuando la existencia de dicho producto sea mayor a 100.

create trigger ti_CalificaciónRevisión on Production.ProductReview
after insert as
begin

	
	declare @OrderFecha datetime
	set @OrderFecha = (select i.ReviewDate from inserted i )
	Declare @QtyDetail int
	set @QtyDetail = (select PPI.Quantity from inserted i inner join  Production.ProductInventory PPI  on (PPI.ProductID = i.ProductID))
	Declare @Correo nvarchar(50)
	set @Correo = (select i.EmailAddress from inserted i ) 
	

	
	if exists (select * from  Production.ProductReview PR where (@OrderFecha = PR.ReviewDate and @Correo = PR.EmailAddress and @QtyDetail >= 100) )
	begin

		print 'No permite Ingresar Revisión'
		ROLLBACK TRANSACTION

	end
	else 
	begin
		print'Ingresado Correctamente'
	end

end


SELECT PAD.City as CIUDAD, CC.CardType as CC, COUNT(1) AS VENTAS, SUM(SOHR.TotalDue) AS TOTAL
    FROM Sales.SalesOrderHeader SOHR
    INNER JOIN Person.Address PAD on SOHR.ShipToAddressID = PAD.AddressID
    INNER JOIN Sales.CreditCard CC on CC.CreditCardID = SOHR.CreditCardID    
    where SOHR.CurrencyRateID is not null
    GROUP BY CC.CardType, PAD.City



	USE [AdventureWorks2017]
GO
CREATE NONCLUSTERED INDEX ix_Parcial1
ON [Sales].[SalesOrderHeader] ([CurrencyRateID])
INCLUDE ([ShipToAddressID],[CreditCardID],[TotalDue])
GO

