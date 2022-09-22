create database tarea1bd
use tarea1bd;

create table Hotel (
	codigo_hotel int primary key not null,
	nombre nvarchar(100) not null,
	direccion nvarchar(100) not null
);

create table Cliente (
	identidad int primary key not null,
	nombre nvarchar(100) not null,
	telefono nvarchar(8),
);

create table Reserva (
	codigo_hotel int not null,
	codigo_cliente int not null,
	fechain date not null,
	fechaout date not null,
	cantidad_personas int default 0,
	primary key (codigo_hotel, codigo_cliente),
	constraint fk_hotel_reserva foreign key  (codigo_hotel) references Hotel(codigo_hotel),
	constraint fk_cliente_reserva foreign key  (codigo_cliente) references Cliente(identidad),
);

create table Aerolinea (
	codigo_aerolinea int primary key not null,
	descuento int not null
	check (descuento >=10)
);

create table Boleto (
	codigo_boleto int primary key not null,
	no_vuelo int not null,
	fecha date not null,
	destino nvarchar(150),
	codigo_cliente int,
	codigo_aerolinea int,
	check (destino in('Mexico','Guatemala','Panama')),
	constraint fk_aerolinea_boleto foreign key  (codigo_aerolinea) references Aerolinea(codigo_aerolinea),
	constraint fk_cliente_boleto foreign key  (codigo_cliente) references Cliente(identidad),
)
