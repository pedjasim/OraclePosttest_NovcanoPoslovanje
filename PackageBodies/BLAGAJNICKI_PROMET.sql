CREATE OR REPLACE PACKAGE BODY                    BLAGAJNICKI_PROMET IS

PROCEDURE AS_OTPREMA_SUVISKA 
        ( P_ID_SUVISAK     IN APOENSKA_STRUKTURA_SUVISKA.id_suvisak%TYPE,
          P_ID_APOEN       IN APOENSKA_STRUKTURA_SUVISKA.id_apoen%TYPE,
          P_KOMADA         IN APOENSKA_STRUKTURA_SUVISKA.komada%TYPE,
          P_REZULTAT      OUT NUMBER,
          P_PORUKA        OUT VARCHAR2 )             
IS
BEGIN

   P_REZULTAT := 1;
   P_PORUKA   := 'NEUSPEŠAN UPIS AS SUVISKA !';
  
   
   INSERT INTO APOENSKA_STRUKTURA_SUVISKA 
      (id_suvisak, id_apoen, komada)
   VALUES 
      (P_ID_SUVISAK, P_ID_APOEN, P_KOMADA); 
   
   P_REZULTAT := 0;
   P_PORUKA   := 'USPEŠAN UPIS AS SUVISKA !';

EXCEPTION
  WHEN OTHERS THEN
    P_REZULTAT := 1;
    P_PORUKA := SQLERRM;

END AS_OTPREMA_SUVISKA;

PROCEDURE AS_PRIJEM_DOTACIJE 
        ( P_ID_DOTACIJA    IN APOENSKA_STRUKTURA_DOTACIJE.id_dotacija%TYPE,
          P_ID_APOEN       IN APOENSKA_STRUKTURA_DOTACIJE.id_apoen%TYPE,
          P_KOMADA         IN APOENSKA_STRUKTURA_DOTACIJE.komada%TYPE,
          P_REZULTAT      OUT NUMBER,
          P_PORUKA        OUT VARCHAR2 )             
IS
BEGIN

   P_REZULTAT := 1;
   P_PORUKA   := 'NEUSPEŠAN UPIS AS DOTACIJE !';
  
   
   INSERT INTO APOENSKA_STRUKTURA_DOTACIJE 
      (id_dotacija, id_apoen, komada)
   VALUES 
      (P_ID_DOTACIJA, P_ID_APOEN, P_KOMADA); 
   
   P_REZULTAT := 0;
   P_PORUKA   := 'USPEŠAN UPIS AS DOTACIJE !';

EXCEPTION
  WHEN OTHERS THEN
    P_REZULTAT := 1;
    P_PORUKA := SQLERRM;

END AS_PRIJEM_DOTACIJE;


PROCEDURE AS_PRIJAVE_MANJKA_VISKA 
        ( P_ID_MANJAK_VISAK  IN APOEN_STRUKTURA_MANJKA_VISKA.id_manjak_visak%TYPE,
          P_ID_APOEN         IN APOEN_STRUKTURA_MANJKA_VISKA.id_apoen%TYPE,
          P_KOMADA           IN APOEN_STRUKTURA_MANJKA_VISKA.komada%TYPE,
          P_REZULTAT        OUT NUMBER,
          P_PORUKA          OUT VARCHAR2 )             
IS
BEGIN

   P_REZULTAT := 1;
   P_PORUKA   := 'NEUSPEŠAN UPIS AS DOTACIJE !';
  
   
   INSERT INTO APOEN_STRUKTURA_MANJKA_VISKA
      (id_manjak_visak, id_apoen, komada)
   VALUES 
      (P_ID_MANJAK_VISAK, P_ID_APOEN, P_KOMADA); 
   
   P_REZULTAT := 0;
   P_PORUKA   := 'USPEŠAN UPIS AS DOTACIJE !';

EXCEPTION
  WHEN OTHERS THEN
    P_REZULTAT := 1;
    P_PORUKA := SQLERRM;

END AS_PRIJAVE_MANJKA_VISKA;

PROCEDURE AS_TREBOVANJE_NOVCA 
        ( P_ID_TREBOVANJE  IN APOENSKA_STRUKTURA_TREBOVANJA.id_trebovanje%TYPE,
          P_ID_APOEN       IN APOENSKA_STRUKTURA_TREBOVANJA.id_apoen%TYPE,
          P_KOMADA         IN APOENSKA_STRUKTURA_TREBOVANJA.komada%TYPE,
          P_REZULTAT      OUT NUMBER,
          P_PORUKA        OUT VARCHAR2 )             
