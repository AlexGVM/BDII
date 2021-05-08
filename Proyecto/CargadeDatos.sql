   BULK INSERT POST
    from 'C:\Users\alexg\Documents\Landivar\Vespertina\Base de datos II\Proyecto\POST.txt'
    with 
    (

        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '\n'

    )


	 BULK INSERT USUARIO
    from 'C:\Users\alexg\Documents\Landivar\Vespertina\Base de datos II\Proyecto\USUARIO.txt'
    with 
    (

        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '\n'

    )

	   BULK INSERT COMENTARIOS
    from 'C:\Users\alexg\Documents\Landivar\Vespertina\Base de datos II\Proyecto\COMENTARIOS.txt'
    with 
    (

        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '\n'

    )


	BULK INSERT USUARIO_AMIGOS
    from 'C:\Users\alexg\Documents\Landivar\Vespertina\Base de datos II\Proyecto\USERAMIGOS.txt'
    with 
    (

        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '\n'

    )


	BULK INSERT BITACORA
    from 'C:\Users\alexg\Documents\Landivar\Vespertina\Base de datos II\Proyecto\BITACORA.txt'
    with 
    (

        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '\n'

    )

	
	BULK INSERT BITACORA_COMENTARIO
    from 'C:\Users\alexg\Documents\Landivar\Vespertina\Base de datos II\Proyecto\BITACORACOMENTARIO.txt'
    with 
    (

        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '\n'

    )


--UC
alter table USUARIO
add constraint UC_Email  UNIQUE (EMAIL)

alter table POST
add constraint UC_TIPODISPOSITIVO check (TIPODISPOSITIVO = 'tablet' or TIPODISPOSITIVO ='telefono' or TIPODISPOSITIVO = 'computadora' or TIPODISPOSITIVO ='consola')

alter table USUARIO_AMIGOS 
ADD constraint UC_USUARIOAMIGO check (IDUSERPROPIETARIO <> IDUSERAGREGADO)


select *
from BITACORA

select *
from BITACORA_COMENTARIO

select *
from COMENTARIOS

select *
from POST

select *
from TIPOPOST

select *
from USUARIO

select *
from USUARIO_AMIGOS