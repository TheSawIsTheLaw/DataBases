-- Вариант 1

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
insert into arrLea(employeeID, dayCome, weekDay, timeCome, inOut) values (1, TO_DATE('14-12-2018'), 'Суббота', TO_TIMESTAMP('09:25', 'HH:MI'), 1);
insert into arrLea(employeeID, dayCome, weekDay, timeCome, inOut) values (2, TO_DATE('14-12-2018'), 'Суббота', TO_TIMESTAMP('09:05', 'HH:MI'), 1);

create or replace function getLateInRange
    return integer
is
    retCount integer;
begin
    select count(outs)
    into retCount
    from (
        select e.employeeID, count(e.employeeID) as outs
        from arrLea join employees e on arrLea.employeeID = e.employeeID
        where inOut = 2 and floor(months_between(current_date, birthday) / 12) between 18 and 40
        group by e.employeeID
         )
    where outs > 3;
    return retCount;
end;

begin
    DBMS_OUTPUT.PUT_LINE(getLateInRange());
end;

select department from employees
having count(employeeID) > 10
group by department;

-- Пусть конец рабочего дня в 12:00))
select distinct employeeID
from arrLea
where employeeID not in (
    select employeeID from arrLea
    where inOut = 2 and timeCome < TO_DATE('12:00', 'hh:mi')
    );

select * from employees join arrLea aL on employees.employeeID = aL.employeeID
where dayCome = TO_DATE('14-12-2018');

select distinct department
from (
     select department, aL.employeeID, min(timeCome) come
    from employees join arrLea aL on employees.employeeID = aL.employeeID
    where dayCome = TO_DATE('14-12-2018')
    and inOut = 1
    group by aL.employeeID, department
         )
where come > TO_DATE('09:00', 'hh24:mi');