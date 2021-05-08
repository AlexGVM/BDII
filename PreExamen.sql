
---Alexander Villatoro 1182118 , Mario Velasquez 1092518


---1.Crear una tabla resumen con la siguiente informaci�n sobre las ventas que se han realizado:

Create procedure usp_TablaResumen  as
Select *
into Sales.TablaResumen
from (select SC.CustomerID, PP.FirstName + ' ' + PP.LastName  Nombre, YEAR(SSH.orderdate), MONTH(SSH.OrderDate), 
	COUNT(SSH.SalesOrderID) as [Cantidad Ordenes], SSH.Orderdate
		from Sales.SalesOrderHeader SSH
	inner join Sales.Customer SC
		ON SSH.CustomerID = SC.CustomerID
	inner join Person.Person PP
		ON SC.PersonID = PP.BusinessEntityID
		GROUP BY SC.CustomerID, PP.FirstName, PP.LastName, YEAR(SSH.OrderDate), MONTH(SSH.OrderDate))

---2. Mostrar las personas con sus respectivas direcciones.

select  (pp.FirstName +' '+ISNULL(PP.MiddleName, '')) as Nombre, pp.LastName as Apellido, PAT.Name as Tipo_Direcci�n, (PA.AddressLine1 + ISNULL(PA.AddressLine2, '')) 
as Linea_1_2, pa.City as Ciudad
	from  Person.Address PA 
		inner join Person.BusinessEntityAddress PBA on (PA.AddressID = PBA.AddressID )
		inner join Person.BusinessEntity PBE on (PBA.BusinessEntityID = PBE.BusinessEntityID)
		inner join Person.Person PP on (PP.BusinessEntityID = PBE.BusinessEntityID)
		inner join Person.AddressType PAT ON (PBA.AddressTypeID = PAT.AddressTypeID)
		order by pp.FirstName

---3.Cuantas ordenes de trabajo se han realizado por producto en cada a�o.

SELECT P.Name as Nombre, YEAR(WO.StartDate) AS A�o, COUNT(WO.WorkOrderID) as Cantidad
FROM PRODUCTION.PRODUCT P 
    INNER JOIN Production.WorkOrder WO ON WO.ProductID = P.ProductID
	GROUP BY YEAR(WO.StartDate), P.Name
	ORDER BY 1


--------------------------------------------------------------------------------------------------

---4.i. Aplicar un aumento del 10% a todos los empleados de la empresa:

---4.ii. Si la persona es de Ventas, aumentar tambi�n un 10% su Bono. Implementando un trigger.

create trigger HumanResources.tu_VentasLab on HumanResources.EmployeePayHistoryCopy
after update as
begin
declare @BusinessEmployee int
select @BusinessEmployee = HRE.BusinessEntityID from HumanResources.EmployeePayHistoryCopy HRE
	
	UPDATE Sales.SalesPerson
	set Bonus = Bonus + (0.1*Bonus)
	where  Sales.SalesPerson.BusinessEntityID = @BusinessEmployee 
	print 'Se actualizo correctamente'
	
end


Declare @NewRate money
Declare @BusinessID int
Declare cRate Cursor for
Select HRL.Rate, HRL.BusinessEntityID
from HumanResources.EmployeePayHistoryCopy HRL
Open cRate
    Fetch next from cRate into @NewRate,@BusinessID
while @@FETCH_STATUS = 0
Begin
    update
    HumanResources.EmployeePayHistoryCopy 
    set Rate = Rate + Rate*0.1
    where Rate = @NewRate and BusinessEntityID = @BusinessID
    fetch next from cRate into @NewRate,@BusinessID
End
CLOSE cRate
DEALLOCATE cRate

---5. Demuestre para los ejercicios 2 y 3, los querys creados sean los mas �ptimos, aplicando ( si es necesario) 
---alguna creaci�n de �ndices ( seg�n sugerencia del motor de base de datos).

---No pide sugerencia, el 2 y 3 se creo correctamente


---6. Sobre los empleados, valide que no permita tener para 1 empleado m�s de un departamento activo.

alter trigger HumanResources.verifyingDepartmentNumber on HumanResources.EmployeeDepartmentHistory
instead of update,insert as 
begin
	Declare @businessEntityID int
	Declare @departmentID smallint

	SELECT @departmentID = i.DepartmentID, @businessEntityID = i.BusinessEntityID
	from inserted I

	if exists (select * from HumanResources.EmployeeDepartmentHistory where BusinessEntityID = @businessEntityID)
	begin
		ROLLBACK TRANSACTION
		print 'Error, no se puede insertar o actualizar'
	end
	else
	begin
		print 'Update o insert realizado con exito'
	end
end

---7. �Cu�l es el producto m�s vendido, por a�o? Tome en cuenta �nicamente los productos que se hayan vendido a m�s de un cliente.

select * from (
select ROW_NUMBER() over(partition by A�o order by  Qty desc ) as ID, YearName.* from (
	
		select  YEAR(SOH.OrderDate) as A�o, PP.Name as Product, sum(SOD.OrderQty) as Qty
		from Sales.SalesOrderHeader SOH
			inner join Sales.SalesOrderDetail SOD on SOH.SalesOrderID = SOD.SalesOrderID
			inner join Production.Product PP on SOD.ProductID = PP.ProductID
				group by YEAR(SOH.OrderDate), PP.Name) YearName ) as FinalTable
				where ID <= 1

---8. Actualice la comisi�n a pagar para los vendedores, cada vez que ocurra alg�n movimiento de venta.

create trigger Sales.ti_SalesMovment on Sales.SalesOrderHeader
after insert
as 
declare @IdVendor int
declare @Total money
	select @IdVendor = i.SalesPersonID from inserted i
	select @Total = i.TotalDue from inserted i

update Sales.SalesPerson
set Bonus = Bonus + @Total*CommissionPct
where Sales.SalesPerson.BusinessEntityID = @IdVendor



delete from sales.ShoppingCartItem
where ShoppingCartItemID = 15


select *
from sales.ShoppingCartItem 

rollback