IS
BEGIN

   P_REZULTAT := 1;
   P_PORUKA   := 'NEUSPEŠAN UPIS AS TREBOVANJA !';
  
   
   INSERT INTO APOENSKA_STRUKTURA_TREBOVANJA 
      (id_trebovanje, id_apoen, komada)
   VALUES 
      (P_ID_TREBOVANJE, P_ID_APOEN, P_KOMADA); 
   
   P_REZULTAT := 0;
   P_PORUKA   := 'USPEŠAN UPIS TREBOVANJA !';

EXCEPTION
  WHEN OTHERS THEN
    P_REZULTAT := 1;
    P_PORUKA := SQLERRM;

END AS_TREBOVANJE_NOVCA;

PROCEDURE OTPREMA_SUVISKA
         (P_ID_CPM         IN SUVISAK.id_cpm%TYPE,
          P_ID_TRANSAKCIJA IN SUVISAK.id_transakcija%TYPE,
          P_ID_NALOG_RAZ   IN SUVISAK.id_nalog_za_razmenu_got%TYPE,
          P_IZNOS          IN SUVISAK.iznos%TYPE,
          P_DATUM          IN SUVISAK.datum%TYPE,
          P_ODREDISTE      IN SUVISAK.odrediste%TYPE,
          P_ID_SUVISAK    OUT SUVISAK.id_suvisak%TYPE,
          P_REZULTAT      OUT NUMBER,
          P_PORUKA        OUT VARCHAR2 )             
IS
  nIdNalogRazmene NUMBER;
  nIdDokumenta    NUMBER;
  nUkupno         NUMBER;
  sPozivNaBroj    VARCHAR2(22);
BEGIN

   P_REZULTAT := 1;
   P_PORUKA   := 'NEUSPEŠAN UPIS SUVIŠKA !';
   
   SELECT SUVISAK_SEQ.NEXTVAL 
     INTO  P_ID_SUVISAK
     FROM DUAL ;

 --  IF (P_ID_NALOG_RAZ IS NULL) -- dotacija je od banke i treba kreirati dokument u izvodu
     -- IZVOD.UNOS_DOKUMENTA ( 1, sPozivNaBroj, P_ID_CPM, NULL, P_IZNOS, 100, P_DATUM, 0, nIdDokumenta, P_REZULTAT, P_PORUKA, NULL, NULL);    
  --ELSE
      SELECT COUNT (*)
        INTO nUkupno
        FROM NALOG_ZA_RAZMENU_GOT
       WHERE id_nalog_za_razmenu_got = P_ID_NALOG_RAZ 
         AND id_cpm_suvisak = P_ID_CPM ; 
         
      IF (nUkupno <> 1) THEN
         P_PORUKA := 'PROVERITE BROJ NALOGA ZA RAMENU GOTOVINE !';
         RETURN ;
      END IF;       
  --  END IF;    
       
   INSERT INTO SUVISAK 
      (id_suvisak, id_cpm, id_transakcija, id_nalog_za_razmenu_got, id_dokument, datum, odrediste, iznos)
   VALUES 
      (P_ID_SUVISAK, P_ID_CPM, P_ID_TRANSAKCIJA, P_ID_NALOG_RAZ, nIdDokumenta, P_DATUM, P_ODREDISTE, P_IZNOS); 
   
   P_REZULTAT := 0;
   P_PORUKA   := 'USPEŠAN UPIS SUVIŠKA !';

EXCEPTION
  WHEN OTHERS THEN
    P_REZULTAT := 1;
    P_PORUKA := SQLERRM;

END OTPREMA_SUVISKA;

PROCEDURE PRIJEM_DOTACIJE 
         (P_ID_CPM         IN DOTACIJA.id_cpm%TYPE,
          P_ID_TRANSAKCIJA IN DOTACIJA.id_transakcija%TYPE,
          P_ID_NALOG_RAZ   IN DOTACIJA.id_nalog_za_razmenu_got%TYPE,
          P_IZNOS          IN DOTACIJA.iznos%TYPE,
          P_DATUM          IN DOTACIJA.datum%TYPE,
          P_POREKLO        IN DOTACIJA.poreklo%TYPE,
          P_ID_DOTACIJA   OUT DOTACIJA.id_dotacija%TYPE,
          P_REZULTAT      OUT NUMBER,
          P_PORUKA        OUT VARCHAR2 )             
IS
  nIdNalogRazmene NUMBER;
  nIdDokumenta    NUMBER;
  nUkupno         NUMBER;
  sPozivNaBroj    VARCHAR2(22);
