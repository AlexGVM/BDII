---ver las estadisticas de una BD

select *
from sys.objects
where name like '%Purchase%' and type = 'U'

select *
from sys.stats
where  object_id = 1602104748
--Data  Base Console Comand

DBCC  show_statistics ('Purchasing.PurchaseOrderHeader','order_status')
--Primer bloque, se puede ver la ultima  vez que se actualizaron estadisticas de una tabla
-- Segundo bloque o tabla se mira la Densidad 
--Tercer Bloque, se mira el histograma 

--Creación una estadistica

create statistics  order_status on Purchasing.PurchaseOrderHeader (status)

select *
from Purchasing.PurchaseOrderHeader POH
	inner join Purchasing.PurchaseOrderDetail  POD on POH.PurchaseOrderID = POD.PurchaseOrderID
