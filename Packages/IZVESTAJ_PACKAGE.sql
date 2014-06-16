CREATE OR REPLACE PACKAGE                    IZVESTAJ_PACKAGE AS

TYPE T_CURSOR IS REF CURSOR;

PROCEDURE INSERT_IZV_NALOZI   (P_ID_CPM_DAN IN VARCHAR2,
                                                    P_ID_TRANSAKCIJA IN VARCHAR2,
                                                    P_SIFRA_TRN IN NUMBER,
                                                    P_NAZIV_TRN IN VARCHAR2,
                                                    P_POSTANSKI_BROJ IN VARCHAR2,
                                                    P_DATUM_OBRACUNSKI IN DATE DEFAULT NULL,
                                                    P_DATUM_UPLATE  IN DATE,
                                                    P_SIFRA_RADNIKA IN VARCHAR2,
                                                    P_RBR_TRANSAKCIJE  IN NUMBER,
                                                    P_IZNOS IN NUMBER,
                                                    P_TEKUCI_RACUN IN VARCHAR2,
                                                    P_POZIV_NA_BROJ IN VARCHAR2,
                                                    P_SIFRA_PLACANJA IN VARCHAR2,
                                                    P_MODEL IN VARCHAR2,
                                                    P_UPLATILAC_I IN VARCHAR2,
                                                    P_UPLATILAC_II IN VARCHAR2,
                                                    P_UPLATILAC_III IN VARCHAR2,
                                                    P_SVRHA_UPLATE_I IN VARCHAR2,
                                                    P_SVRHA_UPLATE_II IN VARCHAR2,
                                                    P_SVRHA_UPLATE_III IN VARCHAR2,
                                                    P_PRIMALAC_I IN VARCHAR2,
                                                    P_PRIMALAC_II IN VARCHAR2,
                                                    P_PRIMALAC_III IN VARCHAR2,
                                                    P_RJ IN VARCHAR2,
                                                    P_ID_IZVOR_PODATAKA  IN NUMBER,
                                                    P_DATUM_PUNJENJA  IN DATE,                                                  
                                                    P_PORUKA OUT VARCHAR2,
                                                    P_REZULTAT OUT NUMBER); 

PROCEDURE INSERT_IZV_SO_TRN (P_ID_CPM_DAN IN VARCHAR2,
                                                    P_ID_TRANSAKCIJA IN VARCHAR2,
                                                    P_RJ IN VARCHAR2,
                                                    P_POSTANSKI_BROJ IN VARCHAR2,
                                                    P_DATUM_OBRACUNSKI IN DATE DEFAULT NULL,
                                                    P_DATUM_TRANSAKCIJE  IN DATE,
                                                    P_DATUM_SO  IN DATE,
                                                    P_SIFRA_TRN IN NUMBER,
                                                    P_NAZIV_TRN IN VARCHAR2 DEFAULT NULL,
                                                    P_SIFRA_RADNIKA IN VARCHAR2,
                                                    P_RBR_TRANSAKCIJE  IN NUMBER,
                                                    P_IZNOS IN NUMBER,
                                                    P_POSTARINA IN NUMBER,
                                                    P_OPIS_I IN VARCHAR2,
                                                    P_OPIS_II IN VARCHAR2,
                                                    P_OPIS_III IN VARCHAR2,
                                                    P_RAZLOG_SO IN VARCHAR2,
                                                    P_BROJ_S_O_TRANSAKCIJE IN VARCHAR2,
                                                    P_DATUM_NOVE_TRN  IN DATE,
                                                    P_SIFRA_NOVE_TRN IN NUMBER,
                                                    P_SIFRA_RADNIKA_NOVE_TRN IN VARCHAR2,
                                                    P_RBR_NOVE_TRN  IN NUMBER,
                                                    P_IZNOS_NOVE_TRN IN NUMBER,
                                                    P_POSTARINA_NOVE_TRN IN NUMBER,
                                                    P_OPIS_I_NOVE_TRN IN VARCHAR2,
                                                    P_OPIS_II_NOVE_TRN IN VARCHAR2,
                                                    P_OPIS_III_NOVE_TRN IN VARCHAR2,    
                                                    P_STATUS IN VARCHAR2,                               
                                                    P_ID_IZVOR_PODATAKA  IN NUMBER,
                                                    P_DATUM_PUNJENJA  IN DATE,                                                       
                                                    P_PORUKA OUT VARCHAR2,
                                                    P_REZULTAT OUT NUMBER); 

PROCEDURE INSERT_IZV_PAZARI   (P_ID_CPM_DAN IN VARCHAR2,
                                                    P_ID_TRANSAKCIJA IN VARCHAR2,
                                                    P_SIFRA_TRN IN NUMBER,
                                                    P_NAZIV_TRN IN VARCHAR2,
                                                    P_RJ IN VARCHAR2,
                                                    P_POSTANSKI_BROJ IN VARCHAR2,
                                                    P_DATUM_OBRACUNSKI IN DATE DEFAULT NULL,
                                                    P_DATUM  IN DATE,    
                                                    P_OPIS IN VARCHAR2,                                           
                                                    P_SIFRA_RADNIKA IN VARCHAR2,
                                                    P_RBR_TRANSAKCIJE  IN NUMBER,
                                                    P_IZNOS IN NUMBER,
                                                    P_GOTOVINSKA_POSTARINA IN NUMBER,
                                                    P_FAKTURISANA_POSTARINA IN NUMBER,
                                                    P_TEKUCI_RACUN IN VARCHAR2,
                                                    P_POZIV_NA_BROJ IN VARCHAR2,
                                                    P_SIFRA_PLACANJA IN VARCHAR2,                                               
                                                    P_UPLATILAC IN VARCHAR2,
                                                    P_SVRHA_UPLATE IN VARCHAR2,
                                                    P_PRIMALAC IN VARCHAR2,
                                                    P_ID_IZVOR_PODATAKA  IN NUMBER,
                                                    P_DATUM_PUNJENJA  IN DATE,                                                  
                                                    P_PORUKA OUT VARCHAR2,
                                                    P_REZULTAT OUT NUMBER); 

PROCEDURE PROVERA_ZA_DATUM
(
    P_DATUM IN DATE, 
    P_REZULTAT OUT NUMBER,
    P_PORUKA OUT VARCHAR2
);

FUNCTION UPISANI_NALOZI (P_DATUM IN DATE)
      RETURN BOOLEAN;
      
FUNCTION UPISANI_PAZARI (P_DATUM IN DATE)
      RETURN BOOLEAN;      
      
FUNCTION UPISANE_SO_TRN (P_DATUM IN DATE)
      RETURN BOOLEAN;
      
PROCEDURE PREGLED_NALOGA
(
    P_DATUM_OD IN IZV_NALOZI.DATUM_UPLATE%TYPE,
    P_DATUM_DO IN IZV_NALOZI.DATUM_UPLATE%TYPE,
    P_CURSOR OUT T_CURSOR
);   

PROCEDURE PREGLED_SO_TRN
(
    P_DATUM_OD IN IZV_SO_TRN.DATUM_TRANSAKCIJE%TYPE,
    P_DATUM_DO IN IZV_SO_TRN.DATUM_TRANSAKCIJE%TYPE,
    P_CURSOR OUT T_CURSOR
);

PROCEDURE PREGLED_PAZARA
(
    P_DATUM_OD IN IZV_PAZARI.DATUM%TYPE,
    P_DATUM_DO IN IZV_PAZARI.DATUM%TYPE,
    P_CURSOR OUT T_CURSOR
);
                       
                                                    
END IZVESTAJ_PACKAGE;
/

SHOW ERRORS;


