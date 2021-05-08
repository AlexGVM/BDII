/*==============================================================*/
/* DBMS name:      Microsoft SQL Server 2008                    */
/* Created on:     10/18/2020 6:47:45 PM                        */
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
/* Table: AMIGOS                                                */
/*==============================================================*/
create table AMIGOS (
   IDAMIGO              int                  not null,
   FECHA                date                 not null,
   HORA                 time                 not null,
   constraint PK_AMIGOS primary key (IDAMIGO)
)
go

/*==============================================================*/
/* Table: BITACORA                                              */
/*==============================================================*/
create table BITACORA (
   IDUSER               int                  null,
   IDPOST               int                  not null,
   TIPOPUBLICACION      nvarchar(50)         not null,
   N                    int                  not null,
   M                    int                  not null,
   FECHA                date                 not null,
   HORA                 time                 not null,
   constraint PK_BITACORA primary key (IDPOST)
)
go

/*==============================================================*/
/* Table: COMENTARIOS                                           */
/*==============================================================*/
create table COMENTARIOS (
   IDCOMMENT            int                  identity,
   IDUSER               int                  null,
   IDPOST               int                  null,
   TEXTOCOMENTARIO      nvarchar(358)        not null,
   DATE                 datetime             not null,
   ACTIVO               bit                  null,
   constraint PK_COMENTARIOS primary key (IDCOMMENT)
)
go

/*==============================================================*/
/* Table: LIKES                                                 */
/*==============================================================*/
create table LIKES (
   IDLIKE               int                  identity,
   IDUSER               int                  null,
   IDPOST               int                  null,
   TYPELIKE             bit                  not null,
   constraint PK_LIKES primary key (IDLIKE)
)
go

/*==============================================================*/
/* Table: POST                                                  */
/*==============================================================*/
create table POST (
   IDPOST               int                  identity,
   IDUSER               int                  null,
   POSTTEXT             text                 not null,
   FECHA                date                 not null,
   HORA                 time                 not null,
   IP                   nvarchar(50)         not null,
   TIPODISPOSITIVO      nvarchar(50)         not null,
   IDTYPEPOST           int                  not null,
   constraint PK_POST primary key (IDPOST)
)
go

/*==============================================================*/
/* Table: TIPOPOST                                              */
/*==============================================================*/
create table TIPOPOST (
   IDPOST               int                  not null,
   TIPO                 nvarchar(50)         not null,
   constraint PK_TIPOPOST primary key (IDPOST)
)
go

/*==============================================================*/
/* Table: USUARIO                                               */
/*==============================================================*/
create table USUARIO (
   IDUSER               int                  identity,
   USUARIO              nvarchar(50)         not null,
   NOMBRE1              nvarchar(50)         not null,
   NOMBRE2              nvarchar(50)         null,
   APELLIDO1            nvarchar(50)         not null,
   APELLIDO2            nvarchar(50)         null,
   EMAIL                nvarchar(75)         not null unique,
   FECHADENACIMIENTO    datetime            not null,
   constraint PK_USUARIO primary key (IDUSER)
)
go

/*==============================================================*/
/* Table: USUARIO_AMIGOS                                        */
/*==============================================================*/
create table USUARIO_AMIGOS (
   IDUSER               int                  null,
   IDAMIGO              int                  null,
   IDUSERAMIGO          int                  not null,
   LIMITEAMIGOS         int                  null,
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

alter table COMENTARIOS
   add constraint FK_COMENTAR_REFERENCE_USUARIO foreign key (IDUSER)
      references USUARIO (IDUSER)
go

alter table COMENTARIOS
   add constraint FK_COMENTAR_REFERENCE_POST foreign key (IDPOST)
      references POST (IDPOST)
go

alter table LIKES
   add constraint FK_LIKES_REFERENCE_USUARIO foreign key (IDUSER)
      references USUARIO (IDUSER)
go

alter table LIKES
   add constraint FK_LIKES_REFERENCE_POST foreign key (IDPOST)
      references POST (IDPOST)
go

alter table POST
   add constraint FK_POST_REFERENCE_USUARIO foreign key (IDUSER)
      references USUARIO (IDUSER)
go

alter table TIPOPOST
   add constraint FK_TIPOPOST_REFERENCE_POST foreign key (IDPOST)
      references POST (IDPOST)
go

alter table USUARIO_AMIGOS
   add constraint FK_USUARIO__REFERENCE_USUARIO foreign key (IDUSER)
      references USUARIO (IDUSER)
go

alter table USUARIO_AMIGOS
   add constraint FK_USUARIO__REFERENCE_AMIGOS foreign key (IDAMIGO)
      references AMIGOS (IDAMIGO)
go

