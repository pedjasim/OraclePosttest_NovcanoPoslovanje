CREATE OR REPLACE PACKAGE BODY                    TRANSAKCIJE IS

PROCEDURE UNOS_TRANSAKCIJA_BANKE(P_ID_CPM_DAN     IN VARCHAR2,
                                 P_SIFRA_BANKE        IN TRANSAKCIJA_BANKA.sifra_banke%TYPE, 
                                 P_SIFRA_TRANSAKCIJE  IN VARCHAR2,
                                 P_VRSTA              IN VARCHAR2,
                                 P_BROJ_TR            IN TRANSAKCIJA_BANKA.broj_tekuceg_racuna%TYPE,
                                 P_BROJ_CEKA          IN TRANSAKCIJA_BANKA.broj_ceka%TYPE,
                                 P_BROJ_SK            IN TRANSAKCIJA_BANKA.broj_stedne_knjizice%TYPE,
                                 P_IZNOS              IN TRANSAKCIJA_BANKA.iznos_transakcije%TYPE,
                                 P_AUTORIZACIONI_BROJ IN TRANSAKCIJA_BANKA.autorizacioni_broj%TYPE,
                                 P_MOD_RADA          IN TRANSAKCIJA_BANKA.nacin_realizacije%TYPE, 
                                 P_NOVO_STANJE        IN TRANSAKCIJA_BANKA.novo_stanje%TYPE,
                                 P_BROJ_KARTICE          IN TRANSAKCIJA_BANKA.broj_kartice%TYPE,
                                 P_AKCEPTANT            IN TRANSAKCIJA_BANKA.akceptant%TYPE,
                                 P_IZVOR_TRANSAKCIJE  IN TRANSAKCIJA_BANKA.izvor_transakcije%TYPE,
                                 P_STATUS               IN TRANSAKCIJA_BANKA.status%TYPE,
                                 P_ID_CPM            IN TRANSAKCIJA_BANKA.id_cpm %TYPE,
                                 P_DATUM             IN TRANSAKCIJA_BANKA.datum%TYPE,
                                 P_ID_VRSTA_TRANSAKCIJE IN TRANSAKCIJA_BANKA.id_vrsta_transakcije%TYPE,
                                 P_ID_RADNIK          IN TRANSAKCIJA_BANKA.id_radnik%TYPE,
                                 P_SIFRA_RADNIKA      IN TRANSAKCIJA_BANKA.sifra_radnika%TYPE,
                                 P_RBR_TRANSAKCIJE    IN TRANSAKCIJA_BANKA.redni_broj_transakcije%TYPE,
                                 P_DATUM_TR             IN TRANSAKCIJA_BANKA.datum_transakcije%TYPE,
                                 P_DOSTAVA             IN TRANSAKCIJA_BANKA.dostava%TYPE,
                                 P_RRN                    IN TRANSAKCIJA_BANKA.rrn%TYPE,      
                                 P_SALTER                   IN TRANSAKCIJA_BANKA.salter%TYPE DEFAULT NULL,           
                                 P_REZULTAT         OUT NUMBER,
                                 P_PORUKA           OUT VARCHAR2)IS
 nObrada NUMBER;
 sVrstaPromene VARCHAR(5); 
 sBrojCeka  VARCHAR(20);
 IdCPMDan RAW(16);
 nIdVrstaTransakcije TRANSAKCIJA_KOMITENT.id_vrsta_transakcije%TYPE;
 
BEGIN
  
  P_REZULTAT := 1;
  P_PORUKA   := 'NEUSPEŠAN UPIS TRANSAKCIJA !';
  IdCPMDan := HEXTORAW(P_ID_CPM_DAN);
    
--  nObrada := PROVERA_CPM_DANA (P_ID_CPM_DAN, 'B');
--  IF (nObrada > 0) THEN
--    P_REZULTAT := 0;
--    P_PORUKA := 'PAKET ZA OVAJ CPM DAN JE VEC RASPAKOVAN !';
--    RETURN;
--  END IF;

 
-- ako je izvor transakcije 'P', u pitanju je isplata cekom iz pazara 
-- ako je izvor transakcije 'C', u pitanju je isplata cekom gradjanina
-- ako je izvor transakcije 'N', u pitanju je isplata nalogom gradjanina   
  sVrstaPromene := '501' ; --PROVERI OVO
  sBrojCeka     := P_BROJ_CEKA; 
  IF (P_SIFRA_BANKE = '200')AND (P_VRSTA = 'U') THEN
    sVrstaPromene := '502';
  ELSIF (P_SIFRA_BANKE = '200')AND (P_VRSTA = 'I') THEN 
    
    IF (P_IZVOR_TRANSAKCIJE = 'P') THEN
      sVrstaPromene := '513';
    ELSIF (P_IZVOR_TRANSAKCIJE = 'N') THEN
      sVrstaPromene := '510'; 
      sBrojCeka     := '00000442'; 
    ELSIF (P_IZVOR_TRANSAKCIJE = 'C') THEN
      sVrstaPromene := '501' ;
    END IF;     
       
  END IF;
  
  IF (P_SIFRA_TRANSAKCIJE = 'S497') THEN
    sVrstaPromene := '402';
  ELSIF (P_SIFRA_TRANSAKCIJE = 'S504') THEN
    sVrstaPromene := '403';
  ELSIF (P_SIFRA_TRANSAKCIJE = '556') THEN
    sVrstaPromene := '556';    
  END IF;     

  IF (P_ID_VRSTA_TRANSAKCIJE IN (433, 202)) THEN  -- isplata ceka na dostavi i pazari
     nIdVrstaTransakcije := 186;
  ELSE
     nIdVrstaTransakcije := P_ID_VRSTA_TRANSAKCIJE;  
  END IF;
  
  INSERT INTO TRANSAKCIJA_BANKA
      (id_transakcija_banka,
       sifra_banke,
       iznos_transakcije,
       broj_tekuceg_racuna,
       broj_ceka,
       broj_stedne_knjizice,
       autorizacioni_broj,
       vrsta_promene,
       nacin_realizacije,
       izvor_transakcije,
       novo_stanje,
       broj_kartice,
       akceptant,
       id_cpm, 
       datum,
       id_vrsta_transakcije,
       id_radnik,
       redni_broj_transakcije,
       status,
       datum_transakcije,
       sifra_transakcije,
       vrsta_transakcije,
       sifra_radnika,
       id_cpm_dan,
       dostava,
       rrn,
       salter
       )
  VALUES
      (TRANSAKCIJA_BANKA_SEQ.NEXTVAL,
       P_SIFRA_BANKE,
       P_IZNOS,
       P_BROJ_TR,
       sBrojCeka,
       P_BROJ_SK,
       P_AUTORIZACIONI_BROJ,
       sVrstaPromene,
       P_MOD_RADA,
       P_IZVOR_TRANSAKCIJE,
       P_NOVO_STANJE,
       P_BROJ_KARTICE,
       P_AKCEPTANT,
       P_ID_CPM,
       P_DATUM,
       nIdVrstaTransakcije,
       P_ID_RADNIK,
       P_RBR_TRANSAKCIJE,
       P_STATUS,
       P_DATUM_TR,
       P_SIFRA_TRANSAKCIJE,
       P_VRSTA,
       P_SIFRA_RADNIKA,
       IdCPMDan,
       P_DOSTAVA,
       P_RRN,
       P_SALTER
      );
   
  P_REZULTAT := 0;
  P_PORUKA   := 'USPEŠAN UPIS TRANSAKCIJA !'; 
  --OBRADA_CPM_DANA (P_ID_CPM_DAN, 'B', P_REZULTAT, P_PORUKA);
  
EXCEPTION
  WHEN OTHERS THEN
    P_REZULTAT := 1;
    P_PORUKA   := SQLERRM || P_SIFRA_BANKE||' ' ||P_IZNOS||' '  ||P_BROJ_TR||' '  ||sBrojCeka||' '  ||P_BROJ_SK||' '  ||P_AUTORIZACIONI_BROJ||' '  ||P_MOD_RADA||' ' || P_IZVOR_TRANSAKCIJE;
    
END UNOS_TRANSAKCIJA_BANKE;

PROCEDURE UNOS_TRANSAKCIJA_KOMITENTI(P_ID_CPM_DAN     IN VARCHAR2,
                                     P_SIFRA_KOMITENTA   IN TRANSAKCIJA_KOMITENT.sifra_komitenta %TYPE,
                                     P_MODEL_POZIVA_NA_BROJ IN TRANSAKCIJA_KOMITENT.model_poziva_na_broj%TYPE,   
                                     P_POZIV_NA_BROJ     IN TRANSAKCIJA_KOMITENT.poziv_na_broj%TYPE,
                                     P_IZNOS             IN TRANSAKCIJA_KOMITENT.iznos%TYPE,
                                     P_PROCENAT_POPUSTA  IN TRANSAKCIJA_KOMITENT.procenat_popusta%TYPE,
                                     P_IZNOS_SA_POPUSTOM IN TRANSAKCIJA_KOMITENT.iznos_sa_popustom%TYPE,
                                     P_STATUS               IN TRANSAKCIJA_KOMITENT.status%TYPE,
                                     P_ID_CPM            IN TRANSAKCIJA_KOMITENT.id_cpm%TYPE,
                                     P_DATUM             IN TRANSAKCIJA_KOMITENT.datum%TYPE,
                                     P_ID_VRSTA_TRANSAKCIJE IN TRANSAKCIJA_KOMITENT.id_vrsta_transakcije%TYPE,
                                     P_ID_RADNIK         IN TRANSAKCIJA_KOMITENT.id_radnik%TYPE,
                                     P_SIFRA_RADNIKA      IN TRANSAKCIJA_KOMITENT.sifra_radnika%TYPE,
                                     P_RBR_TRANSAKCIJE   IN TRANSAKCIJA_KOMITENT.redni_broj_transakcije%TYPE, 
                                     P_DATUM_TR             IN TRANSAKCIJA_KOMITENT.datum_transakcije%TYPE,
                                     P_SIFRA_TRANSAKCIJE  IN TRANSAKCIJA_KOMITENT.sifra_transakcije%TYPE,
                                     P_DOSTAVA            IN TRANSAKCIJA_KOMITENT.dostava%TYPE,                     
                                     P_SALTER                   IN TRANSAKCIJA_KOMITENT.salter%TYPE DEFAULT NULL,        
                                     P_REZULTAT         OUT NUMBER,
                                     P_PORUKA           OUT VARCHAR2) IS
nObrada NUMBER;
IdCPMDan RAW(16);
nIdVrstaTransakcije TRANSAKCIJA_KOMITENT.id_vrsta_transakcije%TYPE;
sSifraTransakcije TRANSAKCIJA_KOMITENT.sifra_transakcije%TYPE;

BEGIN
  
  P_REZULTAT := 1;
  P_PORUKA   := 'NEUSPEŠAN UPIS TRANSAKCIJA !';
  IdCPMDan := HEXTORAW(P_ID_CPM_DAN);
   
--  nObrada := PROVERA_CPM_DANA (P_ID_CPM_DAN, 'K');
--  IF (nObrada > 0) THEN
--    P_REZULTAT := 0;
--    P_PORUKA := 'PAKET ZA OVAJ CPM DAN JE VEC RASPAKOVAN !';
--    RETURN;
--  END IF;
   
  sSifraTransakcije := P_SIFRA_TRANSAKCIJE;
  IF (P_ID_VRSTA_TRANSAKCIJE = 432) THEN  -- uplata na dostavi
     nIdVrstaTransakcije := 191;
  ELSIF (P_ID_VRSTA_TRANSAKCIJE IN (290, 142)) THEN  -- ISPLATA POSTANSKIH UPUTNICA
     nIdVrstaTransakcije := 141;
     sSifraTransakcije := 'PU141';
  ELSE
     nIdVrstaTransakcije := P_ID_VRSTA_TRANSAKCIJE;  
  END IF;
  
  INSERT INTO TRANSAKCIJA_KOMITENT
      (id_transakcija_komitent,
       sifra_komitenta,
       iznos,
       procenat_popusta,
       iznos_sa_popustom, 
       poziv_na_broj,
       id_cpm,
       datum,
       id_vrsta_transakcije,
       id_radnik,
       redni_broj_transakcije,
       status,
       datum_transakcije,
       sifra_transakcije,
       sifra_radnika,
       model_poziva_na_broj,
       id_cpm_dan,
       dostava,
       salter)
  VALUES
      (TRANSAKCIJA_KOMITENT_SEQ.NEXTVAL,
       P_SIFRA_KOMITENTA,
       P_IZNOS,
       P_PROCENAT_POPUSTA,
       P_IZNOS_SA_POPUSTOM,
       P_POZIV_NA_BROJ,
       P_ID_CPM,
       P_DATUM,
       nIdVrstaTransakcije,
       P_ID_RADNIK,
       P_RBR_TRANSAKCIJE,
       P_STATUS, 
       P_DATUM_TR,
       sSifraTransakcije,
       P_SIFRA_RADNIKA,
       SUBSTR(P_MODEL_POZIVA_NA_BROJ,1,2),
       IdCPMDan,
       P_DOSTAVA,
       P_SALTER);
  
  P_REZULTAT := 0;
  P_PORUKA   := 'USPEŠAN UPIS TRANSAKCIJA !'; 
  --OBRADA_CPM_DANA (P_ID_CPM_DAN, 'K', P_REZULTAT, P_PORUKA);
  
EXCEPTION
  WHEN OTHERS THEN
    P_REZULTAT := 1;
    P_PORUKA   := SQLERRM;
    
END UNOS_TRANSAKCIJA_KOMITENTI;

