CREATE OR REPLACE PACKAGE                    TEST_PACKAGE
AS
   TYPE T_CURSOR IS REF CURSOR;

  PROCEDURE INSERT_TEST_OA (P_OPIS     IN VARCHAR2,
                                                P_OPIS_I   IN VARCHAR2);

   PROCEDURE INSERT_TEST (P_PODACI   IN  CLOB,
                                            P_REZULTAT OUT NUMBER,
                                            P_PORUKA OUT VARCHAR2);
   
     PROCEDURE INSERT_TEST_STANDARDNO (P_OPIS     IN TEST.OPIS%TYPE,
                                                                    P_OPIS_I   IN TEST.OPIS_I%TYPE,
                                                                    P_REZULTAT OUT NUMBER,
                                                                    P_PORUKA OUT VARCHAR2);
   END TEST_PACKAGE;
/

SHOW ERRORS;


