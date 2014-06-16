CREATE OR REPLACE PACKAGE ZP_PACKAGE AS
/******************************************************************************
   NAME:       ZP_PACKAGE
   PURPOSE: ZASTUPNI�KE PROVIZIJE ZA UGOVORNE PO�TE I �ALTERE
   
******************************************************************************/
  TYPE T_CURSOR IS  REF CURSOR;
  
  PROCEDURE UGOVORNI_SALTER(P_ID_CPM_DAN  IN   TRANSAKCIJA_BANKA.ID_CPM_DAN%TYPE,                                       
                                                   P_CURSOR     OUT T_CURSOR);
                                                   
  PROCEDURE UGOVORNA_POSTA(P_ID_CPM_DAN  IN   TRANSAKCIJA_BANKA.ID_CPM_DAN%TYPE,                                       
                                                  P_CURSOR   OUT T_CURSOR);

END ZP_PACKAGE;
/

SHOW ERRORS;