PROCEDURE UNOS_TRANSAKCIJA_NALOG_PP(P_ID_CPM_DAN     IN VARCHAR2,
                                    P_NAZIV_UPLATIOCA     IN TRANSAKCIJA_NALOG_PP.naziv_uplatioca%TYPE,
                                    P_ADRESA_UPLATIOCA    IN TRANSAKCIJA_NALOG_PP.adresa_uplatioca%TYPE,
                                    P_POSTA_UPLATIOCA     IN TRANSAKCIJA_NALOG_PP.posta_uplatioca%TYPE,
                                    P_NAZIV_PRIMAOCA      IN TRANSAKCIJA_NALOG_PP.naziv_primaoca%TYPE,
                                    P_ADRESA_PRIMAOCA     IN TRANSAKCIJA_NALOG_PP.adresa_primaoca%TYPE,
                                    P_POSTA_PRIMAOCA      IN TRANSAKCIJA_NALOG_PP.posta_primaoca%TYPE,
                                    P_ZIRO_RACUN_PRIMAOCA IN TRANSAKCIJA_NALOG_PP.tekuci_racun_primaoca%TYPE,
                                    P_MODEL_POZIVA_NA_BROJ IN TRANSAKCIJA_NALOG_PP.model_poziva_na_broj%TYPE,
                                    P_POZIV_NA_BROJ       IN TRANSAKCIJA_NALOG_PP.poziv_na_broj%TYPE,
                                    P_IZNOS               IN TRANSAKCIJA_NALOG_PP.iznos%TYPE,
                                    P_SVRHA_UPLATE        IN TRANSAKCIJA_NALOG_PP.svrha_uplate%TYPE,
                                    P_SIFRA_PLACANJA      IN TRANSAKCIJA_NALOG_PP.sifra_placanja%TYPE,
                                    P_VRSTA_PROMENE       IN TRANSAKCIJA_NALOG_PP.vrsta_promene%TYPE,
                                    P_ID_RADNIK           IN TRANSAKCIJA_NALOG_PP.id_radnik%TYPE,
                                    P_SIFRA_RADNIKA      IN TRANSAKCIJA_NALOG_PP.sifra_radnika%TYPE,
                                    P_RB_TRANSAKCIJE      IN TRANSAKCIJA_NALOG_PP.redni_broj_transakcije%TYPE,
                                    P_ID_CPM              IN TRANSAKCIJA_NALOG_PP.id_cpm%TYPE,
                                    P_DATUM               IN TRANSAKCIJA_NALOG_PP.datum%TYPE,
                                    P_STATUS              IN TRANSAKCIJA_NALOG_PP.status%TYPE,
                                    P_DATUM_TR             IN TRANSAKCIJA_NALOG_PP.datum_transakcije%TYPE,
                                    P_DOSTAVA             IN TRANSAKCIJA_NALOG_PP.dostava%TYPE,
                                    P_HITAN_PAZAR         IN TRANSAKCIJA_NALOG_PP.hitan_pazar%TYPE,
                                    P_REFERENCA_NALOGA    IN TRANSAKCIJA_NALOG_PP.referenca_naloga%TYPE,
                                    P_NACIN_REALIZACIJE   IN TRANSAKCIJA_NALOG_PP.nacin_realizacije%TYPE,
                                    P_DALJA_REALIZACIJA   IN TRANSAKCIJA_NALOG_PP.dalja_realizacija%TYPE,
                                    P_SALTER                   IN TRANSAKCIJA_NALOG_PP.salter%TYPE DEFAULT NULL,    
                                    P_REZULTAT           OUT NUMBER,
                                    P_PORUKA             OUT VARCHAR2) IS
nObrada NUMBER;
sVrstaPromene VARCHAR(3); 
sOznakaPromene VARCHAR(1); 
IdCPMDan RAW(16);
Referenca RAW(16);
sDaljaRealizacija TRANSAKCIJA_NALOG_PP.dalja_realizacija%TYPE;
                                     
BEGIN
  
  P_REZULTAT := 1;
  P_PORUKA   := 'NEUSPEŠAN UPIS TRANSAKCIJA !';

  IdCPMDan := HEXTORAW(P_ID_CPM_DAN);
  Referenca := HEXTORAW(P_REFERENCA_NALOGA);  


  IF (P_VRSTA_PROMENE = 'P') THEN
    sVrstaPromene := 101; -- OVU INFORMACIJU BI MOZDA TREBALO SLATI SA KLIJENTA ??????
    sOznakaPromene := 'U';
  ELSIF (P_VRSTA_PROMENE = 'S') THEN -- NALOG BEZ POSTARINE
    sVrstaPromene := 102;
    sOznakaPromene := 'U';
  ELSIF (P_VRSTA_PROMENE = 'D') THEN -- NALOG BEZ POSTARINE
    sVrstaPromene := 104;
    sOznakaPromene := 'U';
  END IF;   
  
  IF P_NACIN_REALIZACIJE = 'OF' THEN
    sDaljaRealizacija := '2';
  ELSE
    sDaljaRealizacija :=   P_DALJA_REALIZACIJA;
  END IF;
  
  INSERT INTO TRANSAKCIJA_NALOG_PP
      (id_transakcija_nalog_pp, naziv_uplatioca, adresa_uplatioca, posta_uplatioca, naziv_primaoca, adresa_primaoca, posta_primaoca,
       tekuci_racun_primaoca, poziv_na_broj, iznos, sifra_placanja, svrha_uplate, vrsta_naloga, vrsta_promene, oznaka_promene, id_radnik, 
       redni_broj_transakcije, id_cpm, datum, status, datum_transakcije, sifra_radnika, model_poziva_na_broj, id_cpm_dan, dostava, hitan_pazar, 
       referenca_naloga, nacin_realizacije, dalja_realizacija, salter)
  VALUES
      (TRANSAKCIJA_NALOG_PP_SEQ.NEXTVAL, P_NAZIV_UPLATIOCA, P_ADRESA_UPLATIOCA, P_POSTA_UPLATIOCA, P_NAZIV_PRIMAOCA, P_ADRESA_PRIMAOCA, P_POSTA_PRIMAOCA,    
       P_ZIRO_RACUN_PRIMAOCA, P_POZIV_NA_BROJ, P_IZNOS, P_SIFRA_PLACANJA, P_SVRHA_UPLATE,  'P', sVrstaPromene, sOznakaPromene,  P_ID_RADNIK,  
       P_RB_TRANSAKCIJE, P_ID_CPM, P_DATUM, P_STATUS, P_DATUM_TR, P_SIFRA_RADNIKA, P_MODEL_POZIVA_NA_BROJ, IdCPMDan, P_DOSTAVA, P_HITAN_PAZAR, 
       Referenca, P_NACIN_REALIZACIJE, sDaljaRealizacija, P_SALTER);   

  P_REZULTAT := 0;
  P_PORUKA   := 'USPEŠAN UPIS TRANSAKCIJA !';  
  
EXCEPTION
  WHEN OTHERS THEN
    P_REZULTAT := 1;
    P_PORUKA   := SQLERRM;
  
END UNOS_TRANSAKCIJA_NALOG_PP;


PROCEDURE OBRADA_CPM_DANA (P_ID_CPM_DAN      IN VARCHAR2,
                            P_VRSTA_OBRADE   IN VARCHAR2,
                            P_ID_CPM          IN CPM_OBRADA.id_cpm%TYPE,
                            P_DATUM           IN CPM_OBRADA.datum%TYPE,
                            P_REZULTAT      OUT NUMBER,
                            P_PORUKA        OUT VARCHAR2) 
 IS
 nNalogPP NUMBER;
 nBanke   NUMBER;
 nKomitent NUMBER;
 nIdCPMDan NUMBER;
 IdCPMDan RAW(16);
 nIdCPMObrada NUMBER;
 
BEGIN
  
  P_REZULTAT := 1;
  P_PORUKA   := 'NEUSPEŠAN UPIS TRANSAKCIJE !';
   
  IdCPMDan := HEXTORAW(P_ID_CPM_DAN);

  SELECT COUNT (*)
    INTO nIdCPMDan
    FROM CPM_OBRADA
   WHERE id_cpm_dan = IdCPMDan;
     
   IF (P_VRSTA_OBRADE = 'N') THEN
     IF (nIdCPMdan = 0) THEN   
       INSERT INTO CPM_OBRADA
          (id_cpm_dan, id_cpm, datum, obrada_nalog_pp)
       VALUES 
          (IdCPMDan, P_ID_CPM, P_DATUM, 'D');
     ELSE
       UPDATE CPM_OBRADA
          SET obrada_nalog_pp ='D'
        WHERE id_cpm_dan = IdCPMDan
          AND NVL(obrada_nalog_pp, 'N') = 'N';

       IF SQL%ROWCOUNT <> 1 THEN
         RAISE_APPLICATION_ERROR(-20001, 'Obrada je veæ uraðena prethodnom iteracijom!!!');
       END IF;
     END IF;                 
   END IF;
       
   IF (P_VRSTA_OBRADE = 'B') THEN
     IF (nIdCPMdan = 0) THEN   
       INSERT INTO CPM_OBRADA
         (id_cpm_dan, id_cpm, datum, obrada_banke)
       VALUES 
         (IdCPMDan, P_ID_CPM, P_DATUM, 'D');
     ELSE
       UPDATE CPM_OBRADA
          SET obrada_banke ='D'
        WHERE id_cpm_dan = IdCPMDan
          AND NVL(obrada_banke, 'N') = 'N';

       IF SQL%ROWCOUNT <> 1 THEN
         RAISE_APPLICATION_ERROR(-20001, 'Obrada je veæ uraðena prethodnom iteracijom!!!');
       END IF;
     END IF;                 
   END IF; 
   
   
   IF (P_VRSTA_OBRADE = 'K') THEN
     IF (nIdCPMdan = 0) THEN   
       INSERT INTO CPM_OBRADA
         (id_cpm_dan, id_cpm, datum, obrada_komitenti)
       VALUES 
         (IdCPMDan, P_ID_CPM, P_DATUM, 'D');
     ELSE
       UPDATE CPM_OBRADA
          SET obrada_komitenti ='D'
        WHERE id_cpm_dan = IdCPMDan
          AND NVL(obrada_komitenti, 'N') = 'N';

       IF SQL%ROWCOUNT <> 1 THEN
         RAISE_APPLICATION_ERROR(-20001, 'Obrada je veæ uraðena prethodnom iteracijom!!!');
       END IF;
     END IF;                 
   END IF; 

  IF (P_VRSTA_OBRADE = 'P') THEN
     IF (nIdCPMdan = 0) THEN   
       INSERT INTO CPM_OBRADA
         (id_cpm_dan, id_cpm, datum, obrada_blagajne)
       VALUES 
         (IdCPMDan, P_ID_CPM, P_DATUM, 'D');
     ELSE
       UPDATE CPM_OBRADA
          SET obrada_blagajne ='D'
        WHERE id_cpm_dan = IdCPMDan
          AND NVL(obrada_blagajne, 'N') = 'N';

       IF SQL%ROWCOUNT <> 1 THEN
         RAISE_APPLICATION_ERROR(-20001, 'Obrada je veæ uraðena prethodnom iteracijom!!!');
       END IF;
     END IF;                 
   END IF;
     
  P_REZULTAT := 0;
  P_PORUKA   := 'USPEŠNO UPISANA OBRADA !';
  
EXCEPTION
  WHEN OTHERS THEN
    P_REZULTAT := 1;
    P_PORUKA   := SQLERRM;
    
END OBRADA_CPM_DANA; 

PROCEDURE KREIRANJE_PRIJAVE  (P_ID_PRIJAVA      IN NUMBER,
                              P_ID_CPM_DAN      IN VARCHAR2,
                              P_ID_CPM          IN CPM_OBRADA.id_cpm%TYPE,
                              P_DATUM           IN CPM_OBRADA.datum%TYPE,
                              P_POZIV_NA_BROJ   IN TRANSAKCIJA_NALOG_PP.poziv_na_broj%TYPE,
                              P_IZNOS           IN TRANSAKCIJA_NALOG_PP.iznos%TYPE,
                              P_REZULTAT       OUT NUMBER,
                              P_PORUKA         OUT VARCHAR2)  IS
sNazivPrimaoca VARCHAR(35);
sNazivUplatioca VARCHAR(35);
sSvrhaUplate VARCHAR(35);
sRacunRJ VARCHAR(20);
sPostanskiBroj VARCHAR(5); 
sNazivPoste VARCHAR(20); 
nIdTransakcijaNaloga NUMBER;
sSifraPlacanja VARCHAR(5);
sPozivNaBroj VARCHAR(20);
sRBTransakcije VARCHAR(5);
sNazivRJ VARCHAR(35); 
nIdRJ NUMBER; 
                                  
BEGIN
 
  P_REZULTAT := 1;
  P_PORUKA   := ' ';
  
  SELECT  SUBSTR(cpm.postanski_broj,1, 5) postanski_broj, SUBSTR(oc.naziv,1, 20) naziv 
      INTO  sPostanskiBroj, sNazivPoste      
      FROM  POSLOVNO_OKRUZENJE.CVOR_POSTANSKE_MREZE cpm, POSLOVNO_OKRUZENJE.ORGANIZACIONA_CELINA oc
     WHERE cpm.id_organizaciona_celina = oc.id_organizaciona_celina
       AND  cpm.id_cvor_postanske_mreze = P_ID_CPM;
       
  SELECT naziv_prijave, 
         DECODE(uplatilac,'POSTA','POSTA ' || sNazivPoste, 'RJ', 'RJ', uplatilac), 
         DECODE(primalac,'POSTA','POSTA ' || sNazivPoste, 'RJ', 'RJ', primalac)
    INTO sSvrhaUplate, sNazivUplatioca, sNazivPrimaoca
    FROM PRIJAVA 
   WHERE id_prijava = P_ID_PRIJAVA;
   
   PRIPREMA_PODATAKA_ZA_IBM_NOVO.RADNA_JEDINICA(P_ID_CPM,  nIdRJ, sNazivRJ);
   BEGIN
     SELECT tekuci_racun
       INTO sRacunRJ
      FROM TEKUCI_RACUN_RJ
     WHERE id_rj = nIdRJ;  
   EXCEPTION
     WHEN NO_DATA_FOUND THEN
       sRacunRJ := '200004350010200082'; -- ovo ne bi trebalo da se desi?????  
   END;
 
   sSifraPlacanja := '163';
   sPozivNaBroj:= sPostanskiBroj || LTRIM(TO_CHAR(P_DATUM,'DDMMYYYY'));
   
   IF (P_ID_PRIJAVA = '23') THEN -- TRGOVINA
     sSifraPlacanja := '165';
     sPozivNaBroj:= sPozivNaBroj || '7'; 
     sRBTransakcije := '9999';
   ELSIF (P_ID_PRIJAVA = '22') THEN  --  INTERNET USLUGE
     sRacunRJ :=  '200218421010200063';  -- racun RJ PTT NET 
     sRBTransakcije := '9998';
   ELSIF (P_ID_PRIJAVA = '17') THEN   -- TLEGRAMI
     sPozivNaBroj:= sPozivNaBroj || '12';
     sRBTransakcije := '9997';
   ELSIF (P_ID_PRIJAVA = '16') THEN   -- PTT PRIHODI
     sSifraPlacanja := '165';
     sPozivNaBroj:= sPozivNaBroj || '9'; 
     sRBTransakcije := '9996';  
   END IF;
   
   SELECT TRANSAKCIJA_NALOG_PP_SEQ.NEXTVAL
        INTO nIdTransakcijaNaloga
        FROM DUAL; 
                 
   INSERT INTO TRANSAKCIJA_NALOG_PP
           (id_transakcija_nalog_pp, naziv_uplatioca, adresa_uplatioca, posta_uplatioca, naziv_primaoca, adresa_primaoca, posta_primaoca,
            tekuci_racun_primaoca, poziv_na_broj, iznos, svrha_uplate, sifra_placanja, vrsta_naloga, vrsta_promene, oznaka_promene, id_radnik, redni_broj_transakcije, id_cpm, datum, status, datum_transakcije, sifra_radnika, model_poziva_na_broj, id_prijava, id_cpm_dan)
   VALUES
           (nIdTransakcijaNaloga, sNazivUplatioca, null, null, sNazivPrimaoca, null, null,    
            sRacunRJ, sPozivNaBroj, P_IZNOS, sSvrhaUplate, sSifraPlacanja,  'G', '106',  'U', 0, sRBTransakcije, P_ID_CPM, P_DATUM, 'V', SYSDATE(), '0000', '00', P_ID_PRIJAVA, HEXTORAW(P_ID_CPM_DAN)); 
       
  P_REZULTAT := 0;
  P_PORUKA   := 'USPEŠNO UPISANA OBRADA !';