BEGIN

   P_REZULTAT := 1;
   P_PORUKA   := 'NEUSPEŠAN UPIS DOTACIJE !';
   
   SELECT DOTACIJA_SEQ.NEXTVAL 
     INTO  P_ID_DOTACIJA
     FROM DUAL ;

   --IF (P_ID_NALOG_RAZ IS NULL) THEN-- dotacija je od banke i treba kreirati dokument u izvodu
     -- IZVOD.UNOS_DOKUMENTA ( 1, sPozivNaBroj, P_ID_CPM, NULL, P_IZNOS, 99, P_DATUM, 0, nIdDokumenta, P_REZULTAT, P_PORUKA, NULL, NULL);    
   --ELSE
--      SELECT COUNT (*)
--        INTO nUkupno
--        FROM NALOG_ZA_RAZMENU_GOT
--       WHERE id_nalog_za_razmenu_got = P_ID_NALOG_RAZ 
--         AND id_cpm_dotacija = P_ID_CPM ; 
--         
--      IF (nUkupno <> 1) THEN
--         P_PORUKA := 'PROVERITE BROJ NALOGA ZA RAMENU GOTOVINE !';
--         RETURN ;
--      END IF;       
   -- END IF;    
   INSERT INTO DOTACIJA 
      (id_dotacija, id_cpm, id_transakcija, id_nalog_za_razmenu_got, id_dokument, datum, poreklo, iznos)
   VALUES 
      (P_ID_DOTACIJA, P_ID_CPM, P_ID_TRANSAKCIJA, P_ID_NALOG_RAZ, nIdDokumenta, P_DATUM, P_POREKLO, P_IZNOS); 
   
   -- zatvaranje naloga za razmenu, ako je dotacija bila od poste
   
   IF (P_ID_NALOG_RAZ IS NULL) THEN
     
     UPDATE NALOG_ZA_RAZMENU_GOT
        SET status = 'Z'
      WHERE id_nalog_za_razmenu_got = P_ID_NALOG_RAZ ;
        
   END IF;
   P_REZULTAT := 0;
   P_PORUKA   := 'USPEŠAN UPIS DOTACIJE !';

EXCEPTION
  WHEN OTHERS THEN
    P_REZULTAT := 1;
    P_PORUKA := SQLERRM;

END PRIJEM_DOTACIJE;

PROCEDURE TREBOVANJE_NOVCA 
         (P_ID_CPM         IN TREBOVANJE.id_cpm%TYPE,
          P_ZA_DATUM       IN TREBOVANJE.za_datum%TYPE,
          P_IZNOS          IN TREBOVANJE.iznos%TYPE,
          P_KOVANI_NOVAC   IN TREBOVANJE.kovani_novac%TYPE,
         -- P_DATUM          IN TREBOVANJE.datum_trebovanja%TYPE,
          P_ID_TREBOVANJE OUT TREBOVANJE.id_trebovanje%TYPE,
          P_REZULTAT      OUT NUMBER,
          P_PORUKA        OUT VARCHAR2 )             
IS
BEGIN

   P_REZULTAT := 1;
   P_PORUKA   := 'NEUSPEŠAN UPIS TREBOVANJA !';
   
   SELECT TREBOVANJE_SEQ.NEXTVAL 
     INTO  P_ID_TREBOVANJE
     FROM DUAL ;
   
   INSERT INTO TREBOVANJE 
      (id_trebovanje, id_cpm, za_datum, iznos, datum_trebovanja, kovani_novac, status)
   VALUES 
      (P_ID_TREBOVANJE, P_ID_CPM, P_ZA_DATUM, P_IZNOS, SYSDATE,  P_KOVANI_NOVAC, 'E'); 
   
   P_REZULTAT := 0;
   P_PORUKA   := 'USPEŠAN UPIS TREBOVANJA !';

EXCEPTION
  WHEN OTHERS THEN
    P_REZULTAT := 1;
    P_PORUKA := SQLERRM;

END TREBOVANJE_NOVCA;


PROCEDURE STORNIRANJE_TREBOVANJA_NOVCA 
       ( P_ID_TREBOVANJE IN TREBOVANJE.id_trebovanje%TYPE,
         P_REZULTAT      OUT NUMBER,
         P_PORUKA        OUT VARCHAR2 ) 
IS
BEGIN

   P_REZULTAT := 1;
   P_PORUKA   := 'NEUSPEŠNO STORNIRANJE !';
   
   UPDATE TREBOVANJE 
      SET status = 'S'
    WHERE id_trebovanje = P_ID_TREBOVANJE;

   IF (SQL%ROWCOUNT = 0) THEN
     RAISE_APPLICATION_ERROR(-20001, 'NE MOŽETE DA STORNIRATE TREBOVANJE JER NIJE U ODGOVARAJUCEM STATUSU !!!');
   END IF;
   
   P_REZULTAT := 0;
   P_PORUKA   := 'USPEŠAN UPIS TREBOVANJA !';

