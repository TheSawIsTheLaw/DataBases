-- 3 вариант

-- Меню
create table menu(
    menuID integer generated always as identity primary key not null,
    menuName varchar2(16),
    foodTime varchar2(10),
    someWords varchar2(128)
);

insert into menu (menuName, foodTime, someWords)
values ('For somebody', 'zavtrak', 'Smth for smb');
insert into menu (menuName, foodTime, someWords)
values ('For golodny', 'zavtrak', 'if you are hungry');
insert into menu (menuName, foodTime, someWords)
values ('For homeless', 'uzhin', 'Nothing to do here with no money');
insert into menu (menuName, foodTime, someWords)
values ('For stranger', 'obed', 'suicide');
insert into menu (menuName, foodTime, someWords)
values ('Thesawisthelaw', 'zavtrak', 'Where we come from');
insert into menu (menuName, foodTime, someWords)
values ('Deathcore', 'obed', 'Its really scary');
insert into menu (menuName, foodTime, someWords)
values ('Metalcore', 'zavtrak', 'There nothing to do');
insert into menu (menuName, foodTime, someWords)
values ('WhiteChapel', 'obed', 'Kill me...');
insert into menu (menuName, foodTime, someWords)
values ('polnoe litso', 'zavtrak', 'too many food');
insert into menu (menuName, foodTime, someWords)
values ('hudoe litso', 'uzhin', 'im done');

-- Виды блюд
create table foodTypes(
    foodTypeID integer generated always as identity primary key not null,
    foodName varchar2(16),
    someWords varchar2(128),
    rating integer
);

insert into foodTypes (foodName, someWords, rating)
values ('Suicide', 'Really nice', 10);
insert into foodTypes (foodName, someWords, rating)
values ('Pelmeni', 'I want to bliny...', 8);
insert into foodTypes (foodName, someWords, rating)
values ('Vodka', 'You feeling stronger', -1);
insert into foodTypes (foodName, someWords, rating)
values ('Puncakes', 'Blinchiki!!!', 5);
insert into foodTypes (foodName, someWords, rating)
values ('Beer', 'Fantasii u menya net', 3);
insert into foodTypes (foodName, someWords, rating)
values ('Zemlya', 'Deshevo i serdito(((', 1);
insert into foodTypes (foodName, someWords, rating)
values ('Nothing', 'Dlya istinnih ceniteley', 10);
insert into foodTypes (foodName, someWords, rating)
values ('SomeName', 'SomeWords', 5);
insert into foodTypes (foodName, someWords, rating)
values ('Cake', 'Cake hahahahah', 7);
insert into foodTypes (foodName, someWords, rating)
values ('Cidr', 'Alcoholic...', 2);
insert into foodTypes (foodName, someWords, rating)
values ('non-alcohol beer', 'Non-alcoholic...', 5);

create table MF(
    menuID integer,
    foreign key (menuID) references MENU(menuID),
    foodTypeID integer,
    foreign key (foodTypeID) references  foodTypes(foodTypeID)
);

insert into MF (MENUID, FOODTYPEID)
values (1, 3);
insert into MF (MENUID, FOODTYPEID)
values (11, 2);
insert into MF (MENUID, FOODTYPEID)
values (3, 2);
insert into MF (MENUID, FOODTYPEID)
values (9, 9);
insert into MF (MENUID, FOODTYPEID)
values (9, 4);
insert into MF (MENUID, FOODTYPEID)
values (4, 2);
insert into MF (MENUID, FOODTYPEID)
values (1, 2);
insert into MF (MENUID, FOODTYPEID)
values (8, 7);
insert into MF (MENUID, FOODTYPEID)
values (2, 4);
insert into MF (MENUID, FOODTYPEID)
values (10, 9);
insert into MF (MENUID, FOODTYPEID)
values (7, 7);

-- Продукты
create table products (
    productID integer generated always as identity primary key not null,
    prodName varchar2(16),
    whenDone date,
    expireDate date,
    senderName varchar2(32)
);

