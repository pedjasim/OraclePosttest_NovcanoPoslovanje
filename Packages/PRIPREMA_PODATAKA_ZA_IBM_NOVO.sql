CREATE OR REPLACE PACKAGE                    PRIPREMA_PODATAKA_ZA_IBM_NOVO IS
TYPE T_CURSOR IS REF CURSOR;

PROCEDURE KREIRANJE_PRIJAVA (P_ID_CPM_DAN IN VARCHAR2,
                                                  P_REZULTAT  OUT NUMBER);

PROCEDURE KREIRANJE_PRIJAVA_BANKE (P_ID_POSTA IN NUMBER,
                                   P_DATUM IN DATE, 
                                   P_ID_CPM_DAN IN CPM_OBRADA.id_cpm_dan%TYPE,
                                   P_BROJ_POSTE IN VARCHAR2, 
                                   P_NAZIV_POSTE IN VARCHAR2,
                                   P_ID_RJ   IN NUMBER,
                                   P_NAZIV_RJ IN VARCHAR2,
                                   P_ID_PRIJAVE  IN NUMBER,
                                   P_RBR_PRIJAVE IN OUT NUMBER,
                                   P_REZULTAT  OUT NUMBER) ;                                

PROCEDURE KREIRANJE_PRIJAVA_KOMITENTI   (P_GRUPA IN VARCHAR2,
                                                                      P_ID_POSTA IN NUMBER, 
                                                                      P_DATUM IN DATE, 
                                                                      P_ID_CPM_DAN IN CPM_OBRADA.id_cpm_dan%TYPE,
                                                                      P_BROJ_POSTE IN VARCHAR2, 
                                                                      P_NAZIV_POSTE IN VARCHAR2,
                                                                      P_ID_RJ   IN NUMBER,
                                                                      P_NAZIV_RJ IN VARCHAR2,
                                                                      P_ID_PRIJAVE  IN NUMBER,
                                                                      P_RBR_PRIJAVE IN OUT NUMBER, 
                                                                      P_REZULTAT  OUT NUMBER);
                                                                      
PROCEDURE KR_PRIJAVA_KOMITENTI_OBICNI   (P_ID_POSTA IN NUMBER, 
                                                                      P_DATUM IN DATE, 
                                                                      P_ID_CPM_DAN IN CPM_OBRADA.id_cpm_dan%TYPE,
                                                                      P_BROJ_POSTE IN VARCHAR2, 
                                                                      P_NAZIV_POSTE IN VARCHAR2,
                                                                      P_ID_RJ   IN NUMBER,
                                                                      P_NAZIV_RJ IN VARCHAR2,
                                                                      P_ID_PRIJAVE  IN NUMBER,
                                                                      P_RBR_PRIJAVE IN OUT NUMBER);
                                                                      
PROCEDURE KR_PRIJAVA_KOMITENTI_GRUPA_I  (P_ID_POSTA IN NUMBER, 
                                                                       P_DATUM IN DATE, 
                                                                       P_ID_CPM_DAN IN CPM_OBRADA.id_cpm_dan%TYPE,
                                                                       P_BROJ_POSTE IN VARCHAR2, 
                                                                       P_NAZIV_POSTE IN VARCHAR2,
                                                                       P_ID_RJ   IN NUMBER,
                                                                       P_NAZIV_RJ IN VARCHAR2,
                                                                       P_ID_PRIJAVE  IN NUMBER,
                                                                       P_RBR_PRIJAVE IN OUT NUMBER);

PROCEDURE KR_PRIJAVA_KOMITENTI_GRUPA_II (P_ID_POSTA IN NUMBER, 
                                                                        P_DATUM IN DATE, 
                                                                        P_ID_CPM_DAN IN CPM_OBRADA.id_cpm_dan%TYPE,
                                                                        P_BROJ_POSTE IN VARCHAR2, 
                                                                        P_NAZIV_POSTE IN VARCHAR2,
                                                                        P_ID_RJ   IN NUMBER,
                                                                        P_NAZIV_RJ IN VARCHAR2,
                                                                        P_ID_PRIJAVE  IN NUMBER,
                                                                        P_RBR_PRIJAVE IN OUT NUMBER);                                                                    