EXCEPTION
  WHEN OTHERS THEN
    P_REZULTAT := 1;
    P_PORUKA := SQLERRM;

END STORNIRANJE_TREBOVANJA_NOVCA;


PROCEDURE PRIJAVA_MANJKA_VISKA 
       ( P_ID_CPM           IN MANJAK_VISAK.id_cpm %TYPE,
         P_DATUM            IN MANJAK_VISAK.datum%TYPE,
         P_IZNOS            IN MANJAK_VISAK.iznos%TYPE,
         P_VRSTA            IN MANJAK_VISAK.vrsta%TYPE,
         P_UZROK            IN MANJAK_VISAK.uzrok_manjka_viska%TYPE,
         P_ID_RADNIK        IN MANJAK_VISAK.id_radnik%TYPE,
         P_RBR_TRANSAKCIJE  IN MANJAK_VISAK.redni_broj_transakcije%TYPE,
         P_DATUM_TR         IN MANJAK_VISAK.datum_transakcije%TYPE,
         P_STATUS           IN MANJAK_VISAK.status%TYPE,
         P_REZULTAT        OUT NUMBER,
         P_PORUKA          OUT VARCHAR2 )          
IS

  nIdDokumenta    NUMBER;
  sPozivNaBroj    VARCHAR2(22);

BEGIN

   P_REZULTAT := 1;
   P_PORUKA   := 'NEUSPEŠAN UPIS DOTACIJE !';
   
  /* SELECT MANJAK_VISAK_SEQ.NEXTVAL 
     INTO P_ID_MANJAK_VISAK
     FROM DUAL ;*/
  
  -- IF P_VRSTA = 'M' THEN
  -- IZVOD.UNOS_DOKUMENTA ( 1, sPozivNaBroj, P_ID_CPM, NULL, P_IZNOS, 101 P_DATUM, 0, nIdDokumenta, P_REZULTAT, P_PORUKA, NULL, NULL); 
  -- ELSIF P_VRSTA = 'V' THEN
    -- IZVOD.UNOS_DOKUMENTA ( 1, sPozivNaBroj, P_ID_CPM, NULL, P_IZNOS, 101 P_DATUM, 0, nIdDokumenta, P_REZULTAT, P_PORUKA, NULL, NULL);   
  -- END IF;
   nIdDokumenta := 1;
   BEGIN
     
     INSERT INTO MANJAK_VISAK 
       (id_manjak_visak, id_cpm, datum, iznos, vrsta, uzrok_manjka_viska, id_radnik, redni_broj_transakcije,datum_transakcije, status)
     VALUES 
       (MANJAK_VISAK_SEQ.NEXTVAL, P_ID_CPM, P_DATUM, P_IZNOS, P_VRSTA, P_UZROK, P_ID_RADNIK, P_RBR_TRANSAKCIJE, P_DATUM_TR, P_STATUS); 
   
   EXCEPTION
     WHEN NO_DATA_FOUND THEN
       NULL;
   END;
   P_REZULTAT := 0;
   P_PORUKA   := 'USPEŠAN UPIS !';

EXCEPTION
  WHEN OTHERS THEN
    P_REZULTAT := 1;
    P_PORUKA := SQLERRM;

END PRIJAVA_MANJKA_VISKA;


PROCEDURE NALOG_ZA_RAZMENU 
         (P_ID_CPM         IN NALOG_ZA_RAZMENU_GOT.id_cpm_suvisak %TYPE,
          P_VRSTA          IN VARCHAR2,
          P_CURSOR        OUT T_CURSOR,
          P_REZULTAT      OUT NUMBER,
          P_PORUKA        OUT VARCHAR2 )             