EXCEPTION
  WHEN OTHERS THEN
    P_REZULTAT := 1;
    P_PORUKA   := SQLERRM;
    
END KREIRANJE_PRIJAVE;                                                                         

PROCEDURE PROVERA_CPM_DANA         (P_ID_CPM_DAN      IN VARCHAR2,
                                    P_VRSTA_OBRADE    IN VARCHAR2,
                                    P_BROJ           OUT NUMBER)
IS
nIdCPMDan NUMBER;
IdCPMDan RAW(16);

BEGIN
  
  IdCPMDan := HEXTORAW(P_ID_CPM_DAN);
  P_BROJ := -1; 
  IF (P_VRSTA_OBRADE = 'N') THEN
    SELECT COUNT (*)
      INTO nIdCPMDan
      FROM CPM_OBRADA
     WHERE id_cpm_dan = IdCPMDan
       AND obrada_nalog_pp = 'D';
  END IF;
       
  IF (P_VRSTA_OBRADE = 'B') THEN
    SELECT COUNT (*)
      INTO nIdCPMDan
      FROM CPM_OBRADA
     WHERE id_cpm_dan = IdCPMDan
       AND obrada_banke = 'D';
  END IF;
  
  IF (P_VRSTA_OBRADE = 'K') THEN
    SELECT COUNT (*)
      INTO nIdCPMDan
      FROM CPM_OBRADA
     WHERE id_cpm_dan = IdCPMDan
       AND obrada_komitenti = 'D';
  END IF;
  
  IF (P_VRSTA_OBRADE = 'P') THEN
    SELECT COUNT (*)
      INTO nIdCPMDan
      FROM CPM_OBRADA
     WHERE id_cpm_dan = IdCPMDan
       AND obrada_blagajne = 'D';
  END IF; 
  
  P_BROJ := nIdCPMDan;
        
EXCEPTION
  WHEN OTHERS THEN
   P_BROJ := -1; 
    
END PROVERA_CPM_DANA; 

/*PROCEDURE KREIRANJE_NALOGA  (P_REZULTAT       OUT NUMBER,
                             P_PORUKA         OUT VARCHAR2)
IS
CURSOR curPostaDan IS
  SELECT mv.id_cpm, TRUNC(mv.datum) datum
    FROM MANJAK_VISAK mv
   WHERE mv.id_transakcija_nalog_pp IS NULL ;
     

CURSOR curSlogovi (P_ID_POSTA IN NUMBER,P_DATUM IN DATE) IS 
  SELECT vrsta, SUBSTR(oc.naziv, 1, 35) naziv, id_rj, sum (iznos) iznos  
    FROM MANJAK_VISAK mv, POSLOVNO_OKRUZENJE.ORGANIZACIONA_CELINA oc
   WHERE mv.id_rj = oc.id_organizaciona_celina
     AND id_transakcija_nalog_pp IS NULL 
     AND mv.id_cpm= P_ID_POSTA
     AND TRUNC(mv.datum) = P_DATUM  
   GROUP BY vrsta, oc.naziv, id_rj ;     
     
recSlogovi curSlogovi%ROWTYPE;
recPoste curPostaDan%ROWTYPE;
sPostanskiBroj VARCHAR(5); 
sNazivPoste VARCHAR(20); 
sNazivUplatioca VARCHAR(35);
sSvrhaUplate VARCHAR(105);
sSifraPlacanja VARCHAR(3);
sZiroRacun   VARCHAR(18);
sPozivNaBroj VARCHAR(22);
sVrstaPromene VARCHAR(1);
sVrstaPrometa VARCHAR(5);
nIdTransakcijaNaloga NUMBER; 
 
BEGIN 

  P_REZULTAT := 1;
  P_PORUKA := ' ';
   
  OPEN curPostaDan; 
  LOOP
    FETCH curPostaDan INTO recPoste;
    EXIT WHEN curPostaDan%NOTFOUND;
    
    OPEN curSlogovi (recPoste.id_cpm, recPoste.datum);
    LOOP
      FETCH curSlogovi INTO recSlogovi;
      EXIT WHEN curSlogovi%NOTFOUND; 
      -- KREIRANJE PRIJAVE
      SELECT  LTRIM(oc.postanski_broj,5) postanski_broj, LTRIM(oc.naziv,20) naziv -- mozda treba izvuci i adresu poste i smestiti u naziv uplatioca ????
        INTO  sPostanskiBroj, sNazivPoste      
        FROM  POSLOVNO_OKRUZENJE.ORGANIZACIONA_CELINA oc
       WHERE oc.id_organizaciona_celina = recPoste.id_cpm;  
      
      sNazivUplatioca := 'POSTA ' || sNazivPoste; 
      IF recSlogovi.vrsta = 'M' THEN
        sSvrhaUplate := 'PRIJAVA MANJKA POŠTE' ;
        sSifraPlacanja := 165; 
        sVrstaPromene := 'I';
        sVrstaPrometa := 103;
        sPozivNaBroj :=  '00'||sPostanskiBroj || LTRIM(TO_CHAR(recPoste.datum,'DDMMYYYY'))|| '1'; 
      ELSE
        sSvrhaUplate := 'PRIJAVA VIŠKA POŠTE';
        sSifraPlacanja := 165; 
        sVrstaPromene := 'U';
        sVrstaPrometa := 103; 
        sPozivNaBroj :=  '00'||sPostanskiBroj || LTRIM(TO_CHAR(recPoste.datum,'DDMMYYYY'))|| '3';  
      END IF;
      
     
      
      SELECT tekuci_racun
        INTO sZiroRacun
        FROM TEKUCI_RACUN_POSTNET
       WHERE oc_vlasnik_tr = recSlogovi.id_rj;
        
      SELECT TRANSAKCIJA_NALOG_PP_SEQ.NEXTVAL
        INTO nIdTransakcijaNaloga
        FROM DUAL; 
         
      INSERT INTO TRANSAKCIJA_NALOG_PP
           (id_transakcija_nalog_pp, naziv_uplatioca, adresa_uplatioca, posta_uplatioca, naziv_primaoca, adresa_primaoca, posta_primaoca,
            ziro_racun_primaoca, poziv_na_broj, iznos, sifra_placanja, svrha_uplate,  id_cpm, vrsta_naloga, vrsta_promene, oznaka_promene, redni_broj_transakcije, id_radnik)
      VALUES
           (nIdTransakcijaNaloga, sNazivUplatioca, null, null, recSlogovi.naziv, null, null,     
            sZiroRacun, sPozivNaBroj, recSlogovi.iznos, sSifraPlacanja, sSvrhaUplate, sNazivPoste, recPoste.datum, recPoste.id_cpm , 'G', sVrstaPrometa, sVrstaPromene, null, '0000');   
      
      UPDATE MANJAK_VISAK mv
          SET mv.id_transakcija_nalog_pp = nIdTransakcijaNaloga
        WHERE mv.id_cpm = recPoste.id_cpm
          AND TRUNC(mv.datum) = recPoste.datum
          AND mv.vrsta = recSlogovi.vrsta;
                 
    END LOOP;
    CLOSE curSlogovi;
    
  END LOOP;
  CLOSE curPostaDan;
  
  P_REZULTAT := 0 ;
  P_PORUKA := 'OK ';

END KREIRANJE_NALOGA;       */                            

