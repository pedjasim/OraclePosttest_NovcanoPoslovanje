CREATE OR REPLACE PACKAGE BODY                    NOVCANE_TRANSAKCIJE IS

PROCEDURE PREGLED_ZA_BANKE      (
                                 P_ID_CPM_DAN  IN TRANSAKCIJA_BANKA.ID_CPM_DAN%TYPE,                             
                                 P_CURSOR   OUT T_CURSOR)
IS
BEGIN
  
  OPEN P_CURSOR FOR
    SELECT TB.ID_TRANSAKCIJA_BANKA,
                TB.SIFRA_BANKE,
                TB.IZNOS_TRANSAKCIJE,
                TB.BROJ_TEKUCEG_RACUNA,
                TB.BROJ_CEKA,
                TB.BROJ_STEDNE_KNJIZICE,
                TB.AUTORIZACIONI_BROJ,
                decode(TB.VRSTA_PROMENE , '501' ,'Graðanin nalog' ,
                                                             '513', 'Èek pazar', 
                                                             '510', 'Èek graðanin', TB.VRSTA_PROMENE ) AS VRSTA_PROMENE, 
                decode(TB.NACIN_REALIZACIJE , 'D' ,'online' ,
                                                                'N', 'offline', TB.NACIN_REALIZACIJE) AS NACIN_REALIZACIJE,
                decode(TB.IZVOR_TRANSAKCIJE , 'P' ,'Isplata èek (pazar)' ,
                                                                  'N', 'Isplata nalog', 
                                                                  'C', 'Isplata grðjanin', TB.IZVOR_TRANSAKCIJE) AS IZVOR_TRANSAKCIJE,
                TB.NOVO_STANJE,
                TB.BROJ_KARTICE,
                TB.AKCEPTANT,
                TB.ID_CPM,
                TB.DATUM,
                TB.ID_VRSTA_TRANSAKCIJE,
                TB.ID_RADNIK,
                TB.REDNI_BROJ_TRANSAKCIJE,            
                STATUS,
                TB.ID_TRANSAKCIJA_NALOG_PP,
                TB.ID_DNEVNIK_TRANSAKCIJA,
                TB.DATUM_TRANSAKCIJE,
                TB.SIFRA_TRANSAKCIJE,
                decode (TB.VRSTA_TRANSAKCIJE , 'U','Uplata',
                                                                    'I','Isplata',TB.VRSTA_TRANSAKCIJE ) AS VRSTA_TRANSAKCIJE,
                TB.SIFRA_RADNIKA, 
                rawtohex(TB.ID_CPM_DAN) AS ID_CPM_DAN,
                TB.DOSTAVA,
                TB.RRN        
      FROM TRANSAKCIJA_BANKA tb
      WHERE TB.ID_CPM_DAN =  P_ID_CPM_DAN;
       
END PREGLED_ZA_BANKE;

PROCEDURE PREGLED_ZA_KOMITENTE  (
                                   P_ID_CPM_DAN  IN TRANSAKCIJA_KOMITENT.ID_CPM_DAN%TYPE,   
                                   P_CURSOR   OUT T_CURSOR)
IS
BEGIN
  
  OPEN P_CURSOR FOR
     SELECT tk.id_transakcija_komitent, tk.sifra_komitenta, pp.NAZIV_F9 naziv_komitenta, tk.iznos, tk.procenat_popusta,TK.ID_CPM_DAN, tk.iznos_sa_popustom, tk.poziv_na_broj,
                 tk.sifra_radnika, tk.datum_transakcije datum, tk.redni_broj_transakcije, tk.sifra_transakcije, tk.status 
      FROM poslovno_okruzenje.poslovni_partner pp, TRANSAKCIJA_KOMITENT tk
      WHERE tk.SIFRA_KOMITENTA = pp.ID_POSLOVNI_PARTNER  
      AND TK.ID_CPM_DAN=P_ID_CPM_DAN 
      ORDER BY tk.datum DESC, status DESC;
  
EXCEPTION
  WHEN OTHERS THEN
    NULL;
END PREGLED_ZA_KOMITENTE;
  

PROCEDURE PREGLED_ZA_NALOGE_PP  (
                                  P_ID_CPM_DAN  IN TRANSAKCIJA_NALOG_PP.ID_CPM_DAN%TYPE, 
                                  P_CURSOR   OUT T_CURSOR)
IS
BEGIN
  
  OPEN P_CURSOR FOR
    SELECT TN.ID_TRANSAKCIJA_NALOG_PP,
                TN.TEKUCI_RACUN_PRIMAOCA,            
                TN.POZIV_NA_BROJ,
                TN.IZNOS,
                TN.SVRHA_UPLATE,
                TN.SIFRA_PLACANJA,
                TN.VRSTA_NALOGA,
                decode(TN.VRSTA_PROMENE, '101' , 'Uplata' ,
                                                            '102', 'Uplata za spec. korisnika', 
                                                            '103' , 'Uplata bez poštarine', 
                                                            '104 ', 'Uplata sa dostave', 
                                                            '105' , 'Uplata viška' ,
                                                            '106' , 'Prijava uplata', 
                                                            '107 ', 'Prijava PTT prihoda',
                                                            '121' , 'Prijava isplata',TN.VRSTA_PROMENE) AS VRSTA_PROMENE,                
                 decode (TN.OZNAKA_PROMENE , 'U','Uplata',
                                                                 'I','Isplata',TN.OZNAKA_PROMENE ) AS OZNAKA_PROMENE,
                TN.ID_RADNIK,
                TN.REDNI_BROJ_TRANSAKCIJE,
                TN.ID_CPM, 
                TN.DATUM,            
                TN.STATUS,
                TN.ID_DNEVNIK_TRANSAKCIJA,
                TN.DATUM_TRANSAKCIJE,
                TN.SIFRA_RADNIKA,
                TN.MODEL_POZIVA_NA_BROJ,
                TN.ID_PRIJAVA,
                TN.NAZIV_UPLATIOCA,
                TN.ADRESA_UPLATIOCA,
                TN.POSTA_UPLATIOCA,
                TN.NAZIV_PRIMAOCA,
                TN.ADRESA_PRIMAOCA,
                TN.POSTA_PRIMAOCA,
                rawtohex(TN.ID_CPM_DAN) AS ID_CPM_DAN , 
                TN.DOSTAVA,
                TN.HITAN_PAZAR,
                rawtohex(TN.REFERENCA_NALOGA) AS REFERENCA_NALOGA, 
                TN.NACIN_REALIZACIJE, 
                TN.DALJA_REALIZACIJA
                
      FROM TRANSAKCIJA_NALOG_PP tn
      WHERE  tn.ID_CPM_DAN=P_ID_CPM_DAN          
    ORDER BY tn.datum DESC ;
  
EXCEPTION
  WHEN OTHERS THEN
    NULL;
      
END PREGLED_ZA_NALOGE_PP;

END NOVCANE_TRANSAKCIJE;
/

SHOW ERRORS;


