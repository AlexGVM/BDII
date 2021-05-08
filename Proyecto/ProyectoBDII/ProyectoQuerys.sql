--Crear archivo de usuarios
create or alter proc usp_archivo as
begin

	BULK INSERT [dbo].[USUARIO]
	from 'C:\Users\alexg\Documents\Landivar\Vespertina\Base de datos II\Proyecto\USUARIO.txt'
	with 
	(
	
		FIELDTERMINATOR = ',',
		ROWTERMINATOR = ';\n'
	
	)

end
exec usp_archivo

-- NO REPETIR EL NOMBRE MÁS DE 2 VECES
create or alter trigger ti_verify_name
on "USUARIO"
after insert
as
    declare @Usuario int
    declare @Nombre1 varchar(50)
    declare @Nombre2 varchar(50)
    declare @Apellido1 varchar(50)
    declare @Apellido2 varchar(50)
    declare @cont int

    select @Usuario = IDUSER, @Nombre1 = NOMBRE1, @Nombre2 = NOMBRE2, @Apellido1 = APELLIDO1, @Apellido2 = APELLIDO2 from inserted

    select @cont = COUNT(*) from "USUARIO"
    where @Nombre1 = NOMBRE1 AND @Nombre2 = NOMBRE2 AND @Apellido1 = APELLIDO1 AND @Apellido2 = APELLIDO2

    if (@cont > 2)
    begin
        RAISERROR ('El nombre ya se ingreso más de dos veces.', 16, 1);
		ROLLBACK TRANSACTION
    end

insert into USUARIO 
(USUARIO,NOMBRE1,NOMBRE2,APELLIDO1,APELLIDO2,EMAIL,FECHADENACIMIENTO)
VALUES('alexv','Alex','Gabriel','Villatoro','Muñoz','edparedes@ucoz.ru','8/11/1994')

--para cada publicación no pueden existir más de 3 comentarios
create or alter trigger ti_verify_comments
on "Comentarios"
after insert
as
set transaction isolation level read committed;
Begin transaction 
    declare @idPost int
	declare @iduser int 
    declare @cont int
	declare @texto nvarchar(300)
	declare @fecha date

    select @idPost = IDPOST, @iduser = IDUSER, @texto = TEXTOCOMENTARIO, @fecha = Fecha from inserted

    select @cont = COUNT(*) from "COMENTARIOS"
    where @idPost = IDPOST

    if (@cont > 3)
    begin
        RAISERROR ('El comentario ya se ingreso más de 3 veces.', 16, 1);
		ROLLBACK TRANSACTION
		PRINT 'Comentario almacenado en bitacora exitosamente'
		insert into BITACORA
		( IDUSER, IDPOST, TEXTOCOMENTARIO, FECHA)
		Values(@iduser, @idPost, @texto, @fecha)
    end


insert into COMENTARIOS 
(IDUSER, IDPOST,TEXTOCOMENTARIO,Fecha,ACTIVO)
VALUES(5,1,'Jeff nos hizo sentir mal x2','8/11/1994',1)

---Tienen que haber suficientes N para M
--En donde N "me gusta" M "No me gusta" 

create or alter trigger ti_N_M
on "BITACORA"

after insert
as
set transaction isolation level read committed;
Begin transaction 
    declare @N int
	declare @M int
	declare @like bit
	declare @idPost int
	declare @idusar int
	select @idPost = IDPOST, @idusar = IDUSER, @like = TYPELIKE from inserted

    select @N = COUNT(*) from "BITACORA" where TYPELIKE = 1 and @idPost = IDPOST
    select @M = COUNT(*) from "BITACORA" where TYPELIKE = 0 and @idPost = IDPOST

    if (@N >= @M)
    begin
		PRINT 'Interacción hecha con éxito'
		COMMIT TRANSACTION
    end
	else
	begin 
		RAISERROR ('La cantidad de me gusta es menor a los no me gusta', 16, 1);
		ROLLBACK TRANSACTION 
		
	end
	
--El proceso podrá eliminar un comentario específico de una publicación, deberá validar si existen comentarios en cola ( y que no están activos) para 
--que ocupen el lugar que deja el comentario eliminado. 
create or alter trigger td_insertdelete
on "COMENTARIOS"
after delete
as
	declare @idPost int
	declare @iduser int 
	declare @texto nvarchar(100)
	declare @fecha date 

	
	select @idPost = IDPOST from deleted 

	select TOP 1 @iduser = IDUSER, @fecha = Fecha, @texto = TEXTOCOMENTARIO 
	from BITACORA 
	where @idPost = IDPOST 

	insert into COMENTARIOS
	(IDUSER, IDPOST, TEXTOCOMENTARIO, Fecha, ACTIVO)
	values(@iduser, @idPost, @texto, @fecha, 1) 
	DELETE FROM BITACORA WHERE @idPost = IDPOST and @iduser = IDUSER and @fecha = Fecha and @texto = TEXTOCOMENTARIO;
	print 'Transferido Exitosamente'
	commit


