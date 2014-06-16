CREATE OR REPLACE PACKAGE                    CPM_OBRADA_NOVCANO AS
/******************************************************************************
   NAME:       CPM_OBRADA_NOVCANO
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        6.11.2012      nevena.curcic       1. Created this package.
******************************************************************************/

  FUNCTION MyFunction(Param1 IN NUMBER) RETURN NUMBER;
  PROCEDURE MyProcedure(Param1 IN NUMBER);
  TYPE T_CURSOR IS REF CURSOR;
  
 PROCEDURE CPM_OBRADA_PREGLED
      (     
          P_ID_RJ IN VARCHAR2,         
          P_ID_CPM IN CPM_OBRADA.ID_CPM%TYPE,
          P_DATUM_OD IN CPM_OBRADA.DATUM%TYPE,
          P_DATUM_DO IN CPM_OBRADA.DATUM%TYPE, 
          P_CURSOR OUT T_CURSOR
      ); 
END CPM_OBRADA_NOVCANO;
/

SHOW ERRORS;


