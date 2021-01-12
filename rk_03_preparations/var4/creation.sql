-- Вариант 3

begin
    DROPTABLEIFEXIST('arrLea');
    DROPTABLEIFEXIST('employees');
end;

create table employees(
    employeeID integer generated always as identity primary key not null,
    FIO varchar2 (128),
    birthday date,
    department varchar2 (32)
);

create table arrLea(
    employeeID integer not null,
    foreign key (employeeID) references employees(employeeID),
    dayCome date,
    weekDay varchar(32),
    timeCome timestamp,
    inOut integer
);

insert into employees(fio, birthday, department) values ('Иванов Иван Иванович', TO_DATE('25-09-1990'), 'ИТ');
insert into employees(fio, birthday, department) values ('Петров Петр Петрович', TO_DATE('12-11-1987'), 'Бухгалтерия');
insert into employees(fio, birthday, department) values ('Пересторонин Павел Геннадьевич', TO_DATE('01-01-2000'), 'ИТ');

insert into arrLea(employeeID, dayCome, weekDay, timeCome, inOut) values (1, TO_DATE('14-12-2018'), 'Суббота', TO_TIMESTAMP('09:00', 'HH:MI'), 1);
insert into arrLea(employeeID, dayCome, weekDay, timeCome, inOut) values (3, TO_DATE('30-12-2018'), 'Суббота', TO_TIMESTAMP('12:30', 'HH:MI'), 2);
insert into arrLea(employeeID, dayCome, weekDay, timeCome, inOut) values (3, TO_DATE('26-12-2020'), 'Суббота', TO_TIMESTAMP('10:30', 'HH:MI'), 1);
insert into arrLea(employeeID, dayCome, weekDay, timeCome, inOut) values (1, TO_DATE('14-12-2018'), 'Суббота', TO_TIMESTAMP('09:20', 'HH:MI'), 2);
insert into arrLea(employeeID, dayCome, weekDay, timeCome, inOut) values (1, TO_DATE('12-12-2018'), 'Суббота', TO_TIMESTAMP('09:20', 'HH:MI'), 1);
insert into arrLea(employeeID, dayCome, weekDay, timeCome, inOut) values (1, TO_DATE('27-12-2020'), 'Суббота', TO_TIMESTAMP('09:35', 'HH:MI'), 1);
insert into arrLea(employeeID, dayCome, weekDay, timeCome, inOut) values (2, TO_DATE('27-12-2020'), 'Суббота', TO_TIMESTAMP('09:04', 'HH:MI'), 1);

create or replace type notComeToday is object
(
    FIO varchar2(64),
    department varchar2(64)
);

select * from arrLea;

create or replace type notComeTable is table of notComeToday;

create or replace function whoNotCome(today date)
return notComeTable as retTable notComeTable;
begin
    select notComeToday(FIO, department)
    bulk collect into retTable
    from employees
    where employeeID not in (
    select employeeID
    from arrLea
    where dayCome = today
    );

    return retTable;
end;

select * from whoNotCome(TO_DATE('29-12-2018'));

-- Так как человек мог придти в 8, в 9 выйти покурить, а потом придти через три минуты)) Это не опоздание.
select *
from (
     select employeeID, min(timeCome) tc
    from arrLea
    where extract(year from dayCome) = extract(year from current_date)
    and extract(month from dayCome) = extract(month from current_date)
    and extract(day from dayCome) = extract(day from current_date)
    and inOut = 1
    group by employeeID
         )
where tc between TO_DATE('09:00', 'hh24:mi') and TO_DATE('09:05', 'hh24:mi');

-- Второе - это вообще фашизм


select *
from arrLea join employees e on arrLea.employeeID = e.employeeID
where department = 'Бухгалтерия'
and timeCome < TO_DATE('08:00', 'hh24:mi')
and inOut = 1;
