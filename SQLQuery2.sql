--siempre y cuando la direccion de entrega se a utilizado mas de 5 veces en las ordenes
select *
	from SALES.salesorderheader H
			inner JOIN sales.salesorderdetail SOD
				ON h.SalesOrderID = sod.SalesOrderID
where h.ShipToAddressID in (
select ShipToAddressID
from sales.SalesOrderHeader h
group by ShipToAddressID
having count(1) > 5

)
