CREATE OR REPLACE PACKAGE                    NOVCANE_TRANSAKCIJE IS

  TYPE T_CURSOR IS REF CURSOR;

PROCEDURE PREGLED_ZA_BANKE      (
                                  P_ID_CPM_DAN  IN TRANSAKCIJA_BANKA.ID_CPM_DAN%TYPE,                          
                                  P_CURSOR   OUT T_CURSOR);
                               
PROCEDURE PREGLED_ZA_KOMITENTE  (
                                  P_ID_CPM_DAN  IN TRANSAKCIJA_KOMITENT.ID_CPM_DAN%TYPE,   
                                  P_CURSOR   OUT T_CURSOR);  
  
PROCEDURE PREGLED_ZA_NALOGE_PP  (
                                  P_ID_CPM_DAN  IN TRANSAKCIJA_NALOG_PP.ID_CPM_DAN%TYPE,   
                                  P_CURSOR   OUT T_CURSOR);                                                            

END NOVCANE_TRANSAKCIJE;
/

SHOW ERRORS;


