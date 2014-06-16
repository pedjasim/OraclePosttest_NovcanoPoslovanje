CREATE OR REPLACE PACKAGE BODY                    IZVESTAJ_PACKAGE AS


PROCEDURE INSERT_IZV_NALOZI  (P_ID_CPM_DAN IN VARCHAR2,
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
                                                    P_REZULTAT OUT NUMBER) IS
BEGIN

    P_REZULTAT := 1;
    P_PORUKA   := 'NEUSPEŠAN UPIS!';
-- Neki komentar za GitHub
-- Nešto ne?e
    INSERT INTO IZV_NALOZI
               (ID_IZV_NALOZI,
                ID_CPM_DAN,
                ID_TRANSAKCIJA,
                SIFRA_TRN,
                NAZIV_TRN,
                POSTANSKI_BROJ,
                OBRACUNSKI_DAN,
                DATUM_UPLATE,
                SIFRA_RADNIKA,
                RBR_TRANSAKCIJE,
                IZNOS,
                TEKUCI_RACUN,
                POZIV_NA_BROJ,
                SIFRA_PLACANJA,
                MODEL,
                UPLATILAC_I,
                UPLATILAC_II,
                UPLATILAC_III,
                SVRHA_UPLATE_I,
                SVRHA_UPLATE_II,
                SVRHA_UPLATE_III,
                PRIMALAC_I,
                PRIMALAC_II,
                PRIMALAC_III,
                RJ,
                ID_IZVOR_PODATAKA,
                DATUM_PUNJENJA                )
     VALUES
                (IZV_NALOZI_SEQ.NEXTVAL,
                 HEXTORAW(P_ID_CPM_DAN),
                 HEXTORAW(P_ID_TRANSAKCIJA),
                 P_SIFRA_TRN,                
                 P_NAZIV_TRN,
                 P_POSTANSKI_BROJ,
                 P_DATUM_OBRACUNSKI,
                 P_DATUM_UPLATE,
                 P_SIFRA_RADNIKA,
                 P_RBR_TRANSAKCIJE,
                 P_IZNOS,
                 P_TEKUCI_RACUN,
                 P_POZIV_NA_BROJ,
                 P_SIFRA_PLACANJA,
                 P_MODEL,
                 P_UPLATILAC_I,
                 P_UPLATILAC_II,
                 P_UPLATILAC_III,
                 P_SVRHA_UPLATE_I,
                 P_SVRHA_UPLATE_II,
                 P_SVRHA_UPLATE_III,
                 P_PRIMALAC_I,
                 P_PRIMALAC_II,
                 P_PRIMALAC_III,
                 P_RJ,
                 P_ID_IZVOR_PODATAKA,
                 P_DATUM_PUNJENJA);
                 
     P_REZULTAT := 0;
     P_PORUKA   := 'USPEŠAN UPIS !'; 
     
     EXCEPTION  
         --Ako pukne UNIQUE constraint (nad kolonom ID_TRANSAKCIJA)
         WHEN DUP_VAL_ON_INDEX THEN
             P_REZULTAT := 2;
             P_PORUKA   := SQLERRM; 
          WHEN OTHERS THEN    
             P_REZULTAT := 1;
             P_PORUKA   := SQLERRM;
END INSERT_IZV_NALOZI;

PROCEDURE INSERT_IZV_SO_TRN (P_ID_CPM_DAN IN VARCHAR2,
                                                    P_ID_TRANSAKCIJA IN VARCHAR2,
                                                    P_RJ IN VARCHAR2,
                                                    P_POSTANSKI_BROJ IN VARCHAR2,
                                                    P_DATUM_OBRACUNSKI IN DATE DEFAULT NULL,
                                                    P_DATUM_TRANSAKCIJE  IN DATE,
                                                    P_DATUM_SO  IN DATE,
                                                    P_SIFRA_TRN IN NUMBER,
                                                    P_NAZIV_TRN IN VARCHAR2  DEFAULT NULL,
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
                                                    P_REZULTAT OUT NUMBER) IS
                      
