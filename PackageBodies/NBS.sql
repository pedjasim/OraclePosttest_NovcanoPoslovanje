CREATE OR REPLACE PACKAGE BODY                    NBS IS

  PROCEDURE PODACI_ZA_NBS (P_DATUM_OD   IN  DATE,
                                               P_DATUM_DO   IN  DATE,
                                               P_REZULTAT OUT NUMBER,
                                               P_CURSOR OUT T_CURSOR) IS
   BEGIN
   P_REZULTAT := 1;
   OPEN P_CURSOR FOR
   
       /*SELECT tk.sifra_transakcije sifra, SUM (tk.iznos)iznos, COUNT(*) komada,  SUBSTR(t.tekuci_racun, 1,3 ) BANKA
         FROM TRANSAKCIJA_KOMITENT tk, TRANSAKCIJA_ZA_KOMITENTA t
        WHERE tk.id_vrsta_transakcije = t.id_vrsta_transakcije
          AND tk.sifra_komitenta = t.sifra_komitenta
          AND tk.sifra_transakcije = t.sifra_transakcije
          AND  tk.datum_transakcije BETWEEN P_DATUM_OD and  P_DATUM_DO       
          AND tk.sifra_komitenta NOT IN (1955, 1938, 1364, 27386, 19365,1,2, 42278, 31534, 35939, 2544, 45651, 47218, 5, 6, 19, 25179, 2540)         
           AND tk.status ='V'
        GROUP BY  tk.sifra_transakcije,  SUBSTR(t.tekuci_racun, 1,3 ) 
        ORDER BY 1, 2 ;*/        
        
        
        --SELECT /*+ index(tk transakcija_kom_cpm_dan_idx)*/ tk.sifra_transakcije sifra, SUM (tk.iznos)iznos, COUNT(*) komada,  SUBSTR(t.tekuci_racun, 1,3 ) BANKA
        /* FROM TRANSAKCIJA_KOMITENT tk, TRANSAKCIJA_ZA_KOMITENTA t, CPM_OBRADA co
        WHERE tk.id_vrsta_transakcije = t.id_vrsta_transakcije
          AND tk.sifra_komitenta = t.sifra_komitenta
          AND tk.sifra_transakcije = t.sifra_transakcije
          AND tk.id_cpm_dan = co.id_cpm_dan
          AND  tk.datum_transakcije BETWEEN P_DATUM_OD and  P_DATUM_DO       
          AND TK.SIFRA_TRANSAKCIJE not in (select distinct SIFRA_TRANSAKCIJE 
                                                                from transakcija_za_komitenta
                                                                where sifra_komitenta in (1955, 1364, 27386, 19365, 1, 42278, 31534, 35939, 2544, 45651, 47218, 5, 6, 19, 25179, 2540, 3524)) 
          AND  TK.SIFRA_TRANSAKCIJE not  in ('MV143', 'MV144', '291', '292', '2')     
          AND tk.status ='V'
        GROUP BY  tk.sifra_transakcije,  SUBSTR(t.tekuci_racun, 1,3 ) 
        ORDER BY 1, 2 ;     
        
        
        SELECT TK.SIFRA_TRANSAKCIJE SIFRA, 
        SUM(TK.IZNOS) IZNOS, 
        COUNT(*) KOMADA, 
        SUBSTR(T.TEKUCI_RACUN, 1, 3) BANKA 
        FROM NOVCANO_POSLOVANJE.TRANSAKCIJA_KOMITENT TK, 
        NOVCANO_POSLOVANJE.TRANSAKCIJA_ZA_KOMITENTA T, 
        NOVCANO_POSLOVANJE.CPM_OBRADA CO 
        WHERE T.ID_VRSTA_TRANSAKCIJE = TK.ID_VRSTA_TRANSAKCIJE 
        AND T.SIFRA_KOMITENTA = TK.SIFRA_KOMITENTA 
        AND T.SIFRA_TRANSAKCIJE = TK.SIFRA_TRANSAKCIJE 
        AND CO.ID_CPM_DAN = TK.ID_CPM_DAN 
        AND  tk.datum_transakcije BETWEEN P_DATUM_OD and  P_DATUM_DO       
        AND TK.SIFRA_TRANSAKCIJE NOT IN ('MV143', 'MV144', '291', '292', '2')     
        AND 'V' = TK.STATUS 
        AND T.SIFRA_TRANSAKCIJE NOT IN (SELECT DISTINCT SIFRA_TRANSAKCIJE 
        FROM NOVCANO_POSLOVANJE.TRANSAKCIJA_ZA_KOMITENTA TRANSAKCIJA_ZA_KOMITENTA1 
        WHERE TRANSAKCIJA_ZA_KOMITENTA1.ROWID IN (SELECT TRANSAKCIJA_ZA_KOMITENTA2.ROWID 
        FROM NOVCANO_POSLOVANJE.TRANSAKCIJA_ZA_KOMITENTA TRANSAKCIJA_ZA_KOMITENTA2 
        WHERE '1955' = SIFRA_KOMITENTA 
        UNION 
        SELECT TRANSAKCIJA_ZA_KOMITENTA3.ROWID 
        FROM NOVCANO_POSLOVANJE.TRANSAKCIJA_ZA_KOMITENTA TRANSAKCIJA_ZA_KOMITENTA3 
        WHERE '1364' = SIFRA_KOMITENTA 
        OR '27386' = SIFRA_KOMITENTA 
        OR '19365' = SIFRA_KOMITENTA 
        OR '1' = SIFRA_KOMITENTA 
        OR '42278' = SIFRA_KOMITENTA 
        OR '31534' = SIFRA_KOMITENTA 
        OR '35939' = SIFRA_KOMITENTA 
        OR '2544' = SIFRA_KOMITENTA 
        OR '45651' = SIFRA_KOMITENTA 
        OR '47218' = SIFRA_KOMITENTA 
        OR '5' = SIFRA_KOMITENTA 
        OR '6' = SIFRA_KOMITENTA 
        OR '19' = SIFRA_KOMITENTA 
        OR '25179' = SIFRA_KOMITENTA 
        OR '2540' = SIFRA_KOMITENTA 
        OR '3524' = SIFRA_KOMITENTA) 
        GROUP BY SIFRA_TRANSAKCIJE) 
        AND T.SIFRA_TRANSAKCIJE NOT IN ('MV143', 'MV144', '291', '292', '2') 
        GROUP BY TK.SIFRA_TRANSAKCIJE, SUBSTR(T.TEKUCI_RACUN, 1, 3) 
        ORDER BY 1, 2;
        
        
        SELECT TK.SIFRA_TRANSAKCIJE SIFRA, SUM(TK.IZNOS) IZNOS, COUNT(*) KOMADA, 
        CASE WHEN co.datum <= '31-oct-2012' AND t.SIFRA_TRANSAKCIJE = '225' THEN '245' 
        WHEN co.datum between '31-oct-2012' and '06-nov-2012' AND t.SIFRA_TRANSAKCIJE = '225' THEN '355' 
        WHEN co.datum > '06-nov-2012' AND t.SIFRA_TRANSAKCIJE = '225' THEN '200' 
        ---JKP Glogonj
        WHEN co.datum <= '23-oct-2012' AND t.SIFRA_TRANSAKCIJE = '245' THEN '200' 
        WHEN co.datum between '23-oct-2012' and '31-oct-2012' AND t.SIFRA_TRANSAKCIJE = '245' THEN '245' 
        WHEN co.datum > '31-oct-2012' AND t.SIFRA_TRANSAKCIJE = '245' THEN '200' 
        --- Informatika
        WHEN co.datum <= '06-nov-2012' AND t.SIFRA_TRANSAKCIJE = '119' THEN '290' 
        WHEN co.datum > '06-nov-2012' AND co.datum <= '15-jan-2013' AND  t.SIFRA_TRANSAKCIJE = '119' THEN '375' 
        WHEN co.datum > '15-jan-2013' AND t.SIFRA_TRANSAKCIJE = '119' THEN '255' 
        ELSE SUBSTR(t.tekuci_racun, 1,3 ) END BANKA 
        FROM NOVCANO_POSLOVANJE.TRANSAKCIJA_KOMITENT TK, NOVCANO_POSLOVANJE.TRANSAKCIJA_ZA_KOMITENTA T, NOVCANO_POSLOVANJE.CPM_OBRADA CO 
        WHERE T.ID_VRSTA_TRANSAKCIJE = TK.ID_VRSTA_TRANSAKCIJE 
        AND T.SIFRA_KOMITENTA = TK.SIFRA_KOMITENTA 
        AND T.SIFRA_TRANSAKCIJE = TK.SIFRA_TRANSAKCIJE 
        AND CO.ID_CPM_DAN = TK.ID_CPM_DAN 
        AND CO.DATUM BETWEEN P_DATUM_OD and  P_DATUM_DO 
        AND TK.SIFRA_TRANSAKCIJE NOT IN ('MV143', 'MV144', '291', '292', '2', '202', '159')      
        AND 'V' = TK.STATUS 
        AND T.SIFRA_TRANSAKCIJE NOT IN (SELECT DISTINCT SIFRA_TRANSAKCIJE 
        FROM NOVCANO_POSLOVANJE.TRANSAKCIJA_ZA_KOMITENTA TRANSAKCIJA_ZA_KOMITENTA1 
        WHERE TRANSAKCIJA_ZA_KOMITENTA1.ROWID IN (SELECT TRANSAKCIJA_ZA_KOMITENTA2.ROWID 
        FROM NOVCANO_POSLOVANJE.TRANSAKCIJA_ZA_KOMITENTA TRANSAKCIJA_ZA_KOMITENTA2 
        WHERE '1955' = SIFRA_KOMITENTA 
        UNION 
        SELECT TRANSAKCIJA_ZA_KOMITENTA3.ROWID 
        FROM NOVCANO_POSLOVANJE.TRANSAKCIJA_ZA_KOMITENTA TRANSAKCIJA_ZA_KOMITENTA3 
        WHERE '1364' = SIFRA_KOMITENTA 
        OR '27386' = SIFRA_KOMITENTA 
        OR '19365' = SIFRA_KOMITENTA 
        OR '1' = SIFRA_KOMITENTA 
        OR '42278' = SIFRA_KOMITENTA 
        OR '31534' = SIFRA_KOMITENTA 
        OR '35939' = SIFRA_KOMITENTA 
        OR '2544' = SIFRA_KOMITENTA 
        OR '45651' = SIFRA_KOMITENTA 
        OR '47218' = SIFRA_KOMITENTA 
        OR '5' = SIFRA_KOMITENTA 
        OR '6' = SIFRA_KOMITENTA 
        OR '19' = SIFRA_KOMITENTA 
        OR '25179' = SIFRA_KOMITENTA 
        OR '2540' = SIFRA_KOMITENTA 
        OR '3524' = SIFRA_KOMITENTA
        OR '53084' = SIFRA_KOMITENTA) 
        GROUP BY SIFRA_TRANSAKCIJE) 
        AND T.SIFRA_TRANSAKCIJE NOT IN ('MV143', 'MV144', '291', '292', '2', '202', '159') 
        GROUP BY TK.SIFRA_TRANSAKCIJE, CASE WHEN co.datum <= '31-oct-2012' AND t.SIFRA_TRANSAKCIJE = '225' THEN '245' 
        WHEN co.datum between '31-oct-2012' and '06-nov-2012' AND t.SIFRA_TRANSAKCIJE = '225' THEN '355' 
        WHEN co.datum > '06-nov-2012' AND t.SIFRA_TRANSAKCIJE = '225' THEN '200' 
        ---JKP Glogonj
        WHEN co.datum <= '23-oct-2012' AND t.SIFRA_TRANSAKCIJE = '245' THEN '200' 
        WHEN co.datum between '23-oct-2012' and '31-oct-2012' AND t.SIFRA_TRANSAKCIJE = '245' THEN '245' 
        WHEN co.datum > '31-oct-2012' AND t.SIFRA_TRANSAKCIJE = '245' THEN '200' 
        --- Informatika
        WHEN co.datum <= '06-nov-2012' AND t.SIFRA_TRANSAKCIJE = '119' THEN '290' 
        WHEN co.datum > '06-nov-2012' AND co.datum <= '15-jan-2013' AND  t.SIFRA_TRANSAKCIJE = '119' THEN '375' 
        WHEN co.datum > '15-jan-2013' AND t.SIFRA_TRANSAKCIJE = '119' THEN '255'  
        ELSE SUBSTR(t.tekuci_racun, 1,3 ) END
        ORDER BY 1, 2;
        */
        
   SELECT    /*+ index(tk transakcija_kom_cpm_dan_idx)*/
                 tk.sifra_transakcije sifra,
                 SUM (tk.iznos) iznos,
                 COUNT (*) komada,
                 SUBSTR (t.tekuci_racun, 1, 3) BANKA
   FROM     TRANSAKCIJA_KOMITENT tk, 
                 TRANSAKCIJA_ZA_KOMITENTA t, 
                 CPM_OBRADA co
   WHERE     tk.id_vrsta_transakcije = t.id_vrsta_transakcije
                 AND tk.sifra_komitenta = t.sifra_komitenta
                 AND tk.sifra_transakcije = t.sifra_transakcije
                 AND tk.id_cpm_dan = co.id_cpm_dan
                 AND co.datum BETWEEN P_DATUM_OD AND P_DATUM_DO
                 AND tk.status = 'V'
                 AND TK.SIFRA_TRANSAKCIJE NOT IN
                                                                    ('MV143',
                                                                     'MV144',
                                                                     '291',
                                                                     '292',
                                                                     '2',
                                                                     '1',
                                                                     '10',                                                                   
                                                                     '101',
                                                                     '102',
                                                                     '159',
                                                                     '202',
                                                                     '11',
                                                                     '19',
                                                                     '27',
                                                                     '28',
                                                                     '29',
                                                                     '30',
                                                                     '4',
                                                                     '401',
                                                                     '403',
                                                                     '405',
                                                                     '407',
                                                                     '409',
                                                                     '411',
                                                                     '5',
                                                                     '6',
                                                                     '627',
                                                                     '63',
                                                                     '726',
                                                                     '728',
                                                                     '8',
                                                                     '810',
                                                                     '815',
                                                                     '820',
                                                                     '825',
                                                                     '830',
                                                                     '835',
                                                                     '840',
                                                                     '845',
                                                                     '850',
                                                                     '855',
                                                                     '860',
                                                                     '865',
                                                                     '870',
                                                                     '875',
                                                                     '880',
                                                                     '890',
                                                                     '895',
                                                                     '900',
                                                                     '910',
                                                                     '915',
                                                                     '920',
                                                                     '930',
                                                                     '940',
                                                                     '945',
                                                                     '950',
                                                                     '955',
                                                                     '960',
                                                                     '965',
                                                                     '970',
                                                                     '98',
                                                                     'PN212',
                                                                     'PN213',
                                                                     'PU139',
                                                                     'PU140',
                                                                     'PU141',
                                                                     'PU142',
                                                                     'PU290',
                                                                      'TR10',
                                                                        '201',
                                                                        '481',
                                                                        '483',
                                                                        '489',
                                                                        '491',
                                                                        '493',
                                                                        '497',
                                                                        '499',
                                                                        '550',
                                                                        '551',
                                                                        '552',
                                                                        '553',
                                                                        '554',
                                                                        '555',
                                                                        '556',
                                                                        '557',
                                                                        '558',
                                                                        '559',
                                                                        '560',
                                                                        '561',
                                                                        '562',
                                                                        '563',
                                                                        '564',
                                                                        '565',
                                                                        '566',
                                                                        '567',
                                                                        '568',
                                                                        '569',
                                                                        '570',
                                                                        '571',
                                                                        '572',
                                                                        '573',
                                                                        '574',
                                                                        '575',
                                                                        '576',
                                                                        '578',
                                                                        '311',
                                                                        '313',
                                                                        '315',
                                                                        '317',
                                                                        '319',
                                                                        '321',
                                                                        '282',
                                                                        '284',
                                                                        '286',
                                                                        '288',
                                                                        '281')            
    GROUP BY tk.sifra_transakcije, SUBSTR (t.tekuci_racun, 1, 3)
    ORDER BY 1, 2;
                    
    P_REZULTAT := 0;
   
END PODACI_ZA_NBS;

END NBS;
/

SHOW ERRORS;


