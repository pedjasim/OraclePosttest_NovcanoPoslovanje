CREATE OR REPLACE PACKAGE BODY                    PRIPREMA_PODATAKA_ZA_IBM_NOVO IS

PROCEDURE KREIRANJE_PRIJAVA (P_ID_CPM_DAN IN VARCHAR2,
                                                  P_REZULTAT  OUT NUMBER)
IS

nRezultat NUMBER;  
sPostanskiBroj VARCHAR2(5); 
sNazivPoste VARCHAR2(20);
sNazivRJ VARCHAR2(35); 
nIdRJ NUMBER; 
nBrojacPrijava NUMBER;
IdCPMDan RAW(16);

nIdCPM NUMBER;
dDatum DATE;

sKreiranjePrijavaBanka CPM_OBRADA.kreiranje_prijava_banka%TYPE;
sKreiranjePrijavaKomitent CPM_OBRADA.kreiranje_prijava_komitent%TYPE;

BEGIN

  P_REZULTAT := 1;
  IdCPMDan := HEXTORAW(P_ID_CPM_DAN);
  
  BEGIN 

      SELECT co.id_cpm, 
                  trunc(co.datum)datum, 
                  co.kreiranje_prijava_banka, 
                  co.kreiranje_prijava_komitent 
      INTO     nIdCPM, 
                  dDatum, 
                  sKreiranjePrijavaBanka, 
                  sKreiranjePrijavaKomitent
      FROM CPM_OBRADA co
      WHERE co.obrada_banke = 'D' AND
                  co.obrada_komitenti = 'D' AND
                  ID_CPM_DAN = IdCPMDan;

      IF (sKreiranjePrijavaBanka = 'D' AND sKreiranjePrijavaKomitent = 'D') THEN
        P_REZULTAT := 999;        
        RETURN;
      END IF;

      SELECT SUBSTR(cpm.postanski_broj,1, 5) postanski_broj, 
                  SUBSTR(oc.naziv, 1, 20) naziv 
      INTO     sPostanskiBroj, 
                  sNazivPoste      
      FROM POSLOVNO_OKRUZENJE.CVOR_POSTANSKE_MREZE cpm, POSLOVNO_OKRUZENJE.ORGANIZACIONA_CELINA oc
      WHERE cpm.id_organizaciona_celina = oc.id_organizaciona_celina AND
                 cpm.id_cvor_postanske_mreze = nIdCPM;

      RADNA_JEDINICA(nIdCPM,  nIdRJ, sNazivRJ);

      nBrojacPrijava := 0;
      
      FOR recPrijave IN  (SELECT id_prijava, 
                                               vrsta_prijave, 
                                               nvl(grupa, '0') grupa
                                   FROM PRIJAVA
                                   WHERE vrsta_prijave IS NOT NULL AND
                                               status = 'A')  
      LOOP 
       
        IF (recPrijave.vrsta_prijave = 'B') THEN
          KREIRANJE_PRIJAVA_BANKE (nIdCPM, dDatum, IdCPMDan, sPostanskiBroj, sNazivPoste, nIdRJ, sNazivRJ, recPrijave.id_prijava, nBrojacPrijava, nRezultat);
        ELSE
          KREIRANJE_PRIJAVA_KOMITENTI (recPrijave.grupa, nIdCPM, dDatum, IdCPMDan, sPostanskiBroj, sNazivPoste, nIdRJ, sNazivRJ, recPrijave.id_prijava,nBrojacPrijava, nRezultat); 
        END IF;
        
      END LOOP;

     UPDATE CPM_OBRADA 
     SET  kreiranje_prijava_banka = 'D',
             kreiranje_prijava_komitent = 'D'
     WHERE obrada_banke = 'D' AND
                 obrada_komitenti = 'D' AND
                 obrada_nalog_pp = 'D' AND
                 id_cpm_dan = IdCPMDan AND
                 NVL(kreiranje_prijava_banka, 'N') = 'N' AND
                 NVL(kreiranje_prijava_komitent, 'N') = 'N';

     IF SQL%ROWCOUNT <> 1 THEN
       RAISE_APPLICATION_ERROR(-20001, 'Obrada je veæ uraðena prethodnom iteracijom!!!');
     END IF;
        
  EXCEPTION
    WHEN OTHERS THEN
      RAISE;
  END;

  P_REZULTAT := 0;
   
END KREIRANJE_PRIJAVA;

PROCEDURE KREIRANJE_PRIJAVA_BANKE (P_ID_POSTA IN NUMBER,
                                   P_DATUM IN DATE,
                                   P_ID_CPM_DAN IN CPM_OBRADA.id_cpm_dan%TYPE, 
                                   P_BROJ_POSTE IN VARCHAR2, 
                                   P_NAZIV_POSTE IN VARCHAR2,
                                   P_ID_RJ   IN NUMBER,
                                   P_NAZIV_RJ IN VARCHAR2,
                                   P_ID_PRIJAVE  IN NUMBER, 
                                   P_RBR_PRIJAVE IN OUT NUMBER,
                                   P_REZULTAT  OUT NUMBER) 
IS

sSvrhaUplate VARCHAR2(105);
sZiroRacun   VARCHAR2(18);
sPozivNaBroj VARCHAR2(22);
nIdTransakcijaNaloga NUMBER; 
sVrstaPromene VARCHAR2(3); 
sNazivUplatioca  TRANSAKCIJA_NALOG_PP.NAZIV_UPLATIOCA%TYPE; 
sNazivPrimaoca TRANSAKCIJA_NALOG_PP.NAZIV_PRIMAOCA%TYPE; 
sNazivBanke  TRANSAKCIJA_NALOG_PP.NAZIV_PRIMAOCA%TYPE; 
sSediste VARCHAR2(35);
nUkupno NUMBER;
sVrstaTransakcije VARCHAR2(1);

BEGIN
   
  P_REZULTAT := 1;

  FOR recBanke IN (SELECT b.sifra_banke,
                                         b.id_vrsta_transakcije,                                      
                                         tb.konstanta_u_pozivu_na_broj,
                                         tb.sifra_placanja,
                                         tb.vrsta_transakcije_ui, 
                                         DECODE(b.sifra_banke, '295', b.izvor_transakcije, 'X') izvor_transakcije, 
                                         SUM(b.iznos_transakcije)suma
                             FROM TRANSAKCIJA_ZA_BANKU tb, TRANSAKCIJA_BANKA b
                             WHERE tb.sifra_banke = b.sifra_banke AND
                                         tb.sifra_transakcije = b.sifra_transakcije AND
                                         tb.id_vrsta_transakcije = b.id_vrsta_transakcije AND
                                         b.status = 'V' AND
                                         b.id_cpm_dan = HEXTORAW(P_ID_CPM_DAN) AND
                                         b.id_transakcija_nalog_pp IS NULL AND
                                         tb.id_prijava = P_ID_PRIJAVE
                              GROUP BY  b.sifra_banke,
                                               b.id_vrsta_transakcije,                                  
                                               tb.konstanta_u_pozivu_na_broj,
                                               tb.sifra_placanja,
                                               tb.vrsta_transakcije_ui, 
                                               DECODE(b.sifra_banke, '295', b.izvor_transakcije, 'X'))
  LOOP
    
    IF(recBanke.suma > 0) THEN
    
        SELECT SUBSTR(tb.naziv,1,35) naziv, 
                    SUBSTR(tb.sediste,1,35) sediste, 
                    tr.tekuci_racun
        INTO sNazivBanke, 
                sSediste,
                sZiroRacun
        FROM poslovno_okruzenje.tsif_banka tb, poslovno_okruzenje.tekuci_racun_banaka tr
        WHERE tb.id_banka = tr.id_banka(+) AND
                    tr.vrsta_prijave = DECODE(recBanke.sifra_banke, '295', DECODE(recBanke.izvor_transakcije,'C','1','2'), '1') AND
                    tb.sifra = recBanke.sifra_banke;

        ATRIBUTI_NALOGA (P_ID_PRIJAVE, recBanke.vrsta_transakcije_ui, recBanke.konstanta_u_pozivu_na_broj, sNazivBanke,
                                      P_BROJ_POSTE, P_NAZIV_POSTE, P_DATUM, P_ID_RJ, P_NAZIV_RJ,
                                      sSvrhaUplate, sVrstaPromene, sNazivUplatioca, sNazivPrimaoca, sZiroRacun, sPozivNaBroj);    

        SELECT TRANSAKCIJA_NALOG_PP_SEQ.NEXTVAL
        INTO nIdTransakcijaNaloga
        FROM DUAL; 
         
        P_RBR_PRIJAVE := P_RBR_PRIJAVE + 1;
        INSERT INTO TRANSAKCIJA_NALOG_PP
               (id_transakcija_nalog_pp, naziv_uplatioca, adresa_uplatioca, posta_uplatioca, naziv_primaoca, adresa_primaoca, posta_primaoca,
                tekuci_racun_primaoca, poziv_na_broj, iznos, svrha_uplate, sifra_placanja, vrsta_naloga, vrsta_promene, oznaka_promene, id_radnik, 
                redni_broj_transakcije, id_cpm, datum, status, datum_transakcije, sifra_radnika, model_poziva_na_broj, id_prijava, id_cpm_dan)
         VALUES
               (nIdTransakcijaNaloga, sNazivUplatioca, null, null, sNazivPrimaoca, null, null,    
                sZiroRacun, sPozivNaBroj, recBanke.suma, sSvrhaUplate, recBanke.sifra_placanja,  'G', 
                sVrstaPromene,  recBanke.vrsta_transakcije_ui, 0, P_RBR_PRIJAVE, P_ID_POSTA, 
                P_DATUM, 'V', SYSDATE(), '0000', '00', P_ID_PRIJAVE, P_ID_CPM_DAN); 
                
         UPDATE TRANSAKCIJA_BANKA tb
         SET tb.id_transakcija_nalog_pp = nIdTransakcijaNaloga
         WHERE tb.id_vrsta_transakcije = recBanke.id_vrsta_transakcije AND
                     tb.sifra_banke = recBanke.sifra_banke AND
                     tb.id_cpm_dan = HEXTORAW(P_ID_CPM_DAN) AND
                     tb.id_transakcija_nalog_pp IS NULL AND
                     tb.status = 'V' AND
                     tb.izvor_transakcije = DECODE(recBanke.sifra_banke, '295', recBanke.izvor_transakcije, tb.izvor_transakcije);
         
     END IF;
  END LOOP;

  P_REZULTAT := 0;
   
END KREIRANJE_PRIJAVA_BANKE ;

PROCEDURE KR_PRIJAVA_KOMITENTI_OBICNI   (P_ID_POSTA IN NUMBER, 
                                                                      P_DATUM IN DATE, 
                                                                      P_ID_CPM_DAN IN CPM_OBRADA.id_cpm_dan%TYPE,
                                                                      P_BROJ_POSTE IN VARCHAR2, 
                                                                      P_NAZIV_POSTE IN VARCHAR2,
                                                                      P_ID_RJ   IN NUMBER,
                                                                      P_NAZIV_RJ IN VARCHAR2,
                                                                      P_ID_PRIJAVE  IN NUMBER,
                                                                      P_RBR_PRIJAVE IN OUT NUMBER)
