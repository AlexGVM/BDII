
---Alexander Villatoro 1182118 , Mario Velasquez 1092518


---1.Crear una tabla resumen con la siguiente información sobre las ventas que se han realizado:

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

select  (pp.FirstName +' '+ISNULL(PP.MiddleName, '')) as Nombre, pp.LastName as Apellido, PAT.Name as Tipo_Dirección, (PA.AddressLine1 + ISNULL(PA.AddressLine2, '')) 
as Linea_1_2, pa.City as Ciudad
	from  Person.Address PA 
		inner join Person.BusinessEntityAddress PBA on (PA.AddressID = PBA.AddressID )
		inner join Person.BusinessEntity PBE on (PBA.BusinessEntityID = PBE.BusinessEntityID)
		inner join Person.Person PP on (PP.BusinessEntityID = PBE.BusinessEntityID)
		inner join Person.AddressType PAT ON (PBA.AddressTypeID = PAT.AddressTypeID)
		order by pp.FirstName

---3.Cuantas ordenes de trabajo se han realizado por producto en cada año.

SELECT P.Name as Nombre, YEAR(WO.StartDate) AS Año, COUNT(WO.WorkOrderID) as Cantidad
FROM PRODUCTION.PRODUCT P 
    INNER JOIN Production.WorkOrder WO ON WO.ProductID = P.ProductID
	GROUP BY YEAR(WO.StartDate), P.Name
	ORDER BY 1


--------------------------------------------------------------------------------------------------

---4.i. Aplicar un aumento del 10% a todos los empleados de la empresa:

---4.ii. Si la persona es de Ventas, aumentar también un 10% su Bono. Implementando un trigger.

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

---5. Demuestre para los ejercicios 2 y 3, los querys creados sean los mas óptimos, aplicando ( si es necesario) 
---alguna creación de índices ( según sugerencia del motor de base de datos).

---No pide sugerencia, el 2 y 3 se creo correctamente


---6. Sobre los empleados, valide que no permita tener para 1 empleado más de un departamento activo.

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

---7. ¿Cuál es el producto más vendido, por año? Tome en cuenta únicamente los productos que se hayan vendido a más de un cliente.

select * from (
select ROW_NUMBER() over(partition by Año order by  Qty desc ) as ID, YearName.* from (
	
		select  YEAR(SOH.OrderDate) as Año, PP.Name as Product, sum(SOD.OrderQty) as Qty
		from Sales.SalesOrderHeader SOH
			inner join Sales.SalesOrderDetail SOD on SOH.SalesOrderID = SOD.SalesOrderID
			inner join Production.Product PP on SOD.ProductID = PP.ProductID
				group by YEAR(SOH.OrderDate), PP.Name) YearName ) as FinalTable
				where ID <= 1

---8. Actualice la comisión a pagar para los vendedores, cada vez que ocurra algún movimiento de venta.

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