create or replace type hangmansOnLevel is object(
    CHIEFID number,
    POSITIONINHIERARCHY varchar2(10),
    HANGMANID number,
    LVL number
                                                );

create or replace type tableOfHangmansOnLevel is table of hangmansOnLevel;
drop type tableOfHangmansOnLevel;

create or replace function getAllHangmansOnLevel(level number)
return tableOfHangmansOnLevel is retTable tableOfHangmansOnLevel;
begin
    with recurs(CHIEFID, POSITION, HANGMANID, LVL)
    as (
        select CHIEFID, POSITION, HANGMANID, 0 as LVL
        from HANGMAN
        where CHIEFID is null
        union all
        select fTable.CHIEFID, fTable.POSITION, fTable.HANGMANID, sTable.LVL + 1
        from HANGMAN fTable join recurs sTable on fTable.CHIEFID = sTable.HANGMANID
    )
    select hangmansOnLevel(recurs.CHIEFID, recurs.POSITION, recurs.HANGMANID, recurs.LVL)
    bulk collect into retTable
    from recurs
    where recurs.LVL = level;

    return retTable;
end;

select *
from getAllHangmansOnLevel(0);