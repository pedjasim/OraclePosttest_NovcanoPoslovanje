CREATE OR REPLACE PACKAGE BODY                    ZP_PACKAGE AS
/******************************************************************************
   NAME:       ZP_PACKAGE
   PURPOSE: ZASTUPNIÈKE PROVIZIJE ZA UGOVORNE POŠTE I ŠALTERE
   
******************************************************************************/

 PROCEDURE UGOVORNI_SALTER(P_ID_CPM_DAN  IN   TRANSAKCIJA_BANKA.ID_CPM_DAN%TYPE,                                     
                                                 P_CURSOR     OUT T_CURSOR) IS
 BEGIN
    OPEN P_CURSOR FOR
    -- Uplata na tekuæi raèun PŠ
    SELECT tb.ID_CPM_DAN                        ID_CPM_DAN, 
                COUNT (*)                               KOMADA,           
                SUM(tb.IZNOS_TRANSAKCIJE)    IZNOS,
                tb.ID_VRSTA_TRANSAKCIJE       ID_VRSTA_TRANSAKCIJE,
                'Uplata na tekuæi raèun PŠ'         TRANSAKCIJA,
                '2'                                            RBR,
                ''                                              ANALITIKA,
                TB.SALTER                               SALTER
      FROM TRANSAKCIJA_BANKA tb
      WHERE tb.ID_CPM_DAN =  P_ID_CPM_DAN
                 AND tb.ID_VRSTA_TRANSAKCIJE = 185  
                 AND tb.SIFRA_BANKE = '200'                        
                 AND tb.STATUS = 'V'
                 AND tb.SALTER BETWEEN 900 AND 999
     GROUP BY tb.ID_CPM_DAN, tb.ID_VRSTA_TRANSAKCIJE, tb.SALTER
     UNION ALL
     --Isplata sa TR BPŠ - èek (501) i Isplata sa TR BPŠ - nalog (508)
     SELECT tb.ID_CPM_DAN                        ID_CPM_DAN, 
                COUNT (*)                               KOMADA,                
                SUM(tb.IZNOS_TRANSAKCIJE)    IZNOS,
                tb.ID_VRSTA_TRANSAKCIJE       ID_VRSTA_TRANSAKCIJE,
                'Isplata sa TR BPŠ'                     TRANSAKCIJA,
                '3'                                            RBR,
                ''                                              ANALITIKA,
                TB.SALTER                               SALTER
      FROM TRANSAKCIJA_BANKA tb
      WHERE tb.ID_CPM_DAN =  P_ID_CPM_DAN
                 AND tb.ID_VRSTA_TRANSAKCIJE  IN (186, 433)
                 AND tb.SIFRA_BANKE = '200'                        
                 AND tb.STATUS IN ('V', 'O')
                 AND tb.SIFRA_TRANSAKCIJE IN ('501', '508')
                 AND tb.SALTER BETWEEN 900 AND 999
      GROUP BY  tb.ID_CPM_DAN, tb.ID_VRSTA_TRANSAKCIJE, tb.SALTER
      UNION ALL
      -- Isplata štednog uloga
      SELECT   tb.ID_CPM_DAN                        ID_CPM_DAN, 
                    COUNT (*)                               KOMADA,                  
                    SUM(tb.IZNOS_TRANSAKCIJE)    IZNOS,
                    tb.ID_VRSTA_TRANSAKCIJE       ID_VRSTA_TRANSAKCIJE,
                    'Isplata štednog uloga'               TRANSAKCIJA,
                    '4'                                            RBR,
                    ''                                              ANALITIKA,
                    TB.SALTER                               SALTER
      FROM TRANSAKCIJA_BANKA tb
      WHERE tb.ID_CPM_DAN =  P_ID_CPM_DAN
                 AND tb.ID_VRSTA_TRANSAKCIJE = 198                               
                 AND tb.STATUS IN ('V', 'O')
                 AND tb.SALTER BETWEEN 900 AND 999
      GROUP BY  tb.ID_CPM_DAN, tb.ID_VRSTA_TRANSAKCIJE, tb.SALTER
      UNION ALL
     --Prijem i naplata èekova drugih banaka: Prijem dnevnog pazara u èekovima graðana izdatim od strane Banke PŠ
     SELECT  tb.ID_CPM_DAN                                                                                          ID_CPM_DAN, 
                COUNT (*)                                                                                                   KOMADA,                  
                SUM(tb.IZNOS_TRANSAKCIJE)                                                                       IZNOS,
                tb.ID_VRSTA_TRANSAKCIJE                                                                          ID_VRSTA_TRANSAKCIJE,
                'Prijem dnevnog pazara u èekovima graðana izdatim od strane Banke PŠ'          TRANSAKCIJA,
                '5'                                                                                                               RBR,           
                '1'                                                                                                               ANALITIKA,
                TB.SALTER                                                                                                  SALTER
      FROM TRANSAKCIJA_BANKA tb
      WHERE tb.ID_CPM_DAN =  P_ID_CPM_DAN
                 AND tb.ID_VRSTA_TRANSAKCIJE  = 186
                 AND tb.SIFRA_BANKE = '200'                
                 AND TB.SIFRA_TRANSAKCIJE IN ('501', '602', '622')                
                 AND tb.STATUS IN ('V', 'O')               
                 AND tb.SALTER BETWEEN 900 AND 999          
      GROUP BY tb.ID_CPM_DAN, tb.ID_VRSTA_TRANSAKCIJE, tb.SALTER  
      UNION ALL       
      --Prijem i naplata èekova drugih banaka: Prijem i naplata èekova po tekuæim raèunima graðana izdatih od strane drugih banaka 
     SELECT tb.ID_CPM_DAN                                                                                                              ID_CPM_DAN, 
                COUNT (*)                                                                                                                      KOMADA,                  
                SUM(tb.IZNOS_TRANSAKCIJE)                                                                                           IZNOS,
                tb.ID_VRSTA_TRANSAKCIJE                                                                                              ID_VRSTA_TRANSAKCIJE,
                'Prijem i naplata èekova po tekuæim raèunima graðana izdatih od strane drugih banaka'          TRANSAKCIJA,
                '5'                                                                                                                                   RBR,           
                '2'                                                                                                                                   ANALITIKA,
                TB.SALTER                                                                                                                      SALTER
      FROM TRANSAKCIJA_BANKA tb
              WHERE tb.ID_CPM_DAN =  P_ID_CPM_DAN
                 AND tb.ID_VRSTA_TRANSAKCIJE  = 186
                 AND tb.SIFRA_BANKE not in ('200', '295')      
                 AND TB.SIFRA_TRANSAKCIJE = '602'                  
                 AND tb.STATUS IN ('V', 'O')               
                 AND tb.SALTER BETWEEN 900 AND 999          
      GROUP BY tb.ID_CPM_DAN, tb.ID_VRSTA_TRANSAKCIJE, tb.SALTER
      UNION ALL
     --Prijem i naplata èekova drugih banaka: Prijem dnevnog pazara u èekovima graðanaizdatim od strane drugih banaka
     SELECT  tb.ID_CPM_DAN                                                                                              ID_CPM_DAN, 
                COUNT (*)                                                                                                       KOMADA,           
                SUM(tb.IZNOS_TRANSAKCIJE)                                                                           IZNOS,
                tb.ID_VRSTA_TRANSAKCIJE                                                                              ID_VRSTA_TRANSAKCIJE,
                'Prijem dnevnog pazara u èekovima graðana izdatim od strane drugih banaka'       TRANSAKCIJA,
                '5'                                                                                                                   RBR,           
                '3'                                                                                                                   ANALITIKA ,
                TB.SALTER                                                                                                      SALTER
      FROM TRANSAKCIJA_BANKA tb
      WHERE tb.ID_CPM_DAN =  P_ID_CPM_DAN
                 AND tb.ID_VRSTA_TRANSAKCIJE  = 186
                 AND tb.SIFRA_BANKE NOT IN ('200', '295')     
                 AND TB.SIFRA_TRANSAKCIJE IN ('501', '602', '622')                           
                 AND tb.STATUS IN ('V', 'O')               
                 AND tb.SALTER BETWEEN 900 AND 999          
      GROUP BY tb.ID_VRSTA_TRANSAKCIJE, TB.SALTER
      UNION ALL
     --Prijem i naplata èekova drugih banaka: Isplate èekova Srpske banke po tekuæim raèunima graðana
     SELECT tb.ID_CPM_DAN                                                                     ID_CPM_DAN, 
                COUNT (*)                                                                             KOMADA,         
                SUM(tb.IZNOS_TRANSAKCIJE)                                                  IZNOS,
                tb.ID_VRSTA_TRANSAKCIJE                                                     ID_VRSTA_TRANSAKCIJE,
                'Isplate èekova Srpske banke po tekuæim raèunima graðana'       TRANSAKCIJA,
                '5'                                                                                         RBR,           
                '4'                                                                                         ANALITIKA,
                TB.SALTER                                                                             SALTER
      FROM TRANSAKCIJA_BANKA tb
      WHERE tb.ID_CPM_DAN =  P_ID_CPM_DAN
                 AND tb.ID_VRSTA_TRANSAKCIJE  = 186
                 AND tb.SIFRA_BANKE = '295'      
                 AND TB.SIFRA_TRANSAKCIJE = '622'                  
                 AND tb.STATUS IN ('V', 'O')               
                 AND tb.SALTER BETWEEN 900 AND 999          
      GROUP BY tb.ID_CPM_DAN, tb.ID_VRSTA_TRANSAKCIJE, tb.SALTER
      UNION ALL
     --Prijem i naplata èekova drugih banaka: Prijem èekova Srpske banke iz pazara pravnih lica
     SELECT  tb.ID_CPM_DAN                                                          ID_CPM_DAN, 
                COUNT (*)                                                                   KOMADA,                
                SUM(tb.IZNOS_TRANSAKCIJE)                                        IZNOS,
                tb.ID_VRSTA_TRANSAKCIJE                                           ID_VRSTA_TRANSAKCIJE,
                'Prijem èekova Srpske banke iz pazara pravnih lica'          TRANSAKCIJA,
                '5'                                                                                RBR,           
                '5'                                                                                ANALITIKA,
                TB.SALTER                                                                   SALTER           
      FROM TRANSAKCIJA_BANKA tb
      WHERE tb.ID_CPM_DAN =  P_ID_CPM_DAN
                 AND tb.ID_VRSTA_TRANSAKCIJE  = 186
                 AND tb.SIFRA_BANKE = '295' 
                 AND TB.SIFRA_TRANSAKCIJE IN ('501', '602', '622')        
                 AND tb.STATUS IN ('V', 'O')               
                 AND tb.SALTER BETWEEN 900 AND 999          
      GROUP BY tb.ID_CPM_DAN, tb.ID_VRSTA_TRANSAKCIJE, tb.SALTER
      UNION ALL
      --Nalozi za uplatu za Dunav osiguranje za odreðene raèune, bez poštarine
      SELECT   n.ID_CPM_DAN                              ID_CPM_DAN, 
                    COUNT (*)                                    KOMADA,           
                    SUM(n.IZNOS)                               IZNOS,
                    101                                               ID_VRSTA_TRANSAKCIJE,
                    'Uplata pazara'                               TRANSAKCIJA,
                    '8'                                                 RBR,           
                    ''                                                   ANALITIKA,
                    n.SALTER                                    SALTER
      FROM TRANSAKCIJA_NALOG_PP n
      WHERE n.ID_CPM_DAN =  P_ID_CPM_DAN
                 AND n.VRSTA_NALOGA = 'P'
                 AND n.VRSTA_PROMENE IN ('102', '104')
                 AND n.OZNAKA_PROMENE = 'U'
                 AND n.STATUS IN ('V', 'O')               
                 AND n.SALTER BETWEEN 900 AND 999 
                 AND n.TEKUCI_RACUN_PRIMAOCA IN ('105000000005116779',
                                                                        '170000000000061318',
                                                                        '200221091010203373',
                                                                        '205000000001009470',
                                                                        '205000000001014611',
                                                                        '205000000001016648',
                                                                        '205000000001025087',
                                                                        '205000000001030519',
                                                                        '205000000001034011',
                                                                        '205000000001374772',
                                                                        '205000000001409498',
                                                                        '205000000001465952',
                                                                        '205000000001501066',
                                                                        '205000000001514743',
                                                                        '205000000001541418',
                                                                        '205000000001615720',
                                                                        '205000000001780038',
                                                                        '205000000002031171',
                                                                        '205000000003314772',
                                                                        '205000000003363175',
                                                                        '205000000003711211',
                                                                        '205000000000395848',
                                                                        '205000000004926330',
                                                                        '205000000000941376',
                                                                        '205000000000944674',
                                                                        '205000000000948457',
                                                                        '360000000000163445',
                                                                        '360000000000163833',
                                                                        '360000000000164512',
                                                                        '360000000000164997',
                                                                        '360000000000165191',
                                                                        '360000000000165288',
                                                                        '360000000000165676',
                                                                        '360000000000165773',
                                                                        '360000000000165870',
                                                                        '360000000000165967',
                                                                        '360000000000166064',
                                                                        '360000000000166161',
                                                                        '360000000000166258',
                                                                        '360000000000167034',
                                                                        '360000000000167325',
                                                                        '360000000000167616',
                                                                        '360000000000167713',
                                                                        '360000000000167810',
                                                                        '360000000000168586',
                                                                        '360000000000171496',
                                                                        '360000000000175667',
                                                                        '360000000000191284',
                                                                        '360008804260101141',
                                                                        '360008806730101187')         
      GROUP BY  n.ID_CPM_DAN, n.SALTER
      UNION ALL
      -- Prodaja virtuelnih vauèera
     SELECT K.ID_CPM_DAN                                             ID_CPM_DAN ,
                COUNT (*)                                                    KOMADA,           
                 SUM(k.IZNOS)                                              IZNOS,
                 tk.ID_VRSTA_TRANSAKCIJE                           ID_VRSTA_TRANSAKCIJE,
                 'Prodaja vauèera'                                          TRANSAKCIJA,
                  '13'                                                             RBR,           
                  TK.ID_MOBILNI_PROVAJDER_EDOP || ''          ANALITIKA,
                  k.SALTER                                                    SALTER       
       FROM TRANSAKCIJA_KOMITENT k,   TRANSAKCIJA_ZA_KOMITENTA tk
       WHERE  k.sifra_komitenta = tk.sifra_komitenta 
                   AND k.sifra_transakcije = tk.sifra_transakcije
                   AND k.id_vrsta_transakcije = tk.id_vrsta_transakcije
                   AND k.ID_CPM_DAN =  P_ID_CPM_DAN
                   AND k.ID_VRSTA_TRANSAKCIJE = 256  
                   AND k.STATUS IN ('V', 'O')
                   AND k.SALTER BETWEEN 900 AND 999
                   AND  TK.ID_MOBILNI_PROVAJDER_EDOP <= 3
     GROUP BY K.ID_CPM_DAN, tk.ID_VRSTA_TRANSAKCIJE,  TK.ID_MOBILNI_PROVAJDER_EDOP, k.SALTER
     UNION ALL
      -- Uplata za INFOSTAN
     SELECT tk.ID_CPM_DAN                        ID_CPM_DAN ,
     COUNT (*)                                           KOMADA,           
                 SUM(tk.IZNOS)                         IZNOS,
                 tk.ID_VRSTA_TRANSAKCIJE       ID_VRSTA_TRANSAKCIJE,
                 'Uplata za INFOSTAN'                TRANSAKCIJA,             
                  '6'                                           RBR,           
                 TK.SIFRA_TRANSAKCIJE            ANALITIKA,
                  tk.SALTER                               SALTER      
      FROM TRANSAKCIJA_KOMITENT tk
      WHERE tk.ID_CPM_DAN =  P_ID_CPM_DAN
                 AND tk.ID_VRSTA_TRANSAKCIJE = 191         
                 AND tk.SIFRA_KOMITENTA = '1938'                      
                 AND tk.STATUS IN ('V', 'O')
                 AND tk.SALTER BETWEEN 900 AND 999
      GROUP BY tk.ID_CPM_DAN, tk.ID_VRSTA_TRANSAKCIJE , TK.SIFRA_TRANSAKCIJE, tk.SALTER             
      UNION ALL
      -- Uplata komunalnih usluga za koje se prilikom naplate raèuna na šalteru ne naplaæuje poštarina i za koje se ne vrši umanjenje prijave
      SELECT  K.ID_CPM_DAN                        ID_CPM_DAN,
                   COUNT (*)                              KOMADA,           
                  SUM(k.IZNOS)                          IZNOS,
                  k.ID_VRSTA_TRANSAKCIJE        ID_VRSTA_TRANSAKCIJE,
                  'Uplata komunalnih usluga'         TRANSAKCIJA,
                  '7'                                           RBR,           
                 tk.SIFRA_TRANSAKCIJE            ANALITIKA,
                  k.SALTER                               SALTER     
       FROM TRANSAKCIJA_KOMITENT k, TRANSAKCIJA_ZA_KOMITENTA tk
       WHERE  k.sifra_komitenta = tk.sifra_komitenta 
                   AND k.sifra_transakcije = tk.sifra_transakcije
                   AND k.id_vrsta_transakcije = tk.id_vrsta_transakcije
                   AND k.ID_CPM_DAN =  P_ID_CPM_DAN
                   AND k.ID_VRSTA_TRANSAKCIJE = 191  
                   AND k.STATUS IN ('V', 'O')
                   --Izuzetak su 119 – JKP Informatika i 205 = DJKP 2. Oktobar , VŠ  za koje se naplaæuje poštarina a ulaze u ovaj obraèun
                   AND (TK.ID_USLUGA_CENOVNIK_STRANKA IS NULL OR TK.SIFRA_TRANSAKCIJE IN ('119','205'))
                   AND (TK.PROVIZIJA_PRIJAVA IS NULL OR  TK.PROVIZIJA_PRIJAVA = 0)
                   AND tk.VRSTA_KOMITENTA = 'KOM'
                   AND k.SALTER BETWEEN 900 AND 999
      GROUP BY k.ID_CPM_DAN, k.ID_VRSTA_TRANSAKCIJE, TK.SIFRA_TRANSAKCIJE, k.SALTER;
 END UGOVORNI_SALTER;
 
 
 PROCEDURE UGOVORNA_POSTA(P_ID_CPM_DAN  IN  TRANSAKCIJA_BANKA.ID_CPM_DAN%TYPE,                                     
                                                 P_CURSOR      OUT T_CURSOR) IS
 BEGIN
    OPEN P_CURSOR FOR
    
    -- Uplata na tekuæi raèun PŠ
    SELECT tb.ID_CPM_DAN                        ID_CPM_DAN, 
                COUNT (*)                               KOMADA,           
                SUM(tb.IZNOS_TRANSAKCIJE)    IZNOS,
                tb.ID_VRSTA_TRANSAKCIJE       ID_VRSTA_TRANSAKCIJE,
                'Uplata na tekuæi raèun PŠ'         TRANSAKCIJA,
                '2'                                            RBR,
                ''                                              ANALITIKA,
                TB.SALTER                               SALTER
      FROM TRANSAKCIJA_BANKA tb
      WHERE tb.ID_CPM_DAN =  P_ID_CPM_DAN
                 AND tb.ID_VRSTA_TRANSAKCIJE = 185  
                 AND tb.SIFRA_BANKE = '200'                        
                 AND tb.STATUS = 'V'         
     GROUP BY tb.ID_CPM_DAN, tb.ID_VRSTA_TRANSAKCIJE, TB.SALTER
     UNION ALL
     --Isplata sa TR BPŠ - èek (501) i Isplata sa TR BPŠ - nalog (508)
     SELECT tb.ID_CPM_DAN                        ID_CPM_DAN, 
                COUNT (*)                               KOMADA,                
                SUM(tb.IZNOS_TRANSAKCIJE)    IZNOS,
                tb.ID_VRSTA_TRANSAKCIJE       ID_VRSTA_TRANSAKCIJE,
                'Isplata sa TR BPŠ'                     TRANSAKCIJA,
                '3'                                            RBR,
                ''                                              ANALITIKA,
                TB.SALTER                               SALTER
      FROM TRANSAKCIJA_BANKA tb
      WHERE          tb.ID_CPM_DAN =  P_ID_CPM_DAN
                 AND tb.ID_VRSTA_TRANSAKCIJE  IN (186, 433)
                 AND tb.SIFRA_BANKE = '200'                        
                 AND tb.STATUS IN ('V', 'O')
                 AND tb.SIFRA_TRANSAKCIJE IN ('501', '508')           
      GROUP BY tb.ID_CPM_DAN, tb.ID_VRSTA_TRANSAKCIJE, TB.SALTER
      UNION ALL
      -- Isplata štednog uloga
      SELECT   tb.ID_CPM_DAN                        ID_CPM_DAN, 
                    COUNT (*)                               KOMADA,                  
                    SUM(tb.IZNOS_TRANSAKCIJE)    IZNOS,
                    tb.ID_VRSTA_TRANSAKCIJE       ID_VRSTA_TRANSAKCIJE,
                    'Isplata štednog uloga'               TRANSAKCIJA,
                    '4'                                            RBR,
                    ''                                              ANALITIKA,
                    TB.SALTER                               SALTER
      FROM TRANSAKCIJA_BANKA tb
      WHERE          tb.ID_CPM_DAN =  P_ID_CPM_DAN
                 AND tb.ID_VRSTA_TRANSAKCIJE = 198                               
                 AND tb.STATUS IN ('V', 'O')            
      GROUP BY tb.ID_CPM_DAN, tb.ID_VRSTA_TRANSAKCIJE, TB.SALTER
      UNION ALL
     --Prijem i naplata èekova drugih banaka: Prijem dnevnog pazara u èekovima graðana izdatim od strane Banke PŠ
     SELECT  tb.ID_CPM_DAN                                                                                          ID_CPM_DAN, 
                COUNT (*)                                                                                                   KOMADA,                  
                SUM(tb.IZNOS_TRANSAKCIJE)                                                                       IZNOS,
                tb.ID_VRSTA_TRANSAKCIJE                                                                          ID_VRSTA_TRANSAKCIJE,
                'Prijem dnevnog pazara u èekovima graðana izdatim od strane Banke PŠ'          TRANSAKCIJA,
                '5'                                                                                                               RBR,           
                '1'                                                                                                               ANALITIKA,
                TB.SALTER                                                                                                  SALTER
      FROM TRANSAKCIJA_BANKA tb
      WHERE          tb.ID_CPM_DAN =  P_ID_CPM_DAN
                 AND tb.ID_VRSTA_TRANSAKCIJE  = 186
                 AND tb.SIFRA_BANKE = '200'        
                 AND TB.SIFRA_TRANSAKCIJE IN ('501', '602', '622')                                 
                 AND tb.STATUS IN ('V', 'O')                          
      GROUP BY tb.ID_CPM_DAN, tb.ID_VRSTA_TRANSAKCIJE, TB.SALTER
      UNION ALL       
      --Prijem i naplata èekova drugih banaka: Prijem i naplata èekova po tekuæim raèunima graðana izdatih od strane drugih banaka 
     SELECT tb.ID_CPM_DAN                                                                                                              ID_CPM_DAN, 
                COUNT (*)                                                                                                                      KOMADA,                  
                SUM(tb.IZNOS_TRANSAKCIJE)                                                                                           IZNOS,
                tb.ID_VRSTA_TRANSAKCIJE                                                                                              ID_VRSTA_TRANSAKCIJE,
                'Prijem i naplata èekova po tekuæim raèunima graðana izdatih od strane drugih banaka'          TRANSAKCIJA,
                '5'                                                                                                                                   RBR,           
                '2'                                                                                                                                   ANALITIKA,
                TB.SALTER                                                                                                                      SALTER
      FROM TRANSAKCIJA_BANKA tb
              WHERE  tb.ID_CPM_DAN = P_ID_CPM_DAN
                 AND tb.ID_VRSTA_TRANSAKCIJE  = 186
                 AND tb.SIFRA_BANKE not in ('200', '295')      
                 AND TB.SIFRA_TRANSAKCIJE = '602'                  
                 AND tb.STATUS IN ('V', 'O')             
      GROUP BY tb.ID_CPM_DAN, tb.ID_VRSTA_TRANSAKCIJE, TB.SALTER
      UNION ALL
     --Prijem i naplata èekova drugih banaka: Prijem dnevnog pazara u èekovima graðanaizdatim od strane drugih banaka
     SELECT  tb.ID_CPM_DAN                                                                                              ID_CPM_DAN, 
                COUNT (*)                                                                                                       KOMADA,           
                SUM(tb.IZNOS_TRANSAKCIJE)                                                                           IZNOS,
                tb.ID_VRSTA_TRANSAKCIJE                                                                              ID_VRSTA_TRANSAKCIJE,
                'Prijem dnevnog pazara u èekovima graðana izdatim od strane drugih banaka'       TRANSAKCIJA,
                '5'                                                                                                                   RBR,           
                '3'                                                                                                                   ANALITIKA ,
                TB.SALTER                                                                                                      SALTER
      FROM TRANSAKCIJA_BANKA tb
      WHERE tb.ID_CPM_DAN = P_ID_CPM_DAN
                 AND tb.ID_VRSTA_TRANSAKCIJE  = 186
                 AND tb.SIFRA_BANKE NOT IN ('200', '295')             
                 AND TB.SIFRA_TRANSAKCIJE IN ('501', '602', '622')                   
                 AND tb.STATUS IN ('V', 'O')                              
      GROUP BY tb.ID_CPM_DAN, tb.ID_VRSTA_TRANSAKCIJE, TB.SALTER
      UNION ALL
     --Prijem i naplata èekova drugih banaka: Isplate èekova Srpske banke po tekuæim raèunima graðana
     SELECT tb.ID_CPM_DAN                                                                     ID_CPM_DAN, 
                COUNT (*)                                                                             KOMADA,         
                SUM(tb.IZNOS_TRANSAKCIJE)                                                  IZNOS,
                tb.ID_VRSTA_TRANSAKCIJE                                                     ID_VRSTA_TRANSAKCIJE,
                'Isplate èekova Srpske banke po tekuæim raèunima graðana'       TRANSAKCIJA,
                '5'                                                                                         RBR,           
                '4'                                                                                         ANALITIKA,
                TB.SALTER                                                                            SALTER        
      FROM TRANSAKCIJA_BANKA tb
      WHERE tb.ID_CPM_DAN =  P_ID_CPM_DAN
                 AND tb.ID_VRSTA_TRANSAKCIJE  = 186
                 AND tb.SIFRA_BANKE = '295'      
                 AND TB.SIFRA_TRANSAKCIJE = '622'                  
                 AND tb.STATUS IN ('V', 'O')                            
      GROUP BY tb.ID_CPM_DAN, tb.ID_VRSTA_TRANSAKCIJE, TB.SALTER
      UNION ALL
     --Prijem i naplata èekova drugih banaka: Prijem èekova Srpske banke iz pazara pravnih lica
     SELECT  tb.ID_CPM_DAN                                                          ID_CPM_DAN, 
                COUNT (*)                                                                   KOMADA,                
                SUM(tb.IZNOS_TRANSAKCIJE)                                        IZNOS,
                tb.ID_VRSTA_TRANSAKCIJE                                           ID_VRSTA_TRANSAKCIJE,
                'Prijem èekova Srpske banke iz pazara pravnih lica'          TRANSAKCIJA,
                '5'                                                                                RBR,           
                '5'                                                                                ANALITIKA,
                TB.SALTER                                                                   SALTER             
      FROM TRANSAKCIJA_BANKA tb
      WHERE tb.ID_CPM_DAN =  P_ID_CPM_DAN
                 AND tb.ID_VRSTA_TRANSAKCIJE  = 186
                 AND tb.SIFRA_BANKE = '295' 
                 AND TB.SIFRA_TRANSAKCIJE IN ('501', '602', '622')        
                 AND tb.STATUS IN ('V', 'O')                              
      GROUP BY tb.ID_CPM_DAN,tb.ID_VRSTA_TRANSAKCIJE, TB.SALTER
      UNION ALL
      --Nalozi za uplatu za Dunav osiguranje za odreðene raèune, bez poštarine
      SELECT   n.ID_CPM_DAN                              ID_CPM_DAN, 
                    COUNT (*)                                    KOMADA,           
                    SUM(n.IZNOS)                               IZNOS,
                    101                                               ID_VRSTA_TRANSAKCIJE,
                    'Uplata pazara'                               TRANSAKCIJA,
                    '8'                                                 RBR,           
                    ''                                                   ANALITIKA,
                    n.SALTER                                    SALTER
      FROM TRANSAKCIJA_NALOG_PP n
      WHERE n.ID_CPM_DAN =  P_ID_CPM_DAN
                 AND n.VRSTA_NALOGA = 'P'
                 AND n.VRSTA_PROMENE IN ('102', '104')
                 AND n.OZNAKA_PROMENE = 'U'
                 AND n.STATUS IN ('V', 'O')   
                 AND n.TEKUCI_RACUN_PRIMAOCA IN ('105000000005116779',
                                                                        '170000000000061318',
                                                                        '200221091010203373',
                                                                        '205000000001009470',
                                                                        '205000000001014611',
                                                                        '205000000001016648',
                                                                        '205000000001025087',
                                                                        '205000000001030519',
                                                                        '205000000001034011',
                                                                        '205000000001374772',
                                                                        '205000000001409498',
                                                                        '205000000001465952',
                                                                        '205000000001501066',
                                                                        '205000000001514743',
                                                                        '205000000001541418',
                                                                        '205000000001615720',
                                                                        '205000000001780038',
                                                                        '205000000002031171',
                                                                        '205000000003314772',
                                                                        '205000000003363175',
                                                                        '205000000003711211',
                                                                        '205000000000395848',
                                                                        '205000000004926330',
                                                                        '205000000000941376',
                                                                        '205000000000944674',
                                                                        '205000000000948457',
                                                                        '360000000000163445',
                                                                        '360000000000163833',
                                                                        '360000000000164512',
                                                                        '360000000000164997',
                                                                        '360000000000165191',
                                                                        '360000000000165288',
                                                                        '360000000000165676',
                                                                        '360000000000165773',
                                                                        '360000000000165870',
                                                                        '360000000000165967',
                                                                        '360000000000166064',
                                                                        '360000000000166161',
                                                                        '360000000000166258',
                                                                        '360000000000167034',
                                                                        '360000000000167325',
                                                                        '360000000000167616',
                                                                        '360000000000167713',
                                                                        '360000000000167810',
                                                                        '360000000000168586',
                                                                        '360000000000171496',
                                                                        '360000000000175667',
                                                                        '360000000000191284',
                                                                        '360008804260101141',
                                                                        '360008806730101187')         
      GROUP BY  n.ID_CPM_DAN, n.SALTER
      UNION ALL
      -- Prodaja virtuelnih vauèera
     SELECT K.ID_CPM_DAN                                             ID_CPM_DAN ,
                COUNT (*)                                                    KOMADA,           
                 SUM(k.IZNOS)                                              IZNOS,
                 tk.ID_VRSTA_TRANSAKCIJE                           ID_VRSTA_TRANSAKCIJE,
                 'Prodaja vauèera'                                          TRANSAKCIJA,
                  '13'                                                             RBR,           
                  TK.ID_MOBILNI_PROVAJDER_EDOP || ''          ANALITIKA,
                  k.SALTER                                                     SALTER       
       FROM TRANSAKCIJA_KOMITENT k,   TRANSAKCIJA_ZA_KOMITENTA tk
       WHERE  k.sifra_komitenta = tk.sifra_komitenta 
                   AND k.sifra_transakcije = tk.sifra_transakcije
                   AND k.id_vrsta_transakcije = tk.id_vrsta_transakcije                  
                   AND k.ID_CPM_DAN =  P_ID_CPM_DAN
                   AND k.ID_VRSTA_TRANSAKCIJE = 256  
                   AND k.STATUS IN ('V', 'O')
                   AND  TK.ID_MOBILNI_PROVAJDER_EDOP <= 3
     GROUP BY K.ID_CPM_DAN, tk.ID_VRSTA_TRANSAKCIJE,  TK.ID_MOBILNI_PROVAJDER_EDOP, k.SALTER
     UNION ALL
      -- Uplata za INFOSTAN
     SELECT tk.ID_CPM_DAN                        ID_CPM_DAN ,
     COUNT (*)                                           KOMADA,           
                 SUM(tk.IZNOS)                         IZNOS,
                 tk.ID_VRSTA_TRANSAKCIJE       ID_VRSTA_TRANSAKCIJE,
                 'Uplata za INFOSTAN'                TRANSAKCIJA,             
                  '6'                                           RBR,           
                 tk.SIFRA_TRANSAKCIJE            ANALITIKA,
                 tk.SALTER                               SALTER 
      FROM TRANSAKCIJA_KOMITENT tk
      WHERE tk.ID_CPM_DAN =  P_ID_CPM_DAN
                 AND tk.ID_VRSTA_TRANSAKCIJE = 191         
                 AND tk.SIFRA_KOMITENTA = '1938'                      
                 AND tk.STATUS IN ('V', 'O')       
      GROUP BY tk.ID_CPM_DAN, tk.ID_VRSTA_TRANSAKCIJE , TK.SIFRA_TRANSAKCIJE, tk.SALTER           
      UNION ALL
      -- Uplata komunalnih usluga za koje se prilikom naplate raèuna na šalteru ne naplaæuje poštarina i za koje se ne vrši umanjenje prijave
      SELECT  K.ID_CPM_DAN                        ID_CPM_DAN,
                   COUNT (*)                              KOMADA,           
                  SUM(k.IZNOS)                          IZNOS,
                  k.ID_VRSTA_TRANSAKCIJE        ID_VRSTA_TRANSAKCIJE,
                  'Uplata komunalnih usluga'         TRANSAKCIJA,
                  '7'                                           RBR,           
                 TK.SIFRA_TRANSAKCIJE            ANALITIKA,
                 k.SALTER                               SALTER 
       FROM TRANSAKCIJA_KOMITENT k, TRANSAKCIJA_ZA_KOMITENTA tk
       WHERE  k.sifra_komitenta = tk.sifra_komitenta 
                   AND k.sifra_transakcije = tk.sifra_transakcije
                   AND k.id_vrsta_transakcije = tk.id_vrsta_transakcije                  
                   AND k.ID_CPM_DAN =  P_ID_CPM_DAN
                   AND k.ID_VRSTA_TRANSAKCIJE = 191  
                   AND k.STATUS IN ('V', 'O')
                    --Izuzetak su 119 – JKP Informatika i 205 = DJKP 2. Oktobar , VŠ  za koje se naplaæuje poštarina a ulaze u ovaj obraèun
                   AND (TK.ID_USLUGA_CENOVNIK_STRANKA IS NULL OR TK.SIFRA_TRANSAKCIJE IN ('119','205'))
                   AND (TK.PROVIZIJA_PRIJAVA IS NULL OR  TK.PROVIZIJA_PRIJAVA = 0)
                   AND tk.VRSTA_KOMITENTA = 'KOM'
      GROUP BY  K.ID_CPM_DAN, k.ID_VRSTA_TRANSAKCIJE, TK.SIFRA_TRANSAKCIJE, k.SALTER;
 END UGOVORNA_POSTA;

END ZP_PACKAGE;
/

SHOW ERRORS;


