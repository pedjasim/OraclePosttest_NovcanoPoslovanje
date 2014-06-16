CREATE OR REPLACE PACKAGE                    NBS AS

TYPE T_CURSOR IS REF CURSOR;

PROCEDURE PODACI_ZA_NBS (P_DATUM_OD   IN  DATE,
                                             P_DATUM_DO   IN  DATE,
                                             P_REZULTAT OUT NUMBER,
                                             P_CURSOR OUT T_CURSOR); 
                                             
END NBS;
/

SHOW ERRORS;


