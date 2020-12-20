-- Вариант 2

create table employees(
    employeeID integer generated always as identity primary key not null,
    FIO varchar2 (128),
    birthday date,
    department varchar2 (32)
);

create table arrLea(
    employeeID integer not null,
    foreign key (employeeID) references employees(employeeID),
    dayCome varchar2(32) not null, -- моя орм не поддерживает типы date со временем :) Я плакал.
    weekDay varchar(32),
    timeCome varchar2(32) not null,
    inOut integer
);

select * from employees;
insert into employees (FIO, birthday, department) values ('Иванов Иван Иванович', '25-09-1990', 'ИТ');
insert into employees (FIO, birthday, department) values ('Петров Петр Петрович', '12-11-1987', 'Бухгалтерия');
insert into employees (FIO, birthday, department) values ('Якуба Дмитрий Васильевич', '11-09-2000', 'ИТ');
insert into employees (FIO, birthday, department) values ('Пересторонин Павел Алексеевич', '13-09-2000', 'Костоломня');


select * from arrLea;
insert into arrLea (employeeID, dayCome, weekDay, timeCome, inOut) values (1, '14-12-2018', 'Суббота', '09:00:00', 1);
insert into arrLea (employeeID, dayCome, weekDay, timeCome, inOut) values (1, '14-12-2018', 'Суббота', '09:20:00', 2);
insert into arrLea (employeeID, dayCome, weekDay, timeCome, inOut) values (1, '14-12-2018', 'Суббота', '09:25:00', 1);
insert into arrLea (employeeID, dayCome, weekDay, timeCome, inOut) values (2, '14-12-2018', 'Суббота', '09:05:00', 1);
