-- Это НЕ агрегатная функция :)
create or replace function customMax(tableName in varchar2, columnName in varchar2)
return number
as
    language java name 'Facade.customMax(java.lang.String, java.lang.String) return int';

call DBMS_JAVA.set_output(2000);

-- select customMax('LOANSUBJECTS', 'DEBT') from LOANSUBJECTS;
call DBMS_OUTPUT.PUT_LINE(customMax('LOANSUBJECTS', 'DEBT'));

select max(DEBT) from LOANSUBJECTS;

-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
-- @@@@@@@@@@@@@@@@@@@@@@@@    *     @@@@@@@ @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
-- @@@@@@@@@@@@@@@@@@. @@@@@@@@@@@@@@@@@@# @@@  @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
-- @@@@@@@@@@@@@@@& @@@@@@@@@@@@@@@@@@@@@@@@@@&   @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
-- @@@@@@@@@@@@@*&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@   @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
-- @@@@@@@@@@@&,@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ @ @@@@@@@@@      &@@@@@@@@@@@@@
-- @@@@@@@@@@ @@@@@ @@@@,,@@@@@@@@@@@@@@@@@/  @@@@@@ @@@@@@@@( @@@@@@@@ @@@@@@@@@@@
-- @@@@@@. %@@@@ @@@@@@@@@@ @@@@@@@@@@@ @@@@@@@@.@@@@@ @@@@@@ @#@@@@@@@@ @@@@@@@@@@
-- @@@@@@ @@@@*@@@@@@@  /@@@@ @@@@@@@ @@& , @@@@@ @@@@@ #@@@@@@@ @@@@@@@@ @@@@@@@@@
-- @@@@@*@@@@@ @@@@@@    @@@@@@@@@@@ @@@%   @@@@@@ @@@@@  @@@@@@@ @@@@@@@@ @@@@@@@@
-- @@@ @.@@@@@@@@@@@@@@@@@@@@*@@@@@ @@@@@@@@@@@@@*@@@@@@@ @&@@@@@ @@@@@@@@.@@@@@@@@
-- @@@ @/@@@@@@@ @@@@@@@@@,*@@@@@@@@@ ,@@@@@@@@ @@@@@@@@@@ %@@@@@&@@@@@@@@.@@@@@@@@
-- @@@  @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ @@@@@,@@@@@@@@ @@@@@@@@
-- @@@,*@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ %@#  @@@@@@@@@@@@@@@@@@
-- @@@  @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@  @@@@@@@@/  @@@@@@@@@@ @@@@@@@@@@
-- @@@  @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ @@@@@@@@@@ @@@@@@@@@@@@@@@@ @@@@@
-- @@@(@(@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#@@@@@@@@@@@ @@@@@@@@@@@@@@@(@ @@@@
-- @@@@,&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ @@@@@@@@@@@ @@@@@@@@@@@@@@@@@&@@@@
-- @@@@ @ @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ @@@@@@@@@@@@ @@@@@@@@@@    @@@@@@@@
-- @@@@@ @ @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ @@@@@@@@@@@@@ @@@@@@@@@@@@@@ %&%@@@@
-- @@@@@@@ @@@@@@@@@@@  @@@@@@@@@@@@@@@@@@@ &@@@@@@@@@@@@@@ @@@@@@@@@@@ @@@@@@ @@@@
-- @@@@@@@@ @@@@@@@@@@@@@@  @@@@@@@@@@# /@@@@@@@@@@@@@@@@@@ @@@@@@@@@@@@@@@@@ @@@@@
-- @@@@@@@@ @/(@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ @@@@@@@@@@@@@@@@@,%@@@@@
-- @@@@@@@@@&@@@* @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ @@@@@@@@ @@@@  .&&(  @@@@


-- Я пытался. Честно, пытался. Но ничего не выходит. 4,5 часа впустую.

create or replace
PACKAGE JAggrFunPackage authid current_user AS
  FUNCTION ODCIInitialize(
                  ctx OUT NOCOPY NUMBER
                  ) RETURN NUMBER
                  AS LANGUAGE JAVA
    NAME 'Facade.ODCIInitialize(
              java.math.BigDecimal[]) return java.math.BigDecimal';

  FUNCTION ODCIIterate(
                  ctx IN NUMBER,
                  str VARCHAR2) RETURN NUMBER
                  AS LANGUAGE JAVA
    NAME 'Facade.ODCIIterate(
              java.math.BigDecimal,
              java.lang.String) return java.math.BigDecimal';

  FUNCTION ODCITerminate(
                  ctx IN NUMBER,
                  str OUT VARCHAR2) RETURN NUMBER
                  AS LANGUAGE JAVA
    NAME 'Facade.ODCITerminate(
              java.math.BigDecimal,
              java.lang.String[]) return java.math.BigDecimal';

END JAggrFunPackage;

CREATE OR REPLACE
TYPE JAggrFunPackageType AS OBJECT
  (
   jctx NUMBER, -- stored context;  not used in dummy implementation
   STATIC FUNCTION
        ODCIAggregateInitialize(sctx IN OUT JAggrFunPackageType )
        RETURN NUMBER,

   MEMBER FUNCTION
        ODCIAggregateIterate(self IN OUT JAggrFunPackageType,
                             VALUE IN VARCHAR2 )
        RETURN NUMBER,

   MEMBER FUNCTION
        ODCIAggregateTerminate(self IN JAggrFunPackageType,
                               returnValue OUT VARCHAR2,
                               flags IN NUMBER)
        RETURN NUMBER,

   MEMBER FUNCTION
        ODCIAggregateMerge(self IN OUT NOCOPY JAggrFunPackageType,
                           ctx IN JAggrFunPackageType)
        RETURN NUMBER
);

create or replace
type body JAggrFunPackageType  is
  static function ODCIAggregateInitialize(sctx IN OUT NOCOPY JAggrFunPackageType)
  return number
  is
  begin
    sctx := JAggrFunPackageType( null );
    return ODCIConst.Success;
  end;

  member function ODCIAggregateIterate(self IN OUT NOCOPY JAggrFunPackageType,
                                       value IN varchar2 )
  return number
  is
     status  NUMBER;
  begin
    if self.jctx is null then

      status := JAggrFunPackage.ODCIInitialize(self.jctx);
      if (status <> ODCIConst.Success) then
         return status;
      end if;
    end if;

    status := JAggrFunPackage.ODCIIterate(jctx,value);

    return status;
  end;

  member function ODCIAggregateTerminate(self IN JAggrFunPackageType,
                                         returnValue OUT NOCOPY VARCHAR2,
                                         flags IN number)
  return number
  is
  begin

    return JAggrFunPackage.ODCITerminate(jctx, returnValue);
  end;

  member function  ODCIAggregateMerge(self IN OUT NOCOPY JAggrFunPackageType,
                           ctx IN JAggrFunPackageType)
  return number
  is
  begin
    return ODCIConst.Success;
  end;
end;

CREATE OR REPLACE
FUNCTION JAggr(input VARCHAR2)
RETURN VARCHAR2
AGGREGATE USING JAggrFunPackageType;

select JAggr(DUMMY) from dual;