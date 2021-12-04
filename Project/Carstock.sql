CREATE table suppliers (
    id int,
    name VARCHAR(256) unique not null,
    address VARCHAR(256) unique not null,
    PRIMARY KEY (id)
);

create table brands (
    brand varchar(256) unique not null,
    company varchar(256) not null,
    PRIMARY KEY (brand)
);

create table models (
    id int,
    name varchar(256) unique not null,
    body_style varchar(256) not null,
    brand varchar(256) not null,
    primary key (id),
    foreign key (brand)
    references brands (brand)
);

create table parts (
    id int,
    name varchar(256) not null,
    model_id int not null,
    supplier_id int not null,
    primary key (id),
    foreign key (model_id)
    references models (id),
    foreign key (supplier_id)
    references suppliers (id)
);

create table plants (
    id int,
    name VARCHAR(256) unique not null,
    address VARCHAR(256) unique not null,
    PRIMARY KEY (id)
);

create table manufacturing (
    id int,
    model_id int not null,
    plant_id int not null,
    primary key (id),
    foreign key (model_id)
    references models (id),
    foreign key (plant_id)
    references plants (id)
);

create table options (
    id int,
    color varchar(256) not null,
    engine varchar(256) not null,
    transmission varchar(256) not null,
    manufacturing_id int not null,
    primary key(id),
    foreign key (manufacturing_id)
    references manufacturing (id)
);

create table vehicles (
    VIN varchar(256),
    option_id int,
    primary key(VIN),
    foreign key (option_id)
    references options (id)
);

create table dealers (
    name varchar(256) primary key
);

create table stock (
    VIN varchar(256),
    dealer varchar(256) not null,
    buy_date date not null,
    sell_date date,
    primary key(VIN),
    foreign key (VIN)
    references vehicles (VIN),
    foreign key (dealer)
    references dealers (name)
);

create table customers (
    id int,
    name varchar(256) not null,
    phone varchar(256) not null,
    gender varchar(256) not null,
    address varchar(256) not null,
    annual_income int
);

create table sales (
    id int,
    VIN varchar(256) not null,
    price int not null,
    date date not null,
    customer_id int not null
);

insert into suppliers values (1, 'Getrag', 'NewYork');
insert into suppliers values (2, 'Reddist', 'LosAngeles');

insert into brands values ('Rayfield', 'MartinTech');
insert into brands values ('Thorton', 'MartinTech');
insert into brands values ('Archer', 'ARC');
insert into brands values ('Herrera', 'ARC');

insert into models values (1, 'Aerondight S9 Guinevere', 'Convertible', 'Rayfield');
insert into models values (2, 'Mackinaw MTL1', 'Truck', 'Thorton');

insert into parts values (1, 'transmission', 1, 1);
insert into parts values (2, 'engine', 2, 2);

insert into plants values (1, 'Costiro', 'LosAngeles');
insert into plants values (2, 'Geord', 'NewYork');

insert into manufacturing values (1, 1, 2);
insert into manufacturing values (2, 2, 1);

insert into options values (1, 'Black', 'Stock', 'Stock', 1);
insert into options values (2, 'White', 'Stock', 'Stock', 1);
insert into options values (3, 'Black', 'Stock', 'Stock', 2);
insert into options values (4, 'White', 'Stock', 'Stock', 2);

insert into vehicles values ('AA0000', 1);
insert into vehicles values ('AA0001', 2);
insert into vehicles values ('AA0002', 3);
insert into vehicles values ('AA0003', 4);

insert into dealers values ('GCars');
insert into dealers values ('Hi-Tao');

insert into stock values ('AA0000', 'GCars', '2020-01-01', '2020-02-05');
insert into stock values ('AA0001', 'Hi-Tao', '2020-01-04', '2020-06-10');
insert into stock values ('AA0002', 'Hi-Tao', '2020-01-08', '2020-03-02');
insert into stock values ('AA0003', 'GCars', '2020-02-03');

insert into customers values (1, 'Frank','+12345678910','male','NewJersey', 30000);
insert into customers values (2, 'Glory','+45645677892','female','Washington DC', 40000);
insert into customers values (3, 'Emily','+39342375748','female','Washington DC', 55000);
insert into customers values (4, 'Jeffrey','+21121908312','male','Washington DC', 55000);

insert into sales values (1, 'AA0000', 70000, '2020-02-05', 1);
insert into sales values (2, 'AA0001', 70000, '2020-06-10', 2);
insert into sales values (3, 'AA0002', 15000, '2020-03-02', 3);