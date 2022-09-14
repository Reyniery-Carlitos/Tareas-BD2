create database Tarea1_BD2;

use Tarea1_BD2;

create schema tarea1;

-- CREACION DE TABLAS
create table tarea1.Cliente(
	identidad varchar(40) primary key,
	nombre varchar(50) not null,
	apellido varchar(50) not null,
	telefono varchar(30) not null
)

create table tarea1.Hotel(
	codigo varchar(20) primary key,
	nombre varchar(60) not null,
	direccion varchar(200) not null
)

create table tarea1.Reserva(
	identidad_cliente varchar(40), -- Clave foranea Cliente
	codigo_hotel varchar(20), -- Clave foranea Hotel
	fecha_in date,
	fecha_out date not null,
	-- 1) Valor por defecto de la cantidad de personas debe ser 0
	cantidad_personas integer default 0,
	
	-- Restricciones llave primaria y foranea
	primary key (identidad_cliente, codigo_hotel, fecha_in),
	foreign key (identidad_cliente) references tarea1.Cliente(identidad),
	foreign key (codigo_hotel) references tarea1.Hotel(codigo)
)

create table tarea1.Aerolinea(
	codigo varchar(20) primary key,
	-- 2) Check para Descuentos mayor o igual a 10
	descuento integer check(descuento >= 10), 
)

create table tarea1.Boleto(
	codigo varchar(20) primary key,
	no_vuelo varchar(20) not null,
	fecha date not null,
	-- 3) Restriccion check para valores destinos: Mexico, Guatemala y Panama
	destino varchar(30) check(destino in ('Mexico', 'Guatemala', 'Panama')) not null,
	identidad_cliente varchar(40), -- Clave foranea Cliente,
	codigo_aerolinea varchar(20), -- Clave foranea Aerolinea

	-- Restricciones llave foranea
	foreign key (identidad_cliente) references tarea1.Cliente(identidad),
	foreign key (codigo_aerolinea) references tarea1.Aerolinea(codigo)
)

-- INSERTANDO DATOS A LAS TABLAS
	-- Clientes
insert into tarea1.Cliente
values ('0801-1999-00234', 'Juan', 'Perez', '8855-6677')

insert into tarea1.Cliente
values ('0801-2000-45234', 'Lucas', 'Hernandez', '9900-8890')

insert into tarea1.Cliente
values ('0801-1991-06634', 'Maria', 'Lopez', '9088-5544')
	
	-- Hotel
insert into tarea1.Hotel 
values('001', 'Hotel Ritz', 'Guadalajara')

insert into tarea1.Hotel 
values('002', 'Hotel Marriot', 'Ciudad de Guatemala')

insert into tarea1.Hotel 
values('003', 'Hotel via España', 'Santiago')

	-- Reserva
insert into tarea1.Reserva
values ('0801-1999-00234', '001', '01-12-2022', '01-15-2022', 5)

insert into tarea1.Reserva
values ('0801-2000-45234', '002', '04-15-2022', '04-16-2022', 3)

insert into tarea1.Reserva (identidad_cliente, codigo_hotel, fecha_in, fecha_out)
values ('0801-1991-06634', '003', '05-16-2022', '05-20-2022')

	-- Aerolinea
insert into tarea1.Aerolinea
values ('001', 25)

insert into tarea1.Aerolinea
values ('002', 10)

insert into tarea1.Aerolinea
values ('003', 15)

	-- Boleto
insert into tarea1.Boleto
values ('001', '0012452', '01-11-2022', 'Mexico', '0801-1999-00234', '001')

insert into tarea1.Boleto
values ('002', '0015652', '04-14-2022', 'Guatemala', '0801-2000-45234', '002')

insert into tarea1.Boleto
values ('003', '0013452', '05-15-2022', 'Panama', '0801-1991-06634', '003')

-- SELECCIONAR DATOS DE LAS TABLAS
select * from tarea1.Cliente
select * from tarea1.Hotel
select * from tarea1.Reserva
select * from tarea1.Aerolinea
select * from tarea1.Boleto