insert into products (prodName, whenDone, expireDate, senderName) VALUES ('smtht1', '11/1/20', '11/2/20', 'send1');
insert into products (prodName, whenDone, expireDate, senderName) VALUES ('smtht2', '11/2/20', '11/3/20', 'send2');
insert into products (prodName, whenDone, expireDate, senderName) VALUES ('smtht3', '11/1/20', '11/2/20', 'send3');
insert into products (prodName, whenDone, expireDate, senderName) VALUES ('smtht4', '11/1/20', '11/2/20', 'send4');
insert into products (prodName, whenDone, expireDate, senderName) VALUES ('smtht5', '17/1/20', '17/2/20', 'send5');
insert into products (prodName, whenDone, expireDate, senderName) VALUES ('smtht6', '12/1/20', '11/2/20', 'send1');
insert into products (prodName, whenDone, expireDate, senderName) VALUES ('smtht7', '11/6/19', '11/8/20', 'send3');
insert into products (prodName, whenDone, expireDate, senderName) VALUES ('smtht8', '11/1/20', '11/2/20', 'send1');
insert into products (prodName, whenDone, expireDate, senderName) VALUES ('smtht9', '11/1/20', '11/2/20', 'send8');
insert into products (prodName, whenDone, expireDate, senderName) VALUES ('smtht10', '11/1/20', '11/2/20', 'send2');
insert into products (prodName, whenDone, expireDate, senderName) VALUES ('smtht11', '11/1/20', '11/2/20', 'send3');

create table FP(
    foodTypeID integer,
    foreign key (foodTypeID) references FOODTYPES(foodTypeID),
    productID integer,
    foreign key (productID) references PRODUCTS(productID)
);

insert into FP (foodTypeID, productID) VALUES (1, 1);
insert into FP (foodTypeID, productID) VALUES (2, 2);
insert into FP (foodTypeID, productID) VALUES (3, 3);
insert into FP (foodTypeID, productID) VALUES (3, 1);
insert into FP (foodTypeID, productID) VALUES (5, 5);
insert into FP (foodTypeID, productID) VALUES (2, 3);
insert into FP (foodTypeID, productID) VALUES (7, 3);
insert into FP (foodTypeID, productID) VALUES (8, 8);
insert into FP (foodTypeID, productID) VALUES (9, 9);
insert into FP (foodTypeID, productID) VALUES (10, 10);
insert into FP (foodTypeID, productID) VALUES (11, 11);


-- task 2
-- Select, использующий предикат сравнения с квантором
-- Найдём блюда с рейтингом выше тех с названием на "P"
select foodName, rating
from foodTypes
where rating > all(
    select rating
    from foodTypes
    where foodName like 'P%'
    );

-- Select, использующий агрегатные функции в выражениях столбцов
-- Найдём среднее значение рейтинга по таблице foodTypes, вычисленное двумя сопосбами
select AVG(rating), SUM(rating)/count(*)
from foodTypes;

-- Создание новой временной локальной таблицы из результирующего набора данных иснтрукции select
-- Создадим локальную таблицу с информацией foodname, rating, prodname и somewords из большого джойна
create global temporary table someInfo (
    FOODNAME varchar2(16),
    RATING number,
    PRODNAME varchar2(16),
    SOMEWORDS varchar2(128)
) on commit delete rows;

insert into someInfo (
    select foodName, rating, prodName, someWords
    from foodTypes f join FP on f.foodTypeID = FP.foodTypeID join products p  on FP.productID = p.productID
);

-- task3
-- Создать зранимую процедуру, которая, не уничтожая базу данных, уничтожает все те таблицы текущей базы данных,
-- имена которых начинаются с фразы 'TableName'
-- Ремарка - в оракле везде апперкейс, поэтому используем TABLENAME
create or replace procedure deleteTableStartsWithTableName
is
    cursor curTable is select * from USER_TABLES where TABLE_NAME like 'TABLENAME%';
begin
    for i in curTable
    loop
        execute immediate 'DROP TABLE ' || i.TABLE_NAME;
    end loop;
end;

-- тестирование
create table TableName(
    smth int
);
create table TableName2(
    smth int
);

select *
from USER_TABLES
where TABLE_NAME LIKE 'TABLENAME%';

begin
    deleteTableStartsWithTableName();
end;

select *
from USER_TABLES
where TABLE_NAME LIKE 'TABLENAME%';