IS
sumPromene NUMBER;
sSvrhaUplate VARCHAR2(105);
sZiroRacun   VARCHAR2(20);
sPozivNaBroj VARCHAR2(22); 
nIdTransakcijaNaloga NUMBER; 
sNazivUplatioca VARCHAR2(35); 
sVrstaPromene VARCHAR2(3); 
sSifraPlacanja VARCHAR2(3);
sKonstantaPB VARCHAR2(20); 
sVrstaPrometa  VARCHAR2(1);
sNazivPrimaoca VARCHAR2(35);
sNaziv VARCHAR2(35);
sRacunRJ VARCHAR2(1);
sModelBroja VARCHAR2(2);
nIznos TRANSAKCIJA_KOMITENT.iznos%TYPE;
dProvizija TRANSAKCIJA_ZA_KOMITENTA.provizija_prijava%TYPE;
nSuma TRANSAKCIJA_KOMITENT.iznos%TYPE; 
BEGIN

 ---------------------------------------------------Kreiranje prijava za obiène komitente (Grupa = NULL)-----------------------------------------------------

  sumPromene := 0;
  
  FOR recKomitent IN ( SELECT k.sifra_komitenta, 
                                              k.id_vrsta_transakcije, 
                                              k.sifra_transakcije, 
                                              sum(k.iznos) suma
                                  FROM TRANSAKCIJA_KOMITENT k, TRANSAKCIJA_ZA_KOMITENTA tk
                                  WHERE  k.sifra_komitenta = tk.sifra_komitenta AND
                                              k.sifra_transakcije = tk.sifra_transakcije AND
                                              k.id_vrsta_transakcije = tk.id_vrsta_transakcije AND                                         
                                              k.id_cpm_dan = HEXTORAW(P_ID_CPM_DAN) AND                                         
                                              k.id_transakcija_nalog_pp IS NULL AND                                          
                                              k.status = 'V' AND
                                              tk.id_prijava = P_ID_PRIJAVE
                                  GROUP BY k.sifra_komitenta, k.id_vrsta_transakcije, k.sifra_transakcije)
  LOOP
  
    IF(recKomitent.suma > 0) THEN
  
        BEGIN
          SELECT  DECODE( tk.vrsta_prometa, 1, tk.sifra_placanja_uplata, 2, tk.sifra_placanja_isplata) sifra, 
                       tk.knb, 
                       tk.tekuci_racun_ibm, 
                       DECODE (tk.vrsta_prometa, 1,'U', 2,'I', tk.vrsta_prometa), 
                       substr(tk.opis,1,35) opis, 
                       NVL(provizija_prijava,0)
          INTO sSifraPlacanja, sKonstantaPB, sZiroRacun, sVrstaPrometa, sNaziv, dProvizija 
          FROM TRANSAKCIJA_ZA_KOMITENTA tk
          WHERE  tk.sifra_komitenta = recKomitent.sifra_komitenta AND
                       tk.id_vrsta_transakcije = recKomitent.id_vrsta_transakcije AND
                       tk.sifra_transakcije = recKomitent.sifra_transakcije AND
                       tk.id_prijava = P_ID_PRIJAVE; 
             
           ATRIBUTI_NALOGA (P_ID_PRIJAVE, sVrstaPrometa, sKonstantaPB, sNaziv, P_BROJ_POSTE, P_NAZIV_POSTE, P_DATUM, P_ID_RJ, 
                                         P_NAZIV_RJ, sSvrhaUplate, sVrstaPromene, sNazivUplatioca, sNazivPrimaoca, sZiroRacun, sPozivNaBroj);
        
           SELECT TRANSAKCIJA_NALOG_PP_SEQ.NEXTVAL
           INTO nIdTransakcijaNaloga
           FROM DUAL; 
           
           nIznos := ROUND(recKomitent.suma * (dProvizija/100),2);
         
           P_RBR_PRIJAVE := P_RBR_PRIJAVE + 1;
          
          ------------------Ovde idu izuzeci kojima se prijava kreira po odreðenom modelu i na jedinstven poziv na broj------------------
          
           -- JP ŠABAC - ima drugaciju strukturu poziva na broj 97 - 80099100084635 
           IF (recKomitent.sifra_komitenta = '7390')THEN
             sModelBroja := '97';
             sPozivNaBroj := '80099100084635';
           -- JP Opštinska stambena agencija - ima drugaciju strukturu poziva na broj 97 - 9621510070937708523 
           ELSIF (recKomitent.sifra_komitenta = '4669')THEN
             sModelBroja := '97';
             sPozivNaBroj := '9621510070937708523';       
           --JP Grad. stambena ag. -  Poziv na broj u prijavi uplata treba da bude konstanta 36-226-74214101,  po modelu 97
           ELSIF (recKomitent.sifra_komitenta = '40156')THEN
             sModelBroja := '97';
             sPozivNaBroj := '3622674214101';       
           ELSE
             sModelBroja := '00';
           END IF;
           
           ----------------------------------------------------------------------------------------------------------------------------------------------
         
           ---------------------------------Upis sloga u tabelu TRANSAKCIJA_NALOG_PP----------------------------------
           
           INSERT INTO TRANSAKCIJA_NALOG_PP  (id_transakcija_nalog_pp, 
                                                                       naziv_uplatioca, 
                                                                       adresa_uplatioca, 
                                                                       posta_uplatioca, 
                                                                       naziv_primaoca, 
                                                                       adresa_primaoca, 
                                                                       posta_primaoca,
                                                                       tekuci_racun_primaoca, 
                                                                       poziv_na_broj, 
                                                                       iznos, 
                                                                       svrha_uplate, 
                                                                       sifra_placanja, 
                                                                       vrsta_naloga, 
                                                                       vrsta_promene, 
                                                                       oznaka_promene, 
                                                                       id_radnik, 
                                                                       redni_broj_transakcije, 
                                                                       id_cpm, 
                                                                       datum, 
                                                                       status, 
                                                                       datum_transakcije, 
                                                                       sifra_radnika, 
                                                                       model_poziva_na_broj, 
                                                                       id_prijava, 
                                                                       id_cpm_dan)
            VALUES                                              
                                                                      (nIdTransakcijaNaloga, 
                                                                       sNazivUplatioca, 
                                                                       null, 
                                                                       null, 
                                                                       sNazivPrimaoca, 
                                                                       null, 
                                                                       null,    
                                                                       sZiroRacun, 
                                                                       sPozivNaBroj, 
                                                                       (recKomitent.suma - nIznos), 
                                                                       sSvrhaUplate, 
                                                                       sSifraPlacanja, 
                                                                       'G', 
                                                                       sVrstaPromene, 
                                                                       sVrstaPrometa, 
                                                                       0, 
                                                                       P_RBR_PRIJAVE, 
                                                                       P_ID_POSTA, 
                                                                       P_DATUM, 
                                                                       'V', 
                                                                       SYSDATE(),
                                                                       '0000', 
                                                                       sModelBroja, 
                                                                       P_ID_PRIJAVE, 
                                                                       P_ID_CPM_DAN);   
           
            --------------------------Ažuriranje tebele TRANSAKCIJA_KOMITENT---------------------------------
           
           UPDATE TRANSAKCIJA_KOMITENT tk
           SET      tk.id_transakcija_nalog_pp = nIdTransakcijaNaloga
           WHERE tk.id_cpm_dan = HEXTORAW(P_ID_CPM_DAN) AND 
                       tk.sifra_komitenta = recKomitent.sifra_komitenta AND
                       tk.id_vrsta_transakcije = recKomitent.id_vrsta_transakcije AND
                       tk.sifra_transakcije = recKomitent.sifra_transakcije AND
                       tk.status = 'V' ;         
        EXCEPTION
           WHEN NO_DATA_FOUND THEN NULL;      
        END;    

    END IF;
  END LOOP ;
  ---------------------------------------
  END KR_PRIJAVA_KOMITENTI_OBICNI;
  
  PROCEDURE KR_PRIJAVA_KOMITENTI_GRUPA_I  (P_ID_POSTA IN NUMBER, 
                                                                         P_DATUM IN DATE, 
                                                                         P_ID_CPM_DAN IN CPM_OBRADA.id_cpm_dan%TYPE,
                                                                         P_BROJ_POSTE IN VARCHAR2, 
                                                                         P_NAZIV_POSTE IN VARCHAR2,
                                                                         P_ID_RJ   IN NUMBER,
                                                                         P_NAZIV_RJ IN VARCHAR2,
                                                                         P_ID_PRIJAVE  IN NUMBER,
                                                                         P_RBR_PRIJAVE IN OUT NUMBER)
IS
sumPromene NUMBER;
sSvrhaUplate VARCHAR2(105);
sZiroRacun   VARCHAR2(20);
sPozivNaBroj VARCHAR2(22); 
nIdTransakcijaNaloga NUMBER; 
sNazivUplatioca VARCHAR2(35); 
sVrstaPromene VARCHAR2(3); 
sSifraPlacanja VARCHAR2(3);
sKonstantaPB VARCHAR2(20); 
sVrstaPrometa  VARCHAR2(1);
sNazivPrimaoca VARCHAR2(35);
sNaziv VARCHAR2(35);
sRacunRJ VARCHAR2(1);
sModelBroja VARCHAR2(2);
nIznos TRANSAKCIJA_KOMITENT.iznos%TYPE;
dProvizija TRANSAKCIJA_ZA_KOMITENTA.provizija_prijava%TYPE;
nSuma TRANSAKCIJA_KOMITENT.iznos%TYPE; 
BEGIN
  sumPromene := 0;
  
  -----------------------------------------------------------------------TELEKOM---------------------------------------------------------------------
                                    
  FOR recTelekom IN (SELECT k.sifra_komitenta, 
                                             k.id_vrsta_transakcije,
                                             k.sifra_transakcije,
                                             SUBSTR(k.poziv_na_broj,6,3) mrezna_grupa, 
                                             sum(k.iznos)suma
                                FROM TRANSAKCIJA_KOMITENT k, TRANSAKCIJA_ZA_KOMITENTA tk
                                WHERE  k.sifra_komitenta = tk.sifra_komitenta AND
                                             k.sifra_transakcije = tk.sifra_transakcije AND
                                             k.id_vrsta_transakcije = tk.id_vrsta_transakcije AND
                                             k.id_cpm_dan = HEXTORAW(P_ID_CPM_DAN) AND
                                             k.id_transakcija_nalog_pp IS NULL AND
                                             k.status = 'V' AND
                                             tk.id_prijava = P_ID_PRIJAVE                         
                                GROUP BY k.sifra_komitenta, k.id_vrsta_transakcije, k.sifra_transakcije, SUBSTR(k.poziv_na_broj,6,3))
  LOOP
  
  IF(recTelekom.suma > 0) THEN
  
        BEGIN
          SELECT DECODE( tk.vrsta_prometa, 1, tk.sifra_placanja_uplata, 2, tk.sifra_placanja_isplata) sifra, 
                      tk.knb, trk.tekuci_racun, 
                      DECODE (tk.vrsta_prometa, 1,'U',2,'I', tk.vrsta_prometa),
                      substr(tk.opis,1,35) opis
          INTO     sSifraPlacanja, 
                      sKonstantaPB, 
                      sZiroRacun, 
                      sVrstaPrometa, 
                      sNazivPrimaoca 
          FROM TRANSAKCIJA_ZA_KOMITENTA tk , TEKUCI_RACUN_KOMITENTA  trk  
          WHERE tk.id_transakcija_za_komitenta = trk.id_transakcija_za_komitenta AND
                      tk.sifra_komitenta = recTelekom.sifra_komitenta AND
                      tk.id_vrsta_transakcije = recTelekom.id_vrsta_transakcije AND
                      trk.poziv_na_broj_vrednost = recTelekom.mrezna_grupa ; 
         
           ATRIBUTI_NALOGA (P_ID_PRIJAVE, sVrstaPrometa, recTelekom.mrezna_grupa, sNazivPrimaoca, P_BROJ_POSTE, P_NAZIV_POSTE, P_DATUM, P_ID_RJ, 
                                         P_NAZIV_RJ, sSvrhaUplate, sVrstaPromene, sNazivUplatioca, sNazivPrimaoca, sZiroRacun, sPozivNaBroj);
                            
          SELECT TRANSAKCIJA_NALOG_PP_SEQ.NEXTVAL
          INTO nIdTransakcijaNaloga
          FROM DUAL; 
          
          P_RBR_PRIJAVE := P_RBR_PRIJAVE + 1;
          
          -------------------------------------------Upis sloga u tabelu TRANSAKCIJA_NALOG_PP-----------------------------------------------------
           
          INSERT INTO TRANSAKCIJA_NALOG_PP   (id_transakcija_nalog_pp, 
                                                                       naziv_uplatioca,
                                                                       adresa_uplatioca, 
                                                                       posta_uplatioca, 
                                                                       naziv_primaoca, 
                                                                       adresa_primaoca, 
                                                                       posta_primaoca,
                                                                       tekuci_racun_primaoca, 
                                                                       poziv_na_broj,
                                                                       iznos, 
                                                                       svrha_uplate, 
                                                                       sifra_placanja, 
                                                                       vrsta_naloga, 
                                                                       vrsta_promene, 
                                                                       oznaka_promene,
                                                                       id_radnik, 
                                                                       redni_broj_transakcije,
                                                                       id_cpm,
                                                                       datum, 
                                                                       status, 
                                                                       datum_transakcije, 
                                                                       sifra_radnika, 
                                                                       model_poziva_na_broj,
                                                                       id_prijava, 
                                                                       id_cpm_dan)
          VALUES
                                                                      (nIdTransakcijaNaloga, 
                                                                       sNazivUplatioca, 
                                                                       null, 
                                                                       null, 
                                                                       sNazivPrimaoca,
                                                                       null, 
                                                                       null,    
                                                                       sZiroRacun, 
                                                                       sPozivNaBroj,
                                                                       recTelekom.suma, 
                                                                       sNazivPrimaoca, 
                                                                       sSifraPlacanja, 
                                                                       'G', 
                                                                       sVrstaPromene, 
                                                                       sVrstaPrometa, 
                                                                       0, 
                                                                       P_RBR_PRIJAVE, 
                                                                       P_ID_POSTA, 
                                                                       P_DATUM, 
                                                                       'V', 
                                                                       SYSDATE(), 
                                                                       '0000',
                                                                       '00', 
                                                                       P_ID_PRIJAVE, 
                                                                       P_ID_CPM_DAN);   
          
          -------------------------------------------------------------Ažuriranje tebele TRANSAKCIJA_KOMITENT---------------------------------------------------
          
          UPDATE TRANSAKCIJA_KOMITENT tk
          SET      tk.id_transakcija_nalog_pp = nIdTransakcijaNaloga
          WHERE tk.id_cpm_dan = HEXTORAW(P_ID_CPM_DAN) AND
                      tk.sifra_komitenta = recTelekom.sifra_komitenta AND
                      tk.id_vrsta_transakcije = recTelekom.id_vrsta_transakcije AND
                      SUBSTR(tk.poziv_na_broj,6,3) = recTelekom.mrezna_grupa AND
                      tk.id_transakcija_nalog_pp IS NULL AND
                      tk.status = 'V' ;
        EXCEPTION
           WHEN OTHERS THEN 
           RAISE_APPLICATION_ERROR(-20001, 'Nije prošla obrada za Telekom, mrežna grupa = ' || recTelekom.mrezna_grupa || ', poruka greške = ' || SQLERRM);
        END;
        
    END IF;
  END LOOP ;
     
