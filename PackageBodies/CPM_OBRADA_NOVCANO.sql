CREATE OR REPLACE PACKAGE BODY                    CPM_OBRADA_NOVCANO AS
/******************************************************************************
   NAME:       CPM_OBRADA_NOVCANO
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        6.11.2012      nevena.curcic       1. Created this package body.
******************************************************************************/

  FUNCTION MyFunction(Param1 IN NUMBER) RETURN NUMBER IS
  BEGIN
    RETURN Param1;
  END;

  PROCEDURE MyProcedure(Param1 IN NUMBER) IS
    TmpVar NUMBER;
  BEGIN
    TmpVar := Param1;
  END;

 PROCEDURE CPM_OBRADA_PREGLED
 
      (  P_ID_RJ IN VARCHAR2,
          P_ID_CPM IN CPM_OBRADA.ID_CPM%TYPE,
          P_DATUM_OD IN CPM_OBRADA.DATUM%TYPE,
          P_DATUM_DO IN CPM_OBRADA.DATUM%TYPE, 
          P_CURSOR OUT T_CURSOR
      )
   IS
    
BEGIN
   OPEN P_CURSOR FOR
      SELECT O.OBRADA_BANKE,
             O.OBRADA_KOMITENTI,
             O.OBRADA_NALOG_PP,
             O.ID_CPM,
             O.DATUM,
             O.KREIRANJE_PRIJAVA_BANKA,
             O.KREIRANJE_PRIJAVA_KOMITENT,
             O.OBRADA_PRIJAVA,
             O.OBRADA_DNEVNIKA,
             O.FAJL_DN,
             O.FAJL_LOK_KOMITENT_DN,
             O.OBRADA_BLAGAJNE,
             OC.ID_ORGANIZACIONA_CELINA AS idOC,
             RAWTOHEX (O.ID_CPM_DAN) AS CPM_DAN,
             OC.NAZIV
        FROM CPM_OBRADA O,
             CVOR_POSTANSKE_MREZE cpm,
             ORGANIZACIONA_CELINA oc,
             ORGANIZACIONA_CELINA rj
       WHERE     O.ID_CPM = cpm.id_cvor_postanske_mreze
             AND (oc.id_organizaciona_celina = P_ID_CPM OR P_ID_CPM = 0)
             AND DATUM BETWEEN P_DATUM_OD AND P_DATUM_DO
             AND cpm.id_organizaciona_celina = oc.id_organizaciona_celina
             AND cpm.id_vrsta_cvora_pm IN (1, 3, 12)
             AND rj.id_organizaciona_celina =
                    (    SELECT id_organizaciona_celina
                           FROM ORGANIZACIONA_CELINA
                          WHERE id_vrsta_oc = 5
                     START WITH id_organizaciona_celina = cpm.id_organizaciona_celina
                     CONNECT BY PRIOR id_nadredjena_oc = id_organizaciona_celina)
             AND rj.id_organizaciona_celina LIKE P_ID_RJ
        ORDER BY O.DATUM, OC.NAZIV;
END CPM_OBRADA_PREGLED;

END CPM_OBRADA_NOVCANO;
/

SHOW ERRORS;