IS
BEGIN

   P_REZULTAT := 1;
   P_PORUKA   := 'NEUSPEŠAN PRETRAGA NALOGA !';
   
   IF (P_VRSTA = 'S') THEN
     OPEN P_CURSOR FOR
     SELECT id_nalog_za_razmenu_got, id_cpm_dotacija, id_cpm_suvisak, iznos
       FROM NALOG_ZA_RAZMENU_GOT nrg   -- treba spojitit sa organizacionom celinom 
      WHERE nrg.id_cpm_suvisak = P_ID_CPM
        AND nrg.datum_razmene = TRUNC (SYSDATE)
        AND nrg.status = 'V';  
   ELSIF (P_VRSTA = 'D') THEN
     OPEN P_CURSOR FOR
     SELECT id_nalog_za_razmenu_got, id_cpm_dotacija, id_cpm_suvisak, iznos
       FROM NALOG_ZA_RAZMENU_GOT nrg
      WHERE nrg.id_cpm_dotacija = P_ID_CPM
        AND nrg.datum_razmene = TRUNC (SYSDATE)
        AND nrg.status = 'V';
   END IF;    
   
   P_REZULTAT := 0;
   P_PORUKA   := 'USPEŠANA PRETRAGA NALOGA !';

EXCEPTION
  WHEN OTHERS THEN
    P_REZULTAT := 1;
    P_PORUKA := SQLERRM;

END NALOG_ZA_RAZMENU;

PROCEDURE KREIRANJE_NALOG_ZA_RAZMENU 
       ( P_ID_CPM_S       IN NALOG_ZA_RAZMENU_GOT.id_cpm_suvisak%TYPE,
         P_ID_CPM_D       IN NALOG_ZA_RAZMENU_GOT.id_cpm_dotacija%TYPE,
         P_ID_CPM_N       IN NALOG_ZA_RAZMENU_GOT.id_cpm_nalogodavac%TYPE,
         P_DATUM_RAZMENE  IN NALOG_ZA_RAZMENU_GOT.datum_razmene%TYPE,
         P_IZNOS          IN NALOG_ZA_RAZMENU_GOT.iznos%TYPE,
         P_OPERATER       IN NALOG_ZA_RAZMENU_GOT.id_radnik%TYPE,
         P_ID_NALOGA     OUT NALOG_ZA_RAZMENU_GOT.id_nalog_za_razmenu_got%TYPE,
         P_REZULTAT      OUT NUMBER,
         P_PORUKA        OUT VARCHAR2 )
IS
BEGIN

  P_REZULTAT := 1;
  P_PORUKA   := 'NEUSPEŠAN UPIS DOTACIJE !';
  
  SELECT NALOG_ZA_RAZMENU_SEQ.NEXTVAL
    INTO P_ID_NALOGA
    FROM DUAL;  
  
  INSERT INTO NALOG_ZA_RAZMENU_GOT 
       (id_nalog_za_razmenu_got, id_cpm_nalogodavac, id_cpm_dotacija, id_cpm_suvisak, datum, datum_razmene, iznos, id_radnik, status)
  VALUES 
       (P_ID_NALOGA, P_ID_CPM_N, P_ID_CPM_D, P_ID_CPM_S, SYSDATE, TO_DATE(P_DATUM_RAZMENE,'dd.mm.yyyy'), P_IZNOS, P_OPERATER, 'K');       
 
  P_REZULTAT := 0;
  P_PORUKA   := 'USPEŠANO KREIRAN NALOG RAZMENE !';
  
EXCEPTION
  WHEN OTHERS THEN
    P_REZULTAT := 1;
    P_PORUKA := SQLERRM;
    
END KREIRANJE_NALOG_ZA_RAZMENU;

PROCEDURE UNOS_BLAGAJNICKOG_PROMETA
       ( P_ID_CPM_DAN          IN VARCHAR2,
         P_ID_BLAGAJNA         IN VARCHAR2,
         P_ID_VRSTA_BLAGAJNE   IN BLAGAJNA.id_vrsta_blagajne%TYPE,
         P_ID_RADNIK           IN BLAGAJNA.id_radnik%TYPE,
         P_POCETNO_STANJE      IN BLAGAJNA.pocetno_stanje%TYPE,
         P_ULAZ                IN BLAGAJNA.ulaz%TYPE,
         P_IZLAZ               IN BLAGAJNA.izlaz%TYPE,
         P_KOVANI_NOVAC        IN BLAGAJNA.kovani_novac%TYPE,
         P_STATUS                  IN BLAGAJNA.status%TYPE,
         P_REZULTAT           OUT NUMBER,
         P_PORUKA             OUT VARCHAR2 ) IS

 IdCPMDan RAW(16);
 IdBlagajna RAW(16);
 nIdVrstaTransakcije TRANSAKCIJA_KOMITENT.id_vrsta_transakcije%TYPE;