END KR_PRIJAVA_KOMITENTI_GRUPA_I; 

 PROCEDURE KR_PRIJAVA_KOMITENTI_GRUPA_II  (P_ID_POSTA IN NUMBER, 
                                                                         P_DATUM IN DATE, 
                                                                         P_ID_CPM_DAN IN CPM_OBRADA.id_cpm_dan%TYPE,
                                                                         P_BROJ_POSTE IN VARCHAR2, 
                                                                         P_NAZIV_POSTE IN VARCHAR2,
                                                                         P_ID_RJ   IN NUMBER,
                                                                         P_NAZIV_RJ IN VARCHAR2,
                                                                         P_ID_PRIJAVE  IN NUMBER,
                                                                         P_RBR_PRIJAVE IN OUT NUMBER)
IS
sumPromene NUMBER;
sSvrhaUplate VARCHAR2(105);
sZiroRacun   VARCHAR2(20);
sPozivNaBroj VARCHAR2(22); 
nIdTransakcijaNaloga NUMBER; 
sNazivUplatioca VARCHAR2(35); 
sVrstaPromene VARCHAR2(3); 
sSifraPlacanja VARCHAR2(3);
sKonstantaPB VARCHAR2(20); 
sVrstaPrometa  VARCHAR2(1);
sNazivPrimaoca VARCHAR2(35);
sNaziv VARCHAR2(35);
sRacunRJ VARCHAR2(1);
sModelBroja VARCHAR2(2);
nIznos TRANSAKCIJA_KOMITENT.iznos%TYPE;
dProvizija TRANSAKCIJA_ZA_KOMITENTA.provizija_prijava%TYPE;
nSuma TRANSAKCIJA_KOMITENT.iznos%TYPE; 
BEGIN
  sumPromene := 0; 
  
  ----------------------------------------------VIRTUELNI VAUÈERI - VIP, TELEKOM, TELENOR--------------------------------------------
    
  SELECT NVL(sum(k.iznos),0) suma
  INTO nSuma
  FROM TRANSAKCIJA_KOMITENT k, TRANSAKCIJA_ZA_KOMITENTA tk
  WHERE    k.sifra_komitenta = tk.sifra_komitenta AND
                 k.sifra_transakcije = tk.sifra_transakcije AND
                 k.id_vrsta_transakcije = tk.id_vrsta_transakcije AND
                 k.id_cpm_dan = HEXTORAW(P_ID_CPM_DAN) AND
                 k.id_transakcija_nalog_pp IS NULL AND
                 tk.id_prijava = P_ID_PRIJAVE AND
                 k.status = 'V'; 
                
 IF (nSuma > 0) THEN 

    BEGIN
        SELECT *
        INTO sSifraPlacanja, 
                sKonstantaPB, 
                sZiroRacun, 
                sVrstaPrometa,
                sNaziv, 
                dProvizija  
        FROM (SELECT DECODE( tk.vrsta_prometa, 1,tk.sifra_placanja_uplata, 2, tk.sifra_placanja_isplata) sifra,
                               tk.knb, tk.tekuci_racun_ibm, 
                               DECODE (tk.vrsta_prometa, 1,'U', 2,'I', tk.vrsta_prometa), 
                               substr(tk.opis,1,35) opis, 
                               NVL(provizija_prijava,0)
                  FROM TRANSAKCIJA_ZA_KOMITENTA tk
                  WHERE  tk.id_vrsta_transakcije = 256 AND
                              tk.id_prijava = P_ID_PRIJAVE)
        WHERE ROWNUM < 2; 
     
        ATRIBUTI_NALOGA (P_ID_PRIJAVE, sVrstaPrometa, sKonstantaPB, sNaziv, P_BROJ_POSTE, P_NAZIV_POSTE, P_DATUM, P_ID_RJ, 
                                      P_NAZIV_RJ, sSvrhaUplate, sVrstaPromene, sNazivUplatioca, sNazivPrimaoca, sZiroRacun, sPozivNaBroj);

        SELECT TRANSAKCIJA_NALOG_PP_SEQ.NEXTVAL
        INTO nIdTransakcijaNaloga
        FROM DUAL; 
     
        P_RBR_PRIJAVE := P_RBR_PRIJAVE + 1;
        
        --Ako se radi o grupi 3 (ID_PRIJAVA = 25) onda je primalac E - poslovanje (To se mora zakucati u kodu)
                
        IF(P_ID_PRIJAVE = 25) THEN
            sNazivPrimaoca := 'E - poslovanje';
        END IF;
      
        ----------------------------------Upis sloga u tabelu TRANSAKCIJA_NALOG_PP-----------------------------------------
        
        INSERT INTO TRANSAKCIJA_NALOG_PP (id_transakcija_nalog_pp, 
                                                                   naziv_uplatioca,
                                                                   adresa_uplatioca,
                                                                   posta_uplatioca, 
                                                                   naziv_primaoca, 
                                                                   adresa_primaoca, 
                                                                   posta_primaoca,
                                                                   tekuci_racun_primaoca, 
                                                                   poziv_na_broj, 
                                                                   iznos, 
                                                                   svrha_uplate, 
                                                                   sifra_placanja,
                                                                   vrsta_naloga, 
                                                                   vrsta_promene, 
                                                                   oznaka_promene, 
                                                                   id_radnik, 
                                                                   redni_broj_transakcije, 
                                                                   id_cpm, 
                                                                   datum, 
                                                                   status, 
                                                                   datum_transakcije,
                                                                   sifra_radnika, 
                                                                   model_poziva_na_broj, 
                                                                   id_prijava,
                                                                   id_cpm_dan)
        VALUES
                                                                  (nIdTransakcijaNaloga, 
                                                                  sNazivUplatioca, 
                                                                  null, 
                                                                  null, 
                                                                  sNazivPrimaoca, 
                                                                  null, 
                                                                  null, 
                                                                  sZiroRacun, 
                                                                  sPozivNaBroj, 
                                                                  nSuma, 
                                                                  sSvrhaUplate, 
                                                                  sSifraPlacanja,
                                                                  'G', 
                                                                  sVrstaPromene, 
                                                                  sVrstaPrometa, 
                                                                  0, 
                                                                  P_RBR_PRIJAVE,
                                                                  P_ID_POSTA, 
                                                                  P_DATUM,
                                                                  'V', 
                                                                  SYSDATE(), 
                                                                  '0000', 
                                                                  '00', 
                                                                  P_ID_PRIJAVE, 
                                                                  P_ID_CPM_DAN);   
       
        -----------------------------Ažuriranje tebele TRANSAKCIJA_KOMITENT------------------------------
        
        UPDATE TRANSAKCIJA_KOMITENT k
        SET      k.id_transakcija_nalog_pp = nIdTransakcijaNaloga
        WHERE k.id_cpm_dan = HEXTORAW(P_ID_CPM_DAN) AND
                    k.status = 'V' AND 
                    EXISTS  (SELECT 1 
                                  FROM TRANSAKCIJA_ZA_KOMITENTA tk
                                  WHERE k.sifra_komitenta = tk.sifra_komitenta AND
                                              k.sifra_transakcije = tk.sifra_transakcije AND
                                              k.id_vrsta_transakcije = tk.id_vrsta_transakcije AND
                                              tk.id_prijava = P_ID_PRIJAVE);
    EXCEPTION
       WHEN NO_DATA_FOUND THEN NULL;       
     END;      
  END IF ;      
  
END KR_PRIJAVA_KOMITENTI_GRUPA_II; 

PROCEDURE KREIRANJE_PRIJAVA_KOMITENTI (P_GRUPA IN VARCHAR2,
                                                                    P_ID_POSTA IN NUMBER, 
                                                                    P_DATUM IN DATE, 
                                                                    P_ID_CPM_DAN IN CPM_OBRADA.id_cpm_dan%TYPE,
                                                                    P_BROJ_POSTE IN VARCHAR2, 
                                                                    P_NAZIV_POSTE IN VARCHAR2,
                                                                    P_ID_RJ   IN NUMBER,
                                                                    P_NAZIV_RJ IN VARCHAR2,
                                                                    P_ID_PRIJAVE  IN NUMBER,
                                                                    P_RBR_PRIJAVE IN OUT NUMBER, 
                                                                    P_REZULTAT  OUT NUMBER)
