drop database TrackerBD;
Create database TrackerBD charset utf8mb4;
use TrackerBD;

CREATE TABLE almacenes(
    id int unsigned auto_increment primary key,
    capacidad int not null,
    departamento varchar(30) not null,
    numero_puerta varchar(8) not null,
    calle varchar(50) not null,
    telefono varchar(12),
    latitud decimal(7,5) not null check (latitud >= -35 and latitud <= -30),
    longitud decimal(7,5) not null check (longitud >= -59 and longitud <= -53),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL DEFAULT NULL
);

CREATE TABLE productos (
    id INT unsigned auto_increment PRIMARY KEY,
    peso DECIMAL(6,2) unsigned not null,
    destino VARCHAR(20) not null,
    tipo enum("carta", "sobre chico", "sobre grande", "paquete chico", "paquete mediano", "paquete grande", "otro") not null,
    estado enum("en central", "en transito", "almacen final", "en domicilio") not null,
	remitente varchar(50) not null,
    nombre_destinatario varchar(50) not null,
    forma_entrega enum("reparto", "pick up") not null,
    calle varchar(50),
    numero_puerta varchar(8),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL DEFAULT NULL
);

CREATE TABLE almacena (
    id int unsigned auto_increment primary key,
    producto_id INT unsigned unique,
    almacen_id INT unsigned,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL DEFAULT NULL,
    FOREIGN KEY (producto_id) REFERENCES productos(id),
    FOREIGN KEY (almacen_id) REFERENCES almacenes(id)
);

CREATE TABLE usuarios (
	id int unsigned auto_increment primary key,
    usuario VARCHAR(50) unique not null,
    password VARCHAR(50) not null,
    tipo enum("funcionario", "chofer", "admin") not null,
    ci CHAR(8) unique not null,
    primer_nombre VARCHAR(50) not null,
    primer_apellido VARCHAR(50) not null,
    segundo_apellido VARCHAR(50),
    calle VARCHAR(50) not null,
    numero_de_puerta varchar(8) not null,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL DEFAULT NULL
);

CREATE TABLE telefonousuarios (
    usuario_id int unsigned,
    telefono VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL DEFAULT NULL,
    primary key (usuario_id, telefono),
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id)
);

CREATE TABLE vehiculos (
    id int unsigned auto_increment primary key,
    matricula CHAR(7) unique not null,
    capacidad INT unsigned not null,
    estado enum("en almacen", "en transito"),
    tipo enum("flete", "reparto"),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL DEFAULT NULL
);


CREATE TABLE maneja (
    id int unsigned auto_increment primary key,
    vehiculo_id int unsigned,
    usuario_id int unsigned,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL DEFAULT NULL,
    unique key (usuario_id, vehiculo_id),
    FOREIGN KEY (vehiculo_id) REFERENCES vehiculos(id),
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id)
);

CREATE TABLE ruta (
    id INT unsigned auto_increment primary key not null,
    destino VARCHAR(20) not null,
    recorrido int unsigned not null,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL DEFAULT NULL
);

CREATE TABLE paradas (
    idRuta INT unsigned not null,
    latitud DECIMAL(7,5) not null check (latitud >= -35 and latitud <= -30),
    longitud DECIMAL(7,5) not null check (longitud >= -59 and longitud <= -53),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL DEFAULT NULL,
    primary key (idRuta, latitud, longitud),
    FOREIGN KEY (idRuta) REFERENCES ruta(id)
);

CREATE TABLE realiza (
    id int unsigned auto_increment primary key,
    vehiculo_id INT unsigned,
    ruta_id INT unsigned,
    tiempo_estimado time not null,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL DEFAULT NULL,
    unique key (vehiculo_id, ruta_id),
    FOREIGN KEY (vehiculo_id) REFERENCES vehiculos(id),
    FOREIGN KEY (ruta_id) REFERENCES ruta(id)
);

CREATE TABLE va (
    id int unsigned auto_increment primary key,
    ruta_id INT unsigned not null,
    almacen_id INT unsigned not null,
    vehiculo_id int unsigned not null,
    fecha DATE not null,
    horallegada TIME not null,
    horasalida TIME not null,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL DEFAULT NULL,
    unique key (ruta_id, almacen_id, vehiculo_id, fecha),
    FOREIGN KEY (vehiculo_id) REFERENCES vehiculos(id),
    FOREIGN KEY (almacen_id) REFERENCES almacenes(id)
);

CREATE TABLE gestiona (
	id int unsigned auto_increment primary key,
    producto_id INT unsigned not null,
    vehiculo_id INT unsigned not null,
    usuario_id INT unsigned not null,
    IDLote INT unsigned not null,
    fecha DATE not null,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL DEFAULT NULL,
    unique key (producto_id),
    FOREIGN KEY (producto_id) REFERENCES productos(id),
    FOREIGN KEY (vehiculo_id) REFERENCES vehiculos(id),
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id)
);

CREATE TABLE reparte (
	id int unsigned auto_increment primary key,
	producto_id int unsigned,
    almacen_id int unsigned not null,
    vehiculo_id int unsigned not null,
    fechaRealizacion date,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL DEFAULT NULL,
    unique key(producto_id, fechaRealizacion),
    FOREIGN KEY (producto_id) REFERENCES productos(id),
    FOREIGN KEY (vehiculo_id) REFERENCES vehiculos(id),
    FOREIGN KEY (almacen_id) REFERENCES almacenes(id)
);
