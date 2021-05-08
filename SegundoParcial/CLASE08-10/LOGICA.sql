select *
from sales.salesOrderHeader
order by 1 desc
select *
from sales.SalesOrderDetail

exec sales.spIngresaVenta
	'30/10/2020',5,10

	exec sales.spIngresaVenta
	'30/10/2020',5,6

--1. Crear un procedimiento que inserte en SalesOrderHeader
--	-Recibe las columnas necesarias para insertar
--	-recibe cuantos PRODUCTOS (líneas)tendrá el detalle
--  -actualizar las columnas respectivas de TOTALES

--2. Insertar en SalesOrderDetail
-- -Utilizo el mismo del header o creo uno adicional ?
-- -Maneja los errores para determinar o confirmar los que sí aplican
-- -Presentar el resultado del detalle

--3. 



			PROC PRINCIPAL ---una sola vez

			insertar el encabezado
			--ciclo
			recorrido con los N detalles para insertar el producto-linea
			llamar a un procedimiento específio para insertar el detalle

			actualizar totales