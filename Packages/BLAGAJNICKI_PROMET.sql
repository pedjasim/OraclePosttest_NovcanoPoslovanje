CREATE OR REPLACE PACKAGE                    BLAGAJNICKI_PROMET IS

TYPE T_CURSOR IS REF CURSOR;

PROCEDURE AS_OTPREMA_SUVISKA 
       ( P_ID_SUVISAK     IN APOENSKA_STRUKTURA_SUVISKA.id_suvisak%TYPE,
         P_ID_APOEN       IN APOENSKA_STRUKTURA_SUVISKA.id_apoen%TYPE,
         P_KOMADA         IN APOENSKA_STRUKTURA_SUVISKA.komada%TYPE,
         P_REZULTAT      OUT NUMBER,
         P_PORUKA        OUT VARCHAR2 );
         
PROCEDURE AS_PRIJEM_DOTACIJE 
       ( P_ID_DOTACIJA    IN APOENSKA_STRUKTURA_DOTACIJE.id_dotacija%TYPE,
         P_ID_APOEN       IN APOENSKA_STRUKTURA_DOTACIJE.id_apoen%TYPE,
         P_KOMADA         IN APOENSKA_STRUKTURA_DOTACIJE.komada%TYPE,
         P_REZULTAT      OUT NUMBER,
         P_PORUKA        OUT VARCHAR2 ) ;
         
PROCEDURE AS_TREBOVANJE_NOVCA 
       ( P_ID_TREBOVANJE  IN APOENSKA_STRUKTURA_TREBOVANJA.id_trebovanje%TYPE,
         P_ID_APOEN       IN APOENSKA_STRUKTURA_TREBOVANJA.id_apoen%TYPE,
         P_KOMADA         IN APOENSKA_STRUKTURA_TREBOVANJA.komada%TYPE,
         P_REZULTAT      OUT NUMBER,
         P_PORUKA        OUT VARCHAR2 );


PROCEDURE AS_PRIJAVE_MANJKA_VISKA 
       ( P_ID_MANJAK_VISAK  IN APOEN_STRUKTURA_MANJKA_VISKA.id_manjak_visak%TYPE,
         P_ID_APOEN         IN APOEN_STRUKTURA_MANJKA_VISKA.id_apoen%TYPE,
         P_KOMADA           IN APOEN_STRUKTURA_MANJKA_VISKA.komada%TYPE,
         P_REZULTAT        OUT NUMBER,
         P_PORUKA          OUT VARCHAR2 );         
         
PROCEDURE OTPREMA_SUVISKA
       ( P_ID_CPM         IN SUVISAK.id_cpm%TYPE,
         P_ID_TRANSAKCIJA IN SUVISAK.id_transakcija%TYPE,
         P_ID_NALOG_RAZ   IN SUVISAK.id_nalog_za_razmenu_got%TYPE,
         P_IZNOS          IN SUVISAK.iznos%TYPE,
         P_DATUM          IN SUVISAK.datum%TYPE,
         P_ODREDISTE      IN SUVISAK.odrediste%TYPE,
         P_ID_SUVISAK    OUT SUVISAK.id_suvisak%TYPE,
         P_REZULTAT      OUT NUMBER,
         P_PORUKA        OUT VARCHAR2 ) ;
         
PROCEDURE PRIJEM_DOTACIJE 
       ( P_ID_CPM         IN DOTACIJA.id_cpm%TYPE,
         P_ID_TRANSAKCIJA IN DOTACIJA.id_transakcija%TYPE,
         P_ID_NALOG_RAZ   IN DOTACIJA.id_nalog_za_razmenu_got%TYPE,
         P_IZNOS          IN DOTACIJA.iznos%TYPE,
         P_DATUM          IN DOTACIJA.datum%TYPE,
         P_POREKLO        IN DOTACIJA.poreklo%TYPE,
         P_ID_DOTACIJA   OUT DOTACIJA.id_dotacija%TYPE,
         P_REZULTAT      OUT NUMBER,
         P_PORUKA        OUT VARCHAR2 ) ;
        