select *
	from BITACORA	



insert into LIKES
(IDUSER,IDPOST,TYPELIKE)
VALUES(4,3,1)

--Deberá de llevar una bitácora de los mismos (la misma información que los comentarios) para que en algún momento en
--el tiempo se pueda obtener cuantos N existían.
CREATE or ALTER PROCEDURE usp_consultabitacora
	@idPost1 int  as --input
BEGIN
	
	declare @N int, @M int

	set @N = (select COUNT(*) from BITACORA where TYPELIKE = 1 and IDPOST = @idPost1)
	set @M = (select COUNT(*) from BITACORA where TYPELIKE = 0 and IDPOST = @idPost1)
	print 'El post con ID:' + Convert(varchar(10),@idPost1)
	print 'Cantidad de Likes' + ' ' +Convert(varchar(10),@N)
	print 'Cantidad de Dislikes' + ' ' +Convert(varchar(10),@M)

END
exec usp_consultabitacora 1

insert into BITACORA
(IDUSER,IDPOST,FECHA,TYPELIKE)
VALUES(1,1,GETDATE(),0)

select *
from BITACORA

-- tomando en
--cuenta que si se encuentran usuarios con los mismos apellidos
--automáticamente se relacionan y entran dentro de los 50 amigos que tienen
--permitido asociar. 
create or alter trigger ti_insertdelete
on "USUARIO"
for insert
as
	
	declare @idUser int
	declare @idUser1  int
	declare @apellido nvarchar(50)
	declare @apellido1 nvarchar(50)
	declare @cantidad int
	declare @limite int
	select @idUser = IDUSER from inserted
	select @apellido = APELLIDO1 from inserted
	select @apellido1 = APELLIDO2 from inserted

	select TOP 1 @idUser1 = IDUSER, @limite = LIMITEAMIGOS
	from USUARIO 
	where @idUser != IDUSER and (@apellido = APELLIDO1 or @apellido1 = APELLIDO2)
	select @cantidad = COUNT(*)
	from USUARIO_AMIGOS
	where @idUser1 = IDUSERPROPIETARIO
	if(@idUser1 is null )
	begin 
		print 'No hay familiares para asociar como amigos'
		COMMIT
	end
	else
	begin
		if(@cantidad < @limite)
		begin
		insert into USUARIO_AMIGOS
		(IDUSERPROPIETARIO,IDUSERAGREGADO)
		VALUES(@idUser,@idUser1)
		insert into USUARIO_AMIGOS
		(IDUSERPROPIETARIO,IDUSERAGREGADO)
		VALUES(@idUser1,@idUser)
		print 'Familiar asociado como amigo'
		COMMIT
		end
		else
		begin
		print 'No se puede agregar Familiar ya que tiene el limite de amigos permitidos'
		commit
		end
	end
	
	insert into USUARIO 
	(USUARIO,NOMBRE1,APELLIDO1,APELLIDO2,EMAIL,FECHADENACIMIENTO,LIMITEAMIGOS)
	VALUES('papi-kun','Joel','Swindle','Twiddle','swt123w@ucoz.ru','8/11/2015', 50)


--Si una publicación, al finalizar el día, tiene como
--mínimo 15 “me gusta”, se podrá aumentar un amigo más en dicho limite. 

create or alter proc usp_BLikes as
begin

declare @idPostC int
declare @fechaC date
declare @typelikeC bit
declare @fechaPT date
declare @idUserPT int
declare @contadorF int

declare c_BitacoLikes Cursor 
for select BA.IDPOST,BA.FECHA,TYPELIKE,PT.FECHA as [Fecha de Creación], PT.IDUSER 
	from BITACORA BA inner join POST PT on (BA.IDPOST = PT.IDPOST)

open c_BitacoLikes
Fetch c_BitacoLikes into @idPostC,@fechaC, @typelikeC, @fechaPT, @idUserPT
while (@@FETCH_STATUS =  0)
begin
	
	set @contadorF  = 0
	select @contadorF = COUNT(*) 
	from POST PT inner join BITACORA BA on (BA.IDPOST = PT.IDPOST)
	where @typelikeC = 1 and MONTH(@fechaPT) = MONTH(@fechaC) and YEAR(@fechaPT) = YEAR(@fechaC) and DAY(@fechaPT) = DAY(@fechaC) and (@idPostC = BA.IDPOST)
	
	if(@contadorF >= 15)
	begin

		update Usuario
		set LIMITEAMIGOS = LIMITEAMIGOS + 1
		where @idUserPT = IDUSER
		print 'Se aumento el limite de amigos de el usuario: ' +(CONVERT(nvarchar(50), @idPostC))
	end

	fetch c_BitacoLikes into @idPostC,@fechaC, @typelikeC, @fechaPT, @idUserPT