IS
BEGIN
  
  CASE  
       -----------------------------------------Kreiranje prijava za obiène komitente (Nulta grupa)-------------------------------------------
       WHEN P_GRUPA = '0' THEN                   
                    
          KR_PRIJAVA_KOMITENTI_OBICNI (P_ID_POSTA, 
                                                            P_DATUM, 
                                                            P_ID_CPM_DAN,
                                                            P_BROJ_POSTE, 
                                                            P_NAZIV_POSTE,
                                                            P_ID_RJ,
                                                            P_NAZIV_RJ,
                                                            P_ID_PRIJAVE,
                                                            P_RBR_PRIJAVE);
                                                            
       -------------------------------------Kreiranje prijava za komitente grupe I (Telekom raèune)-----------------------------------------
       WHEN P_GRUPA = '1' THEN           

          KR_PRIJAVA_KOMITENTI_GRUPA_I (P_ID_POSTA, 
                                                              P_DATUM, 
                                                              P_ID_CPM_DAN,
                                                              P_BROJ_POSTE, 
                                                              P_NAZIV_POSTE,
                                                              P_ID_RJ,
                                                              P_NAZIV_RJ,
                                                              P_ID_PRIJAVE,
                                                              P_RBR_PRIJAVE);
                                                              
      -------------------------Kreiranje prijava za komitente grupe II (Virtuelni vauèeri - Telekom, Telenor i VIP)-------------------------      
      -------------------Kreiranje prijava za komitente grupe III (Vauèeri - Limundo, PostFIN i evidentiranje sa uplatom)------------------   
                                                      
      WHEN P_GRUPA = '2' OR P_GRUPA = '3' THEN
        
         KR_PRIJAVA_KOMITENTI_GRUPA_II (P_ID_POSTA, 
                                                              P_DATUM, 
                                                              P_ID_CPM_DAN,
                                                              P_BROJ_POSTE, 
                                                              P_NAZIV_POSTE,
                                                              P_ID_RJ,
                                                              P_NAZIV_RJ,
                                                              P_ID_PRIJAVE,
                                                              P_RBR_PRIJAVE);        
      
       END CASE;
END KREIRANJE_PRIJAVA_KOMITENTI;

PROCEDURE PRIPREMA_NALOGA_ZA_TRANSFER (P_ID_POSTA IN NUMBER, 
                                       P_DATUM IN DATE,
                                       P_ID_CPM_DAN IN CPM_OBRADA.id_cpm_dan%TYPE, 
                                       P_BROJ_POSTE IN VARCHAR2, 
                                       P_NAZIV_POSTE IN VARCHAR2
                                       ) 
IS
   
sSlog VARCHAR2(500);
nBrojac NUMBER;
sSifraPosiljaoca VARCHAR2(7);
sTotal VARCHAR2(15);
sVrstaPrometa VARCHAR2(3);
nRedniBrojSloga NUMBER ; -- broji sve slogove 1 poruke
nSumarniBrojKomadaSlogova NUMBER; -- broji stvarne slogove grupe (bez naslovnog i kranjeg sloga poruke)

sumIznosa NUMBER (18,2);
sSifraPS VARCHAR2(5);
nTotal NUMBER; 
sSifraDomicilaPromene VARCHAR2(7);
sSifraPrimaoca  VARCHAR2(7); 
sNazivPoste  VARCHAR2(20);
Referenca RAW(16);
sNoviSlog VARCHAR2(35); 

BEGIN
  
  sSifraPS := '001';
           -- obrada naloga : posta, dan, vrsta_promene (iplata/isplata)  ----
  sSifraDomicilaPromene := P_BROJ_POSTE ||'00'; 
  sSifraPrimaoca := '0'|| id_radna_jedinica(P_ID_POSTA) ||'0000'; 
  sNazivPoste := P_NAZIV_POSTE ;
  
  nRedniBrojSloga:=2;
  nTotal := 0;  
  FOR recVodeci002 IN (  SELECT DISTINCT DECODE(t.oznaka_promene,'I',2,'U',1) oznaka_uplate_isplate
                            FROM TRANSAKCIJA_NALOG_PP t
                           WHERE t.id_dnevnik_transakcija IS NULL
                             AND t.id_cpm_dan = HEXTORAW(P_ID_CPM_DAN)
                             AND status ='V'
                             AND hitan_pazar = 'N' -- ovo treba izbaciti 
                       )      


    LOOP    
      sSlog:= '';
      sNoviSlog := '';
      sSlog:= '002'||sSifraDomicilaPromene ||sSifraPrimaoca || ltrim(TO_CHAR(P_DATUM,'YYMMDD'));
      sSlog:= sSlog||'01'||recVodeci002.oznaka_uplate_isplate||'01'||'9999'||'0'||'001'||sSifraPS ;
      sSlog:= RPAD(sSlog,80,' ');  
      
      INSERT INTO STAVKA_DNEVNIKA(ID_CPM_DAN, VREDNOST, REDNI_BROJ, VRSTA_SLOGA) 
                           VALUES(P_ID_CPM_DAN, sSlog,nRedniBrojSloga, 'N'); 
    
      nRedniBrojSloga:=nRedniBrojSloga+1;                                  
      nSumarniBrojKomadaSlogova:=1;
      sumIznosa := 0;
      
      FOR recSlogoviPromena IN (  SELECT DECODE (t.naziv_primaoca, null, ' ', t.naziv_primaoca) naziv_primaoca , 
                                         DECODE (t.adresa_primaoca, null, ' ', t.adresa_primaoca) adresa_primaoca, 
                                         DECODE (t.posta_primaoca,null, ' ', t.posta_primaoca) posta_primaoca,
                                         DECODE (t.naziv_uplatioca, null, ' ', t.naziv_uplatioca) naziv_uplatioca,
                                         DECODE (t.adresa_uplatioca, null, ' ', t.adresa_uplatioca)adresa_uplatioca,
                                         DECODE (t.posta_uplatioca, null, ' ', t.posta_uplatioca)posta_uplatioca,
                                         t.tekuci_racun_primaoca, t.iznos, t.svrha_uplate, t.sifra_placanja, 
                                         DECODE (t.poziv_na_broj, null, ' ', t.poziv_na_broj) poziv_na_broj, t.datum, t.vrsta_promene,
                                         t.sifra_radnika, t.redni_broj_transakcije,
                                         DECODE (t.model_poziva_na_broj, null, '00', t.model_poziva_na_broj) model_poziva_na_broj, t.vrsta_naloga,
                                         DECODE (t.referenca_naloga, null, ' ',RAWTOHEX(t.referenca_naloga))referenca_naloga, 
                                         DECODE(t.nacin_realizacije,'ON','0','OF','1','FT','2', null, ' ') nacin_realizacije, 
                                         DECODE(t.dalja_realizacija, null, ' ', t.dalja_realizacija) dalja_realizacija
                                   FROM TRANSAKCIJA_NALOG_PP t
                                  WHERE t.id_cpm_dan = HEXTORAW(P_ID_CPM_DAN)
                                    AND t.oznaka_promene=DECODE(recVodeci002.oznaka_uplate_isplate,1,'U',2,'I')
                                    AND t.id_dnevnik_transakcija IS NULL
                                    AND t.status = 'V'
                                    AND hitan_pazar = 'N' -- izbaciti
                               )
     
      LOOP
            
        sSlog:= '003'||LPAD(recSlogoviPromena.sifra_radnika,4,0) || LPAD(recSlogoviPromena.redni_broj_transakcije,4,0);
        sSlog:= sSlog||recSlogoviPromena.vrsta_promene ||'0'; -- heder
       
        sSlog:= sSlog||RPAD(recSlogoviPromena.naziv_uplatioca,35,' ') || RPAD(recSlogoviPromena.adresa_uplatioca,35,' ') || RPAD(recSlogoviPromena.posta_uplatioca, 35, ' ');
        sSlog:= sSlog||RPAD(recSlogoviPromena.naziv_primaoca,35,' ') || RPAD(recSlogoviPromena.adresa_primaoca,35,' ') || RPAD(recSlogoviPromena.posta_primaoca,35,' ');
        sSlog:= sSlog||RPAD(recSlogoviPromena.tekuci_racun_primaoca,18,' ')||'DIN';
      
        sumIznosa := sumIznosa + recSlogoviPromena.iznos;
        sSlog:= sSlog||FORMAT_IZNOS (recSlogoviPromena.iznos, 15);
        -- novi slog je zbog online naloga :
        -- nacin realizacije u posti(0-online, 1-offline, 2 - odlozeni online), realizacija naloga (1- poslat na IBM, 2- nije poslat, 0 - ne znamo status slanja na IBM, server nije vratio odgovor na klijenta)
        -- refrenca 32 karaktera i 1 prazan polje
        sNoviSlog :=  recSlogoviPromena.nacin_realizacije || recSlogoviPromena.dalja_realizacija || RPAD(recSlogoviPromena.referenca_naloga,32,' ') || ' ';
        sSlog:= sSlog|| RPAD(recSlogoviPromena.svrha_uplate,70,' ') || RPAD(sNoviSlog,35,' ') || recSlogoviPromena.sifra_placanja; 
      
        sSlog:= sSlog|| RPAD(recSlogoviPromena.model_poziva_na_broj,2,' ')|| RPAD(recSlogoviPromena.poziv_na_broj,20,' ') || RPAD(sNazivPoste,20,' ');
        sSlog:= sSlog|| TO_CHAR(recSlogoviPromena.datum,'YYYYMMDD')|| TO_CHAR(recSlogoviPromena.datum,'YYYYMMDD') ;  
      
         INSERT INTO STAVKA_DNEVNIKA(ID_CPM_DAN, VREDNOST, REDNI_BROJ, VRSTA_SLOGA) 
                              VALUES(P_ID_CPM_DAN, sSlog,nRedniBrojSloga, 'N'); 
        
        nRedniBrojSloga:=nRedniBrojSloga+1;
        nSumarniBrojKomadaSlogova:=nSumarniBrojKomadaSlogova+1;
                    
      END LOOP ;      
    
      
      nSumarniBrojKomadaSlogova:=nSumarniBrojKomadaSlogova+1;
    
      sSlog:= '992'||sSifraDomicilaPromene ||sSifraPrimaoca || ltrim(TO_CHAR(P_DATUM,'YYMMDD'));
      sSlog:= sSlog||'01'||recVodeci002.oznaka_uplate_isplate ||'01'||'9999';
    
      sSlog:=sSlog||LPAD(TO_CHAR(nSumarniBrojKomadaSlogova),7,'0');
      sSlog:=sSlog||FORMAT_IZNOS (sumIznosa, 15);
      nTotal := nTotal + sumIznosa;
      sSlog:=sSlog||'000000000000000'||sSifraPS;
        
      INSERT INTO STAVKA_DNEVNIKA(ID_CPM_DAN, VREDNOST, REDNI_BROJ, VRSTA_SLOGA, IZNOS) 
                           VALUES(P_ID_CPM_DAN, sSlog,nRedniBrojSloga, 'N', sumIznosa);          
      nRedniBrojSloga:=nRedniBrojSloga+1;
       
      /*UPDATE TRANSAKCIJA_NALOG_PP
         SET id_dnevnik_transakcija = P_ID_DNEVNIK
       WHERE id_cpm_dan = P_ID_CPM_DAN
         AND oznaka_promene = DECODE(recVodeci002.oznaka_uplate_isplate,1,'U',2,'I')
         AND id_dnevnik_transakcija IS NULL
         AND status = 'V';*/
                                
    END LOOP;

END PRIPREMA_NALOGA_ZA_TRANSFER;


PROCEDURE  PRIPREMA_DNEVNIKA (P_ID_CPM_DAN IN VARCHAR2,
                              P_REZULTAT  OUT NUMBER)
IS


nRezultat NUMBER; 
nIdDnevnikKom NUMBER;
nIdDnevnikSB NUMBER;
nIdDnevnikKliring NUMBER;
nIdDnevnikNalog NUMBER;

sPostanskiBroj VARCHAR2(5); 
sNazivPoste VARCHAR2(20);  
sSlog VARCHAR2(500);
sKljuc VARCHAR2(27);

nIdCPMDan CPM_OBRADA.id_cpm_dan%TYPE;

nIdCPM NUMBER;
dDatum DATE;

sObradaDnevnika CPM_OBRADA.obrada_dnevnika%TYPE;