PROCEDURE PRIPREMA_DNEVNIKA (P_ID_CPM_DAN IN VARCHAR2,
                             P_REZULTAT  OUT NUMBER);


PROCEDURE PRIPREMA_NALOGA_ZA_TRANSFER (P_ID_POSTA IN NUMBER, 
                                       P_DATUM IN DATE,
                                       P_ID_CPM_DAN IN CPM_OBRADA.id_cpm_dan%TYPE,
                                       P_BROJ_POSTE IN VARCHAR2, 
                                       P_NAZIV_POSTE IN VARCHAR2);
                                       
PROCEDURE PRIPREMA_DNEV_KOMITENATA (P_ID_POSTA IN NUMBER, 
                                    P_DATUM IN DATE,
                                    P_ID_CPM_DAN IN CPM_OBRADA.id_cpm_dan%TYPE, 
                                    P_BROJ_POSTE IN VARCHAR2, 
                                    P_NAZIV_POSTE IN VARCHAR2
                                    );
                                    
PROCEDURE PRIPREMA_DNEV_SRPSKA_BANKA (P_ID_POSTA IN NUMBER, 
                                      P_DATUM IN DATE, 
                                      P_ID_CPM_DAN IN CPM_OBRADA.id_cpm_dan%TYPE,
                                      P_BROJ_POSTE IN VARCHAR2, 
                                      P_NAZIV_POSTE IN VARCHAR2
                                      );
                                      
PROCEDURE PRIPREMA_DNEVNIKA_CEKOVA (P_ID_POSTA IN NUMBER, 
                                    P_DATUM IN DATE,
                                    P_ID_CPM_DAN IN CPM_OBRADA.id_cpm_dan%TYPE, 
                                    P_BROJ_POSTE IN VARCHAR2, 
                                    P_NAZIV_POSTE IN VARCHAR2
                                    );

PROCEDURE PRIPREMA_DNEV_LOKAL_KOMITENATA (P_ID_POSTA IN NUMBER, 
                                    P_DATUM IN DATE,
                                    P_ID_CPM_DAN IN CPM_OBRADA.id_cpm_dan%TYPE, 
                                    P_BROJ_POSTE IN VARCHAR2, 
                                    P_NAZIV_POSTE IN VARCHAR2
                                    );
                                                                        
FUNCTION ID_RADNA_JEDINICA (P_ID_CPM IN NUMBER) RETURN NUMBER;

PROCEDURE RADNA_JEDINICA (P_ID_CPM IN NUMBER,
                          P_ID_RJ  OUT NUMBER,
                          P_NAZIV  OUT VARCHAR2
                         ) ;

FUNCTION ODREDI_KONTROLNE_CIFRE
 (P_MODEL IN VARCHAR2,
  P_BROJ IN VARCHAR2) RETURN VARCHAR2 ; 

FUNCTION FORMAT_IZNOS(P_BROJ IN NUMBER, P_DUZINA IN NUMBER) RETURN VARCHAR2;

PROCEDURE CPM_DAN_ZA_OBRADU
  ( 
    P_REZULTAT      OUT NUMBER,
    P_CURSOR        OUT T_CURSOR
  );

PROCEDURE CPM_DAN_ZA_OBRADU_LOK_KOM
  ( 
    P_REZULTAT      OUT NUMBER,
    P_CURSOR        OUT T_CURSOR
  );
    
PROCEDURE UPDATE_CPM_OBRADA
  ( P_ID_CPM_DAN IN VARCHAR2,
    P_GLAVNA_OBRADA  IN VARCHAR2, 
    P_REZULTAT      OUT NUMBER,
    P_PORUKA        OUT VARCHAR2
  );
      
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
                          );                           
END PRIPREMA_PODATAKA_ZA_IBM_NOVO;
/

SHOW ERRORS;


