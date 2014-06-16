CREATE OR REPLACE PACKAGE BODY                    PREGLED IS

  PROCEDURE PREGLED_TREBOVANJA(P_ID_CPM   IN VARCHAR2,
                               P_DATUM_OD IN TREBOVANJE.datum_trebovanja%TYPE,
                               P_DATUM_DO IN TREBOVANJE.datum_trebovanja%TYPE,
                               P_CURSOR   OUT T_CURSOR)
 IS
  BEGIN
    
    OPEN P_CURSOR FOR
      SELECT t.*, oc.naziv
        FROM TREBOVANJE t, CVOR_POSTANSKE_MREZE cpm, ORGANIZACIONA_CELINA oc
       WHERE t.id_cpm = cpm.id_cvor_postanske_mreze
         AND cpm.id_organizaciona_celina = oc.id_organizaciona_celina
         AND t.id_cpm LIKE P_ID_CPM
         AND t.datum_trebovanja >= P_DATUM_OD
         AND t.datum_trebovanja <= P_DATUM_DO
       ORDER BY t.datum_trebovanja DESC ;
    
  EXCEPTION
    WHEN OTHERS THEN
      NULL;
    
  END PREGLED_TREBOVANJA;

  PROCEDURE PREGLED_AS_TREBOVANJA(P_ID_TREBOVANJE IN TREBOVANJE.id_trebovanje%TYPE,
                                  P_CURSOR        OUT T_CURSOR)
  IS
  BEGIN
    
    OPEN P_CURSOR FOR
      SELECT ast.*, a.nominalna_vrednost
        FROM apoenska_struktura_trebovanja ast, apoen a
       WHERE ast.id_apoen = a.id_apoen
         AND ast.id_trebovanje = P_ID_TREBOVANJE;
  
  EXCEPTION
    WHEN OTHERS THEN
      NULL;
       
  END PREGLED_AS_TREBOVANJA;

  PROCEDURE PREGLED_DOTACIJA_SUVISAK(P_ID_CPM   IN DOTACIJA.id_cpm %TYPE,
                                     P_DATUM_OD IN DOTACIJA.datum%TYPE,
                                     P_DATUM_DO IN DOTACIJA.datum%TYPE,
                                     P_VRSTA    IN VARCHAR2,
                                     P_CURSOR   OUT T_CURSOR)
  
   IS
  BEGIN
  
    IF (P_VRSTA = 'D') THEN
    
      OPEN P_CURSOR FOR
        SELECT id_dotacija id,
               id_cpm,
               datum,
               iznos,
               decode(poreklo, 'B', 'Banka', 'P', 'Razmena posta') Mesto,
               id_nalog_za_razmenu_got,
               id_dokument
          FROM DOTACIJA d
         WHERE d.id_cpm = P_ID_CPM;
    
    ELSIF (P_VRSTA = 'S') THEN
    
      OPEN P_CURSOR FOR
        SELECT id_suvisak id,
               id_cpm,
               datum,
               iznos,
               decode(odrediste, 'B', 'Banka', 'P', 'Razmena posta') Mesto,
               id_nalog_za_razmenu_got,
               id_dokument
          FROM SUVISAK s
         WHERE s.id_cpm = P_ID_CPM;
    
    END IF;
  
  EXCEPTION
    WHEN OTHERS THEN
      NULL; -- DODATI UPIS U LOG 
  
  END PREGLED_DOTACIJA_SUVISAK;

  PROCEDURE PREGLED_AS_DOTACIJA_SUVISAK(P_ID_DOTACIJA IN DOTACIJA.id_dotacija%TYPE,
                                        P_VRSTA       IN VARCHAR2,
                                        P_CURSOR      OUT T_CURSOR)
  
   IS
  BEGIN
  
    IF (P_VRSTA = 'D') THEN
    
      OPEN P_CURSOR FOR
        SELECT asp.*, a.nominalna_vrednost
          FROM apoenska_struktura_dotacije asp, apoen a
         WHERE asp.id_apoen = a.id_apoen
           AND asp.id_dotacija = P_ID_DOTACIJA;
    
    ELSIF (P_VRSTA = 'S') THEN
    
      OPEN P_CURSOR FOR
        SELECT ass.*, a.nominalna_vrednost
          FROM apoenska_struktura_suviska ass, apoen a
         WHERE ass.id_apoen = a.id_apoen
           AND ass.id_suvisak = P_ID_DOTACIJA;
    
    END IF;
  
  EXCEPTION
    WHEN OTHERS THEN
      NULL;
    
  END PREGLED_AS_DOTACIJA_SUVISAK;

  PROCEDURE PREGLED_SUVISKA(P_ID_CPM IN SUVISAK.id_cpm %TYPE,
                            P_DATUM  IN SUVISAK.datum%TYPE,
                            P_CURSOR OUT T_CURSOR)
  
   IS
  BEGIN
  
    OPEN P_CURSOR FOR
      SELECT id_suvisak,
             id_cpm,
             datum,
             iznos,
             decode(odrediste, 'B', 'Banka', 'P', 'Razmena posta') Odrediste,
             id_nalog_za_razmenu_got,
             id_dokument
        FROM SUVISAK s
       WHERE s.id_cpm = P_ID_CPM;
  
  EXCEPTION
    WHEN OTHERS THEN
      NULL; -- DODATI UPIS U LOG 
  
  END PREGLED_SUVISKA;

  PROCEDURE PREGLED_AS_SUVISKA(P_ID_SUVISAK IN SUVISAK.id_suvisak%TYPE,
                               P_CURSOR     OUT T_CURSOR)
  
   IS
  BEGIN
  
    OPEN P_CURSOR FOR
      SELECT ass.*, a.nominalna_vrednost
        FROM apoenska_struktura_suviska ass, apoen a
       WHERE ass.id_apoen = a.id_apoen
         AND ass.id_suvisak = P_ID_SUVISAK;
  
  EXCEPTION
    WHEN OTHERS THEN
      NULL;
    
  END PREGLED_AS_SUVISKA;

  PROCEDURE PREGLED_NALOGA_ZA_RAZMENU(P_ID_CPM_N      IN NALOG_ZA_RAZMENU_GOT.id_cpm_nalogodavac%TYPE,
                                      P_ID_CPM_S      IN NALOG_ZA_RAZMENU_GOT.id_cpm_suvisak%TYPE,
                                      P_ID_CPM_D      IN NALOG_ZA_RAZMENU_GOT.id_cpm_dotacija%TYPE,
                                      P_DATUM_RAZMENE IN NALOG_ZA_RAZMENU_GOT.datum_razmene%TYPE,
                                      P_STATUS        IN NALOG_ZA_RAZMENU_GOT.status%TYPE,
                                      P_CURSOR        OUT T_CURSOR) IS
  BEGIN
  
    OPEN P_CURSOR FOR
      SELECT * FROM NALOG_ZA_RAZMENU_GOT ng;
    --WHERE ng.id_cpm_nalogodavac like P_ID_CPM_N
    -- AND ng.id_cpm_suvisak like P_ID_CPM_S
    --  AND ng.id_cpm_dotacija like P_ID_CPM_D
    -- AND ng.status LIKE P_STATUS; 
  
  END PREGLED_NALOGA_ZA_RAZMENU;

  PROCEDURE PREGLED_POSTA(P_ID_RJ IN VARCHAR2, P_CURSOR OUT T_CURSOR) IS
  BEGIN
  
    OPEN P_CURSOR FOR
      SELECT oc.id_organizaciona_celina id_posta,
             oc.naziv,
             rj.id_organizaciona_celina id_rj,
             cpm.ID_CVOR_POSTANSKE_MREZE id_cvor
        FROM CVOR_POSTANSKE_MREZE cpm,
             ORGANIZACIONA_CELINA oc,
             ORGANIZACIONA_CELINA rj
       WHERE cpm.id_organizaciona_celina = oc.id_organizaciona_celina
         AND cpm.id_vrsta_cvora_pm IN (1, 3)
         AND rj.id_organizaciona_celina =
             (SELECT id_organizaciona_celina
                FROM ORGANIZACIONA_CELINA
               WHERE id_vrsta_oc = 5
               START WITH id_organizaciona_celina =
                          cpm.id_organizaciona_celina
              CONNECT BY PRIOR id_nadredjena_oc = id_organizaciona_celina)
         AND rj.id_organizaciona_celina LIKE P_ID_RJ
       ORDER BY cpm.postanski_broj;
  
  END PREGLED_POSTA;