BEGIN

    P_REZULTAT := 1;
    P_PORUKA   := 'NEUSPEŠAN UPIS!';
   
    INSERT INTO IZV_SO_TRN
               (ID_IZV_SO_TRN,
                ID_CPM_DAN,
                ID_TRANSAKCIJA,
                RJ,
                POSTA,
                OBRACUNSKI_DAN,
                DATUM_TRANSAKCIJE,
                DATUM_STORNO_OPOZIV,
                SIFRA_TRANSAKCIJE,
                NAZIV_TRN,
                SIFRA_RADNIKA,
                RBR_TRANSAKCIJE,
                IZNOS,
                POSTARINA,
                OPIS_I,
                OPIS_II,
                OPIS_III,
                RAZLOG_STORNO_OPOZIV,
                BROJ_S_O_TRANSAKCIJE,
                DATUM_NOVE_TRN,
                SIFRA_NOVE_TRN,
                SIFRA_RADNIKA_NOVE_TRN,
                RBR_NOVE_TRN,
                IZNOS_NOVE_TRN,
                POSTARINA_NOVE_TRN,
                OPIS_I_NOVE_TRN,
                OPIS_II_NOVE_TRN,
                OPIS_III_NOVE_TRN,
                STATUS,
                ID_IZVOR_PODATAKA,
                DATUM_PUNJENJA)
    VALUES 
               (IZV_SO_TRN_SEQ.NEXTVAL,
                 HEXTORAW(P_ID_CPM_DAN),
                 HEXTORAW(P_ID_TRANSAKCIJA),
                 P_RJ,
                 P_POSTANSKI_BROJ,
                 P_DATUM_OBRACUNSKI,
                 P_DATUM_TRANSAKCIJE,
                 P_DATUM_SO,
                 P_SIFRA_TRN,
                 P_NAZIV_TRN,
                 P_SIFRA_RADNIKA,
                 P_RBR_TRANSAKCIJE,
                 P_IZNOS,
                 P_POSTARINA,
                 P_OPIS_I,
                 P_OPIS_II,
                 P_OPIS_III,
                 P_RAZLOG_SO,
                 P_BROJ_S_O_TRANSAKCIJE,
                 P_DATUM_NOVE_TRN,
                 P_SIFRA_NOVE_TRN,
                 P_SIFRA_RADNIKA_NOVE_TRN,
                 P_RBR_NOVE_TRN,
                 P_IZNOS_NOVE_TRN,
                 P_POSTARINA_NOVE_TRN,
                 P_OPIS_I_NOVE_TRN,
                 P_OPIS_II_NOVE_TRN,
                 P_OPIS_III_NOVE_TRN,
                 P_STATUS,
                 P_ID_IZVOR_PODATAKA,
                 P_DATUM_PUNJENJA);
                 
     P_REZULTAT := 0;
     P_PORUKA   := 'USPEŠAN UPIS !'; 
     
    EXCEPTION
         --Ako pukne UNIQUE constraint (nad kolonom ID_TRANSAKCIJA)
          WHEN DUP_VAL_ON_INDEX THEN
                 P_REZULTAT := 2;
                 P_PORUKA   := SQLERRM; 
          WHEN OTHERS THEN    
                 P_REZULTAT := 1;
                 P_PORUKA   := SQLERRM;
END INSERT_IZV_SO_TRN;

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
                                                    P_REZULTAT OUT NUMBER) IS
                      
BEGIN

    P_REZULTAT := 1;
    P_PORUKA   := 'NEUSPEŠAN UPIS!';
   
    INSERT INTO IZV_PAZARI 
              (ID_IZV_PAZARi,
                ID_CPM_DAN,
                ID_TRANSAKCIJA,
                SIFRA_TRN,
                NAZIV_TRN,
                RJ,
                POSTANSKI_BROJ,
                OBRACUNSKI_DAN,
                DATUM,        
                OPIS,     
                SIFRA_RADNIKA,
                RBR_TRANSAKCIJE,
                IZNOS,
                GOTOVINSKA_POSTARINA,
                FAKTURISANA_POSTARINA,
                TEKUCI_RACUN,
                POZIV_NA_BROJ,
                SIFRA_PLACANJA,
                UPLATILAC,
                SVRHA_UPLATE,
                PRIMALAC,
                ID_IZVOR_PODATAKA,
                DATUM_PUNJENJA)
    VALUES
               (IZV_PAZARI_SEQ.NEXTVAL,
                 HEXTORAW(P_ID_CPM_DAN),
                 HEXTORAW(P_ID_TRANSAKCIJA),
                 P_SIFRA_TRN,
                 P_NAZIV_TRN,
                 P_RJ,
                 P_POSTANSKI_BROJ,
                 P_DATUM_OBRACUNSKI,
                 P_DATUM,             
                 P_OPIS,
                 P_SIFRA_RADNIKA,
                 P_RBR_TRANSAKCIJE,
                 P_IZNOS,
                 P_GOTOVINSKA_POSTARINA,
                 P_FAKTURISANA_POSTARINA,
                 P_TEKUCI_RACUN,
                 P_POZIV_NA_BROJ,
                 P_SIFRA_PLACANJA,
                 P_UPLATILAC,
                 P_SVRHA_UPLATE,
                 P_PRIMALAC,
                 P_ID_IZVOR_PODATAKA,
                 P_DATUM_PUNJENJA);
                 
     P_REZULTAT := 0;
     P_PORUKA   := 'USPEŠAN UPIS !'; 
     
     EXCEPTION
         --Ako pukne UNIQUE constraint (nad kolonom ID_TRANSAKCIJA)
          WHEN DUP_VAL_ON_INDEX THEN
                 P_REZULTAT := 2;
                 P_PORUKA   := SQLERRM; 
          WHEN OTHERS THEN    
                 P_REZULTAT := 1;
                 P_PORUKA   := SQLERRM;                              