BEGIN
  
  P_REZULTAT := 1;
  P_PORUKA   := 'NEUSPEŠAN UPIS TRANSAKCIJA !';
  IdCPMDan := HEXTORAW(P_ID_CPM_DAN);
  IdBlagajna := HEXTORAW(P_ID_BLAGAJNA);
  
  INSERT INTO BLAGAJNA (ID_BLAGAJNA, ID_VRSTA_BLAGAJNE, POCETNO_STANJE, ULAZ, IZLAZ, KOVANI_NOVAC, ID_RADNIK, ID_CPM_DAN, STATUS)
               VALUES (IdBlagajna, P_ID_VRSTA_BLAGAJNE, P_POCETNO_STANJE, P_ULAZ, P_IZLAZ, P_KOVANI_NOVAC, P_ID_RADNIK, IdCPMDan, P_STATUS);
               
  P_REZULTAT := 0;
  P_PORUKA   := 'USPEŠAN UPIS TRANSAKCIJA !'; 

  
EXCEPTION
  WHEN OTHERS THEN
    P_REZULTAT := 1;
    P_PORUKA   := 'UNOS_BLAGAJNICKOG_PROMETA'|| SQLERRM ;
    
END UNOS_BLAGAJNICKOG_PROMETA; 

PROCEDURE AS_BLAGAJNE
       ( P_ID_BLAGAJNA         IN APOENSKA_STRUKTURA_BLAGAJNE.id_blagajna%TYPE,
         P_ID_APOEN            IN APOENSKA_STRUKTURA_BLAGAJNE.id_apoen%TYPE,
         P_KOMADA              IN APOENSKA_STRUKTURA_BLAGAJNE.komada%TYPE,
         P_REZULTAT           OUT NUMBER,
         P_PORUKA             OUT VARCHAR2 )IS

 IdBlagajna RAW(16);
 nIdVrstaTransakcije TRANSAKCIJA_KOMITENT.id_vrsta_transakcije%TYPE;
BEGIN
  
  P_REZULTAT := 1;
  P_PORUKA   := 'NEUSPEŠAN UPIS TRANSAKCIJA !';

  IdBlagajna := HEXTORAW(P_ID_BLAGAJNA);
  
  INSERT INTO APOENSKA_STRUKTURA_BLAGAJNE (id_blagajna, id_apoen, komada)
                                   VALUES (IdBlagajna, P_ID_APOEN, P_KOMADA);
               
  P_REZULTAT := 0;
  P_PORUKA   := 'USPEŠAN UPIS TRANSAKCIJA !'; 

  
EXCEPTION
  WHEN OTHERS THEN
    P_REZULTAT := 1;
    P_PORUKA   := SQLERRM ;
    
END AS_BLAGAJNE;      

PROCEDURE UNOS_PROMETA
       ( P_ID_CPM_DAN           IN VARCHAR2,
         P_ID_PROMET            IN VARCHAR2,
         P_ID_BLAGAJNA          IN VARCHAR2,
         P_UPLATA               IN PROMET.iznos_uplate%TYPE,
         P_ISPLATA              IN PROMET.iznos_isplate%TYPE,
         P_ID_VRSTA_PROMETA     IN PROMET.id_vrsta_prometa%TYPE,
         P_ID_SREDSTVO_PLACANJA IN PROMET.id_sredstvo_placanja%TYPE,
         P_KOVANI_NOVAC         IN PROMET.kovani_novac%TYPE,
         P_REFERENCA         IN PROMET.referenca%TYPE,
         P_REZULTAT            OUT NUMBER,
         P_PORUKA              OUT VARCHAR2 ) IS

 IdCPMDan RAW(16);
 IdBlagajna RAW(16);
 IdPromet RAW(16);
 nIdVrstaTransakcije TRANSAKCIJA_KOMITENT.id_vrsta_transakcije%TYPE;
BEGIN
  
  P_REZULTAT := 1;
  P_PORUKA   := 'NEUSPEŠAN UPIS TRANSAKCIJA !';
  IdCPMDan := HEXTORAW(P_ID_CPM_DAN);
  IdBlagajna := HEXTORAW(P_ID_BLAGAJNA);
  IdPromet := HEXTORAW(P_ID_PROMET);
  
  INSERT INTO PROMET (id_promet, id_blagajna, iznos_uplate, iznos_isplate, id_vrsta_prometa, id_sredstvo_placanja, kovani_novac, id_cpm_dan, referenca)
               VALUES (IdPromet, IdBlagajna, P_UPLATA, P_ISPLATA, P_ID_VRSTA_PROMETA, P_ID_SREDSTVO_PLACANJA, P_KOVANI_NOVAC, IdCPMDan, P_REFERENCA );
               
  P_REZULTAT := 0;
  P_PORUKA   := 'USPEŠAN UPIS TRANSAKCIJA !'; 

  