PROCEDURE PREGLED_RJ
                (P_CURSOR OUT T_CURSOR) 
IS
  BEGIN
  
    OPEN P_CURSOR FOR
      SELECT id_organizaciona_celina id_radna_jedinica, naziv
        FROM ORGANIZACIONA_CELINA
       WHERE id_vrsta_oc_detaljno = 1
          OR id_organizaciona_celina = 47
       ORDER BY naziv;
  END PREGLED_RJ;
  
  
PROCEDURE PREGLED_BANAKA
                   (P_CURSOR OUT T_CURSOR) 
IS
BEGIN
  
  OPEN P_CURSOR FOR
    SELECT id_banka, sifra, naziv
      FROM poslovno_okruzenje.tsif_banka
     WHERE status = 'A' 
     ORDER BY sifra;
     
END PREGLED_BANAKA;
 

PROCEDURE PREGLED_KOMITENATA(P_CURSOR OUT T_CURSOR)
IS
BEGIN
  
  OPEN P_CURSOR FOR
    SELECT id_poslovni_partner, naziv_f9 naziv
      FROM poslovno_okruzenje.poslovni_partner
     ORDER BY naziv;
     
END PREGLED_KOMITENATA; 
  
  PROCEDURE PREGLED_TRANSAKCIJA_ZA_BANKU(P_SIFRA_BANKE IN NOVCANO_POSLOVANJE.TRANSAKCIJA_ZA_BANKU.SIFRA_BANKE%TYPE,
                                         P_CURSOR      OUT T_CURSOR) IS
  BEGIN
  
    OPEN P_CURSOR FOR
      SELECT *
        FROM NOVCANO_POSLOVANJE.TRANSAKCIJA_ZA_BANKU TZB
       WHERE TZB.SIFRA_BANKE LIKE P_SIFRA_BANKE;
  END PREGLED_TRANSAKCIJA_ZA_BANKU;

  PROCEDURE PREGLED_TRANS_ZA_KOMITENTA(P_ID_VRSTA_TRANSAKCIJE IN VARCHAR2, --NOVCANO_POSLOVANJE.TRANSAKCIJA_ZA_KOMITENTA.ID_VRSTA_TRANSAKCIJE%TYPE,
                                       --P_SIFRA_KOMITENTA      IN NOVCANO_POSLOVANJE.TRANSAKCIJA_ZA_KOMITENTA.SIFRA_KOMITENTA%TYPE,
                                       P_CURSOR OUT T_CURSOR) IS
  BEGIN
  
    OPEN P_CURSOR FOR
      SELECT *
        FROM NOVCANO_POSLOVANJE.TRANSAKCIJA_ZA_KOMITENTA TZK;
      -- WHERE /*TZK.SIFRA_KOMITENTA LIKE SIFRA_KOMITENTA
                              -- AND*/
      -- NVL(TZK.ID_VRSTA_TRANSAKCIJE, -1) like P_ID_VRSTA_TRANSAKCIJE
      -- ORDER BY TZK.ID_TRANSAKCIJA_ZA_KOMITENTA;
  END PREGLED_TRANS_ZA_KOMITENTA;

  PROCEDURE PREGLED_TEKUCIH_RACUNA(P_ID_TRANSAKCIJA_ZA_KOMITENTA IN NOVCANO_POSLOVANJE.TRANSAKCIJA_ZA_KOMITENTA.ID_TRANSAKCIJA_ZA_KOMITENTA%TYPE,
                                   P_CURSOR                      OUT T_CURSOR) IS
  
  BEGIN
    OPEN P_CURSOR FOR
      SELECT *
        FROM NOVCANO_POSLOVANJE.TEKUCI_RACUN_KOMITENTA TRK
       WHERE TRK.ID_TRANSAKCIJA_ZA_KOMITENTA =
             P_ID_TRANSAKCIJA_ZA_KOMITENTA;
  END PREGLED_TEKUCIH_RACUNA;

END PREGLED;
/

SHOW ERRORS;


