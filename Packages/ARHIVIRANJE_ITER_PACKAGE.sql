CREATE OR REPLACE PACKAGE                    ARHIVIRANJE_ITER_PACKAGE AS

PROCEDURE ARHIVIRAJ_U_ITERACIJAMA;

PROCEDURE UPIS_U_LOG (P_VRSTA_PORUKE     IN VARCHAR2,
                                       P_PORUKA   IN VARCHAR2,
                                       P_ITERACIJA IN NUMBER);

END ARHIVIRANJE_ITER_PACKAGE;
/

SHOW ERRORS;