end
Close c_BitacoLikes
Deallocate c_BitacoLikes
end
exec usp_BLikes

-- no exceda el maximo de amigos
create or alter trigger ti_MaxAmigos
on "USUARIO_AMIGOS"
after insert
as
    declare @cantidadMax int
	declare @cantidad int
	declare @propietario int
	declare @agregado int 

	select @propietario = IDUSERPROPIETARIO from inserted
	select @agregado = IDUSERAGREGADO from inserted
	select @cantidadMax = LIMITEAMIGOS from Usuario where @propietario = IDUSER
	select @cantidad = COUNT(*) from USUARIO_AMIGOS where @propietario = IDUSERPROPIETARIO

	if(@cantidad <= @cantidadMax)
	begin 
		print 'Amigo agregado'
		commit
	end
	else
	begin 
		RAISERROR ('Se alcanzo el limite de amigos', 16, 1);
		ROLLBACK TRANSACTION 
	end


--RANDOM POSTS

CREATE or ALTER PROCEDURE usp_randompost
AS BEGIN
set transaction isolation level read uncommitted;
Begin transaction 
declare @num int, @num1 int, @cont int, @cont1 int, @CantUser int, @UserForPost int
SELECT @num = ROUND(((99 - 1) * RAND() + 1), 0)
SELECT @num1 = ROUND(((99 - 1) * RAND() + 1), 0)
Select @cont = 0
Select @cont1 = 0
Select @CantUser =  COUNT(*) from USUARIO
Select @UserForPost =0

WHILE @cont < @num
BEGIN
 select @UserForPost = ROUND(((@CantUser - 1) * RAND() + 1),0)
  WHILE @cont1 < @num1
BEGIN
	select @UserForPost = ROUND(((@CantUser - 1) * RAND() + 1),0)
   insert into POST(IDUSER, POSTTEXT, FECHA, IP, TIPODISPOSITIVO, IDTYPEPOST) 
   VALUES (@UserForPost ,'Profe, le cayo un camarón a mi tarea, sorry', getdate(),'377.1.0.0' ,'telefono',1)
   SET @cont1 = @cont1 + 1;
END;
   SET @cont = @cont + 1;
END;
COMMIT TRANSACTION 
END
exec usp_randompost

--- Número de usuarios nuevos por día y porcentaje de crecimiento


--Número de usuarios nuevos por día y porcentaje de crecimiento. 
create or alter FUNCTION ufnGetStock (@fecha date) RETURNS INT AS
BEGIN
declare @cantidad int
select  @cantidad = ISNULL(count(IDUSER), 0)
from USUARIO 
where @fecha = FECHACREACIÓN
Group by  FECHACREACIÓN
RETURN @cantidad
END

create or alter procedure UsuarioPorcentaje
 AS
 declare @TotalUsers numeric
 select @TotalUsers = count(IDUSER) from USUARIO

select CONCAT('Cantidad de nuevos usuarios: ' , dbo.ufnGetStock( FECHACREACIÓN),  ' en la fecha ' , FECHACREACIÓN, ' Porcentaje: ',
(Convert(decimal(10,2),(dbo.ufnGetStock( FECHACREACIÓN)/ @TotalUsers) * 100)), '%' )  as Porcentaje 
from USUARIO 
Group by  FECHACREACIÓN
 
 exec UsuarioPorcentaje

--Número de publicaciones al mes, con el 100% de su capacidad de comentarios llena.

select YEAR(P.FECHA) as Año , MONTH(P.fecha) as Mes, COUNT(*) as Cantidad
from COMENTARIOS C
	inner join  POST P on C.IDPOST = P.IDPOST
WHERE C.ACTIVO = 1
GROUP  BY YEAR(P.FECHA), MONTH(P.fecha)
HAVING COUNT(C.ACTIVO) >= 3

--Detalle de publicaciones que en algún momento impactaron en el incremento de la cantidad máxima de amigos para un usuario.


select YEAR(PT.FECHA) as Año, MONTH(PT.FECHA) as Mes, DAY(PT.FECHA) as Dia, PT.IDPOST, COUNT(BA.TYPELIKE) as CantidadLikes, PT.POSTTEXT
from POST PT inner join BITACORA BA on (BA.IDPOST = PT.IDPOST)
where BA.TYPELIKE = 1 and MONTH(PT.FECHA) = MONTH(BA.FECHA) and YEAR(PT.FECHA) = YEAR(BA.FECHA) and DAY(PT.FECHA) = DAY(BA.FECHA)
group by YEAR(PT.FECHA), MONTH(PT.FECHA), DAY(PT.FECHA), PT.IDPOST, PT.POSTTEXT
having COUNT(BA.TYPELIKE) > = 15