/*PROCEDURE KREIRANJE_GRUPNIH_NALOGA_BANKE
IS
  
  CURSOR curPostaDan IS
    SELECT DISTINCT b.id_cpm, TRUNC(b.datum) datum, b.vrsta_prometa
      FROM TRANSAKCIJA_BANKA b
     WHERE b.id_cpm = 2324 
     GROUP BY  b.id_cpm, TRUNC(b.datum), b.vrsta_prometa
     ORDER BY 1,2,3;
  
   CURSOR curSlogoviPromenaBanke(P_ID_POSTA IN NUMBER,P_OSNOV IN VARCHAR2,P_DATUM IN DATE) IS
     SELECT a.*, oc.naziv 
       FROM (
            SELECT b.id_cpm, b.sifra_transakcije, sum(b.iznos_transakcije)suma, b.id_transakcija_banka
              FROM TRANSAKCIJA_BANKA b
             WHERE b.id_cpm= P_ID_POSTA
               --AND TRUNC(b.datum) = P_DATUM    
               AND b.vrsta_prometa= P_OSNOV
               AND b.sifra_transakcije IN ('502', 'S497')
               AND b.kreiran_nalog IS NULL 
             GROUP BY b.id_cpm,b.sifra_transakcije ) a, POSLOVNO_OKRUZENJE.ORGANIZACIONA_CELINA oc 
      WHERE a.id_cpm = oc.id_organizaciona_celina;

 recPoste curPostaDan%ROWTYPE;
 recBanke curSlogoviPromenaBanke%ROWTYPE; 
 sumPromene NUMBER;
 sSvrhaUplate VARCHAR(105);
 sZiroRacun   VARCHAR(18);
 sPozivNaBroj VARCHAR(22);
 nIdTransakcijaNaloga NUMBER;   
BEGIN
   NULL;
   -- treba kreirati prijave naloga za banke i komitente
   OPEN curPostaDan; 
   
  LOOP --po postama
    FETCH curPostaDan INTO recPoste;
    EXIT WHEN curPostaDan%NOTFOUND;
     
    sumPromene := 0;
    OPEN curSlogoviPromenaBanke(recPoste.ID_CPM, recPoste.vrsta_prometa, recPoste.datum);--slogovi promene
    
    LOOP
      FETCH curSlogoviPromenaBanke INTO recBanke;          
      EXIT  WHEN curSlogoviPromenaBanke%NOTFOUND;       
      sZiroRacun := '1243543';
      sPozivNaBroj := '324235345467';
      BEGIN
          SELECT tb.predmet_transakcije
            INTO sSvrhaUplate 
            FROM TRANSAKCIJA_ZA_BANKU tb
           WHERE tb.sifra_transakcije = recBanke.sifra_transakcije ; 
      
          SELECT TRANSAKCIJA_NALOG_PP_SEQ.NEXTVAL
            INTO nIdTransakcijaNaloga
            FROM DUAL; 
            
          INSERT INTO TRANSAKCIJA_NALOG_PP
           (id_transakcija_nalog_pp, naziv_uplatioca, adresa_uplatioca, posta_uplatioca, naziv_primaoca, adresa_primaoca, posta_primaoca,
            ziro_racun_primaoca, poziv_na_broj, iznos, sifra_placanja, svrha_uplate, mesto_prijema, datum_prijema, id_cpm, vrsta_naloga, vrsta_promene, oznaka_promene, poslat,redni_broj_transakcije)
          VALUES
           (nIdTransakcijaNaloga, recBanke.naziv, null, null, null, null, null,    
            sZiroRacun, sPozivNaBroj, recBanke.suma, '106', sSvrhaUplate, recPoste.ID_CPM, recPoste.datum, recPoste.id_cpm, 'G', '106',  recPoste.vrsta_prometa, 'N', null);   
            
          UPDATE TRANSAKCIJA_BANKA tb
             SET tb.kreiran_nalog = 'D',
                 tb.id_transakcija_nalog_pp = nIdTransakcijaNaloga
           WHERE tb.id_transakcija_banka = recBanke.id_transakcija_banka;      
               
      EXCEPTION
       WHEN NO_DATA_FOUND THEN NULL;
      END;              
    END LOOP ;      
    
    CLOSE curSlogoviPromenaBanke; -- kraj obrade naloga za istu postu, dan i vrstu promene
    
  END LOOP;
  
  CLOSE curPostaDan; -- obradjene su sve poste

   
END KREIRANJE_GRUPNIH_NALOGA_BANKE ;


PROCEDURE KREIRANJE_NALOGA_KOMITENTI
IS
  
  CURSOR curPostaDan IS
    SELECT DISTINCT k.id_cpm, TRUNC(k.datum) datum
      FROM TRANSAKCIJA_KOMITENT k
     WHERE k.id_cpm = 2324 
     GROUP BY  k.id_cpm, TRUNC(k.datum)
     ORDER BY 1,2;
  
   CURSOR curSlogoviPromenaKomitent(P_ID_POSTA IN NUMBER,P_DATUM IN DATE) IS
     SELECT a.*, oc.naziv 
       FROM (
            SELECT k.id_cpm, k.sifra_transakcije, sum(k.iznos)suma, k.id_transakcija_komitent
              FROM TRANSAKCIJA_KOMITENT k
             WHERE k.id_cpm= P_ID_POSTA
               --AND TRUNC(k.datum) = P_DATUM    
              -- AND k.sifra_transakcije IN ('502', 'S497') 
             GROUP BY k.id_cpm,k.sifra_transakcije ) a, POSLOVNO_OKRUZENJE.ORGANIZACIONA_CELINA oc 
      WHERE a.id_cpm = oc.id_organizaciona_celina;

 recPoste curPostaDan%ROWTYPE;
 recKomitent curSlogoviPromenaKomitent%ROWTYPE; 
 sumPromene NUMBER;
 sSvrhaUplate VARCHAR(105);
 sZiroRacun   VARCHAR(18);
 sPozivNaBroj VARCHAR(22); 
 nIdTransakcijaNaloga NUMBER;   
BEGIN
   NULL;
   -- treba kreirati prijave naloga za banke i komitente
   OPEN curPostaDan; 
   
  LOOP --po postama
    FETCH curPostaDan INTO recPoste;
    EXIT WHEN curPostaDan%NOTFOUND;
     
    sumPromene := 0;
    OPEN curSlogoviPromenaKomitent(recPoste.ID_CPM, recPoste.datum);--slogovi promene
    
    LOOP
      FETCH curSlogoviPromenaKomitent INTO recKomitent;          
      EXIT  WHEN curSlogoviPromenaKomitent%NOTFOUND;  -- ne radi dobro kad je kursor prazan !!!!!      
      
      BEGIN
          SELECT tk.opis
            INTO sSvrhaUplate 
            FROM TRANSAKCIJA_ZA_KOMITENTA tk 
           WHERE tk.sifra_transakcije = recKomitent.sifra_transakcije ; 
          
          SELECT TRANSAKCIJA_NALOG_PP_SEQ.NEXTVAL
            INTO nIdTransakcijaNaloga
            FROM DUAL; 
            
          INSERT INTO TRANSAKCIJA_NALOG_PP
           (id_transakcija_nalog_pp, naziv_uplatioca, adresa_uplatioca, posta_uplatioca, naziv_primaoca, adresa_primaoca, posta_primaoca,
            ziro_racun_primaoca, poziv_na_broj, iznos, sifra_placanja, svrha_uplate, mesto_prijema, datum_prijema, id_cpm, vrsta_naloga, vrsta_promene, oznaka_promene, poslat,redni_broj_transakcije)
          VALUES
           (nIdTransakcijaNaloga, recKomitent.naziv, null, null, null, null, null,    
            sZiroRacun, sPozivNaBroj, recKomitent.suma, '106', sSvrhaUplate, recPoste.ID_CPM, recPoste.datum, recPoste.id_cpm, 'G', '106', 'U', 'N', null);   
          
          UPDATE TRANSAKCIJA_KOMITENT tk
             SET tk.kreiran_nalog = 'D',
                 tk.id_transakcija_nalog_pp = nIdTransakcijaNaloga
           WHERE tk.id_transakcija_komitent = recKomitent.id_transakcija_komitent;       
      EXCEPTION
       WHEN NO_DATA_FOUND THEN NULL;
      END;    
                
    END LOOP ;      
    
    CLOSE curSlogoviPromenaKomitent; -- kraj obrade naloga za istu postu, dan i vrstu promene
    
  END LOOP;
  
  CLOSE curPostaDan; -- obradjene su sve poste

   
END KREIRANJE_NALOGA_KOMITENTI;
 
PROCEDURE PRIPREMA_NALOGA_ZA_TRANSFER ( P_REZULTAT  OUT NUMBER) IS

 
  CURSOR curVodeci002 IS 
     SELECT a.*, oc.postanski_broj||'00' SIFRA_DOMICILA_PROMENE, 
        '0'|| id_radna_jedinica(oc.id_organizaciona_celina) ||'0000' sifra_primaoca, oc.naziv posta
       FROM (  
         SELECT DISTINCT t.id_cpm, t.datum_prijema, DECODE(t.oznaka_promene,'I',2,'U',1) oznaka_uplate_isplate
           FROM TRANSAKCIJA_NALOG_PP t
          WHERE t.poslat= 'N'
          GROUP BY t.id_cpm,t.datum_prijema, t.oznaka_promene
          ORDER BY 1,2,3
             )a, POSLOVNO_OKRUZENJE.ORGANIZACIONA_CELINA oc
      WHERE a.id_cpm = oc.id_organizaciona_celina;
 
  CURSOR curSlogoviPromena(P_ID_POSTA IN NUMBER,P_OSNOV IN VARCHAR2,P_DATUM IN DATE) IS
     SELECT t.naziv_primaoca , t.adresa_primaoca, t.posta_primaoca, t.naziv_uplatioca, t.adresa_uplatioca, t.posta_uplatioca,
           t.ziro_racun_primaoca, t.iznos, t.svrha_uplate, t.sifra_placanja, t.poziv_na_broj, t.mesto_prijema, t.datum_prijema, t.vrsta_promene,
           t.id_radnik, t.redni_broj_transakcije
      FROM TRANSAKCIJA_NALOG_PP t
     WHERE t.poslat = 'N'
       --AND t.datum_prijema=P_DATUM    
       AND t.id_cpm=P_ID_POSTA    
       AND t.oznaka_promene=DECODE(P_OSNOV,1,'U',2,'I');

 recVodeci002 curVodeci002%ROWTYPE;
 recSlogoviPromena curSlogoviPromena%ROWTYPE;
 sSlog VARCHAR2(500);
 sKljuc VARCHAR2(27);
 nBrojac NUMBER;
 sSifraPosiljaoca VARCHAR (7);
 sTotal VARCHAR(15);
 sVrstaPrometa VARCHAR(3);
 nRedniBrojSloga NUMBER ; -- broji sve slogove 1 poruke
 nRedniBrojDnevnika NUMBER;
 nSumarniBrojKomadaSlogova NUMBER; -- broji stvarne slogove grupe (bez naslovnog i kranjeg sloga poruke)
 UKUPNO NUMBER;
 nIdDnevnik NUMBER;
 cPom VARCHAR2(30);
 sumIznosa NUMBER (18,2);
 
BEGIN
  
  P_REZULTAT := 1;
           -- obrada naloga : posta, dan, vrsta_promene (iplata/isplata)  ----
  
  OPEN curVodeci002; --vodeci slog posla
   
  LOOP --po postama
    FETCH curVodeci002 INTO recVodeci002;
    EXIT WHEN curVodeci002%NOTFOUND;
     
    SELECT DNEVNIK_NALOGA_PP_SEQ.NEXTVAL
      INTO nIdDnevnik 
      FROM DUAL;
    
    INSERT INTO DNEVNIK_NALOGA_PP(ID_DNEVNIK_NALOGA_PP, ZA_DAN, ID_CPM, DATUM_PRIPREME, DATUM_SLANJA, FAJL) 
                           VALUES(nIdDnevnik, TO_DATE(SYSDATE,'DD.MM.YYYY'), 1, SYSDATE , NULL, NULL);
                  
    nRedniBrojSloga:=2;
    nRedniBrojDnevnika :=1;
   -- kljuc svakog sloga je duzine 27 : ggmmdd  || hhmmss || 'PPP' || idterminala? duz(4) || brojac (duz 8) 
    sKljuc := '';
    sKljuc := TO_CHAR(SYSDATE,'YYMMDD') || TO_CHAR(SYSDATE,'HHMISS')|| 'PPP'||'9999'; 
    
    sSlog:='';
    sSlog:=sKljuc||LPAD(TO_CHAR(nRedniBrojSloga),7,'0') ||'002'||recVodeci002.sifra_domicila_promene ||recVodeci002.sifra_primaoca || ltrim(TO_CHAR(recVodeci002.datum_prijema,'YYMMDD'));
    sSlog:=sSlog||'01'||recVodeci002.oznaka_uplate_isplate||'01'||'9999'||'0'||'001'||'001' ;
    sSlog:=RPAD(sSlog,80,' ');  
       
    INSERT INTO STAVKA_DNEVNIK_NALOG_PP(ID_DNEVNIK_NALOGA_PP, VREDNOST, REDNI_BROJ) 
                                 VALUES(nIdDnevnik, sSlog,nRedniBrojSloga);
    
    nRedniBrojSloga:=nRedniBrojSloga+1;                                  
    nSumarniBrojKomadaSlogova:=1;
     -- za svaku postu generisem naloge odredjene promene
    sumIznosa := 0;
    OPEN curSlogoviPromena(recVodeci002.ID_CPM, recVodeci002.oznaka_uplate_isplate, recVodeci002.datum_prijema);--slogovi promene
    
    LOOP
      FETCH curSlogoviPromena INTO recSlogoviPromena;          
      EXIT  WHEN curSlogoviPromena%NOTFOUND;       
      
      sSlog:=sKljuc||LPAD(TO_CHAR(nRedniBrojSloga),7,'0') || '003'||LPAD(recSlogoviPromena.id_radnik,4,0) || LPAD(recSlogoviPromena.redni_broj_transakcije,4,0);
      sSlog:=sSlog||recSlogoviPromena.vrsta_promene ||'0'; -- heder
       
      sSlog:=sSlog||RPAD(recSlogoviPromena.naziv_uplatioca,35,' ') || RPAD(recSlogoviPromena.adresa_uplatioca,35,' ') || RPAD(recSlogoviPromena.posta_uplatioca, 35, ' ');
      sSlog:=sSlog||RPAD(recSlogoviPromena.naziv_primaoca,35,' ') || RPAD(recSlogoviPromena.adresa_primaoca,35,' ') || RPAD(recSlogoviPromena.posta_primaoca,35,' ');
      sSlog:=sSlog||RPAD(recSlogoviPromena.ziro_racun_primaoca,18,' ')||'DIN';
      
      sumIznosa := sumIznosa + recSlogoviPromena.iznos;
     --  DBMS_OUTPUT.PUT_LINE (TO_CHAR(REPLACE(recSlogoviPromena.iznos,',','.'))); 
      sSlog:=sSlog||FORMAT_IZNOS (recSlogoviPromena.iznos, 15);
      sSlog:=sSlog|| RPAD(recSlogoviPromena.svrha_uplate,105,' ') || recSlogoviPromena.sifra_placanja;
      sSlog:=sSlog|| RPAD(recSlogoviPromena.poziv_na_broj,20,' ') || RPAD(recSlogoviPromena.mesto_prijema,20,' ');
      sSlog:=sSlog|| TO_CHAR(recSlogoviPromena.datum_prijema,'YYYYMMDD') || TO_CHAR(recSlogoviPromena.datum_prijema,'YYYYMMDD');  
      --sSlog:=RPAD(sSlog,80,' ');                          
      
      INSERT INTO STAVKA_DNEVNIK_NALOG_PP(ID_DNEVNIK_NALOGA_PP, VREDNOST, REDNI_BROJ) 
                                   VALUES(nIdDnevnik, sSlog,nRedniBrojSloga);
      nRedniBrojSloga:=nRedniBrojSloga+1;
      nSumarniBrojKomadaSlogova:=nSumarniBrojKomadaSlogova+1;
                    
    END LOOP ;      
    
    CLOSE curSlogoviPromena; -- kraj obrade naloga za istu postu, dan i vrstu promene
    
    nSumarniBrojKomadaSlogova:=nSumarniBrojKomadaSlogova+1;
    
    sSlog:=sKljuc||LPAD(TO_CHAR(nRedniBrojSloga),7,'0') || '992'||recVodeci002.SIFRA_DOMICILA_PROMENE ||recVodeci002.SIFRA_PRIMAOCA || LTRIM(TO_CHAR(recVodeci002.datum_prijema,'YYMMDD'));
    sSlog:=sSlog||'01'||recVodeci002.oznaka_uplate_isplate ||'01'||'9999';
    
    sSlog:=sSlog||LPAD(TO_CHAR(nSumarniBrojKomadaSlogova),7,'0');
    sSlog:=sSlog||FORMAT_IZNOS (sumIznosa, 15);
    
    sSlog:=sSlog||'000000000000000'||'001';
    --sSlog:=RPAD(sSlog,80,' ');
    
    INSERT INTO STAVKA_DNEVNIK_NALOG_PP(ID_DNEVNIK_NALOGA_PP, VREDNOST, REDNI_BROJ) 
                                  VALUES(nIdDnevnik, sSlog,nRedniBrojSloga);             
                                                        
    nRedniBrojSloga:=nRedniBrojSloga+1;
       
    UPDATE TRANSAKCIJA_NALOG_PP
       SET poslat='D',
           id_dnevnik_naloga_pp = nIdDnevnik
     WHERE id_cpm=recVodeci002.id_cpm
       AND datum_prijema = recVodeci002.datum_prijema
       AND oznaka_promene = DECODE(recVodeci002.oznaka_uplate_isplate,1,'U',2,'I');  
  
      --PRVI 001
    sSlog:='';
    sSlog:=sKljuc||LPAD(TO_CHAR(1),7,'0') || '001'||TO_CHAR(SYSDATE,'YYMMDD')|| recVodeci002.sifra_primaoca ||'VAC0000'||LPAD(TO_CHAR(nRedniBrojSloga),7,'0');
    sSlog:=sSlog||'9999';
    sSlog:=RPAD(sSlog,80,' ');
   
    INSERT INTO STAVKA_DNEVNIK_NALOG_PP(ID_DNEVNIK_NALOGA_PP, VREDNOST, REDNI_BROJ) 
                                 VALUES(nIdDnevnik, sSlog,1);

                                                
    --POSLEDNJI 991
    sSlog:=sKljuc||LPAD(TO_CHAR(nRedniBrojSloga),7,'0') ||'991'||TO_CHAR(SYSDATE,'YYMMDD')||recVodeci002.sifra_primaoca||'VAC0000'|| LPAD(TO_CHAR(nRedniBrojSloga),7,'0');
    sSlog:=sSlog||FORMAT_IZNOS (sumIznosa, 15);
    sSlog:=RPAD(sSlog,80,' ');
  
    INSERT INTO STAVKA_DNEVNIK_NALOG_PP(ID_DNEVNIK_NALOGA_PP, VREDNOST, REDNI_BROJ) 
                                  VALUES(nIdDnevnik, sSlog,nRedniBrojSloga);
                            
  
  END LOOP;
  
  CLOSE curVodeci002; -- obradjene su sve poste
 
  P_REZULTAT:=0;
   
END PRIPREMA_NALOGA_ZA_TRANSFER;



PROCEDURE PRIPREMA_DNEVNIKA_ZA_TRANSFER ( P_REZULTAT  OUT NUMBER) IS

 
  CURSOR curVodeci002 IS 
     SELECT a.*, oc.postanski_broj||'00' SIFRA_DOMICILA_PROMENE, 
        '0'|| id_radna_jedinica(oc.id_organizaciona_celina) ||'0000' sifra_primaoca, oc.naziv posta
       FROM (  
         SELECT DISTINCT k.id_cpm, trunc(k.datum) datum, k.sifra_komitenta -- KOD KOMITENATA IMAMO SAMO UPLATU, PA GRUPISEM PO POSTA,DAN, SIFRA KOMITENTA !!!!
           FROM TRANSAKCIJA_KOMITENT k
          WHERE k.id_dnevnik_transakcija IS NULL
           ORDER BY 1,2, 3
             )a, POSLOVNO_OKRUZENJE.ORGANIZACIONA_CELINA oc
      WHERE a.id_cpm = oc.id_organizaciona_celina;
 
  CURSOR curSlogoviPromena(P_ID_POSTA IN NUMBER, P_DATUM IN DATE, P_SIFRA_KOM VARCHAR) IS
     SELECT k.tekuci_racun, k.poziv_na_broj, k.iznos, k.procenat_popusta, k.iznos_sa_popustom, k.sifra_komitenta,
            k.sifra_transakcije, k.redni_broj_transakcije, k.id_radnik
      FROM TRANSAKCIJA_KOMITENT k
     WHERE k.id_dnevnik_transakcija IS NULL
       AND trunc (k.datum)=P_DATUM    
       AND k.id_cpm=P_ID_POSTA
       AND k.sifra_komitenta = P_SIFRA_KOM;    
      
 recVodeci002 curVodeci002%ROWTYPE;
 recSlogoviPromena curSlogoviPromena%ROWTYPE;
 sSlog VARCHAR2(500);
 sKljuc VARCHAR2(27);
 nBrojac NUMBER;
 sSifraPosiljaoca VARCHAR (7);
 sTotal VARCHAR(15);
 sVrstaPrometa VARCHAR(3);
 nRedniBrojSloga NUMBER ; -- broji sve slogove 1 poruke
 nRedniBrojDnevnika NUMBER;
 nSumarniBrojKomadaSlogova NUMBER; -- broji stvarne slogove grupe (bez naslovnog i kranjeg sloga poruke)
 UKUPNO NUMBER;
 nIdDnevnik NUMBER;
 cPom VARCHAR2(30);
 sumIznosa NUMBER ;
 sVrstaKom VARCHAR(1);
 
BEGIN
  
  P_REZULTAT := 1;
           -- obrada dnevnika : posta, dan  ----
  
  OPEN curVodeci002; --vodeci slog posla
   
  LOOP --po postama
    FETCH curVodeci002 INTO recVodeci002;
    EXIT WHEN curVodeci002%NOTFOUND;
     
    SELECT DNEVNIK_TRANSAKCIJA_SEQ.NEXTVAL
      INTO nIdDnevnik 
      FROM DUAL;
   
    INSERT INTO DNEVNIK_TRANSAKCIJA(ID_DNEVNIK_TRANSAKCIJA, ZA_DAN, ID_CPM, DATUM_PRIPREME, DATUM_SLANJA, FAJL) 
                           VALUES(nIdDnevnik, TO_DATE(SYSDATE,'DD.MM.YYYY'), 1, SYSDATE , NULL, NULL);
                  
    nRedniBrojSloga:=2;
    nRedniBrojDnevnika :=1;
   -- kljuc svakog sloga je duzine 27 : ggmmdd  || hhmmss || 'PPP' || idterminala? duz(4) || brojac (duz 8) 
    sKljuc := '';
    sKljuc := TO_CHAR(SYSDATE,'YYMMDD') || TO_CHAR(SYSDATE,'HHMISS')|| 'PPP'||'9999'; 
    
    sSlog:='';
    sSlog:=sKljuc||LPAD(TO_CHAR(nRedniBrojSloga),7,'0') ||'002'||recVodeci002.sifra_domicila_promene ||recVodeci002.sifra_primaoca || ltrim(TO_CHAR(recVodeci002.datum,'YYMMDD'));
    sSlog:=sSlog||'01'||'1'||'01'||'9999'||'0'||'001'||'002' ; -- SIFARNIK U pOSTnET-U JE DRUGACIJI, trenutno svi imaju sifru = 002 ???????
    sSlog:=RPAD(sSlog,80,' ');  
       
    INSERT INTO STAVKA_DNEVNIK_TRANSAKCIJA(ID_DNEVNIK_TRANSAKCIJA, VREDNOST, REDNI_BROJ) 
                                 VALUES(nIdDnevnik, sSlog,nRedniBrojSloga);
    
    nRedniBrojSloga:=nRedniBrojSloga+1;                                  
    nSumarniBrojKomadaSlogova:=1;
     -- za svaku postu generisem naloge odredjene promene
    sumIznosa := 0;
    OPEN curSlogoviPromena(recVodeci002.ID_CPM, recVodeci002.datum, recVodeci002.sifra_komitenta );--slogovi promene po komitentima
    
    LOOP
      FETCH curSlogoviPromena INTO recSlogoviPromena;          
      EXIT  WHEN curSlogoviPromena%NOTFOUND;       
      
      sSlog:=sKljuc||LPAD(TO_CHAR(nRedniBrojSloga),7,'0') || '003'||LPAD(recSlogoviPromena.id_radnik,4,0) || LPAD(recSlogoviPromena.redni_broj_transakcije,4,0);
      sSlog:=sSlog||recSlogoviPromena.sifra_transakcije ||'0'; -- vrsta_ promene je definisana uz sifre komitenata????? heder
       
     -- OVAJ DEO ZAVISI OD VRSTE KOMITENTA
       -- EDB i KDS imaju istu strukturu
       IF (recSlogoviPromena.sifra_komitenta = 037) THEN
         sSlog:=sSlog|| RPAD(recSlogoviPromena.poziv_na_broj,25,' ') || FORMAT_IZNOS (recSlogoviPromena.iznos, 15);
         sSlog:=sSlog|| FORMAT_IZNOS (recSlogoviPromena.procenat_popusta, 4)|| FORMAT_IZNOS (recSlogoviPromena.iznos_sa_popustom, 12);
       ELSE
         sSlog:=sSlog|| RPAD(recSlogoviPromena.poziv_na_broj,16,' ') || FORMAT_IZNOS (recSlogoviPromena.iznos, 12);
       END IF;
     -- sumIznosa := sumIznosa + recSlogoviPromena.iznos;

     -- sSlog:=sSlog||FORMAT_IZNOS (recSlogoviPromena.iznos, 15);
      --sSlog:=sSlog|| RPAD(recSlogoviPromena.svrha_uplate,105,' ') || recSlogoviPromena.sifra_placanja;
     -- sSlog:=sSlog|| RPAD(recSlogoviPromena.poziv_na_broj,20,' ') || RPAD(recSlogoviPromena.mesto_prijema,20,' ');
      --sSlog:=sSlog|| TO_CHAR(recSlogoviPromena.datum_prijema,'YYYYMMDD') || TO_CHAR(recSlogoviPromena.datum_prijema,'YYYYMMDD');  
      --sSlog:=RPAD(sSlog,80,' ');                          
      
      INSERT INTO STAVKA_DNEVNIK_TRANSAKCIJA(ID_DNEVNIK_TRANSAKCIJA, VREDNOST, REDNI_BROJ) 
                                   VALUES(nIdDnevnik, sSlog,nRedniBrojSloga);
      nRedniBrojSloga:=nRedniBrojSloga+1;
      nSumarniBrojKomadaSlogova:=nSumarniBrojKomadaSlogova+1;
                    
    END LOOP ;      
    
    CLOSE curSlogoviPromena; -- kraj obrade naloga za istu postu, dan i vrstu promene
    
    nSumarniBrojKomadaSlogova:=nSumarniBrojKomadaSlogova+1;
    
    sSlog:=sKljuc||LPAD(TO_CHAR(nRedniBrojSloga),7,'0') || '992'||recVodeci002.SIFRA_DOMICILA_PROMENE ||recVodeci002.SIFRA_PRIMAOCA || LTRIM(TO_CHAR(recVodeci002.datum,'YYMMDD'));
    sSlog:=sSlog||'01'||'1'||'01'||'9999';  -- umesto '01' treba da stoji vrsta prometa za tog komitenta koja ga i odredjuje, jer u PostNet-u, svi komunalci su 02
    
    sSlog:=sSlog||LPAD(TO_CHAR(nSumarniBrojKomadaSlogova),7,'0');
    sSlog:=sSlog||FORMAT_IZNOS (sumIznosa, 15);
    
    sSlog:=sSlog||'000000000000000'||recVodeci002.sifra_komitenta;
    --sSlog:=RPAD(sSlog,80,' ');
    
    INSERT INTO STAVKA_DNEVNIK_TRANSAKCIJA(ID_DNEVNIK_TRANSAKCIJA, VREDNOST, REDNI_BROJ) 
                                  VALUES(nIdDnevnik, sSlog,nRedniBrojSloga);             
                                                        
    nRedniBrojSloga:=nRedniBrojSloga+1;
       
    UPDATE TRANSAKCIJA_KOMITENT
       SET id_dnevnik_transakcija = nIdDnevnik
     WHERE id_cpm=recVodeci002.id_cpm
       AND TRUNC(datum) = recVodeci002.datum
       AND sifra_komitenta = recVodeci002.sifra_komitenta;                         
    
   
    
  END LOOP;
  
  CLOSE curVodeci002; -- obradjene su sve poste
    --PRVI 001
    sSlog:='';
    sSlog:=sKljuc||LPAD(TO_CHAR(1),7,'0') || '001'||TO_CHAR(SYSDATE,'YYMMDD')|| recVodeci002.sifra_primaoca ||'VAC0000'||LPAD(TO_CHAR(nRedniBrojSloga),7,'0');
    sSlog:=sSlog||'9999';
    sSlog:=RPAD(sSlog,80,' ');
   
    INSERT INTO STAVKA_DNEVNIK_TRANSAKCIJA(ID_DNEVNIK_TRANSAKCIJA, VREDNOST, REDNI_BROJ) 
                                 VALUES(nIdDnevnik, sSlog,1);

                                                
    --POSLEDNJI 991
    sSlog:=sKljuc||LPAD(TO_CHAR(nRedniBrojSloga),7,'0') ||'991'||TO_CHAR(SYSDATE,'YYMMDD')||recVodeci002.sifra_primaoca||'VAC0000'|| LPAD(TO_CHAR(nRedniBrojSloga),7,'0');
    sSlog:=sSlog||FORMAT_IZNOS (sumIznosa, 15);
    sSlog:=RPAD(sSlog,80,' ');
  
    INSERT INTO STAVKA_DNEVNIK_TRANSAKCIJA(ID_DNEVNIK_TRANSAKCIJA, VREDNOST, REDNI_BROJ) 
                                  VALUES(nIdDnevnik, sSlog,nRedniBrojSloga);
 
  P_REZULTAT:=0;
   
END PRIPREMA_DNEVNIKA_ZA_TRANSFER;


FUNCTION ID_RADNA_JEDINICA (P_ID_ORGANIZACIONA_CELINA IN NUMBER)RETURN NUMBER
IS
  nIdRJ NUMBER;
BEGIN

  SELECT id_organizaciona_celina
    INTO nIdRJ
  FROM POSLOVNO_OKRUZENJE.ORGANIZACIONA_CELINA
  WHERE id_vrsta_oc=5
  START WITH id_organizaciona_celina=P_ID_ORGANIZACIONA_CELINA
  CONNECT BY PRIOR id_nadredjena_oc=id_organizaciona_celina;

  RETURN nIdRJ;

END ID_RADNA_JEDINICA;

FUNCTION FORMAT_IZNOS(P_BROJ IN NUMBER, P_DUZINA IN NUMBER) RETURN VARCHAR2 
IS
 cPom VARCHAR2(100);
BEGIN

-- DBMS_OUTPUT.PUT_LINE (TO_CHAR(p_BROJ));  
 SELECT LPAD(LTRIM(TO_CHAR(TRUNC(REPLACE(P_BROJ,',','.'),0))),(P_DUZINA - 2),'0')||SUBSTR(TO_CHAR(ROUND(REPLACE(P_BROJ,',','.'),2)-TRUNC(REPLACE(P_BROJ,',','.'),0),'.00'),3)
    INTO cPom
   FROM DUAL;
-- DBMS_OUTPUT.PUT_LINE (cPom); 
  RETURN cPom;

END FORMAT_IZNOS;*/























                                                                         
 --- SASINE TRANSAKCIJE                                      
  /*PROCEDURE UNOS_TRANSAKCIJA_ZA_BANKU(P_ID_VRSTA_TRANSAKCIJE        IN TRANSAKCIJA_ZA_BANKU.ID_VRSTA_TRANSAKCIJE%TYPE,
                                      P_ID_UGOVORENA_USLUGA         IN TRANSAKCIJA_ZA_BANKU.ID_UGOVORENA_USLUGA%TYPE,
                                      P_SIFRA_BANKE_KOMITENTA       IN TRANSAKCIJA_ZA_BANKU.SIFRA_BANKE_KOMITENTA%TYPE,
                                      P_SIFRA_BANKE                 IN TRANSAKCIJA_ZA_BANKU.SIFRA_BANKE%TYPE,
                                      P_SIFRA_TRANSAKCIJE           IN TRANSAKCIJA_ZA_BANKU.SIFRA_TRANSAKCIJE%TYPE,
                                      P_PREDMET_TRANSAKCIJE         IN TRANSAKCIJA_ZA_BANKU.PREDMET_TRANSAKCIJE%TYPE,
                                      P_ONLINE_DN                   IN TRANSAKCIJA_ZA_BANKU.ONLINE_DN%TYPE,
                                      P_AUTORIZACIJA_DN             IN TRANSAKCIJA_ZA_BANKU.AUTORIZACIJA_DN%TYPE,
                                      P_MODEL_TEKUCI_RACUN          IN TRANSAKCIJA_ZA_BANKU.MODEL_TEKUCI_RACUN%TYPE,
                                      P_MODEL_BROJ_CEKA             IN TRANSAKCIJA_ZA_BANKU.MODEL_BROJ_CEKA%TYPE,
                                      P_MINIMALNI_IZNOS             IN TRANSAKCIJA_ZA_BANKU.MINIMALNI_IZNOS%TYPE,
                                      P_MAKSIMALNI_IZNOS            IN TRANSAKCIJA_ZA_BANKU.MAKSIMALNI_IZNOS%TYPE,
                                      P_LICNI_DOKUMENT_DN           IN TRANSAKCIJA_ZA_BANKU.LICNI_DOKUMENT_DN%TYPE,
                                      P_IME_PREZIME_DN              IN TRANSAKCIJA_ZA_BANKU.IME_PREZIME_DN%TYPE,
                                      P_ADRESA_DN                   IN TRANSAKCIJA_ZA_BANKU.ADRESA_DN%TYPE,
                                      P_STANJE_NAKON_TRANSAKCIJE_DN IN TRANSAKCIJA_ZA_BANKU.STANJE_NAKON_TRANSAKCIJE_DN%TYPE,
                                      P_VRSTA_OVERE                 IN TRANSAKCIJA_ZA_BANKU.VRSTA_OVERE%TYPE,
                                      P_REDNI_BROJ_REDA_DN          IN TRANSAKCIJA_ZA_BANKU.REDNI_BROJ_REDA_DN%TYPE,
                                      P_TRANSFER_DN                 IN TRANSAKCIJA_ZA_BANKU.TRANSFER_DN%TYPE,
                                      P_TRANSFER_FORMAT             IN TRANSAKCIJA_ZA_BANKU.TRANSFER_FORMAT%TYPE,
                                      P_TRANSFER_EKSTENZIJA         IN TRANSAKCIJA_ZA_BANKU.TRANSFER_EKSTENZIJA%TYPE,
                                      P_TRANSFER_KANAL              IN TRANSAKCIJA_ZA_BANKU.TRANSFER_KANAL%TYPE,
                                      P_ID_TRANSAKCIJA_ZA_BANKU     OUT TRANSAKCIJA_ZA_BANKU.ID_TRANSAKCIJA_ZA_BANKU%TYPE,
                                      P_REZULTAT                    OUT NUMBER,
                                      P_PORUKA                      OUT VARCHAR2) IS

  BEGIN
    P_ID_TRANSAKCIJA_ZA_BANKU := -1;
    P_REZULTAT := 1;
    P_PORUKA   := 'NEUSPEŠAN UPIS TRANSAKCIJE ZA BANKU!';
  
    SELECT TRANSAKCIJA_ZA_BANKU_SEQ.NEXTVAL
      INTO P_ID_TRANSAKCIJA_ZA_BANKU
      FROM DUAL;
  
    INSERT INTO NOVCANO_POSLOVANJE.TRANSAKCIJA_ZA_BANKU
      (ID_TRANSAKCIJA_ZA_BANKU,
       ID_VRSTA_TRANSAKCIJE,
       ID_UGOVORENA_USLUGA,
       SIFRA_BANKE_KOMITENTA,
       SIFRA_BANKE,
       SIFRA_TRANSAKCIJE,
       PREDMET_TRANSAKCIJE,
       ONLINE_DN,
       AUTORIZACIJA_DN,
       MODEL_TEKUCI_RACUN,
       MODEL_BROJ_CEKA,
       MINIMALNI_IZNOS,
       MAKSIMALNI_IZNOS,
       LICNI_DOKUMENT_DN,
       IME_PREZIME_DN,
       ADRESA_DN,
       STANJE_NAKON_TRANSAKCIJE_DN,
       VRSTA_OVERE,
       REDNI_BROJ_REDA_DN,
       TRANSFER_DN,
       TRANSFER_FORMAT,
       TRANSFER_EKSTENZIJA,
       TRANSFER_KANAL)
    VALUES
      (P_ID_TRANSAKCIJA_ZA_BANKU,
       P_ID_VRSTA_TRANSAKCIJE,
       P_ID_UGOVORENA_USLUGA,
       P_SIFRA_BANKE_KOMITENTA,
       P_SIFRA_BANKE,
       P_SIFRA_TRANSAKCIJE,
       P_PREDMET_TRANSAKCIJE,
       P_ONLINE_DN,
       P_AUTORIZACIJA_DN,
       P_MODEL_TEKUCI_RACUN,
       P_MODEL_BROJ_CEKA,
       P_MINIMALNI_IZNOS,
       P_MAKSIMALNI_IZNOS,
       P_LICNI_DOKUMENT_DN,
       P_IME_PREZIME_DN,
       P_ADRESA_DN,
       P_STANJE_NAKON_TRANSAKCIJE_DN,
       P_VRSTA_OVERE,
       P_REDNI_BROJ_REDA_DN,
       P_TRANSFER_DN,
       P_TRANSFER_FORMAT,
       P_TRANSFER_EKSTENZIJA,
       P_TRANSFER_KANAL);
  
    P_REZULTAT := 0;
    P_PORUKA   := 'USPEŠNO UPISANA TRANSAKCIJA ZA BANKU!';
  
  EXCEPTION
    WHEN OTHERS THEN
      P_ID_TRANSAKCIJA_ZA_BANKU := -1;
      P_REZULTAT := 1;
      P_PORUKA   := SQLERRM;
    
  END UNOS_TRANSAKCIJA_ZA_BANKU;*/

 /* PROCEDURE IZMENA_TRANSAKCIJA_ZA_BANKU(P_ID_TRANSAKCIJA_ZA_BANKU     IN TRANSAKCIJA_ZA_BANKU.ID_TRANSAKCIJA_ZA_BANKU%TYPE,
                                        P_ID_VRSTA_TRANSAKCIJE        IN TRANSAKCIJA_ZA_BANKU.ID_VRSTA_TRANSAKCIJE%TYPE,
                                        P_ID_UGOVORENA_USLUGA         IN TRANSAKCIJA_ZA_BANKU.ID_UGOVORENA_USLUGA%TYPE,
                                        P_SIFRA_BANKE_KOMITENTA       IN TRANSAKCIJA_ZA_BANKU.SIFRA_BANKE_KOMITENTA%TYPE,
                                        P_SIFRA_BANKE                 IN TRANSAKCIJA_ZA_BANKU.SIFRA_BANKE%TYPE,
                                        P_SIFRA_TRANSAKCIJE           IN TRANSAKCIJA_ZA_BANKU.SIFRA_TRANSAKCIJE%TYPE,
                                        P_PREDMET_TRANSAKCIJE         IN TRANSAKCIJA_ZA_BANKU.PREDMET_TRANSAKCIJE%TYPE,
                                        P_ONLINE_DN                   IN TRANSAKCIJA_ZA_BANKU.ONLINE_DN%TYPE,
                                        P_AUTORIZACIJA_DN             IN TRANSAKCIJA_ZA_BANKU.AUTORIZACIJA_DN%TYPE,
                                        P_MODEL_TEKUCI_RACUN          IN TRANSAKCIJA_ZA_BANKU.MODEL_TEKUCI_RACUN%TYPE,
                                        P_MODEL_BROJ_CEKA             IN TRANSAKCIJA_ZA_BANKU.MODEL_BROJ_CEKA%TYPE,
                                        P_MINIMALNI_IZNOS             IN TRANSAKCIJA_ZA_BANKU.MINIMALNI_IZNOS%TYPE,
                                        P_MAKSIMALNI_IZNOS            IN TRANSAKCIJA_ZA_BANKU.MAKSIMALNI_IZNOS%TYPE,
                                        P_LICNI_DOKUMENT_DN           IN TRANSAKCIJA_ZA_BANKU.LICNI_DOKUMENT_DN%TYPE,
                                        P_IME_PREZIME_DN              IN TRANSAKCIJA_ZA_BANKU.IME_PREZIME_DN%TYPE,
                                        P_ADRESA_DN                   IN TRANSAKCIJA_ZA_BANKU.ADRESA_DN%TYPE,
                                        P_STANJE_NAKON_TRANSAKCIJE_DN IN TRANSAKCIJA_ZA_BANKU.STANJE_NAKON_TRANSAKCIJE_DN%TYPE,
                                        P_VRSTA_OVERE                 IN TRANSAKCIJA_ZA_BANKU.VRSTA_OVERE%TYPE,
                                        P_REDNI_BROJ_REDA_DN          IN TRANSAKCIJA_ZA_BANKU.REDNI_BROJ_REDA_DN%TYPE,
                                        P_TRANSFER_DN                 IN TRANSAKCIJA_ZA_BANKU.TRANSFER_DN%TYPE,
                                        P_TRANSFER_FORMAT             IN TRANSAKCIJA_ZA_BANKU.TRANSFER_FORMAT%TYPE,
                                        P_TRANSFER_EKSTENZIJA         IN TRANSAKCIJA_ZA_BANKU.TRANSFER_EKSTENZIJA%TYPE,
                                        P_TRANSFER_KANAL              IN TRANSAKCIJA_ZA_BANKU.TRANSFER_KANAL%TYPE,
                                        P_REZULTAT                    OUT NUMBER,
                                        P_PORUKA                      OUT VARCHAR2) IS
  BEGIN
  
    P_REZULTAT := 1;
    P_PORUKA   := 'NEUSPEŠNA IZMENA TRANSAKCIJE ZA BANKU!';
  
    UPDATE NOVCANO_POSLOVANJE.TRANSAKCIJA_ZA_BANKU
       SET ID_VRSTA_TRANSAKCIJE        = P_ID_VRSTA_TRANSAKCIJE,
           ID_UGOVORENA_USLUGA         = P_ID_UGOVORENA_USLUGA,
           SIFRA_BANKE_KOMITENTA       = P_SIFRA_BANKE_KOMITENTA,
           SIFRA_BANKE                 = P_SIFRA_BANKE,
           SIFRA_TRANSAKCIJE           = P_SIFRA_TRANSAKCIJE,
           PREDMET_TRANSAKCIJE         = P_PREDMET_TRANSAKCIJE,
           ONLINE_DN                   = P_ONLINE_DN,
           AUTORIZACIJA_DN             = P_AUTORIZACIJA_DN,
           MODEL_TEKUCI_RACUN          = P_MODEL_TEKUCI_RACUN,
           MODEL_BROJ_CEKA             = P_MODEL_BROJ_CEKA,
           MINIMALNI_IZNOS             = P_MINIMALNI_IZNOS,
           MAKSIMALNI_IZNOS            = P_MAKSIMALNI_IZNOS,
           LICNI_DOKUMENT_DN           = P_LICNI_DOKUMENT_DN,
           IME_PREZIME_DN              = P_IME_PREZIME_DN,
           ADRESA_DN                   = P_ADRESA_DN,
           STANJE_NAKON_TRANSAKCIJE_DN = P_STANJE_NAKON_TRANSAKCIJE_DN,
           VRSTA_OVERE                 = P_VRSTA_OVERE,
           REDNI_BROJ_REDA_DN          = P_REDNI_BROJ_REDA_DN,
           TRANSFER_DN                 = P_TRANSFER_DN,
           TRANSFER_FORMAT             = P_TRANSFER_FORMAT,
           TRANSFER_EKSTENZIJA         = P_TRANSFER_EKSTENZIJA,
           TRANSFER_KANAL              = P_TRANSFER_KANAL
     WHERE ID_TRANSAKCIJA_ZA_BANKU = P_ID_TRANSAKCIJA_ZA_BANKU;
  
    P_REZULTAT := 0;
    P_PORUKA   := 'USPEŠNA IZMENA TRANSAKCIJE ZA BANKU!';
  
  EXCEPTION
    WHEN OTHERS THEN
      P_REZULTAT := 1;
      P_PORUKA   := SQLERRM;
    
  END IZMENA_TRANSAKCIJA_ZA_BANKU;

  PROCEDURE UNOS_TR_KOMITENTA(P_ID_TRANSAKCIJA_ZA_KOMITENTA IN TEKUCI_RACUN_KOMITENTA.ID_TRANSAKCIJA_ZA_KOMITENTA%TYPE,
                              P_POZIV_NA_BROJ_VREDNOST      IN TEKUCI_RACUN_KOMITENTA.POZIV_NA_BROJ_VREDNOST%TYPE,
                              P_TEKUCI_RACUN                IN TEKUCI_RACUN_KOMITENTA.TEKUCI_RACUN%TYPE,
                              P_REZULTAT                    OUT NUMBER,
                              P_PORUKA                      OUT VARCHAR2) IS
  BEGIN
  
    P_REZULTAT := 1;
    P_PORUKA   := 'NEUSPEŠAN UPIS TEKUCEG RACUNA KOMITENTA!';
  
    INSERT INTO NOVCANO_POSLOVANJE.TEKUCI_RACUN_KOMITENTA
      (ID_TRANSAKCIJA_ZA_KOMITENTA, POZIV_NA_BROJ_VREDNOST, TEKUCI_RACUN)
    VALUES
      (P_ID_TRANSAKCIJA_ZA_KOMITENTA,
       P_POZIV_NA_BROJ_VREDNOST,
       P_TEKUCI_RACUN);
  
    P_REZULTAT := 0;
    P_PORUKA   := 'USPEŠAN UPIS TEKUCEG RACUNA KOMITENTA!';
  
  EXCEPTION
    WHEN OTHERS THEN
      P_REZULTAT := 1;
      P_PORUKA   := SQLERRM;
    
  END UNOS_TR_KOMITENTA;

  PROCEDURE IZMENA_TR_KOMITENTA(P_ID_TRANSAKCIJA_ZA_KOMITENTA IN TEKUCI_RACUN_KOMITENTA.ID_TRANSAKCIJA_ZA_KOMITENTA%TYPE,
                                P_POZIV_NA_BROJ_VREDNOST      IN TEKUCI_RACUN_KOMITENTA.POZIV_NA_BROJ_VREDNOST%TYPE,
                                P_TEKUCI_RACUN                IN TEKUCI_RACUN_KOMITENTA.TEKUCI_RACUN%TYPE,
                                P_REZULTAT                    OUT NUMBER,
                                P_PORUKA                      OUT VARCHAR2) IS
  BEGIN
  
    P_REZULTAT := 1;
    P_PORUKA   := 'NEUSPEŠNA IZMENA TEKUCEG RACUNA KOMITENTA!';
  
    UPDATE NOVCANO_POSLOVANJE.TEKUCI_RACUN_KOMITENTA TRK
       SET TRK.TEKUCI_RACUN = P_TEKUCI_RACUN
     WHERE TRK.ID_TRANSAKCIJA_ZA_KOMITENTA = P_ID_TRANSAKCIJA_ZA_KOMITENTA
       AND TRK.POZIV_NA_BROJ_VREDNOST = P_POZIV_NA_BROJ_VREDNOST;
  
    P_REZULTAT := 0;
    P_PORUKA   := 'USPEŠNA IZMENA TEKUCEG RACUNA KOMITENTA!';
  
  EXCEPTION
    WHEN OTHERS THEN
      P_REZULTAT := 1;
      P_PORUKA   := SQLERRM;
    
  END IZMENA_TR_KOMITENTA;

  PROCEDURE BRISANJE_TR_KOMITENTA(P_ID_TRANSAKCIJA_ZA_KOMITENTA IN TEKUCI_RACUN_KOMITENTA.ID_TRANSAKCIJA_ZA_KOMITENTA%TYPE,
                                  P_POZIV_NA_BROJ_VREDNOST      IN TEKUCI_RACUN_KOMITENTA.POZIV_NA_BROJ_VREDNOST%TYPE,
                                  P_REZULTAT                    OUT NUMBER,
                                  P_PORUKA                      OUT VARCHAR2) IS
  BEGIN
    P_REZULTAT := 1;
    P_PORUKA   := 'NEUSPEŠNA BRISANJE TEKUCEG RACUNA KOMITENTA!';
  
    DELETE FROM NOVCANO_POSLOVANJE.TEKUCI_RACUN_KOMITENTA TRK
     WHERE TRK.ID_TRANSAKCIJA_ZA_KOMITENTA = P_ID_TRANSAKCIJA_ZA_KOMITENTA
       AND TRK.POZIV_NA_BROJ_VREDNOST = P_POZIV_NA_BROJ_VREDNOST;
  
    P_REZULTAT := 0;
    P_PORUKA   := 'TEKUCI RACUNA KOMITENTA USPEŠNO OBRISAN!';
  
  EXCEPTION
    WHEN OTHERS THEN
      P_REZULTAT := 1;
      P_PORUKA   := SQLERRM;
  END BRISANJE_TR_KOMITENTA;*/

 /* PROCEDURE UNOS_TRANSAKCIJA_ZA_KOMITENTA(P_ID_VRSTA_TRANSAKCIJE        IN TRANSAKCIJA_ZA_KOMITENTA.ID_VRSTA_TRANSAKCIJE%TYPE,
                                          P_ID_UGOVORENA_USLUGA         IN TRANSAKCIJA_ZA_KOMITENTA.ID_UGOVORENA_USLUGA%TYPE,
                                          P_SIFRA_TRANSAKCIJE           IN TRANSAKCIJA_ZA_KOMITENTA.SIFRA_TRANSAKCIJE%TYPE,
                                          P_OPIS                        IN TRANSAKCIJA_ZA_KOMITENTA.OPIS%TYPE,
                                          P_MODEL_POZIVA_NA_BROJ        IN TRANSAKCIJA_ZA_KOMITENTA.MODEL_POZIVA_NA_BROJ%TYPE,
                                          P_DUZINA_POZIVA_NA_BROJ_OD    IN TRANSAKCIJA_ZA_KOMITENTA.DUZINA_POZIVA_NA_BROJ_OD%TYPE,
                                          P_DUZINA_POZIVA_NA_BROJ_DO    IN TRANSAKCIJA_ZA_KOMITENTA.DUZINA_POZIVA_NA_BROJ_DO%TYPE,
                                          P_KONSTANTA_U_POZIVU_NA_BROJ  IN TRANSAKCIJA_ZA_KOMITENTA.KONSTANTA_U_POZIVU_NA_BROJ%TYPE,
                                          P_KONSTANTA_PB_POZICIJA_OD    IN TRANSAKCIJA_ZA_KOMITENTA.KONSTANTA_PB_POZICIJA_OD%TYPE,
                                          P_KONSTANTA_PB_POZICIJA_DO    IN TRANSAKCIJA_ZA_KOMITENTA.KONSTANTA_PB_POZICIJA_DO%TYPE,
                                          P_TEKUCI_RACUN                IN TRANSAKCIJA_ZA_KOMITENTA.TEKUCI_RACUN%TYPE,
                                          P_POZIV_NA_BROJ_OD_ZA_TR      IN TRANSAKCIJA_ZA_KOMITENTA.POZIV_NA_BROJ_OD_ZA_TR%TYPE,
                                          P_POZIV_NA_BROJ_DO_ZA_TR      IN TRANSAKCIJA_ZA_KOMITENTA.POZIV_NA_BROJ_DO_ZA_TR%TYPE,
                                          P_DATUM_KASA_SKONTA           IN TRANSAKCIJA_ZA_KOMITENTA.DATUM_KASA_SKONTA%TYPE,
                                          P_KASA_SKONTO_POPUST          IN TRANSAKCIJA_ZA_KOMITENTA.KASA_SKONTO_POPUST%TYPE,
                                          P_MINIMALNI_IZNOS             IN TRANSAKCIJA_ZA_KOMITENTA.MINIMALNI_IZNOS%TYPE,
                                          P_MAKSIMALNI_IZNOS            IN TRANSAKCIJA_ZA_KOMITENTA.MAKSIMALNI_IZNOS%TYPE,
                                          P_TRANSFER_DN                 IN TRANSAKCIJA_ZA_KOMITENTA.TRANSFER_DN%TYPE,
                                          P_TRANSFER_FORMAT             IN TRANSAKCIJA_ZA_KOMITENTA.TRANSFER_FORMAT%TYPE,
                                          P_TRANSFER_EKSTENZIJA         IN TRANSAKCIJA_ZA_KOMITENTA.TRANSFER_EKSTENZIJA%TYPE,
                                          P_TRANSFER_KANAL              IN TRANSAKCIJA_ZA_KOMITENTA.TRANSFER_KANAL%TYPE,
                                          P_VRSTA_OVERE                 IN TRANSAKCIJA_ZA_KOMITENTA.VRSTA_OVERE%TYPE,
                                          P_ONLINE_DN                   IN TRANSAKCIJA_ZA_KOMITENTA.ONLINE_DN%TYPE,
                                          P_BK_POZIV_NA_BROJ_OD         IN TRANSAKCIJA_ZA_KOMITENTA.BK_POZIV_NA_BROJ_OD%TYPE,
                                          P_BK_POZIV_NA_BROJ_DO         IN TRANSAKCIJA_ZA_KOMITENTA.BK_POZIV_NA_BROJ_DO%TYPE,
                                          P_BK_IZNOS_POZICIJA_OD        IN TRANSAKCIJA_ZA_KOMITENTA.BK_IZNOS_POZICIJA_OD%TYPE,
                                          P_BK_IZNOS_POZICIJA_DO        IN TRANSAKCIJA_ZA_KOMITENTA.BK_IZNOS_POZICIJA_DO%TYPE,
                                          P_BK_SIFRA_KOMITENTA_DO       IN TRANSAKCIJA_ZA_KOMITENTA.BK_SIFRA_KOMITENTA_DO%TYPE,
                                          P_BK_SIFRA_KOMITENTA_OD       IN TRANSAKCIJA_ZA_KOMITENTA.BK_SIFRA_KOMITENTA_OD%TYPE,
                                          P_OCR_POZIV_NA_BROJ_OD        IN TRANSAKCIJA_ZA_KOMITENTA.OCR_POZIV_NA_BROJ_OD%TYPE,
                                          P_OCR_POZIV_NA_BROJ_DO        IN TRANSAKCIJA_ZA_KOMITENTA.OCR_POZIV_NA_BROJ_DO%TYPE,
                                          P_OCR_IZNOS_POZICIJA_OD       IN TRANSAKCIJA_ZA_KOMITENTA.OCR_IZNOS_POZICIJA_OD%TYPE,
                                          P_OCR_IZNOS_POZICIJA_DO       IN TRANSAKCIJA_ZA_KOMITENTA.OCR_IZNOS_POZICIJA_DO%TYPE,
                                          P_OCR_TR_POZICIJA_OD          IN TRANSAKCIJA_ZA_KOMITENTA.OCR_TR_POZICIJA_OD%TYPE,
                                          P_OCR_TR_POZICIJA_DO          IN TRANSAKCIJA_ZA_KOMITENTA.OCR_TR_POZICIJA_DO%TYPE,
                                          P_VALIDACIJA_TR_DA_NE         IN TRANSAKCIJA_ZA_KOMITENTA.VALIDACIJA_TR_DA_NE%TYPE,
                                          P_ID_USLUGA_CENOVNIK_STRANKA  IN TRANSAKCIJA_ZA_KOMITENTA.ID_USLUGA_CENOVNIK_STRANKA%TYPE,
                                          P_FIKSNI_IZNOSI               IN TRANSAKCIJA_ZA_KOMITENTA.FIKSNI_IZNOSI%TYPE,
                                          P_POPUST_DATUM                IN TRANSAKCIJA_ZA_KOMITENTA.POPUST_DATUM%TYPE,
                                          P_POZIV_NA_BROJ_POPUS_OD      IN TRANSAKCIJA_ZA_KOMITENTA.POZIV_NA_BROJ_POPUS_OD%TYPE,
                                          P_POZIV_NA_PROJ_POPUST_DO     IN TRANSAKCIJA_ZA_KOMITENTA.POZIV_NA_PROJ_POPUST_DO%TYPE,
                                          P_POSTNET_SIFRA_KOMUNALCA     IN TRANSAKCIJA_ZA_KOMITENTA.POSTNET_SIFRA_KOMUNALCA%TYPE,
                                          P_POSTNET_SIFRA_U_PRENOSU     IN TRANSAKCIJA_ZA_KOMITENTA.POSTNET_SIFRA_U_PRENOSU%TYPE,
                                          P_POSTNET_JEDNA_PRIJAVA       IN TRANSAKCIJA_ZA_KOMITENTA.POSTNET_JEDNA_PRIJAVA%TYPE,
                                          P_POSTNET_PROVPRIJ            IN TRANSAKCIJA_ZA_KOMITENTA.POSTNET_PROVPRIJ%TYPE,
                                          P_POSTNET_POSTARINA           IN TRANSAKCIJA_ZA_KOMITENTA.POSTNET_POSTARINA%TYPE,
                                          P_POSTNET_MINIMALNAPOSTARINA  IN TRANSAKCIJA_ZA_KOMITENTA.POSTNET_MINIMALNAPOSTARINA%TYPE,
                                          P_POSTNET_KNB                 IN TRANSAKCIJA_ZA_KOMITENTA.POSTNET_KNB%TYPE,
                                          P_POSTNET_FT97                IN TRANSAKCIJA_ZA_KOMITENTA.POSTNET_FT97%TYPE,
                                          P_POSTNET_DOKUMENT_OVERE      IN TRANSAKCIJA_ZA_KOMITENTA.POSTNET_DOKUMENT_OVERE%TYPE,
                                          P_POSTNET_KOMUNALAC_DN        IN TRANSAKCIJA_ZA_KOMITENTA.POSTNET_KOMUNALAC_DN%TYPE,
                                          P_POSTNET_PROVIZIJA           IN TRANSAKCIJA_ZA_KOMITENTA.POSTNET_PROVIZIJA%TYPE,
                                          P_POSTNET_POPUST              IN TRANSAKCIJA_ZA_KOMITENTA.POSTNET_POPUST%TYPE,
                                          P_ID_TRANSAKCIJA_ZA_KOMITENTA OUT TRANSAKCIJA_ZA_KOMITENTA.ID_TRANSAKCIJA_ZA_KOMITENTA%TYPE,
                                          P_REZULTAT                    OUT NUMBER,
                                          P_PORUKA                      OUT VARCHAR2) IS
  BEGIN
    P_ID_TRANSAKCIJA_ZA_KOMITENTA := -1;
    P_REZULTAT                    := 1;
    P_PORUKA                      := 'NEUSPEŠAN UNOS TRANSAKCIJE ZA KOMITENTA!';
  
    SELECT TRANSAKCIJA_ZA_KOMITENTA_SEQ.NEXTVAL
      INTO P_ID_TRANSAKCIJA_ZA_KOMITENTA
      FROM DUAL;
  
    INSERT INTO NOVCANO_POSLOVANJE.TRANSAKCIJA_ZA_KOMITENTA
      (ID_TRANSAKCIJA_ZA_KOMITENTA,
       ID_VRSTA_TRANSAKCIJE,
       ID_UGOVORENA_USLUGA,
       SIFRA_TRANSAKCIJE,
       OPIS,
       MODEL_POZIVA_NA_BROJ,
       DUZINA_POZIVA_NA_BROJ_OD,
       DUZINA_POZIVA_NA_BROJ_DO,
       KONSTANTA_U_POZIVU_NA_BROJ,
       KONSTANTA_PB_POZICIJA_OD,
       KONSTANTA_PB_POZICIJA_DO,
       TEKUCI_RACUN,
       POZIV_NA_BROJ_OD_ZA_TR,
       POZIV_NA_BROJ_DO_ZA_TR,
       DATUM_KASA_SKONTA,
       KASA_SKONTO_POPUST,
       MINIMALNI_IZNOS,
       MAKSIMALNI_IZNOS,
       TRANSFER_DN,
       TRANSFER_FORMAT,
       TRANSFER_EKSTENZIJA,
       TRANSFER_KANAL,
       VRSTA_OVERE,
       ONLINE_DN,
       BK_POZIV_NA_BROJ_OD,
       BK_POZIV_NA_BROJ_DO,
       BK_IZNOS_POZICIJA_OD,
       BK_IZNOS_POZICIJA_DO,
       BK_SIFRA_KOMITENTA_DO,
       BK_SIFRA_KOMITENTA_OD,
       OCR_POZIV_NA_BROJ_OD,
       OCR_POZIV_NA_BROJ_DO,
       OCR_IZNOS_POZICIJA_OD,
       OCR_IZNOS_POZICIJA_DO,
       OCR_TR_POZICIJA_OD,
       OCR_TR_POZICIJA_DO,
       VALIDACIJA_TR_DA_NE,
       ID_USLUGA_CENOVNIK_STRANKA,
       FIKSNI_IZNOSI,
       POPUST_DATUM,
       POZIV_NA_BROJ_POPUS_OD,
       POZIV_NA_PROJ_POPUST_DO,
       POSTNET_SIFRA_KOMUNALCA,
       POSTNET_SIFRA_U_PRENOSU,
       POSTNET_JEDNA_PRIJAVA,
       POSTNET_PROVPRIJ,
       POSTNET_POSTARINA,
       POSTNET_MINIMALNAPOSTARINA,
       POSTNET_KNB,
       POSTNET_FT97,
       POSTNET_DOKUMENT_OVERE,
       POSTNET_KOMUNALAC_DN,
       POSTNET_PROVIZIJA,
       POSTNET_POPUST)
    VALUES
      (P_ID_TRANSAKCIJA_ZA_KOMITENTA,
       P_ID_VRSTA_TRANSAKCIJE,
       P_ID_UGOVORENA_USLUGA,
       P_SIFRA_TRANSAKCIJE,
       P_OPIS,
       P_MODEL_POZIVA_NA_BROJ,
       P_DUZINA_POZIVA_NA_BROJ_OD,
       P_DUZINA_POZIVA_NA_BROJ_DO,
       P_KONSTANTA_U_POZIVU_NA_BROJ,
       P_KONSTANTA_PB_POZICIJA_OD,
       P_KONSTANTA_PB_POZICIJA_DO,
       P_TEKUCI_RACUN,
       P_POZIV_NA_BROJ_OD_ZA_TR,
       P_POZIV_NA_BROJ_DO_ZA_TR,
       P_DATUM_KASA_SKONTA,
       P_KASA_SKONTO_POPUST,
       P_MINIMALNI_IZNOS,
       P_MAKSIMALNI_IZNOS,
       P_TRANSFER_DN,
       P_TRANSFER_FORMAT,
       P_TRANSFER_EKSTENZIJA,
       P_TRANSFER_KANAL,
       P_VRSTA_OVERE,
       P_ONLINE_DN,
       P_BK_POZIV_NA_BROJ_OD,
       P_BK_POZIV_NA_BROJ_DO,
       P_BK_IZNOS_POZICIJA_OD,
       P_BK_IZNOS_POZICIJA_DO,
       P_BK_SIFRA_KOMITENTA_DO,
       P_BK_SIFRA_KOMITENTA_OD,
       P_OCR_POZIV_NA_BROJ_OD,
       P_OCR_POZIV_NA_BROJ_DO,
       P_OCR_IZNOS_POZICIJA_OD,
       P_OCR_IZNOS_POZICIJA_DO,
       P_OCR_TR_POZICIJA_OD,
       P_OCR_TR_POZICIJA_DO,
       P_VALIDACIJA_TR_DA_NE,
       P_ID_USLUGA_CENOVNIK_STRANKA,
       P_FIKSNI_IZNOSI,
       P_POPUST_DATUM,
       P_POZIV_NA_BROJ_POPUS_OD,
       P_POZIV_NA_PROJ_POPUST_DO,
       P_POSTNET_SIFRA_KOMUNALCA,
       P_POSTNET_SIFRA_U_PRENOSU,
       P_POSTNET_JEDNA_PRIJAVA,
       P_POSTNET_PROVPRIJ,
       P_POSTNET_POSTARINA,
       P_POSTNET_MINIMALNAPOSTARINA,
       P_POSTNET_KNB,
       P_POSTNET_FT97,
       P_POSTNET_DOKUMENT_OVERE,
       P_POSTNET_KOMUNALAC_DN,
       P_POSTNET_PROVIZIJA,
       P_POSTNET_POPUST);
  
    P_REZULTAT := 0;
    P_PORUKA   := 'USPEŠAN UNOS TRANSAKCIJE ZA KOMITENTA!';
  
  EXCEPTION
    WHEN OTHERS THEN
      P_ID_TRANSAKCIJA_ZA_KOMITENTA := -1;
      P_REZULTAT                    := 1;
      P_PORUKA                      := SQLERRM;
    
  END UNOS_TRANSAKCIJA_ZA_KOMITENTA;*/

  /*PROCEDURE IZMENA_TRN_ZA_KOMITENTA(P_ID_TRANSAKCIJA_ZA_KOMITENTA IN TRANSAKCIJA_ZA_KOMITENTA.ID_TRANSAKCIJA_ZA_KOMITENTA%TYPE,
                                    P_ID_VRSTA_TRANSAKCIJE        IN TRANSAKCIJA_ZA_KOMITENTA.ID_VRSTA_TRANSAKCIJE%TYPE,
                                    P_ID_UGOVORENA_USLUGA         IN TRANSAKCIJA_ZA_KOMITENTA.ID_UGOVORENA_USLUGA%TYPE,
                                    P_SIFRA_TRANSAKCIJE           IN TRANSAKCIJA_ZA_KOMITENTA.SIFRA_TRANSAKCIJE%TYPE,
                                    P_OPIS                        IN TRANSAKCIJA_ZA_KOMITENTA.OPIS%TYPE,
                                    P_MODEL_POZIVA_NA_BROJ        IN TRANSAKCIJA_ZA_KOMITENTA.MODEL_POZIVA_NA_BROJ%TYPE,
                                    P_DUZINA_POZIVA_NA_BROJ_OD    IN TRANSAKCIJA_ZA_KOMITENTA.DUZINA_POZIVA_NA_BROJ_OD%TYPE,
                                    P_DUZINA_POZIVA_NA_BROJ_DO    IN TRANSAKCIJA_ZA_KOMITENTA.DUZINA_POZIVA_NA_BROJ_DO%TYPE,
                                    P_KONSTANTA_U_POZIVU_NA_BROJ  IN TRANSAKCIJA_ZA_KOMITENTA.KONSTANTA_U_POZIVU_NA_BROJ%TYPE,
                                    P_KONSTANTA_PB_POZICIJA_OD    IN TRANSAKCIJA_ZA_KOMITENTA.KONSTANTA_PB_POZICIJA_OD%TYPE,
                                    P_KONSTANTA_PB_POZICIJA_DO    IN TRANSAKCIJA_ZA_KOMITENTA.KONSTANTA_PB_POZICIJA_DO%TYPE,
                                    P_TEKUCI_RACUN                IN TRANSAKCIJA_ZA_KOMITENTA.TEKUCI_RACUN%TYPE,
                                    P_POZIV_NA_BROJ_OD_ZA_TR      IN TRANSAKCIJA_ZA_KOMITENTA.POZIV_NA_BROJ_OD_ZA_TR%TYPE,
                                    P_POZIV_NA_BROJ_DO_ZA_TR      IN TRANSAKCIJA_ZA_KOMITENTA.POZIV_NA_BROJ_DO_ZA_TR%TYPE,
                                    P_DATUM_KASA_SKONTA           IN TRANSAKCIJA_ZA_KOMITENTA.DATUM_KASA_SKONTA%TYPE,
                                    P_KASA_SKONTO_POPUST          IN TRANSAKCIJA_ZA_KOMITENTA.KASA_SKONTO_POPUST%TYPE,
                                    P_MINIMALNI_IZNOS             IN TRANSAKCIJA_ZA_KOMITENTA.MINIMALNI_IZNOS%TYPE,
                                    P_MAKSIMALNI_IZNOS            IN TRANSAKCIJA_ZA_KOMITENTA.MAKSIMALNI_IZNOS%TYPE,
                                    P_TRANSFER_DN                 IN TRANSAKCIJA_ZA_KOMITENTA.TRANSFER_DN%TYPE,
                                    P_TRANSFER_FORMAT             IN TRANSAKCIJA_ZA_KOMITENTA.TRANSFER_FORMAT%TYPE,
                                    P_TRANSFER_EKSTENZIJA         IN TRANSAKCIJA_ZA_KOMITENTA.TRANSFER_EKSTENZIJA%TYPE,
                                    P_TRANSFER_KANAL              IN TRANSAKCIJA_ZA_KOMITENTA.TRANSFER_KANAL%TYPE,
                                    P_VRSTA_OVERE                 IN TRANSAKCIJA_ZA_KOMITENTA.VRSTA_OVERE%TYPE,
                                    P_ONLINE_DN                   IN TRANSAKCIJA_ZA_KOMITENTA.ONLINE_DN%TYPE,
                                    P_BK_POZIV_NA_BROJ_OD         IN TRANSAKCIJA_ZA_KOMITENTA.BK_POZIV_NA_BROJ_OD%TYPE,
                                    P_BK_POZIV_NA_BROJ_DO         IN TRANSAKCIJA_ZA_KOMITENTA.BK_POZIV_NA_BROJ_DO%TYPE,
                                    P_BK_IZNOS_POZICIJA_OD        IN TRANSAKCIJA_ZA_KOMITENTA.BK_IZNOS_POZICIJA_OD%TYPE,
                                    P_BK_IZNOS_POZICIJA_DO        IN TRANSAKCIJA_ZA_KOMITENTA.BK_IZNOS_POZICIJA_DO%TYPE,
                                    P_BK_SIFRA_KOMITENTA_DO       IN TRANSAKCIJA_ZA_KOMITENTA.BK_SIFRA_KOMITENTA_DO%TYPE,
                                    P_BK_SIFRA_KOMITENTA_OD       IN TRANSAKCIJA_ZA_KOMITENTA.BK_SIFRA_KOMITENTA_OD%TYPE,
                                    P_OCR_POZIV_NA_BROJ_OD        IN TRANSAKCIJA_ZA_KOMITENTA.OCR_POZIV_NA_BROJ_OD%TYPE,
                                    P_OCR_POZIV_NA_BROJ_DO        IN TRANSAKCIJA_ZA_KOMITENTA.OCR_POZIV_NA_BROJ_DO%TYPE,
                                    P_OCR_IZNOS_POZICIJA_OD       IN TRANSAKCIJA_ZA_KOMITENTA.OCR_IZNOS_POZICIJA_OD%TYPE,
                                    P_OCR_IZNOS_POZICIJA_DO       IN TRANSAKCIJA_ZA_KOMITENTA.OCR_IZNOS_POZICIJA_DO%TYPE,
                                    P_OCR_TR_POZICIJA_OD          IN TRANSAKCIJA_ZA_KOMITENTA.OCR_TR_POZICIJA_OD%TYPE,
                                    P_OCR_TR_POZICIJA_DO          IN TRANSAKCIJA_ZA_KOMITENTA.OCR_TR_POZICIJA_DO%TYPE,
                                    P_VALIDACIJA_TR_DA_NE         IN TRANSAKCIJA_ZA_KOMITENTA.VALIDACIJA_TR_DA_NE%TYPE,
                                    P_ID_USLUGA_CENOVNIK_STRANKA  IN TRANSAKCIJA_ZA_KOMITENTA.ID_USLUGA_CENOVNIK_STRANKA%TYPE,
                                    P_FIKSNI_IZNOSI               IN TRANSAKCIJA_ZA_KOMITENTA.FIKSNI_IZNOSI%TYPE,
                                    P_POPUST_DATUM                IN TRANSAKCIJA_ZA_KOMITENTA.POPUST_DATUM%TYPE,
                                    P_POZIV_NA_BROJ_POPUS_OD      IN TRANSAKCIJA_ZA_KOMITENTA.POZIV_NA_BROJ_POPUS_OD%TYPE,
                                    P_POZIV_NA_PROJ_POPUST_DO     IN TRANSAKCIJA_ZA_KOMITENTA.POZIV_NA_PROJ_POPUST_DO%TYPE,
                                    P_POSTNET_SIFRA_KOMUNALCA     IN TRANSAKCIJA_ZA_KOMITENTA.POSTNET_SIFRA_KOMUNALCA%TYPE,
                                    P_POSTNET_SIFRA_U_PRENOSU     IN TRANSAKCIJA_ZA_KOMITENTA.POSTNET_SIFRA_U_PRENOSU%TYPE,
                                    P_POSTNET_JEDNA_PRIJAVA       IN TRANSAKCIJA_ZA_KOMITENTA.POSTNET_JEDNA_PRIJAVA%TYPE,
                                    P_POSTNET_PROVPRIJ            IN TRANSAKCIJA_ZA_KOMITENTA.POSTNET_PROVPRIJ%TYPE,
                                    P_POSTNET_POSTARINA           IN TRANSAKCIJA_ZA_KOMITENTA.POSTNET_POSTARINA%TYPE,
                                    P_POSTNET_MINIMALNAPOSTARINA  IN TRANSAKCIJA_ZA_KOMITENTA.POSTNET_MINIMALNAPOSTARINA%TYPE,
                                    P_POSTNET_KNB                 IN TRANSAKCIJA_ZA_KOMITENTA.POSTNET_KNB%TYPE,
                                    P_POSTNET_FT97                IN TRANSAKCIJA_ZA_KOMITENTA.POSTNET_FT97%TYPE,
                                    P_POSTNET_DOKUMENT_OVERE      IN TRANSAKCIJA_ZA_KOMITENTA.POSTNET_DOKUMENT_OVERE%TYPE,
                                    P_POSTNET_KOMUNALAC_DN        IN TRANSAKCIJA_ZA_KOMITENTA.POSTNET_KOMUNALAC_DN%TYPE,
                                    P_POSTNET_PROVIZIJA           IN TRANSAKCIJA_ZA_KOMITENTA.POSTNET_PROVIZIJA%TYPE,
                                    P_POSTNET_POPUST              IN TRANSAKCIJA_ZA_KOMITENTA.POSTNET_POPUST%TYPE,
                                    P_REZULTAT                    OUT NUMBER,
                                    P_PORUKA                      OUT VARCHAR2) IS
  BEGIN
  
    P_REZULTAT := 1;
    P_PORUKA   := 'NEUSPEŠNA IZMENA TRANSAKCIJE ZA KOMITENTA!';
  
    UPDATE NOVCANO_POSLOVANJE.TRANSAKCIJA_ZA_KOMITENTA
       SET ID_VRSTA_TRANSAKCIJE       = P_ID_VRSTA_TRANSAKCIJE,
           ID_UGOVORENA_USLUGA        = P_ID_UGOVORENA_USLUGA,
           SIFRA_TRANSAKCIJE          = P_SIFRA_TRANSAKCIJE,
           OPIS                       = P_OPIS,
           MODEL_POZIVA_NA_BROJ       = P_MODEL_POZIVA_NA_BROJ,
           DUZINA_POZIVA_NA_BROJ_OD   = P_DUZINA_POZIVA_NA_BROJ_OD,
           DUZINA_POZIVA_NA_BROJ_DO   = P_DUZINA_POZIVA_NA_BROJ_DO,
           KONSTANTA_U_POZIVU_NA_BROJ = P_KONSTANTA_U_POZIVU_NA_BROJ,
           KONSTANTA_PB_POZICIJA_OD   = P_KONSTANTA_PB_POZICIJA_OD,
           KONSTANTA_PB_POZICIJA_DO   = P_KONSTANTA_PB_POZICIJA_DO,
           TEKUCI_RACUN               = P_TEKUCI_RACUN,
           POZIV_NA_BROJ_OD_ZA_TR     = P_POZIV_NA_BROJ_OD_ZA_TR,
           POZIV_NA_BROJ_DO_ZA_TR     = P_POZIV_NA_BROJ_DO_ZA_TR,
           DATUM_KASA_SKONTA          = P_DATUM_KASA_SKONTA,
           KASA_SKONTO_POPUST         = P_KASA_SKONTO_POPUST,
           MINIMALNI_IZNOS            = P_MINIMALNI_IZNOS,
           MAKSIMALNI_IZNOS           = P_MAKSIMALNI_IZNOS,
           TRANSFER_DN                = P_TRANSFER_DN,
           TRANSFER_FORMAT            = P_TRANSFER_FORMAT,
           TRANSFER_EKSTENZIJA        = P_TRANSFER_EKSTENZIJA,
           TRANSFER_KANAL             = P_TRANSFER_KANAL,
           VRSTA_OVERE                = P_VRSTA_OVERE,
           ONLINE_DN                  = P_ONLINE_DN,
           BK_POZIV_NA_BROJ_OD        = P_BK_POZIV_NA_BROJ_OD,
           BK_POZIV_NA_BROJ_DO        = P_BK_POZIV_NA_BROJ_DO,
           BK_IZNOS_POZICIJA_OD       = P_BK_IZNOS_POZICIJA_OD,
           BK_IZNOS_POZICIJA_DO       = P_BK_IZNOS_POZICIJA_DO,
           BK_SIFRA_KOMITENTA_DO      = P_BK_SIFRA_KOMITENTA_DO,
           BK_SIFRA_KOMITENTA_OD      = P_BK_SIFRA_KOMITENTA_OD,
           OCR_POZIV_NA_BROJ_OD       = P_OCR_POZIV_NA_BROJ_OD,
           OCR_POZIV_NA_BROJ_DO       = P_OCR_POZIV_NA_BROJ_DO,
           OCR_IZNOS_POZICIJA_OD      = P_OCR_IZNOS_POZICIJA_OD,
           OCR_IZNOS_POZICIJA_DO      = P_OCR_IZNOS_POZICIJA_DO,
           OCR_TR_POZICIJA_OD         = P_OCR_TR_POZICIJA_OD,
           OCR_TR_POZICIJA_DO         = P_OCR_TR_POZICIJA_DO,
           VALIDACIJA_TR_DA_NE        = P_VALIDACIJA_TR_DA_NE,
           ID_USLUGA_CENOVNIK_STRANKA = P_ID_USLUGA_CENOVNIK_STRANKA,
           FIKSNI_IZNOSI              = P_FIKSNI_IZNOSI,
           POPUST_DATUM               = P_POPUST_DATUM,
           POZIV_NA_BROJ_POPUS_OD     = P_POZIV_NA_BROJ_POPUS_OD,
           POZIV_NA_PROJ_POPUST_DO    = P_POZIV_NA_PROJ_POPUST_DO,
           POSTNET_SIFRA_KOMUNALCA    = P_POSTNET_SIFRA_KOMUNALCA,
           POSTNET_SIFRA_U_PRENOSU    = P_POSTNET_SIFRA_U_PRENOSU,
           POSTNET_JEDNA_PRIJAVA      = P_POSTNET_JEDNA_PRIJAVA,
           POSTNET_PROVPRIJ           = P_POSTNET_PROVPRIJ,
           POSTNET_POSTARINA          = P_POSTNET_POSTARINA,
           POSTNET_MINIMALNAPOSTARINA = P_POSTNET_MINIMALNAPOSTARINA,
           POSTNET_KNB                = P_POSTNET_KNB,
           POSTNET_FT97               = P_POSTNET_FT97,
           POSTNET_DOKUMENT_OVERE     = P_POSTNET_DOKUMENT_OVERE,
           POSTNET_KOMUNALAC_DN       = P_POSTNET_KOMUNALAC_DN,
           POSTNET_PROVIZIJA          = P_POSTNET_PROVIZIJA,
           POSTNET_POPUST             = P_POSTNET_POPUST
     WHERE ID_TRANSAKCIJA_ZA_KOMITENTA = P_ID_TRANSAKCIJA_ZA_KOMITENTA;
  
    P_REZULTAT := 0;
    P_PORUKA   := 'USPEŠNA IZMENA TRANSAKCIJE ZA KOMITENTA!';
  
  EXCEPTION
    WHEN OTHERS THEN
      P_REZULTAT := 1;
      P_PORUKA   := SQLERRM;
    
  END IZMENA_TRN_ZA_KOMITENTA;*/
  

END TRANSAKCIJE;
/

SHOW ERRORS;


