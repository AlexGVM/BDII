
--Cuantas ordenes de trabajo se han realizado por producto en cada año.
--si se repite es bueno verlo antes que hacer el query y si se repite con un count
--y este query la clave es la SUM(pwo.OrderQty) para saber la cantidad total

select p.Name,  YEAR(PWO.StartDate) as  Año, SUM(pwo.OrderQty) as CantidadTotal
from Production.Product p inner join Production.WorkOrder PWO on (p.ProductID = PWO.ProductID)
group by p.Name, YEAR(PWO.StartDate)
order by p.Name asc

--Crear un procedimiento que actualice el método de entrega para todas las compras realizadas.
use [AdventureWorks2017]
go
create procedure [dbo].[SPUOrderHeader]
@shipmethodid int,
@orderdate datetime
as
begin 
update Purchasing.PurchaseOrderHeader
   set OrderDate = @orderdate
   where ShipMethodID = @shipmethodid
end

exec SPUOrderHeader '3', '2011'
 