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
insert into arrLea(employeeID, dayCome, weekDay, timeCome, inOut) values (2, TO_DATE('27-12-2020'), 'Суббота', TO_TIMESTAMP('09:05', 'HH:MI'), 1);

create or replace function getMinLateAge
return integer
is
    retAge integer;
begin
    select floor(months_between(current_date, max(birthday)) / 12)
    into retAge
    from (
     select birthday, min(timeCome) as come
     from arrLea join employees e on arrLea.employeeID = e.employeeID
     group by arrLea.employeeID, dayCome, birthday
         )
    where extract(minute from come) + extract(hour from come) * 60 - 60 * 9 > 10;

    return retAge;
end;

begin
    DBMS_OUTPUT.PUT_LINE(getMinLateAge());
end;

select *
from employees
where birthday = (select min(birthday) from employees where department = 'Бухгалтерия')

select employeeID
from arrLea
where inOut = 2
group by employeeID
having count(inOut) > 3;

select employeeID, tc
from (
     select employeeID, max(timeCome) tc
    from arrLea
    where inOut = 1 and extract(day from dayCome) = extract(day from current_date)
    and extract(month from dayCome) = extract(month from current_date)
    and extract(year from dayCome) = extract(year from current_date)
    group by employeeID
);

select employeeID, timeCome
from arrLea
where inOut = 1 and extract(day from dayCome) = extract(day from current_date)
    and extract(month from dayCome) = extract(month from current_date)
    and extract(year from dayCome) = extract(year from current_date)
    and timeCome = (select max(timeCome) from arrLea where inOut = 1 and extract(day from dayCome) = extract(day from current_date)
                                                                     and extract(month from dayCome) = extract(month from current_date)
                                                                     and extract(year from dayCome) = extract(year from current_date));