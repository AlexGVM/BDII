/*==============================================================*/
/* DBMS name:      Microsoft SQL Server 2019                    */
/* Created on:     10/23/2020 1:41:19 PM                        */
/*==============================================================*/

if exists (select 1
            from  sysobjects
           where  id = object_id('AMIGOS')
            and   type = 'U')
   drop table AMIGOS
go

if exists (select 1
            from  sysobjects
           where  id = object_id('BITACORA')
            and   type = 'U')
   drop table BITACORA
go

if exists (select 1
            from  sysobjects
           where  id = object_id('BITACORA_COMENTARIO')
            and   type = 'U')
   drop table BITACORA_COMENTARIO
go

if exists (select 1
            from  sysobjects
           where  id = object_id('COMENTARIOS')
            and   type = 'U')
   drop table COMENTARIOS
go

if exists (select 1
            from  sysobjects
           where  id = object_id('LIKES')
            and   type = 'U')
   drop table LIKES
go

if exists (select 1
            from  sysobjects
           where  id = object_id('POST')
            and   type = 'U')
   drop table POST
go

if exists (select 1
            from  sysobjects
           where  id = object_id('TIPOPOST')
            and   type = 'U')
   drop table TIPOPOST
go

if exists (select 1
            from  sysobjects
           where  id = object_id('USUARIO')
            and   type = 'U')
   drop table USUARIO
go

if exists (select 1
            from  sysobjects
           where  id = object_id('USUARIO_AMIGOS')
            and   type = 'U')
   drop table USUARIO_AMIGOS
go

if exists(select 1 from systypes where name='DOMAIN_1')
   drop type DOMAIN_1
go

/*==============================================================*/
/* Domain: DOMAIN_1                                             */
/*==============================================================*/
create type DOMAIN_1
   from char(10)
go


/*==============================================================*/
/* Table: BITACORA                                              */
/*==============================================================*/
create table BITACORA (
   IDUSER               int                  not null,
   IDPOST               int                  not null,
   TEXTOCOMENTARIO      nvarchar(358)        null,
   IDBITACORA               int              identity(1,1) not null,
   FECHA                date                 not null,
   TYPELIKE             bit                  null
   constraint PK_BITACORA primary key (IDBITACORA)
)
go

/*==============================================================*/
/* Table: BITACORA_COMENTARIO                                   */
/*==============================================================*/
create table BITACORA_COMENTARIO (
   IDPOST               int                   not null,
   IDCOMMENT            int                   not null,
   IDBITACORACOMENTARIO int                  identity(1,1) not null,
   constraint PK_BITACORA_COMENTARIO primary key (IDBITACORACOMENTARIO)
)
go

/*==============================================================*/
/* Table: COMENTARIOS                                           */
/*==============================================================*/
create table COMENTARIOS (
   IDCOMMENT            int                  identity(1,1) not null,
   IDUSER               int                   not null,
   IDPOST               int                  not null,
   TEXTOCOMENTARIO      nvarchar(358)        not null,
   Fecha                date             not null,
   ACTIVO               bit                  null,
   constraint PK_COMENTARIOS primary key (IDCOMMENT)
)
go



/*==============================================================*/
/* Table: POST                                                  */
/*==============================================================*/
create table POST (
   IDPOST               int                  identity(1,1) not null,
   IDUSER               int                  not null,
   POSTTEXT             nvarchar(1000)       not null,
   FECHA                datetime                 not null,
   IP                   nvarchar(100)         not null,
   TIPODISPOSITIVO      nvarchar(100)         not null,
   IDTYPEPOST           int                  not null,
   constraint PK_POST primary key (IDPOST)
)
go

/*==============================================================*/
/* Table: TIPOPOST                                              */
/*==============================================================*/
create table TIPOPOST (
   IDTIPOPOST               int              identity(1,1)  not null,
   TIPO                 nvarchar(50)         not null,
   constraint PK_TIPOPOST primary key (IDTIPOPOST)
)
go

/*==============================================================*/
/* Table: USUARIO                                               */
/*==============================================================*/
create table USUARIO (
   IDUSER               int                  identity(1,1) not null,
   USUARIO              nvarchar(50)         not null,
   NOMBRE1              nvarchar(50)         not null,
   NOMBRE2              nvarchar(50)         null,
   APELLIDO1            nvarchar(50)         not null,
   APELLIDO2            nvarchar(50)         null,
   EMAIL                nvarchar(75)         not null,
   FECHADENACIMIENTO    datetime             not null,
   FECHACREACIÓN		 date             not null,
   LIMITEAMIGOS         int                 null,
   constraint PK_USUARIO primary key (IDUSER)
)
go

/*==============================================================*/
/* Table: USUARIO_AMIGOS                                        */
/*==============================================================*/
create table USUARIO_AMIGOS (
   IDUSERPROPIETARIO               int                   not null,
   IDUSERAGREGADO             int                   not null,
   IDUSERAMIGO          int                  identity(1,1) not null,
   constraint PK_USUARIO_AMIGOS primary key (IDUSERAMIGO)
)
go

alter table BITACORA
   add constraint FK_BITACORA_REFERENCE_POST foreign key (IDPOST)
      references POST (IDPOST)
go

alter table BITACORA
   add constraint FK_BITACORA_REFERENCE_USUARIO foreign key (IDUSER)
      references USUARIO (IDUSER)
go

alter table BITACORA_COMENTARIO
   add constraint FK_BITACORA_REFERENCE_COMENTAR foreign key (IDCOMMENT)
      references COMENTARIOS (IDCOMMENT)
go

alter table COMENTARIOS
   add constraint FK_COMENTAR_REFERENCE_USUARIO foreign key (IDUSER)
      references USUARIO (IDUSER)
go

alter table COMENTARIOS
   add constraint FK_COMENTAR_REFERENCE_POST foreign key (IDPOST)
      references POST (IDPOST)
go


alter table POST
   add constraint FK_POST_REFERENCE_USUARIO foreign key (IDUSER)
      references USUARIO (IDUSER)
go

alter table POST
   add constraint FK_POST_REFERENCE_TIPOPOST foreign key (IDTYPEPOST)
      references TIPOPOST (IDTIPOPOST)
go


alter table USUARIO_AMIGOS
   add constraint FK_USUARIO__REFERENCE_USUARIOPROPIETARIO foreign key (IDUSERPROPIETARIO)
      references USUARIO (IDUSER)
go

alter table USUARIO_AMIGOS
   add constraint FK_USUARIO__REFERENCE_USUARIOAGREGADO foreign key (IDUSERAGREGADO)
      references USUARIO (IDUSER)
go