PROCEDURE TREBOVANJE_NOVCA 
       ( P_ID_CPM         IN TREBOVANJE.id_cpm%TYPE,
         P_ZA_DATUM       IN TREBOVANJE.za_datum%TYPE,
         P_IZNOS          IN TREBOVANJE.iznos%TYPE,
         P_KOVANI_NOVAC   IN TREBOVANJE.kovani_novac%TYPE,
         -- P_DATUM          IN TREBOVANJE.datum_trebovanja%TYPE,
         P_ID_TREBOVANJE OUT TREBOVANJE.id_trebovanje%TYPE,
         P_REZULTAT      OUT NUMBER,
         P_PORUKA        OUT VARCHAR2 ); 
         
PROCEDURE STORNIRANJE_TREBOVANJA_NOVCA 
       ( P_ID_TREBOVANJE IN TREBOVANJE.id_trebovanje%TYPE,
         P_REZULTAT      OUT NUMBER,
         P_PORUKA        OUT VARCHAR2 ); 
         
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
         P_PORUKA          OUT VARCHAR2 );          
PROCEDURE NALOG_ZA_RAZMENU 
       ( P_ID_CPM         IN NALOG_ZA_RAZMENU_GOT.id_cpm_suvisak %TYPE,
         P_VRSTA          IN VARCHAR2,
         P_CURSOR        OUT T_CURSOR,
         P_REZULTAT      OUT NUMBER,
         P_PORUKA        OUT VARCHAR2 ); 
         
PROCEDURE KREIRANJE_NALOG_ZA_RAZMENU 
       ( P_ID_CPM_S       IN NALOG_ZA_RAZMENU_GOT.id_cpm_suvisak%TYPE,
         P_ID_CPM_D       IN NALOG_ZA_RAZMENU_GOT.id_cpm_dotacija%TYPE,
         P_ID_CPM_N       IN NALOG_ZA_RAZMENU_GOT.id_cpm_nalogodavac%TYPE,
         P_DATUM_RAZMENE  IN NALOG_ZA_RAZMENU_GOT.datum_razmene%TYPE,
         P_IZNOS          IN NALOG_ZA_RAZMENU_GOT.iznos%TYPE,
         P_OPERATER       IN NALOG_ZA_RAZMENU_GOT.id_radnik%TYPE,
         P_ID_NALOGA     OUT NALOG_ZA_RAZMENU_GOT.id_nalog_za_razmenu_got%TYPE,
         P_REZULTAT      OUT NUMBER,
         P_PORUKA        OUT VARCHAR2 );         
                      
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
         P_PORUKA             OUT VARCHAR2 ) ;
                  
PROCEDURE AS_BLAGAJNE
       ( P_ID_BLAGAJNA         IN APOENSKA_STRUKTURA_BLAGAJNE.id_blagajna%TYPE,
         P_ID_APOEN            IN APOENSKA_STRUKTURA_BLAGAJNE.id_apoen%TYPE,
         P_KOMADA              IN APOENSKA_STRUKTURA_BLAGAJNE.komada%TYPE,
         P_REZULTAT           OUT NUMBER,
         P_PORUKA             OUT VARCHAR2 );    
 
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
         P_PORUKA              OUT VARCHAR2 ) ;
                 
PROCEDURE AS_PROMETA
       ( P_ID_PROMET           IN APOENSKA_STRUKTURA_PROMETA.id_promet%TYPE,
         P_ID_APOEN            IN APOENSKA_STRUKTURA_PROMETA.id_apoen%TYPE,
         P_KOMADA              IN APOENSKA_STRUKTURA_PROMETA.komada%TYPE,
         P_REZULTAT           OUT NUMBER,
         P_PORUKA             OUT VARCHAR2 );    

PROCEDURE UPLATE_ISPLATE
       ( P_ID_CPM_DAN           IN VARCHAR2,
         P_UPLATA               IN STANJE_KASE.uplata%TYPE,
         P_ISPLATA              IN STANJE_KASE.isplata%TYPE,
         P_REZULTAT            OUT NUMBER,
         P_PORUKA              OUT VARCHAR2 ) ;

PROCEDURE FORMIRANJE_STANJA_KASE  (P_ID_CPM_DAN IN VARCHAR2,
                                   P_REZULTAT  OUT NUMBER,
                                   P_PORUKA    OUT VARCHAR2);

PROCEDURE SPREMI_STANJE_KASE  (P_REZULTAT  OUT NUMBER,
                               P_CURSOR    OUT T_CURSOR); 
                                                                   
END BLAGAJNICKI_PROMET;
/

SHOW ERRORS;


