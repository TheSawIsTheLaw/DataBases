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
insert into arrLea(employeeID, dayCome, weekDay, timeCome, inOut) values (3, TO_DATE('14-12-2018'), 'Суббота', TO_TIMESTAMP('10:30', 'HH:MI'), 1);
insert into arrLea(employeeID, dayCome, weekDay, timeCome, inOut) values (3, TO_DATE('26-12-2020'), 'Суббота', TO_TIMESTAMP('10:30', 'HH:MI'), 1);
insert into arrLea(employeeID, dayCome, weekDay, timeCome, inOut) values (1, TO_DATE('14-12-2018'), 'Суббота', TO_TIMESTAMP('09:20', 'HH:MI'), 2);
insert into arrLea(employeeID, dayCome, weekDay, timeCome, inOut) values (1, TO_DATE('14-12-2018'), 'Суббота', TO_TIMESTAMP('09:25', 'HH:MI'), 1);
insert into arrLea(employeeID, dayCome, weekDay, timeCome, inOut) values (2, TO_DATE('14-12-2018'), 'Суббота', TO_TIMESTAMP('09:05', 'HH:MI'), 1);

select * from employees join arrLea aL on employees.employeeID = aL.employeeID;
-- drop type lateTable;
create or replace type rowEmployeesLate is object (
    lateMinutes integer,
    amountOfEmployees integer
);

create or replace type lateTable is table of rowEmployeesLate;

create or replace function getLateTableAt(day in date)
return lateTable as retTable lateTable;
    begin
        select rowEmployeesLate(late, cnt)
        bulk collect into retTable
        from (
              select extract(minute from time - TO_TIMESTAMP('09:00', 'HH:MI')) + extract(hour from time - TO_TIMESTAMP('09:00', 'HH:MI')) * 60 as late, count(time) as cnt
            from (
                select min(timeCome) as time
                from arrLea
                where dayCome = day
                    and employeeID not in (select employeeID
                                  from arrLea
                                  where timeCome <= TO_TIMESTAMP('09:00', 'HH:MI') and dayCome = day)
                group by employeeID
            )
            group by time
            );

        return retTable;
    end;

select * from getLateTableAt(TO_DATE('14-12-2018'));

select department
from employees
where department not in (
    select department
    from employees
    where floor(months_between(current_date, birthday) / 12) < 25
    );

select distinct employeeID
from arrLea
where timeCome in (
    select min(timeCome)
    from arrLea
    where extract(year from dayCome) = extract(year from current_date)
      and extract(month from dayCome) = extract(month from current_date)
      and extract(day from dayCome) = extract(day from current_date)
      and inOut = 1
    );


select employeeID
from (
    select employeeID, min(timeCome) mTime
    from arrLea
    where inOut = 1
    group by employeeID, dayCome
    )
where mTime > TO_DATE('09:00', 'hh:mi')
group by employeeID
having count(employeeID) > 5;
select * from arrLea;

select employeeID, min(timeCome) mTime
    from arrLea
    where inOut = 1
    group by employeeID, dayCome

--     group by employeeID, dayCome