EXCEPTION
  WHEN OTHERS THEN
    P_REZULTAT := 1;
    P_PORUKA   :=SQLERRM ;
    
END UNOS_PROMETA; 

PROCEDURE AS_PROMETA
       ( P_ID_PROMET           IN APOENSKA_STRUKTURA_PROMETA.id_promet%TYPE,
         P_ID_APOEN            IN APOENSKA_STRUKTURA_PROMETA.id_apoen%TYPE,
         P_KOMADA              IN APOENSKA_STRUKTURA_PROMETA.komada%TYPE,
         P_REZULTAT           OUT NUMBER,
         P_PORUKA             OUT VARCHAR2 )IS

 IdPromet RAW(16);
 nIdVrstaTransakcije TRANSAKCIJA_KOMITENT.id_vrsta_transakcije%TYPE;
BEGIN
  
  P_REZULTAT := 1;
  P_PORUKA   := 'NEUSPEŠAN UPIS TRANSAKCIJA !';

  IdPromet := HEXTORAW(P_ID_PROMET);
  
  INSERT INTO APOENSKA_STRUKTURA_PROMETA (id_promet, id_apoen, komada)
                                   VALUES (IdPromet, P_ID_APOEN, P_KOMADA);
               
  P_REZULTAT := 0;
  P_PORUKA   := 'USPEŠAN UPIS TRANSAKCIJA !'; 

  
EXCEPTION
  WHEN OTHERS THEN
    P_REZULTAT := 1;
    P_PORUKA   := SQLERRM ;
    
END AS_PROMETA;     

PROCEDURE UPLATE_ISPLATE
       ( P_ID_CPM_DAN           IN VARCHAR2,
         P_UPLATA               IN STANJE_KASE.uplata%TYPE,
         P_ISPLATA              IN STANJE_KASE.isplata%TYPE,
         P_REZULTAT            OUT NUMBER,
         P_PORUKA              OUT VARCHAR2 ) IS

 IdCPMDan RAW(16);
BEGIN
  
  P_REZULTAT := 1;
  P_PORUKA   := 'NEUSPEŠAN UPIS TRANSAKCIJA !';

  IdCPMDan := HEXTORAW(P_ID_CPM_DAN);
  INSERT INTO STANJE_KASE (id_cpm_dan, uplata, isplata)
                   VALUES (IdCPMDan, P_UPLATA, P_ISPLATA);
               
  P_REZULTAT := 0;
  P_PORUKA   := 'USPEŠAN UPIS TRANSAKCIJA !'; 

  
EXCEPTION
  WHEN OTHERS THEN
    P_REZULTAT := 1;
    P_PORUKA   := SQLERRM ;
    
END UPLATE_ISPLATE;     

PROCEDURE FORMIRANJE_STANJA_KASE  (P_ID_CPM_DAN IN VARCHAR2,
                                   P_REZULTAT  OUT NUMBER,
                                   P_PORUKA    OUT VARCHAR2) IS
                        
nIdCPM NUMBER;
dDatum DATE;
IdCPMDan RAW(16);
nIdVrstaPrometa VRSTA_PROMETA.id_vrsta_prometa%TYPE;
nPocetnoStanje PROMET.iznos_uplate%TYPE;
nDotacija STANJE_KASE.dotacija%TYPE; 
nSuvisak STANJE_KASE.suvisak%TYPE; 
nManjak STANJE_KASE.suvisak%TYPE; 
nVisak STANJE_KASE.suvisak%TYPE;    
nReonDanas STANJE_KASE.nerazduzen_reon%TYPE;  
nReonOdJuce  STANJE_KASE.nerazduzen_reon%TYPE;  
                   