BEGIN
  P_REZULTAT := 1;
  nIdCPMDan := HEXTORAW(P_ID_CPM_DAN);
  
  SELECT co.id_cpm, TRUNC(co.datum) datum, obrada_dnevnika
    INTO nIdCPM, dDatum, sObradaDnevnika 
    FROM CPM_OBRADA co
   WHERE co.kreiranje_prijava_banka = 'D'   
     AND co.kreiranje_prijava_komitent = 'D'
     AND co.obrada_nalog_pp = 'D'
     AND co.id_cpm_dan = nIdCPMDan;

  IF sObradaDnevnika = 'D' THEN
    P_REZULTAT := 0;
    RETURN;
  END IF;
      
  
  SELECT  SUBSTR(cpm.postanski_broj,1, 5) postanski_broj, SUBSTR(oc.naziv,1, 20) naziv 
    INTO  sPostanskiBroj, sNazivPoste      
    FROM  POSLOVNO_OKRUZENJE.CVOR_POSTANSKE_MREZE cpm, POSLOVNO_OKRUZENJE.ORGANIZACIONA_CELINA oc
   WHERE cpm.id_organizaciona_celina = oc.id_organizaciona_celina
     AND  cpm.id_cvor_postanske_mreze = nIdCPM;
     

     
  PRIPREMA_DNEV_KOMITENATA (nIdCPM, dDatum, nIdCPMDan, sPostanskiBroj, sNazivPoste); 
       
  PRIPREMA_DNEV_SRPSKA_BANKA (nIdCPM, dDatum, nIdCPMDan, sPostanskiBroj, sNazivPoste);
      
  PRIPREMA_DNEVNIKA_CEKOVA (nIdCPM, dDatum, nIdCPMDan, sPostanskiBroj, sNazivPoste);
   
  PRIPREMA_NALOGA_ZA_TRANSFER (nIdCPM, dDatum, nIdCPMDan, sPostanskiBroj, sNazivPoste);
  
  PRIPREMA_DNEV_LOKAL_KOMITENATA (nIdCPM, dDatum, nIdCPMDan, sPostanskiBroj, sNazivPoste);
        
  UPDATE CPM_OBRADA 
     SET obrada_prijava = 'D',
         obrada_dnevnika = 'D'
   WHERE id_cpm_dan = nIdCPMDan
     AND NVL(obrada_prijava, 'N') = 'N'
     AND NVL(obrada_dnevnika, 'N') = 'N';

  IF SQL%ROWCOUNT <> 1 THEN
    RAISE_APPLICATION_ERROR(-20001, 'Obrada je veæ uraðena prethodnom iteracijom!!!');
  END IF;

  P_REZULTAT := 0;
   
END PRIPREMA_DNEVNIKA;

                        
                                       
PROCEDURE PRIPREMA_DNEV_KOMITENATA (P_ID_POSTA IN NUMBER, 
                                    P_DATUM IN DATE, 
                                    P_ID_CPM_DAN IN CPM_OBRADA.id_cpm_dan%TYPE,
                                    P_BROJ_POSTE IN VARCHAR2, 
                                    P_NAZIV_POSTE IN VARCHAR2 
                                    ) IS
 sSlog VARCHAR2(500);

 nBrojac NUMBER;
 sSifraPosiljaoca VARCHAR2(7);
 sTotal VARCHAR2(15);
 sVrstaPrometa VARCHAR2(3);
 nRedniBrojSloga NUMBER ; -- broji sve slogove 1 poruke
 nSumarniBrojKomadaSlogova NUMBER; -- broji stvarne slogove grupe (bez naslovnog i kranjeg sloga poruke)
 UKUPNO NUMBER;
 nIdDnevnik NUMBER;
 cPom VARCHAR2(30);
 sumIznosa NUMBER ;
 sVrstaKom VARCHAR2(1);
 sSifraKomitenta VARCHAR2(3);
 sSifraDomicilaPromene VARCHAR2(7);
 sSifraPrimaoca  VARCHAR2(7); 
 sSifraIBM VARCHAR2(5);
 nTotal NUMBER;
 sSifraKomitentaIBM VARCHAR2(3);
 
BEGIN
   -- obrada dnevnika : posta, dan  ----
  
  sSifraDomicilaPromene := P_BROJ_POSTE ||'00'; 
  sSifraPrimaoca := '0'|| id_radna_jedinica(P_ID_POSTA) ||'0000'; 

  nRedniBrojSloga:=2;
  nTotal := 0;
  FOR recVodeci002 IN 
           (SELECT DISTINCT k.sifra_komitenta sifra_komitenta, k.id_vrsta_transakcije, k.sifra_transakcije, vrsta_prometa, 'K' vrsta, '01' vrsta_prometa_IBM 
            FROM TRANSAKCIJA_KOMITENT k, TRANSAKCIJA_ZA_KOMITENTA tk
           WHERE k.sifra_komitenta = tk.sifra_komitenta
             AND k.sifra_transakcije = tk.sifra_transakcije
             --AND k.id_dnevnik_transakcija IS NULL
             AND k.id_cpm_dan = hextoraw(P_ID_CPM_DAN)
             AND k.status = 'V'
             AND tk.transfer_dn = 'D'
             UNION ALL
            SELECT DISTINCT b.sifra_banke sifra_komitenta, b.id_vrsta_transakcije, '' sifra_transakcije, DECODE(b.vrsta_transakcije,'U',1,'I',2) vrsta_prometa,
                  'B' vrsta, tb.vrsta_promene vrsta_prometa_IBM  
              FROM TRANSAKCIJA_BANKA b, TRANSAKCIJA_ZA_BANKU tb
             WHERE b.sifra_banke = tb.sifra_banke
               AND b.id_vrsta_transakcije  = tb.id_vrsta_transakcije
              -- AND b.id_dnevnik_transakcija IS NULL
               AND b.id_cpm_dan = hextoraw(P_ID_CPM_DAN)
               AND b.status = 'V'
               AND b.sifra_banke = '200' -- SRPSKA BANKA IDE POSEBNO. OSTALE BANKE IDU U KLIRING
             ORDER BY 4,1,2
            )

   LOOP 
     IF (recVodeci002.vrsta = 'K') THEN
         IF (recVodeci002.sifra_komitenta = '1364')THEN-- TELEKOM
           sSifraKomitentaIBM := '003';
         ELSIF (recVodeci002.sifra_komitenta = '1938')THEN-- INFOSTAN
           sSifraKomitentaIBM := '037';  
         ELSE
           sSifraKomitentaIBM := '002';  
         END IF; 
     ELSE
          sSifraKomitentaIBM := '001'; -- POSTANSKA
     END IF; 
      
     sSlog:= '';
     sSlog:= '002'||sSifraDomicilaPromene ||sSifraPrimaoca || LTRIM(TO_CHAR(P_DATUM,'YYMMDD'));
     sSlog:= sSlog||'01'||recVodeci002.vrsta_prometa||recVodeci002.vrsta_prometa_IBM ||'9999'||'0'||'001'||sSifraKomitentaIBM ;
     sSlog:= RPAD(sSlog,80,' ');  
          
     INSERT INTO STAVKA_DNEVNIKA(ID_CPM_DAN, VREDNOST, REDNI_BROJ, VRSTA_SLOGA) 
                          VALUES(P_ID_CPM_DAN, sSlog,nRedniBrojSloga, 'O');
    
     nRedniBrojSloga:=nRedniBrojSloga+1;                                  
     nSumarniBrojKomadaSlogova:=1;
     -- za svaku postu generisem naloge odredjene promene
     sumIznosa := 0;
     IF (recVodeci002.vrsta = 'K') THEN
       FOR recSlogoviPromena IN 
                           ( SELECT tk.tekuci_racun, k.poziv_na_broj, k.iznos, k.procenat_popusta, k.iznos_sa_popustom, k.sifra_komitenta,
                                    tk.sifra_transakcije, k.redni_broj_transakcije, k.sifra_radnika, tk.FT97_DN, tk.vrsta_promene
                              FROM TRANSAKCIJA_KOMITENT k , TRANSAKCIJA_ZA_KOMITENTA tk
                             WHERE k.sifra_komitenta = tk.sifra_komitenta
                               AND k.sifra_transakcije = tk.sifra_transakcije
                               AND k.id_vrsta_transakcije = tk.id_vrsta_transakcije
                               AND k.id_cpm_dan = hextoraw(P_ID_CPM_DAN)
                               AND k.sifra_komitenta = recVodeci002.sifra_komitenta
                               AND k.sifra_transakcije = recVodeci002.sifra_transakcije
                               AND k.status ='V')
       LOOP
         
         sSlog:= '003'||LPAD(recSlogoviPromena.sifra_radnika,4,0) || LPAD(recSlogoviPromena.redni_broj_transakcije,4,0);
         sSlog:= sSlog||recSlogoviPromena.vrsta_promene||'0'; 
         
         IF (recVodeci002.sifra_komitenta = '1938') THEN  --INFOSTAN
           sSlog:=sSlog|| LPAD(recSlogoviPromena.poziv_na_broj,25,'0') || FORMAT_IZNOS (recSlogoviPromena.iznos, 15);
           sSlog:=sSlog|| LPAD (recSlogoviPromena.procenat_popusta, 4, '0')|| FORMAT_IZNOS (recSlogoviPromena.iznos, 15);
         ELSIF (recVodeci002.sifra_komitenta = '1364')THEN -- TELEKOM
           sSlog:=sSlog|| LPAD(recSlogoviPromena.poziv_na_broj,15,'0') ||'97' || FORMAT_IZNOS (recSlogoviPromena.iznos, 15);
         ELSE
           IF (recSlogoviPromena.FT97_DN = 'D') THEN
             sSlog := sSlog || LPAD(recSlogoviPromena.poziv_na_broj,20,'0') || FORMAT_IZNOS (recSlogoviPromena.iznos, 12);
           ELSIF(recSlogoviPromena.FT97_DN = 'N') THEN
             sSlog := sSlog || LPAD(recSlogoviPromena.poziv_na_broj,16,'0') || FORMAT_IZNOS (recSlogoviPromena.iznos, 12);   
           END IF;  
         END IF;
                              
         INSERT INTO STAVKA_DNEVNIKA(ID_CPM_DAN, VREDNOST, REDNI_BROJ, VRSTA_SLOGA) 
                          VALUES(P_ID_CPM_DAN, sSlog,nRedniBrojSloga, 'O');
         
         nSumarniBrojKomadaSlogova:=nSumarniBrojKomadaSlogova+1;
         nRedniBrojSloga:=nRedniBrojSloga+1;
         sumIznosa := sumIznosa + recSlogoviPromena.iznos;
       END LOOP ;      
         
       /*UPDATE TRANSAKCIJA_KOMITENT
          SET id_dnevnik_transakcija = P_ID_DNEVNIK
        WHERE id_cpm_dan = P_ID_CPM_DAN
          AND sifra_komitenta = recVodeci002.sifra_komitenta
          AND sifra_transakcije = recVodeci002.sifra_transakcije
          AND status ='V';*/
          
     ELSIF(recVodeci002.vrsta = 'B') THEN 
       
       FOR recSlogoviPromenaBanke IN
                                 ( SELECT SUBSTR(b.broj_tekuceg_racuna,7,10) broj_tekuceg_racuna, b.broj_ceka, b.broj_stedne_knjizice, b.iznos_transakcije, b.vrsta_promene, 
                                            b.nacin_realizacije,DECODE(b.autorizacioni_broj, NULL, '0', b.autorizacioni_broj)autorizacioni_broj, 
                                            b.sifra_banke, b.sifra_transakcije, b.novo_stanje, DECODE(b.broj_kartice, NULL, '0', b.broj_kartice) broj_kartice, DECODE(b.akceptant, NULL, '0', b.akceptant)akceptant,
                                            b.sifra_radnika, b.redni_broj_transakcije, b.rrn
                                      FROM TRANSAKCIJA_BANKA b
                                     WHERE b.id_cpm_dan = hextoraw(P_ID_CPM_DAN)
                                       AND b.sifra_banke = recVodeci002.sifra_komitenta
                                       AND b.id_vrsta_transakcije = recVodeci002.id_vrsta_transakcije
                                       AND b.status = 'V' )
      
       LOOP
         sSlog:= '003'||LPAD(recSlogoviPromenaBanke.sifra_radnika,4,0) || LPAD(recSlogoviPromenaBanke.redni_broj_transakcije,4,0);
         sSlog:= sSlog||recSlogoviPromenaBanke.vrsta_promene ||'0'; 
       
         IF (recSlogoviPromenaBanke.vrsta_promene IN ('402','403')) THEN    -- STEDNJA
           sSlog:=sSlog|| LPAD(recSlogoviPromenaBanke.broj_stedne_knjizice, 8,'0') || FORMAT_IZNOS (recSlogoviPromenaBanke.iznos_transakcije, 11);
           sSlog:=sSlog|| FORMAT_IZNOS (recSlogoviPromenaBanke.novo_stanje, 13);
         ELSIF (recSlogoviPromenaBanke.vrsta_promene = '556') THEN          -- POSTTERMINAL
           sSlog:=sSlog|| LPAD(recSlogoviPromenaBanke.broj_kartice,19,'0') || FORMAT_IZNOS (recSlogoviPromenaBanke.iznos_transakcije, 11)|| LPAD(recSlogoviPromenaBanke.autorizacioni_broj,6,'0');
           sSlog:=sSlog|| LPAD(recSlogoviPromenaBanke.akceptant,15,'0') || LPAD(recSlogoviPromenaBanke.rrn,12,'0');
         ELSE                                                          -- TEKUCI RACUNI
           sSlog:=sSlog|| LPAD(recSlogoviPromenaBanke.broj_tekuceg_racuna,10,'0') || FORMAT_IZNOS (recSlogoviPromenaBanke.iznos_transakcije, 11)|| LPAD(recSlogoviPromenaBanke.broj_ceka,8,'0');
         END IF;
                  
         sumIznosa := sumIznosa + recSlogoviPromenaBanke.iznos_transakcije;
         INSERT INTO STAVKA_DNEVNIKA(ID_CPM_DAN, VREDNOST, REDNI_BROJ, VRSTA_SLOGA) 
                          VALUES(P_ID_CPM_DAN, sSlog,nRedniBrojSloga, 'O');
         nRedniBrojSloga:=nRedniBrojSloga+1;
         nSumarniBrojKomadaSlogova:=nSumarniBrojKomadaSlogova+1;
       END LOOP ;      
            
       /*UPDATE TRANSAKCIJA_BANKA
          SET id_dnevnik_transakcija = P_ID_DNEVNIK
        WHERE id_cpm_dan = P_ID_CPM_DAN
          AND sifra_banke = recVodeci002.sifra_komitenta
          AND id_vrsta_transakcije = recVodeci002.id_vrsta_transakcije
          AND vrsta_transakcije = DECODE(recVodeci002.vrsta_prometa, 1, 'U', 2,'I') 
          AND status ='V';*/
               
     END IF;
    
     nSumarniBrojKomadaSlogova:=nSumarniBrojKomadaSlogova+1;
    
     sSlog:= '992'||sSifraDomicilaPromene ||sSifraPrimaoca || LTRIM(TO_CHAR(P_DATUM,'YYMMDD'));
     sSlog:=sSlog||'01'||recVodeci002.vrsta_prometa||recVodeci002.vrsta_prometa_IBM ||'9999';  
    
     sSlog:=sSlog||LPAD(TO_CHAR(nSumarniBrojKomadaSlogova),7,'0');
     sSlog:=sSlog||FORMAT_IZNOS (sumIznosa, 15);
     nTotal := nTotal + sumIznosa;
     sSlog:=sSlog||'000000000000000'|| sSifraKomitentaIBM ;
     --sSlog:=RPAD(sSlog,80,' ');
     INSERT INTO STAVKA_DNEVNIKA(ID_CPM_DAN, VREDNOST, REDNI_BROJ, VRSTA_SLOGA, IZNOS) 
                          VALUES(P_ID_CPM_DAN, sSlog,nRedniBrojSloga, 'O', sumIznosa);
     nRedniBrojSloga:=nRedniBrojSloga+1;   
                       
   END LOOP;

