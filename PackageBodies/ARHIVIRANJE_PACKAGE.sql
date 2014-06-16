CREATE OR REPLACE PACKAGE BODY                    ARHIVIRANJE_PACKAGE
AS
   PROCEDURE ARHIVIRAJ
   IS
        nBrojDana NUMBER;
        nIteracija NUMBER;
   BEGIN
        nBrojDana := 404;
        
        SELECT ARH_ITERACIJA_SEQ.nextval
            INTO nIteracija
        FROM DUAL;

       UPIS_U_LOG('I', 'POÈETAK ARHIVIRANJA', nIteracija);               
       UPIS_U_LOG('I', 'Za brisanje, pre ' || TO_CHAR(nBrojDana) || ' dana', nIteracija);  
        
      --=====================ARHIVIRANJE  TRANSAKCIJA_KOMITENT======================--

      --Upisati slogove u arhivsku tabelu
      INSERT INTO ARH_TRANSAKCIJA_KOMITENT (ID_TRANSAKCIJA_KOMITENT,
                                            SIFRA_KOMITENTA,
                                            IZNOS,
                                            PROCENAT_POPUSTA,
                                            IZNOS_SA_POPUSTOM,
                                            POZIV_NA_BROJ,
                                            ID_CPM,
                                            DATUM,
                                            ID_VRSTA_TRANSAKCIJE,
                                            ID_RADNIK,
                                            REDNI_BROJ_TRANSAKCIJE,
                                            STATUS,
                                            ID_TRANSAKCIJA_NALOG_PP,
                                            ID_DNEVNIK_TRANSAKCIJA,
                                            DATUM_TRANSAKCIJE,
                                            SIFRA_TRANSAKCIJE,
                                            SIFRA_RADNIKA,
                                            MODEL_POZIVA_NA_BROJ,
                                            ID_CPM_DAN,
                                            DOSTAVA,
                                            SALTER)
         SELECT k.*
           FROM TRANSAKCIJA_KOMITENT k, CPM_OBRADA co
          WHERE co.ID_CPM_DAN = k.ID_CPM_DAN AND 
                      co.DATUM < SYSDATE - nBrojDana;

        UPIS_U_LOG('I', 'Arhivirano TRANSAKCIJA_KOMITENT ' || TO_CHAR(SQL%ROWCOUNT), nIteracija);        

      --Obriši slog koji je prebaèen u arhivu
      DELETE TRANSAKCIJA_KOMITENT k
       WHERE EXISTS
                (SELECT 1
                   FROM CPM_OBRADA co
                  WHERE co.ID_CPM_DAN = k.ID_CPM_DAN AND 
                             co.DATUM < SYSDATE - nBrojDana);

        UPIS_U_LOG('I','Obrisano TRANSAKCIJA_KOMITENT ' || TO_CHAR(SQL%ROWCOUNT), nIteracija);      

      --=====================ARHIVIRANJE  TRANSAKCIJA_BANKA======================--

      --Upisati slog u arhivsku tabelu
      INSERT INTO ARH_TRANSAKCIJA_BANKA   (ID_TRANSAKCIJA_BANKA,
                                                                     SIFRA_BANKE,
                                                                     IZNOS_TRANSAKCIJE,
                                                                     BROJ_TEKUCEG_RACUNA,
                                                                     BROJ_CEKA,
                                                                     BROJ_STEDNE_KNJIZICE,
                                                                     AUTORIZACIONI_BROJ,
                                                                     VRSTA_PROMENE,
                                                                     NACIN_REALIZACIJE,
                                                                     IZVOR_TRANSAKCIJE,
                                                                     NOVO_STANJE,
                                                                     BROJ_KARTICE,
                                                                     AKCEPTANT,
                                                                     ID_CPM,
                                                                     DATUM,
                                                                     ID_VRSTA_TRANSAKCIJE,
                                                                     ID_RADNIK,
                                                                     REDNI_BROJ_TRANSAKCIJE,
                                                                     STATUS,
                                                                     ID_TRANSAKCIJA_NALOG_PP,
                                                                     ID_DNEVNIK_TRANSAKCIJA,
                                                                     DATUM_TRANSAKCIJE,
                                                                     SIFRA_TRANSAKCIJE,
                                                                     VRSTA_TRANSAKCIJE,
                                                                     SIFRA_RADNIKA,
                                                                     ID_CPM_DAN,
                                                                     DOSTAVA,
                                                                     RRN,
                                                                     SALTER)
         SELECT b.*
           FROM TRANSAKCIJA_BANKA b, CPM_OBRADA co
          WHERE co.id_cpm_dan = b.id_cpm_dan AND 
                      co.DATUM < SYSDATE - nBrojDana;


         UPIS_U_LOG('I', 'Arhivirano TRANSAKCIJA_BANKA ' || TO_CHAR(SQL%ROWCOUNT), nIteracija);           

      --Obriši slog koji je prebaèen u arhivu
      DELETE TRANSAKCIJA_BANKA b
       WHERE EXISTS
                (SELECT 1
                   FROM CPM_OBRADA co
                  WHERE co.id_cpm_dan = b.id_cpm_dan AND 
                              co.DATUM < SYSDATE - nBrojDana);

        UPIS_U_LOG('I', 'Obrisano TRANSAKCIJA_BANKA ' || TO_CHAR(SQL%ROWCOUNT), nIteracija);           

      --=====================ARHIVIRANJE  TRANSAKCIJA_NALOG_PP======================--

      --Upisati slog u arhivsku tabelu
      INSERT INTO ARH_TRANSAKCIJA_NALOG_PP (ID_TRANSAKCIJA_NALOG_PP,
                                                                        NAZIV_UPLATIOCA,
                                                                        ADRESA_UPLATIOCA,
                                                                        POSTA_UPLATIOCA,
                                                                        NAZIV_PRIMAOCA,
                                                                        ADRESA_PRIMAOCA,
                                                                        POSTA_PRIMAOCA,
                                                                        TEKUCI_RACUN_PRIMAOCA,
                                                                        POZIV_NA_BROJ,
                                                                        IZNOS,
                                                                        SVRHA_UPLATE,
                                                                        SIFRA_PLACANJA,
                                                                        VRSTA_NALOGA,
                                                                        VRSTA_PROMENE,
                                                                        OZNAKA_PROMENE,
                                                                        ID_RADNIK,
                                                                        REDNI_BROJ_TRANSAKCIJE,
                                                                        ID_CPM,
                                                                        DATUM,
                                                                        STATUS,
                                                                        ID_DNEVNIK_TRANSAKCIJA,
                                                                        DATUM_TRANSAKCIJE,
                                                                        SIFRA_RADNIKA,
                                                                        MODEL_POZIVA_NA_BROJ,
                                                                        ID_PRIJAVA,
                                                                        ID_CPM_DAN,
                                                                        DOSTAVA,
                                                                        HITAN_PAZAR,
                                                                        REFERENCA_NALOGA,
                                                                        NACIN_REALIZACIJE,
                                                                        DALJA_REALIZACIJA,
                                                                        SALTER)
         SELECT n.*
           FROM TRANSAKCIJA_NALOG_PP n, CPM_OBRADA co
          WHERE co.id_cpm_dan = n.id_cpm_dan AND 
                      co.DATUM < SYSDATE - nBrojDana;

          UPIS_U_LOG('I', 'Arhivirano TRANSAKCIJA_NALOG_PP ' || TO_CHAR(SQL%ROWCOUNT), nIteracija);

      --Obriši slog koji je prebaèen u arhivu
      DELETE TRANSAKCIJA_NALOG_PP n
       WHERE EXISTS
                (SELECT 1
                   FROM CPM_OBRADA co
                  WHERE co.id_cpm_dan = n.id_cpm_dan AND 
                              co.DATUM < SYSDATE - nBrojDana);

         UPIS_U_LOG('I', 'Obrisano TRANSAKCIJA_NALOG_PP ' || TO_CHAR(SQL%ROWCOUNT), nIteracija);     

      --=====================ARHIVIRANJE  CPM_OBRADA======================--

      --Upisati slog u arhivsku tabelu
      INSERT INTO ARH_CPM_OBRADA   (ID_CPM_DAN,
                                                          OBRADA_BANKE,
                                                          OBRADA_KOMITENTI,
                                                          OBRADA_NALOG_PP,
                                                          ID_CPM,
                                                          DATUM,
                                                          KREIRANJE_PRIJAVA_BANKA,
                                                          KREIRANJE_PRIJAVA_KOMITENT,
                                                          OBRADA_PRIJAVA,
                                                          OBRADA_DNEVNIKA,
                                                          FAJL_DN,
                                                          FAJL_LOK_KOMITENT_DN,
                                                          OBRADA_BLAGAJNE)
         SELECT c.*
           FROM CPM_OBRADA c
          WHERE c.DATUM < SYSDATE - nBrojDana;
        
          UPIS_U_LOG('I', 'Arhivirano CPM_OBRADA ' || TO_CHAR(SQL%ROWCOUNT), nIteracija);         

      --Arhiviram sve slogove STAVKE_DNEVNIKA
      INSERT INTO ARH_STAVKA_DNEVNIKA (ID_CPM_DAN,
                                                               VREDNOST,
                                                               REDNI_BROJ,
                                                               VRSTA_SLOGA,
                                                               IZNOS)
         SELECT sd.*
           FROM STAVKA_DNEVNIKA sd, CPM_OBRADA c
          WHERE sd.ID_CPM_DAN = c.ID_CPM_DAN AND 
                     c.DATUM < SYSDATE - nBrojDana;
                     
         UPIS_U_LOG('I', 'Arhivirano STAVKA_DNEVNIKA ' || TO_CHAR(SQL%ROWCOUNT), nIteracija);     

      --Obriši slogove STAVKA_DNEVNIKA koji su prebaèeni u arhivu
      DELETE STAVKA_DNEVNIKA sd
       WHERE EXISTS
                (SELECT 1
                   FROM CPM_OBRADA c
                  WHERE sd.ID_CPM_DAN = c.ID_CPM_DAN AND 
                             c.DATUM < SYSDATE - nBrojDana);

        UPIS_U_LOG('I', 'Obrisano STAVKA_DNEVNIKA ' || TO_CHAR(SQL%ROWCOUNT), nIteracija);     

      --Arhiviram sve slogove STAVKE_DNEVNIKA_LOK_KOMITENT
      INSERT INTO ARH_STAVKA_DNEVNIKA_LOK_KOM (ID_CPM_DAN,
                                                                               VREDNOST,
                                                                               REDNI_BROJ,
                                                                               EKSTENZIJA,
                                                                               IZNOS)
         SELECT sdlk.*
           FROM STAVKA_DNEVNIKA_LOK_KOMITENT sdlk, CPM_OBRADA c
          WHERE sdlk.ID_CPM_DAN = c.ID_CPM_DAN AND 
                      c.DATUM < SYSDATE - nBrojDana;
                      
         UPIS_U_LOG('I', 'Arhivirano STAVKA_DNEVNIKA_LOK_KOM ' || TO_CHAR(SQL%ROWCOUNT), nIteracija);  

      --Obriši slogove STAVKA_DNEVNIKA_LOK_KOMITENT koji su prebaèeni u arhivu
      DELETE STAVKA_DNEVNIKA_LOK_KOMITENT sdlk
       WHERE EXISTS
                (SELECT 1
                   FROM CPM_OBRADA c
                  WHERE sdlk.ID_CPM_DAN = c.ID_CPM_DAN AND 
                              c.DATUM < SYSDATE - nBrojDana);

        UPIS_U_LOG('I', 'Obrisano STAVKA_DNEVNIKA_LOK_KOM ' || TO_CHAR(SQL%ROWCOUNT), nIteracija);       

      --Obriši slogove CPM_OBRADA koji je prebaèen u arhivu
      DELETE CPM_OBRADA
       WHERE DATUM < SYSDATE - nBrojDana;
         
      UPIS_U_LOG('I', 'Obrisano CPM_OBRADA ' || TO_CHAR(SQL%ROWCOUNT), nIteracija);
      UPIS_U_LOG('I', 'KRAJ ARHIVIRANJA', nIteracija);      
      COMMIT;
      
   EXCEPTION
      WHEN OTHERS
      THEN      
         ROLLBACK;     
          UPIS_U_LOG('G', 'Greška ' || SQLERRM, nIteracija);
         COMMIT;         
   END ARHIVIRAJ;  
 
   
   PROCEDURE UPIS_U_LOG (P_VRSTA_PORUKE IN VARCHAR2,
                                          P_PORUKA IN VARCHAR2,
                                          P_ITERACIJA IN NUMBER)  IS
  BEGIN
  
  INSERT INTO ARH_LOG (ID_ARH_LOG, DATUM_VREME, PORUKA, VRSTA_PORUKE, ITERACIJA) 
                        VALUES (ID_ARH_LOG_SEQ.nextval, SYSDATE, P_PORUKA, P_VRSTA_PORUKE, P_ITERACIJA);
  
  END UPIS_U_LOG;
   
END ARHIVIRANJE_PACKAGE;
/

SHOW ERRORS;


