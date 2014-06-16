CREATE OR REPLACE PACKAGE                    TRANSAKCIJE IS

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
                                 P_ID_CPM            IN TRANSAKCIJA_BANKA.id_cpm%TYPE,
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
                                 P_PORUKA           OUT VARCHAR2);

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
                                     P_PORUKA           OUT VARCHAR2);

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
                                    P_PORUKA             OUT VARCHAR2);
                                     
PROCEDURE PROVERA_CPM_DANA        (P_ID_CPM_DAN      IN VARCHAR2,
                                   P_VRSTA_OBRADE    IN VARCHAR2,
                                   P_BROJ           OUT NUMBER);

                                      
PROCEDURE OBRADA_CPM_DANA         (P_ID_CPM_DAN     IN VARCHAR2,
                                   P_VRSTA_OBRADE    IN VARCHAR2,
                                   P_ID_CPM          IN CPM_OBRADA.id_cpm%TYPE,
                                   P_DATUM           IN CPM_OBRADA.datum%TYPE,
                                   P_REZULTAT       OUT NUMBER,
                                   P_PORUKA         OUT VARCHAR2);      
                                                                                                    
PROCEDURE KREIRANJE_PRIJAVE  (P_ID_PRIJAVA      IN NUMBER,
                              P_ID_CPM_DAN      IN VARCHAR2,
                              P_ID_CPM          IN CPM_OBRADA.id_cpm%TYPE,
                              P_DATUM           IN CPM_OBRADA.datum%TYPE,
                              P_POZIV_NA_BROJ   IN TRANSAKCIJA_NALOG_PP.poziv_na_broj%TYPE,
                              P_IZNOS           IN TRANSAKCIJA_NALOG_PP.iznos%TYPE,
                              P_REZULTAT       OUT NUMBER,
                              P_PORUKA         OUT VARCHAR2);   
                                   
/*PROCEDURE KREIRANJE_GRUPNIH_NALOGA_BANKE ;
PROCEDURE KREIRANJE_NALOGA_KOMITENTI;

PROCEDURE PRIPREMA_NALOGA_ZA_TRANSFER ( P_REZULTAT  OUT NUMBER);
PROCEDURE PRIPREMA_DNEVNIKA_ZA_TRANSFER ( P_REZULTAT  OUT NUMBER);

FUNCTION ID_RADNA_JEDINICA (P_ID_ORGANIZACIONA_CELINA IN NUMBER) RETURN NUMBER;
FUNCTION FORMAT_IZNOS(P_BROJ IN NUMBER, P_DUZINA IN NUMBER) RETURN VARCHAR2 ;*/

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
                                      P_PORUKA                      OUT VARCHAR2);

  PROCEDURE IZMENA_TRANSAKCIJA_ZA_BANKU(P_ID_TRANSAKCIJA_ZA_BANKU     IN TRANSAKCIJA_ZA_BANKU.ID_TRANSAKCIJA_ZA_BANKU%TYPE,
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
                                        P_PORUKA                      OUT VARCHAR2);

  PROCEDURE UNOS_TR_KOMITENTA(P_ID_TRANSAKCIJA_ZA_KOMITENTA IN TEKUCI_RACUN_KOMITENTA.ID_TRANSAKCIJA_ZA_KOMITENTA%TYPE,
                              P_POZIV_NA_BROJ_VREDNOST      IN TEKUCI_RACUN_KOMITENTA.POZIV_NA_BROJ_VREDNOST%TYPE,
                              P_TEKUCI_RACUN                IN TEKUCI_RACUN_KOMITENTA.TEKUCI_RACUN%TYPE,
                              P_REZULTAT                    OUT NUMBER,
                              P_PORUKA                      OUT VARCHAR2);

  PROCEDURE IZMENA_TR_KOMITENTA(P_ID_TRANSAKCIJA_ZA_KOMITENTA IN TEKUCI_RACUN_KOMITENTA.ID_TRANSAKCIJA_ZA_KOMITENTA%TYPE,
                                P_POZIV_NA_BROJ_VREDNOST      IN TEKUCI_RACUN_KOMITENTA.POZIV_NA_BROJ_VREDNOST%TYPE,
                                P_TEKUCI_RACUN                IN TEKUCI_RACUN_KOMITENTA.TEKUCI_RACUN%TYPE,
                                P_REZULTAT                    OUT NUMBER,
                                P_PORUKA                      OUT VARCHAR2);

  PROCEDURE BRISANJE_TR_KOMITENTA(P_ID_TRANSAKCIJA_ZA_KOMITENTA IN TEKUCI_RACUN_KOMITENTA.ID_TRANSAKCIJA_ZA_KOMITENTA%TYPE,
                                  P_POZIV_NA_BROJ_VREDNOST      IN TEKUCI_RACUN_KOMITENTA.POZIV_NA_BROJ_VREDNOST%TYPE,
                                  P_REZULTAT                    OUT NUMBER,
                                  P_PORUKA                      OUT VARCHAR2);

  PROCEDURE UNOS_TRANSAKCIJA_ZA_KOMITENTA(P_ID_VRSTA_TRANSAKCIJE        IN TRANSAKCIJA_ZA_KOMITENTA.ID_VRSTA_TRANSAKCIJE%TYPE,
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
                                          P_PORUKA                      OUT VARCHAR2);

  PROCEDURE IZMENA_TRN_ZA_KOMITENTA(P_ID_TRANSAKCIJA_ZA_KOMITENTA IN TRANSAKCIJA_ZA_KOMITENTA.ID_TRANSAKCIJA_ZA_KOMITENTA%TYPE,
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
                                    P_PORUKA                      OUT VARCHAR2);*/

END TRANSAKCIJE;
/

SHOW ERRORS;