END PRIPREMA_DNEV_KOMITENATA;


PROCEDURE PRIPREMA_DNEV_SRPSKA_BANKA (P_ID_POSTA IN NUMBER, 
                                      P_DATUM IN DATE, 
                                      P_ID_CPM_DAN IN CPM_OBRADA.id_cpm_dan%TYPE,
                                      P_BROJ_POSTE IN VARCHAR2, 
                                      P_NAZIV_POSTE IN VARCHAR2
                                      ) IS

 sSlog VARCHAR2(500);
 nBrojac NUMBER;
 sSifraPosiljaoca VARCHAR2(7);
 nRedniBrojSloga NUMBER ; -- broji sve slogove 1 poruke
 nSumarniBrojKomadaSlogova NUMBER; -- broji stvarne slogove grupe (bez naslovnog i kranjeg sloga poruke)
 nTotal NUMBER;
 sumIznosa NUMBER ;
 sSifraDomicilaPromene VARCHAR2(10);
 sSifraPrimaoca VARCHAR2(10);
 sIzvorTransakcije VARCHAR2(2); 
 sIdentifikatorTransakcije VARCHAR2(20);
-- sPostanskiBroj VARCHAR2(5);
 sOznakaTransakcije VARCHAR2(10);
 
BEGIN
          -- obrada dnevnika : posta, dan  ----
     
  sSifraDomicilaPromene := P_BROJ_POSTE ||'00'; 
  sSifraPrimaoca := '0'|| id_radna_jedinica(P_ID_POSTA) ||'0000'; 

  nRedniBrojSloga:=2;
  nTotal := 0;
  FOR recVodeci002 IN (
                         SELECT DISTINCT b.izvor_transakcije
                           FROM TRANSAKCIJA_BANKA b
                          WHERE b.id_dnevnik_transakcija IS NULL
                            AND b.id_cpm_dan = hextoraw(P_ID_CPM_DAN)
                            AND b.sifra_banke = '295' 
                            AND b.status ='V'
                      )
  LOOP  

    sSlog:= '';
    sSlog:= '002'||sSifraDomicilaPromene||sSifraPrimaoca || LTRIM(TO_CHAR(P_DATUM,'YYMMDD'));
    IF (recVodeci002.izvor_transakcije = 'P') THEN
     sIzvorTransakcije := '02';
    ELSE
     sIzvorTransakcije := '01'; 
    END IF;
    
    sSlog:= sSlog||'01'|| '2'||sIzvorTransakcije||'9999'||'0'||'001'|| '061';  
    sSlog:= RPAD(sSlog,80,' ');  
           
    INSERT INTO STAVKA_DNEVNIKA(ID_CPM_DAN, VREDNOST, REDNI_BROJ, VRSTA_SLOGA ) 
                          VALUES(P_ID_CPM_DAN, sSlog,nRedniBrojSloga, 'S');
    
    nRedniBrojSloga:=nRedniBrojSloga+1;                                  
    nSumarniBrojKomadaSlogova:=1;
    sumIznosa := 0;
    FOR recSlogoviPromena IN (  
                    SELECT SUBSTR(b.broj_tekuceg_racuna,7,10) broj_tekuceg_racuna, b.broj_ceka, b.iznos_transakcije, b.vrsta_promene, 
                            DECODE(b.autorizacioni_broj, NULL, '0', b.autorizacioni_broj) autorizacioni_broj,
                            b.sifra_radnika, b.redni_broj_transakcije,DECODE(b.broj_kartice, NULL, '0', b.broj_kartice) broj_kartice
                      FROM TRANSAKCIJA_BANKA b
                     WHERE b.id_dnevnik_transakcija IS NULL
                       AND b.id_cpm_dan = hextoraw(P_ID_CPM_DAN)
                       AND b.sifra_banke = '295'
                       AND b.izvor_transakcije = recVodeci002.izvor_transakcije
                       AND b.status ='V'   
                             )
  
    LOOP
      
    -- opis sloga : sifra transakcije, sifra filijale, bezveze(+0), iznos, datum, TR, cek, broj kartice, autorizacioni broj, identifikator transakcije, sifra banke  
    -- u PostNet-u : SifraTransakcije : ISP001 - da li ostaje sito ili stavljam svoju sifru iz PostTis-a?
    -- Sifra filijale je postanski_broj
    -- Iznos duzine 15
    --Broj kartice : sve su 0
    -- Identifikator transakcije : datum(ddmmgg), posta(5), sif radnika(4), sif transakcije(4) (moj zakljucak)
      sOznakaTransakcije := 'ISP001';
      sSlog:= sOznakaTransakcije ||';' || LPAD(P_BROJ_POSTE,6,0)||';';
      sSlog:= sSlog || '+0' || FORMAT_IZNOS (recSlogoviPromena.iznos_transakcije, 15)||';'|| LTRIM(TO_CHAR(P_DATUM,'YYMMDD')); 
      sSlog:= sSlog ||';' || LPAD(recSlogoviPromena.broj_tekuceg_racuna,10,'0') || ';'|| LPAD(recSlogoviPromena.broj_ceka,10,'0');
      sSlog:= sSlog  ||';'|| LPAD(recSlogoviPromena.broj_kartice,16,'0') || ';'|| LPAD(recSlogoviPromena.autorizacioni_broj,9,'0') ;
      
      sIdentifikatorTransakcije := LTRIM(TO_CHAR(P_DATUM,'DDMMYY')) || P_BROJ_POSTE || LPAD(recSlogoviPromena.sifra_radnika, 4, '0') || LPAD(recSlogoviPromena.redni_broj_transakcije,4,'0');
      sSlog:=sSlog  || ';' ||sIdentifikatorTransakcije || ';' ||  '295' ; 
      sumIznosa := sumIznosa + recSlogoviPromena.iznos_transakcije;
     
      INSERT INTO STAVKA_DNEVNIKA(ID_CPM_DAN, VREDNOST, REDNI_BROJ, VRSTA_SLOGA) 
                          VALUES(P_ID_CPM_DAN, sSlog,nRedniBrojSloga, 'S');
      nSumarniBrojKomadaSlogova:=nSumarniBrojKomadaSlogova+1;
      nRedniBrojSloga:=nRedniBrojSloga+1;
                    
    END LOOP ;      
    
    nSumarniBrojKomadaSlogova:=nSumarniBrojKomadaSlogova+1;
    
    sSlog:= '992'||sSifraDomicilaPromene ||sSifraPrimaoca || LTRIM(TO_CHAR(P_DATUM,'YYMMDD'));
    sSlog:= sSlog||'01'||'2'||sIzvorTransakcije||'9999';  
    
    sSlog:= sSlog||LPAD(TO_CHAR(nSumarniBrojKomadaSlogova),7,'0');
    sSlog:= sSlog||FORMAT_IZNOS (sumIznosa, 15);
    nTotal := nTotal + sumIznosa ;
    
    sSlog:=sSlog||'000000000000000'|| '061'; 
    
    INSERT INTO STAVKA_DNEVNIKA(ID_CPM_DAN, VREDNOST, REDNI_BROJ, VRSTA_SLOGA, IZNOS) 
                          VALUES(P_ID_CPM_DAN, sSlog,nRedniBrojSloga, 'S', sumIznosa);            
      
    nRedniBrojSloga:=nRedniBrojSloga+1;    
    /*UPDATE TRANSAKCIJA_BANKA
       SET id_dnevnik_transakcija = P_ID_DNEVNIK
     WHERE id_cpm_dan = P_ID_CPM_DAN
       AND sifra_banke = '295'
       AND id_dnevnik_transakcija IS NULL
       AND izvor_transakcije = recVodeci002.izvor_transakcije;  */
        
  END LOOP; 

END PRIPREMA_DNEV_SRPSKA_BANKA;

