-- Выгружаем битлджуса из таблички
-- Создадим некое подобие телефонной книги

select JSON_OBJECT('FName' is FIRSTNAME, 'SName' is LASTNAME, 'Telephone' is TELEPHONENUM) from DEBTORS;

-- Также можно дампнуть через поле Services, либо использовать Execute to File по правой кнопке мыши
select FIRSTNAME, LASTNAME, TELEPHONENUM from DEBTORS;

-- Если бы мы использовали sql*plus, то получили бы вот такое чудо. Но оно бы не работало, там просто всё будет в файл
-- с расширением залетать. Можно было бы вообще это всё с помощью JSON_OBJECT форматировать, выводя это всё в
-- дбмс аутпут...
-- Возможностей много, но намного проще использовать Services)))0
spool 'C:\Users\dobri\Desktop\DataBases\result.json';
select FIRSTNAME, LASTNAME, TELEPHONENUM from DEBTORS;
spool off;