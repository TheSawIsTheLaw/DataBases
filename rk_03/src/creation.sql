-- Вариант 3

create table employees (
    employeeID integer generated always as identity primary key not null,
    FIO varchar2(128),
    birthday date,
    department varchar2(32)
);

create table arrLea (
    employeeID integer not null,
    foreign key (employeeID) references employees(employeeID),
    dayCome date,
    weekDay varchar2(32),
    timeCome date,
    inOut integer
);

insert into employees(fio, birthday, department) values ('Иванов Иван Иванович', TO_DATE('25-09-1990'), 'ИТ');
insert into employees(fio, birthday, department) values ('Петров Петр Петрович', TO_DATE('30-12-1987'), 'Бухгалтерия');
insert into employees(fio, birthday, department) values ('Пересторонин Павел Геннадьевич', TO_DATE('01-01-2000'), 'ИТ');

insert into arrLea(employeeID, dayCome, weekDay, timeCome, inOut) values (1, TO_DATE('14-12-2018'), 'Суббота', TO_TIMESTAMP('09:00', 'HH24:MI'), 1);
insert into arrLea(employeeID, dayCome, weekDay, timeCome, inOut) values (3, TO_DATE('30-12-2018'), 'Суббота', TO_TIMESTAMP('12:30', 'HH24:MI'), 2);
insert into arrLea(employeeID, dayCome, weekDay, timeCome, inOut) values (3, TO_DATE('26-12-2020'), 'Суббота', TO_TIMESTAMP('10:30', 'HH24:MI'), 1);
insert into arrLea(employeeID, dayCome, weekDay, timeCome, inOut) values (3, TO_DATE('28-12-2020'), 'Суббота', TO_TIMESTAMP('10:30', 'HH24:MI'), 1);
insert into arrLea(employeeID, dayCome, weekDay, timeCome, inOut) values (1, TO_DATE('17-12-2018'), 'Суббота', TO_TIMESTAMP('09:20', 'HH24:MI'), 2);
insert into arrLea(employeeID, dayCome, weekDay, timeCome, inOut) values (1, TO_DATE('12-12-2018'), 'Суббота', TO_TIMESTAMP('09:20', 'HH24:MI'), 1);
insert into arrLea(employeeID, dayCome, weekDay, timeCome, inOut) values (1, TO_DATE('28-12-2020'), 'Суббота', TO_TIMESTAMP('09:35', 'HH24:MI'), 1);
insert into arrLea(employeeID, dayCome, weekDay, timeCome, inOut) values (2, TO_DATE('27-12-2020'), 'Суббота', TO_TIMESTAMP('09:05', 'HH24:MI'), 1);
insert into arrLea(employeeID, dayCome, weekDay, timeCome, inOut) values (2, TO_DATE('28-12-2020'), 'Суббота', TO_TIMESTAMP('09:05', 'HH24:MI'), 1);

-- Скалярная функция, возвращающая минимальный возраст сотрудника, опоздавшего более чем на 10 минут
-- Предположим, что нам дают день, в который мы хотим это узнать
-- Считаем, что рабочий день начинается в 9:00 и берём только первый приход (минимум по времени)
create or replace function getMinLateAge(today date)
return integer
is
    retAge integer;
begin
    select floor(months_between(current_date, max(birthday)) / 12)
    into retAge
    from (
        select birthday, min(timeCome) as come
        from arrLea join employees e on arrLea.employeeID = e.employeeID
        where inOut = 1  -- Ну он мог отсюда ночью уехать, а потом опять приехать работать
          and extract(year from today) = extract(year from dayCome)
          and extract(month from today) = extract(month from dayCome)
          and extract(day from today) = extract(day from dayCome)
        group by arrLea.employeeID, dayCome, birthday
     )
     where extract(minute from cast(come as timestamp)) + extract(hour from cast(come as timestamp)) * 60 - 60 * 9 > 10;

    return retAge;
end;

begin
    DBMS_OUTPUT.PUT_LINE(getMinLateAge(current_date));
end;

-- Проверка
select * from arrLea;
select * from arrLea join employees e on arrLea.employeeID = e.employeeID where dayCome = TO_DATE('28-12-2020');

-- Найти самого старшего сотрудника в бухгалтерии
-- Получится найти не одного, а всех старших сотрудников. Можно сказать, что план перевыполнен.
select *
from employees
where birthday = (
        select min(birthday)
        from employees
        where department = 'Бухгалтерия'
    )
and department = 'Бухгалтерия';

-- Найти сотрудников, выходивших больше 3-х раз с рабочего места
-- Так как не говорится, в какой день или кто и как, просто посчитаем выходы людей...
select employeeID
from arrLea
where inOut = 2
group by employeeID
having count(employeeID) > 3;

-- Найти сотрудника, который пришёл сегодня последним
-- Я бы мог искать приходы по самому первому приходу, как делал это в скалярной функции, но в задании не обозначено,
-- поэтому сделал в лоб
with
     todayTable as (
         select *
         from arrLea
         where inOut = 1
           and extract(year from dayCome) = extract(year from current_date)
           and extract(month from dayCome) = extract(month from current_date)
           and extract(day from dayCome) = extract(day from current_date)
     )
select employeeID, timeCome
from todayTable
where timeCome = (select max(timeCome) from todayTable);