PROCEDURE PRIPREMA_DNEVNIKA_CEKOVA (P_ID_POSTA IN NUMBER, 
                                    P_DATUM IN DATE,
                                    P_ID_CPM_DAN IN CPM_OBRADA.id_cpm_dan%TYPE,
                                    P_BROJ_POSTE IN VARCHAR2, 
                                    P_NAZIV_POSTE IN VARCHAR2
                                    ) IS

 sSlog VARCHAR2(500);
 nBrojac NUMBER;
 sSifraPosiljaoca VARCHAR2(7);
 nTotal NUMBER;
 nRedniBrojSloga NUMBER ; -- broji sve slogove 1 poruke
 nRedniBrojDnevnika NUMBER;
 nSumarniBrojKomadaSlogova NUMBER; -- broji stvarne slogove grupe (bez naslovnog i kranjeg sloga poruke)
 sumIznosa NUMBER ;

 sSifraDomicilaPromene VARCHAR2(10);
 sSifraPrimaoca VARCHAR2(10);
 sPostanskiBroj VARCHAR2(5);
BEGIN
          -- obrada dnevnika : posta, dan  ----
     
  sSifraDomicilaPromene := P_BROJ_POSTE ||'00'; 
  sSifraPrimaoca := '0'|| id_radna_jedinica(P_ID_POSTA) ||'0000'; 

  nTotal := 0;
  nRedniBrojSloga:=2;
  FOR recVodeci002 IN (  SELECT DISTINCT b.sifra_banke 
                           FROM TRANSAKCIJA_BANKA b
                          WHERE b.id_dnevnik_transakcija IS NULL 
                            AND b.id_cpm_dan = hextoraw(P_ID_CPM_DAN)
                            AND b.status = 'V'
                            AND b.sifra_banke NOT IN ('200', '295')
                            AND b.broj_ceka IS NOT NULL
                       )
  
  LOOP  
    
    sSlog:= '';
    sSlog:= '002'||sSifraDomicilaPromene||sSifraPrimaoca || LTRIM(TO_CHAR(P_DATUM,'YYMMDD'));
    /*IF (recVodeci002.izvor_transakcije = 'P') THEN
     sIzvorTransakcije := '02';
    ELSE
     sIzvorTransakcije := '01'; 
    END IF;*/
    
    sSlog:=sSlog ||'01'|| '2'||'03'||'9999'||'0'||'001'||recVodeci002.sifra_banke;  
           
    INSERT INTO STAVKA_DNEVNIKA(ID_CPM_DAN, VREDNOST, REDNI_BROJ, VRSTA_SLOGA) 
                          VALUES(P_ID_CPM_DAN, sSlog,nRedniBrojSloga, 'K');
    
    nRedniBrojSloga:=nRedniBrojSloga+1;                                  
    nSumarniBrojKomadaSlogova:=1;
    sumIznosa := 0;
    FOR recSlogoviPromena IN ( SELECT b.broj_tekuceg_racuna, b.broj_ceka, b.iznos_transakcije, 
              DECODE(b.autorizacioni_broj, NULL, '0', b.autorizacioni_broj) autorizacioni_broj, b.sifra_radnika, b.redni_broj_transakcije
              FROM TRANSAKCIJA_BANKA b
             WHERE b.id_dnevnik_transakcija IS NULL
               AND b.id_cpm_dan = hextoraw(P_ID_CPM_DAN)
               AND b.sifra_banke = recVodeci002.sifra_banke
               AND b.status = 'V')
    
    LOOP
      
      -- opis sloga : Sifra radnika, RBR Transakcije, TR, Broj ceka, Iznos, Autorizacioni broj
      sSlog:= '003';
      sSlog:= sSlog || LPAD(recSlogoviPromena.sifra_radnika,4,0) || LPAD(recSlogoviPromena.redni_broj_transakcije,4,0);
      sSlog:= sSlog || LPAD(recSlogoviPromena.broj_tekuceg_racuna,18,'0') || LPAD(recSlogoviPromena.broj_ceka,13,'0');
      sSlog:= sSlog || FORMAT_IZNOS (recSlogoviPromena.iznos_transakcije, 15); 
      sSlog:= sSlog || LPAD(recSlogoviPromena.autorizacioni_broj,9,'0') ;
     
      sumIznosa := sumIznosa + recSlogoviPromena.iznos_transakcije;
      INSERT INTO STAVKA_DNEVNIKA(ID_CPM_DAN, VREDNOST, REDNI_BROJ, VRSTA_SLOGA) 
                          VALUES(P_ID_CPM_DAN, sSlog,nRedniBrojSloga, 'K');
      nRedniBrojSloga:=nRedniBrojSloga+1;
      nSumarniBrojKomadaSlogova:=nSumarniBrojKomadaSlogova+1;
                    
    END LOOP ;      
    
    nSumarniBrojKomadaSlogova:=nSumarniBrojKomadaSlogova+1;
    
    sSlog:= '992'||sSifraDomicilaPromene ||sSifraPrimaoca || LTRIM(TO_CHAR(P_DATUM,'YYMMDD'));
    sSlog:=sSlog||'01'||'2'||'03'||'9999';  
    
    sSlog:=sSlog||LPAD(TO_CHAR(nSumarniBrojKomadaSlogova),7,'0');
    sSlog:=sSlog||FORMAT_IZNOS (sumIznosa, 15);
    nTotal := nTotal + sumIznosa;
    sSlog:=sSlog||'000000000000000'|| recVodeci002.sifra_banke; 
    
    INSERT INTO STAVKA_DNEVNIKA(ID_CPM_DAN, VREDNOST, REDNI_BROJ, VRSTA_SLOGA, IZNOS) 
                          VALUES(P_ID_CPM_DAN, sSlog,nRedniBrojSloga, 'K', sumIznosa);          
             
   /*UPDATE TRANSAKCIJA_BANKA
       SET id_dnevnik_transakcija = P_ID_DNEVNIK
     WHERE id_cpm_dan = P_ID_CPM_DAN
       AND sifra_banke = recVodeci002.sifra_banke
       AND id_dnevnik_transakcija IS NULL
       AND status ='V';
       --AND izvor_transakcije = recVodeci002.izvor_transakcije;  */
      nRedniBrojSloga:=nRedniBrojSloga+1;                         
  END LOOP; 

  
END PRIPREMA_DNEVNIKA_CEKOVA;

PROCEDURE PRIPREMA_DNEV_LOKAL_KOMITENATA (P_ID_POSTA IN NUMBER, 
                                          P_DATUM IN DATE, 
                                          P_ID_CPM_DAN IN CPM_OBRADA.id_cpm_dan%TYPE,
                                          P_BROJ_POSTE IN VARCHAR2, 
                                          P_NAZIV_POSTE IN VARCHAR2 
                                         ) IS
 sSlog VARCHAR2(500);
 nBrojac NUMBER;
 sSifraPosiljaoca VARCHAR2(7);
 sTotal VARCHAR2(15);
 sVrstaPrometa VARCHAR2(3);
 nRedniBrojSloga NUMBER ; -- broji sve slogove 1 poruke
 nSumarniBrojKomadaSlogova NUMBER; -- broji stvarne slogove grupe (bez naslovnog i kranjeg sloga poruke)
 UKUPNO NUMBER;
 nIdDnevnik NUMBER;
 cPom VARCHAR2(30);
 sumIznosa NUMBER ;
 sVrstaKom VARCHAR2(1);
 sSifraKomitenta VARCHAR2(3);
 sSifraDomicilaPromene VARCHAR2(7);
 sSifraPrimaoca  VARCHAR2(7); 
 sSifraIBM VARCHAR2(5);
 nTotal NUMBER;
 sSifraKomitentaIBM VARCHAR2(3);
 
BEGIN
   -- obrada dnevnika : posta, dan  ----
  
  sSifraDomicilaPromene := P_BROJ_POSTE ||'00'; 
  sSifraPrimaoca := '0'|| id_radna_jedinica(P_ID_POSTA) ||'0000'; 

  nRedniBrojSloga:=2;
  nTotal := 0;
  FOR recVodeci002 IN 
           (SELECT DISTINCT k.sifra_komitenta sifra_komitenta, k.id_vrsta_transakcije, k.sifra_transakcije, vrsta_prometa, transfer_ekstenzija, '01' vrsta_prometa_IBM 
              FROM TRANSAKCIJA_KOMITENT k, TRANSAKCIJA_ZA_KOMITENTA tk
             WHERE k.sifra_komitenta = tk.sifra_komitenta
               AND k.sifra_transakcije = tk.sifra_transakcije
               AND k.id_vrsta_transakcije = tk.id_vrsta_transakcije
               AND k.id_cpm_dan = hextoraw(P_ID_CPM_DAN)
               AND k.status = 'V'
               AND tk.transfer_dn = 'L'
             ORDER BY 4,1,2
            )

   LOOP 
     
     sSifraKomitentaIBM := '002';   
     sSlog:= '';
     sSlog:= '002'||sSifraDomicilaPromene ||sSifraPrimaoca || LTRIM(TO_CHAR(P_DATUM,'YYMMDD'));
     sSlog:= sSlog||'01'||recVodeci002.vrsta_prometa||recVodeci002.vrsta_prometa_IBM ||'9999'||'0'||'001'||sSifraKomitentaIBM ;
     sSlog:= RPAD(sSlog,80,' ');  
          
     INSERT INTO STAVKA_DNEVNIKA_LOK_KOMITENT(ID_CPM_DAN, VREDNOST, REDNI_BROJ, EKSTENZIJA) 
                          VALUES(P_ID_CPM_DAN, sSlog,nRedniBrojSloga, recVodeci002.transfer_ekstenzija);
    
     nRedniBrojSloga:=nRedniBrojSloga+1;                                  
     nSumarniBrojKomadaSlogova:=1;
     -- za svaku postu generisem naloge odredjene promene
     sumIznosa := 0;

     FOR recSlogoviPromena IN 
                       ( SELECT tk.tekuci_racun, k.poziv_na_broj, k.iznos, k.procenat_popusta, k.iznos_sa_popustom, k.sifra_komitenta,
                                tk.sifra_transakcije, k.redni_broj_transakcije, k.sifra_radnika, tk.FT97_DN, tk.vrsta_promene
                          FROM TRANSAKCIJA_KOMITENT k , TRANSAKCIJA_ZA_KOMITENTA tk
                         WHERE k.sifra_komitenta = tk.sifra_komitenta
                           AND k.sifra_transakcije = tk.sifra_transakcije
                           AND k.id_vrsta_transakcije = tk.id_vrsta_transakcije
                           AND k.id_cpm_dan = hextoraw(P_ID_CPM_DAN)
                           AND k.sifra_komitenta = recVodeci002.sifra_komitenta
                           AND k.sifra_transakcije = recVodeci002.sifra_transakcije
                           AND k.status ='V')
     LOOP
         
       sSlog:= '003'||LPAD(recSlogoviPromena.sifra_radnika,4,0) || LPAD(recSlogoviPromena.redni_broj_transakcije,4,0);
       sSlog:= sSlog||recSlogoviPromena.vrsta_promene||'0'; 
       IF (recSlogoviPromena.FT97_DN = 'D') THEN
         sSlog := sSlog || LPAD(recSlogoviPromena.poziv_na_broj,20,'0') || FORMAT_IZNOS (recSlogoviPromena.iznos, 12);
       ELSIF(recSlogoviPromena.FT97_DN = 'N') THEN
         sSlog := sSlog || LPAD(recSlogoviPromena.poziv_na_broj,16,'0') || FORMAT_IZNOS (recSlogoviPromena.iznos, 12);   
       END IF;   
                                   
       INSERT INTO STAVKA_DNEVNIKA_LOK_KOMITENT(ID_CPM_DAN, VREDNOST, REDNI_BROJ, EKSTENZIJA) 
                      VALUES(P_ID_CPM_DAN, sSlog,nRedniBrojSloga, recVodeci002.transfer_ekstenzija);
         
       nSumarniBrojKomadaSlogova:=nSumarniBrojKomadaSlogova+1;
       nRedniBrojSloga:=nRedniBrojSloga+1;
       sumIznosa := sumIznosa + recSlogoviPromena.iznos;
     END LOOP ;      
    
     nSumarniBrojKomadaSlogova:=nSumarniBrojKomadaSlogova+1;
    
     sSlog:= '992'||sSifraDomicilaPromene ||sSifraPrimaoca || LTRIM(TO_CHAR(P_DATUM,'YYMMDD'));
     sSlog:=sSlog||'01'||recVodeci002.vrsta_prometa||recVodeci002.vrsta_prometa_IBM ||'9999';  
    
     sSlog:=sSlog||LPAD(TO_CHAR(nSumarniBrojKomadaSlogova),7,'0');
     sSlog:=sSlog||FORMAT_IZNOS (sumIznosa, 15);
     nTotal := nTotal + sumIznosa;
     sSlog:=sSlog||'000000000000000'|| sSifraKomitentaIBM ;
     --sSlog:=RPAD(sSlog,80,' ');
     INSERT INTO STAVKA_DNEVNIKA_LOK_KOMITENT(ID_CPM_DAN, VREDNOST, REDNI_BROJ, EKSTENZIJA, IZNOS) 
                          VALUES(P_ID_CPM_DAN, sSlog,nRedniBrojSloga, recVodeci002.transfer_ekstenzija, sumIznosa);
     nRedniBrojSloga:=nRedniBrojSloga+1;   
                       
   END LOOP;