BEGIN

    P_REZULTAT := 1;
    IdCPMDan := HEXTORAW(P_ID_CPM_DAN);
       -- Ukupno uplata (uplate (FAT) + postarine (FAT) + viskovi blagajni (PROMET) ), 
       --ukupno isplata : isplate (FAT) + manjkovi blagajni (PROMET)
       --  POCETNO STANJE (UKLJUCITI I KOREKCIJU UKOLIKO POSTOJI)
       -- DOTACIJE
       -- SUVISAK
       -- VISAK/MANJAK BLAGAJNI (GB, PB, POSTAR)
       -- treba dodati visak/manjak PB i postara ?????????
       nPocetnoStanje := 0;
       nDotacija :=  0;
       nSuvisak :=  0;
       nManjak :=  0;
       nVisak :=  0;
       nReonDanas := 0;
       FOR recPromet IN(SELECT a.id_vrsta_prometa, SUM (a.suma) iznos
                          FROM (
                               SELECT p.id_vrsta_prometa, DECODE(p.iznos_uplate, 0,  DECODE (p.id_vrsta_prometa, 18,  iznos_isplate *(-1),  iznos_isplate), p.iznos_uplate)suma
                                 FROM BLAGAJNA b, PROMET p
                                WHERE b.id_blagajna = p.id_blagajna 
                                  AND p.id_vrsta_prometa in (1, 18, 7, 8, 9, 10, 11, 12, 13, 14)
                                  AND b.id_blagajna IN (SELECT id_blagajna 
                                                         FROM BLAGAJNA 
                                                        WHERE id_cpm_dan = IdCPMDan)
                             )a
                        GROUP BY a.id_vrsta_prometa
                     )
       LOOP
          CASE  recPromet.id_vrsta_prometa
             WHEN 1 THEN nPocetnoStanje := nPocetnoStanje + recPromet.iznos; 
             WHEN 7  THEN nDotacija := nDotacija + recPromet.iznos; 
             WHEN 8 THEN nDotacija := nDotacija + recPromet.iznos; 
             WHEN 9 THEN nSuvisak := nSuvisak + recPromet.iznos;
             WHEN 10 THEN nSuvisak := nSuvisak + recPromet.iznos; 
             WHEN 11 THEN nManjak := nManjak + recPromet.iznos; 
             WHEN 12 THEN nManjak := nManjak + recPromet.iznos; 
             WHEN 13 THEN nVisak := nVisak + recPromet.iznos;
             WHEN 14 THEN nVisak := nVisak + recPromet.iznos;
             WHEN 18 THEN nPocetnoStanje := nPocetnoStanje + recPromet.iznos; 
             ELSE  NULL;
          END CASE; 
       END LOOP; 
       
--nerazduzen reon danas
       SELECT SUM(p.iznos_uplate)  - SUM(p.iznos_isplate)
          INTO nReonDanas
        FROM   BLAGAJNA  b, PROMET  p
      WHERE   b.id_cpm_dan = IdCPMDan
          AND   b.id_blagajna = p.id_blagajna 
         AND    b.Status = 'N';
         
    -- nerazduzen reon od prethodnog dana
      SELECT nvl (SUM(p.iznos_uplate), 0) AS Iznos
         INTO   nReonOdJuce
        FROM   BLAGAJNA  b, PROMET  p
      WHERE   b.id_cpm_dan = IdCPMDan
          AND   b.id_blagajna = p.id_blagajna 
         AND    p.id_vrsta_prometa = 19 ;    
         
       UPDATE STANJE_KASE
          SET pocetno_stanje = nPocetnoStanje + nReonOdJuce,
              dotacija = nDotacija,
              suvisak = nSuvisak, 
              uplata = uplata + nVisak,
              isplata = isplata + nManjak,
              nerazduzen_reon = nReonDanas
        WHERE id_cpm_dan = IdCPMDan;
        
     P_REZULTAT := 0;

END FORMIRANJE_STANJA_KASE;                        


PROCEDURE SPREMI_STANJE_KASE  (P_REZULTAT  OUT NUMBER,
                               P_CURSOR    OUT T_CURSOR)IS
                        
nIdCPM NUMBER;
dDatum DATE;
IdCPMDan RAW(16);
nIdVrstaPrometa VRSTA_PROMETA.id_vrsta_prometa%TYPE;
nPocetnoStanje PROMET.iznos_uplate%TYPE;                        
BEGIN

  BEGIN
    P_REZULTAT := 1;
    
    OPEN P_CURSOR FOR  
      SELECT co.datum, SUBSTR(cpm.postanski_broj,1, 5) postanski_broj,
             st.pocetno_stanje, st.dotacija, st.suvisak, st.uplata, st.isplata,  nvl(st.nerazduzen_reon,0) nerazduzen_reon,
             (st.pocetno_stanje + st.dotacija + st.uplata) ukupno_uplata,
             (st.suvisak + st.isplata)ukupno_isplata
        FROM CPM_OBRADA co, STANJE_KASE st, POSLOVNO_OKRUZENJE.CVOR_POSTANSKE_MREZE cpm
       WHERE co.id_cpm_dan = st.id_cpm_dan
         AND cpm.id_cvor_postanske_mreze = co.id_cpm 
         AND TRUNC(co.DATUM) = TRUNC(SYSDATE)-1   ;
         
  EXCEPTION
    WHEN OTHERS THEN
      RAISE;
  END;   
       
 P_REZULTAT := 0;

END SPREMI_STANJE_KASE;     

                                
END BLAGAJNICKI_PROMET;
/

SHOW ERRORS;