END INSERT_IZV_PAZARI;

PROCEDURE PROVERA_ZA_DATUM (P_DATUM IN DATE, 
                                                    P_REZULTAT OUT NUMBER,
                                                    P_PORUKA OUT VARCHAR2)
IS
    bUpisaniNalozi BOOLEAN;
    bUpisaniPazari BOOLEAN;
    bUpisaneSO BOOLEAN;
BEGIN
   P_REZULTAT := 2;

   bUpisaniNalozi := UPISANI_NALOZI(P_DATUM);

    IF(bUpisaniNalozi = TRUE) THEN
        P_REZULTAT := 3;
    ELSE
        bUpisaniPazari := UPISANI_PAZARI(P_DATUM);

        IF(bUpisaniPazari = TRUE) THEN
            P_REZULTAT := 3;
        ELSE
            bUpisaneSO := UPISANE_SO_TRN(P_DATUM);

            IF(bUpisaneSO = TRUE) THEN
                P_REZULTAT := 3;
            END IF;
        END IF;
    END IF;
    EXCEPTION
        WHEN OTHERS THEN
            P_REZULTAT := 1;
            P_PORUKA := SQLERRM;
END PROVERA_ZA_DATUM;

FUNCTION UPISANI_NALOZI(P_DATUM IN DATE) RETURN BOOLEAN AS
    nKomada NUMBER;
BEGIN

    SELECT COUNT(*)
        INTO nKomada
    FROM IZV_NALOZI N
    WHERE N.OBRACUNSKI_DAN = TRUNC(P_DATUM);

    IF(nKomada > 0) THEN
       RETURN TRUE;
    ELSE
       RETURN FALSE;
    END IF;

END UPISANI_NALOZI;

FUNCTION UPISANI_PAZARI(P_DATUM IN DATE)  RETURN BOOLEAN AS
    nKomada NUMBER;
BEGIN

    SELECT COUNT(*)
        INTO nKomada
    FROM IZV_PAZARI P
    WHERE P.OBRACUNSKI_DAN = TRUNC(P_DATUM);

    IF(nKomada > 0) THEN
       RETURN TRUE;
    ELSE
       RETURN FALSE;
    END IF;

END UPISANI_PAZARI;

FUNCTION UPISANE_SO_TRN(P_DATUM IN DATE)  RETURN BOOLEAN AS
    nKomada NUMBER;
BEGIN

    SELECT COUNT(*)
        INTO nKomada
    FROM IZV_SO_TRN S
    WHERE S.OBRACUNSKI_DAN = TRUNC(P_DATUM);

    IF(nKomada > 0) THEN
       RETURN TRUE;
    ELSE
       RETURN FALSE;
    END IF;

END UPISANE_SO_TRN;

PROCEDURE PREGLED_NALOGA
(
    P_DATUM_OD IN IZV_NALOZI.DATUM_UPLATE%TYPE,
    P_DATUM_DO IN IZV_NALOZI.DATUM_UPLATE%TYPE,
    P_CURSOR OUT T_CURSOR
)
IS
BEGIN
    OPEN P_CURSOR FOR
    
    SELECT *
    FROM IZV_NALOZI I
    WHERE  I.OBRACUNSKI_DAN between P_DATUM_OD and P_DATUM_DO;
    
END PREGLED_NALOGA;

PROCEDURE PREGLED_SO_TRN
(
    P_DATUM_OD IN IZV_SO_TRN.DATUM_TRANSAKCIJE%TYPE,
    P_DATUM_DO IN IZV_SO_TRN.DATUM_TRANSAKCIJE%TYPE,
    P_CURSOR OUT T_CURSOR
)
IS
BEGIN

    OPEN P_CURSOR FOR
    
    SELECT *
    FROM IZV_SO_TRN IST
    WHERE   IST.OBRACUNSKI_DAN between P_DATUM_OD and P_DATUM_DO;

END PREGLED_SO_TRN;

PROCEDURE PREGLED_PAZARA
(
    P_DATUM_OD IN IZV_PAZARI.DATUM%TYPE,
    P_DATUM_DO IN IZV_PAZARI.DATUM%TYPE,
    P_CURSOR OUT T_CURSOR
)
IS
BEGIN

    OPEN P_CURSOR FOR
    
    SELECT  IP.*
    FROM IZV_PAZARI IP 
    WHERE IP.OBRACUNSKI_DAN  between P_DATUM_OD and P_DATUM_DO;
    
END PREGLED_PAZARA;    

END IZVESTAJ_PACKAGE;
/

SHOW ERRORS;