END PRIPREMA_DNEV_LOKAL_KOMITENATA;

FUNCTION ID_RADNA_JEDINICA (P_ID_CPM IN NUMBER)RETURN NUMBER
IS
  nIdRJ NUMBER;
  nOC NUMBER;
BEGIN

  SELECT  oc.id_organizaciona_celina
    INTO  nOC      
    FROM  POSLOVNO_OKRUZENJE.CVOR_POSTANSKE_MREZE cpm, POSLOVNO_OKRUZENJE.ORGANIZACIONA_CELINA oc
   WHERE cpm.id_organizaciona_celina = oc.id_organizaciona_celina
     AND  cpm.id_cvor_postanske_mreze = P_ID_CPM;
 
 SELECT SUBSTR(sifra,3,2) sifra
    INTO nIdRJ
  FROM POSLOVNO_OKRUZENJE.ORGANIZACIONA_CELINA
  WHERE id_vrsta_oc=5
  START WITH id_organizaciona_celina=nOC
  CONNECT BY PRIOR id_nadredjena_oc=id_organizaciona_celina;

  RETURN nIdRJ;


END ID_RADNA_JEDINICA;

PROCEDURE RADNA_JEDINICA (P_ID_CPM IN NUMBER,
                          P_ID_RJ  OUT NUMBER,
                          P_NAZIV  OUT VARCHAR2
                         ) 
IS
  nazivRJ VARCHAR2(35);
  nOC NUMBER;
  nRJ NUMBER;
BEGIN

  SELECT  oc.id_organizaciona_celina
    INTO  nOC      
    FROM  POSLOVNO_OKRUZENJE.CVOR_POSTANSKE_MREZE cpm, POSLOVNO_OKRUZENJE.ORGANIZACIONA_CELINA oc
   WHERE cpm.id_organizaciona_celina = oc.id_organizaciona_celina
     AND  cpm.id_cvor_postanske_mreze = P_ID_CPM;
 
 SELECT SUBSTR (naziv,1,2) || ' PS ' || SUBSTR (naziv,25,31) naziv, id_organizaciona_celina
    INTO P_NAZIV, P_ID_RJ 
  FROM POSLOVNO_OKRUZENJE.ORGANIZACIONA_CELINA 
  WHERE id_vrsta_oc=5
  START WITH id_organizaciona_celina=nOC
  CONNECT BY PRIOR id_nadredjena_oc=id_organizaciona_celina;


END RADNA_JEDINICA;

FUNCTION ODREDI_KONTROLNE_CIFRE
 (P_MODEL IN VARCHAR2,
  P_BROJ IN VARCHAR2) RETURN VARCHAR2 
IS
  sBrojZaObradu VARCHAR2(100);
  nOstatak NUMBER;
  nZbir NUMBER;
  i INTEGER;
  sKontrolneCifre VARCHAR2(2);
BEGIN

 sKontrolneCifre := '';
  IF P_MODEL='97' THEN
    sBrojZaObradu := P_BROJ||'00';
    nOstatak := 0;
    FOR i IN 1..LENGTH(sBrojZaObradu) LOOP
      nZbir := 10*nOstatak+TO_NUMBER(SUBSTR(sBrojZaObradu,i,1));
      nOstatak := MOD(nZbir,97);
    END LOOP;
    sKontrolneCifre := LPAD(TO_CHAR(98-nOstatak),2,'0');
  END IF;

  RETURN sKontrolneCifre;

  EXCEPTION
  WHEN OTHERS THEN
    RETURN '';
    
END ODREDI_KONTROLNE_CIFRE;

FUNCTION FORMAT_IZNOS(P_BROJ IN NUMBER, P_DUZINA IN NUMBER) RETURN VARCHAR2 
IS
 cPom VARCHAR2(100);
 iznos VARCHAR2(100);
 pom NUMBER;
BEGIN

  iznos := REPLACE((to_char(P_BROJ)),',','.');
  pom := P_BROJ * 100;
  cPom := LPAD (pom, P_DUZINA, '0');
  RETURN cPom;

END FORMAT_IZNOS;

PROCEDURE CPM_DAN_ZA_OBRADU
  ( 
    P_REZULTAT      OUT NUMBER,
    P_CURSOR        OUT T_CURSOR
  ) IS
nRezultat NUMBER;  

BEGIN
  -- OVA PROCEDURA KREIRA FAJLOVE ZA IBM (PRIJAVE I DNEVNIKE)
  P_REZULTAT := 1;
 
 OPEN P_CURSOR FOR
    SELECT RAWTOHEX (co.id_cpm_dan) id_cpm_dan, sd.vrsta_sloga, sd.redni_broj, sd.vrednost, sd.iznos
      FROM CPM_OBRADA co, STAVKA_DNEVNIKA sd
     WHERE co.id_cpm_dan = sd.id_cpm_dan
       AND co.obrada_prijava = 'D'
       AND co.obrada_dnevnika = 'D'
       AND co.fajl_dn IS NULL
     ORDER BY 1,2 desc,3 ;
         
 P_REZULTAT := 0;
 
END  CPM_DAN_ZA_OBRADU;  


PROCEDURE CPM_DAN_ZA_OBRADU_LOK_KOM
  ( 
    P_REZULTAT      OUT NUMBER,
    P_CURSOR        OUT T_CURSOR
   ) IS
nRezultat NUMBER;  

BEGIN
  -- OVA PROCEDURA KREIRA FAJLOVE ZA IBM (PRIJAVE I DNEVNIKE)
  P_REZULTAT := 1;
 
  OPEN P_CURSOR FOR
    SELECT RAWTOHEX (co.id_cpm_dan) id_cpm_dan, sd.ekstenzija, sd.redni_broj, sd.vrednost, sd.iznos
      FROM CPM_OBRADA co, STAVKA_DNEVNIKA_LOK_KOMITENT sd
     WHERE co.id_cpm_dan = sd.id_cpm_dan
       AND co.obrada_prijava = 'D'
       AND co.obrada_dnevnika = 'D'
       AND co.fajl_lok_komitent_dn IS NULL
     ORDER BY 1,2 desc,3 ;
         
 P_REZULTAT := 0;
 
END  CPM_DAN_ZA_OBRADU_LOK_KOM; 

PROCEDURE UPDATE_CPM_OBRADA
  ( P_ID_CPM_DAN     IN VARCHAR2,
    P_GLAVNA_OBRADA  IN VARCHAR2, 
    P_REZULTAT      OUT NUMBER,
    P_PORUKA        OUT VARCHAR2
  ) 
IS
IdCPMDan RAW(16);
BEGIN

  P_REZULTAT := 1;
  IdCPMDan := HEXTORAW(P_ID_CPM_DAN);
  IF (P_GLAVNA_OBRADA = 'D')THEN 
    UPDATE CPM_OBRADA
       SET fajl_dn = 'D'
     WHERE id_cpm_dan = IdCPMDan
       AND NVL(fajl_dn, 'N') = 'N';

    IF SQL%ROWCOUNT <> 1 THEN
      RAISE_APPLICATION_ERROR(-20001, 'Obrada je veæ uraðena prethodnom iteracijom!!!');
    END IF;
  ELSE
    UPDATE CPM_OBRADA
         SET fajl_lok_komitent_dn = 'D'
       WHERE id_cpm_dan = IdCPMDan
       AND NVL(fajl_lok_komitent_dn, 'N') = 'N';

    IF SQL%ROWCOUNT <> 1 THEN
      RAISE_APPLICATION_ERROR(-20001, 'Obrada je veæ uraðena prethodnom iteracijom!!!');
    END IF;
  END IF;
  P_REZULTAT := 0;
  P_PORUKA := 'USPESAN UPDATE !';
         
END UPDATE_CPM_OBRADA; 

PROCEDURE ATRIBUTI_NALOGA (P_ID_PRIJAVA IN NUMBER, 
                           P_VRSTA_PROMETA IN VARCHAR2,
                           P_KONSTANTA IN VARCHAR2,
                           P_OPIS IN VARCHAR2,
                           P_BROJ_POSTE IN VARCHAR2,
                           P_NAZIV_POSTE IN VARCHAR2,
                           P_DATUM IN DATE,
                           P_ID_RJ IN NUMBER,
                           P_NAZIV_RJ IN VARCHAR2,
                           P_SVRHA_PLACANJA OUT VARCHAR2,
                           P_VRSTA_PROMENE OUT VARCHAR2,
                           P_NAZIV_UPLATIOCA OUT VARCHAR2,
                           P_NAZIV_PRIMAOCA OUT VARCHAR2,
                           P_TEKUCI_RACUN IN OUT VARCHAR2,
                           P_POZIV_NA_BROJ OUT VARCHAR2
                          ) IS
sRacunRJ VARCHAR2(1);
sVrstaPrometa  VARCHAR2(1);
sKonstantaPB VARCHAR2(20); 
--sNaziv VARCHAR2(35);                        
BEGIN
     
  IF (P_VRSTA_PROMETA = 'U') THEN
    P_VRSTA_PROMENE := '106';
  ELSE
    P_VRSTA_PROMENE := '112';  
  END IF; 
       
  IF (P_KONSTANTA = '97') THEN
    P_POZIV_NA_BROJ := ODREDI_KONTROLNE_CIFRE ('97', P_BROJ_POSTE) ||  P_BROJ_POSTE ;   -- edb  
  ELSE
    P_POZIV_NA_BROJ := P_BROJ_POSTE || LTRIM(TO_CHAR(P_DATUM,'DDMMYYYY'))||P_KONSTANTA;
  END IF;

  SELECT naziv_prijave, 
         DECODE(uplatilac,'POSTA','POSTA ' || P_NAZIV_POSTE, 'RJ', P_NAZIV_RJ, P_OPIS), 
         DECODE(primalac,'POSTA','POSTA ' || P_NAZIV_POSTE, 'RJ', P_NAZIV_RJ, P_OPIS), racun_rj       
    INTO P_SVRHA_PLACANJA, P_NAZIV_UPLATIOCA, P_NAZIV_PRIMAOCA, sRacunRJ
    FROM PRIJAVA 
   WHERE id_prijava = P_ID_PRIJAVA;

  IF (sRacunRJ = 'D')THEN -- racun RJ 
    SELECT tekuci_racun
      INTO P_TEKUCI_RACUN
      FROM TEKUCI_RACUN_RJ
     WHERE id_rj = P_ID_RJ;

  END IF;

END ATRIBUTI_NALOGA;
                          
END PRIPREMA_PODATAKA_ZA_IBM_NOVO;
/

SHOW ERRORS;


