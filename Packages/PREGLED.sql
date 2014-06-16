CREATE OR REPLACE PACKAGE                    PREGLED IS

  TYPE T_CURSOR IS REF CURSOR;

  PROCEDURE PREGLED_TREBOVANJA(P_ID_CPM   IN VARCHAR2,
                               P_DATUM_OD IN TREBOVANJE.datum_trebovanja%TYPE,
                               P_DATUM_DO IN TREBOVANJE.datum_trebovanja%TYPE,
                               P_CURSOR   OUT T_CURSOR);

  PROCEDURE PREGLED_AS_TREBOVANJA(P_ID_TREBOVANJE IN TREBOVANJE.id_trebovanje%TYPE,
                                  P_CURSOR        OUT T_CURSOR);

  PROCEDURE PREGLED_DOTACIJA_SUVISAK(P_ID_CPM   IN DOTACIJA.id_cpm%TYPE,
                                     P_DATUM_OD IN DOTACIJA.datum%TYPE,
                                     P_DATUM_DO IN DOTACIJA.datum%TYPE,
                                     P_VRSTA    IN VARCHAR2,
                                     P_CURSOR   OUT T_CURSOR);

  PROCEDURE PREGLED_AS_DOTACIJA_SUVISAK(P_ID_DOTACIJA IN DOTACIJA.id_dotacija%TYPE,
                                        P_VRSTA       IN VARCHAR2,
                                        P_CURSOR      OUT T_CURSOR);

  PROCEDURE PREGLED_SUVISKA(P_ID_CPM IN SUVISAK.id_cpm%TYPE,
                            P_DATUM  IN SUVISAK.datum%TYPE,
                            P_CURSOR OUT T_CURSOR);

  PROCEDURE PREGLED_AS_SUVISKA(P_ID_SUVISAK IN SUVISAK.id_suvisak%TYPE,
                               P_CURSOR     OUT T_CURSOR);

  PROCEDURE PREGLED_NALOGA_ZA_RAZMENU(P_ID_CPM_N      IN NALOG_ZA_RAZMENU_GOT.id_cpm_nalogodavac%TYPE,
                                      P_ID_CPM_S      IN NALOG_ZA_RAZMENU_GOT.id_cpm_suvisak%TYPE,
                                      P_ID_CPM_D      IN NALOG_ZA_RAZMENU_GOT.id_cpm_dotacija%TYPE,
                                      P_DATUM_RAZMENE IN NALOG_ZA_RAZMENU_GOT.datum_razmene%TYPE,
                                      P_STATUS        IN NALOG_ZA_RAZMENU_GOT.status%TYPE,
                                      P_CURSOR        OUT T_CURSOR);

  PROCEDURE PREGLED_POSTA(P_ID_RJ IN VARCHAR2, P_CURSOR OUT T_CURSOR);

  PROCEDURE PREGLED_RJ(P_CURSOR OUT T_CURSOR);
  
  PROCEDURE PREGLED_BANAKA(P_CURSOR OUT T_CURSOR);
  PROCEDURE PREGLED_KOMITENATA(P_CURSOR OUT T_CURSOR);

  PROCEDURE PREGLED_TRANSAKCIJA_ZA_BANKU(P_SIFRA_BANKE IN NOVCANO_POSLOVANJE.TRANSAKCIJA_ZA_BANKU.SIFRA_BANKE%TYPE,
                                         P_CURSOR      OUT T_CURSOR);

  PROCEDURE PREGLED_TRANS_ZA_KOMITENTA(P_ID_VRSTA_TRANSAKCIJE IN VARCHAR2, --NOVCANO_POSLOVANJE.TRANSAKCIJA_ZA_KOMITENTA.ID_VRSTA_TRANSAKCIJE%TYPE,
                                       --P_SIFRA_KOMITENTA      IN NOVCANO_POSLOVANJE.TRANSAKCIJA_ZA_KOMITENTA.SIFRA_KOMITENTA%TYPE,
                                       P_CURSOR OUT T_CURSOR);

  PROCEDURE PREGLED_TEKUCIH_RACUNA(P_ID_TRANSAKCIJA_ZA_KOMITENTA IN NOVCANO_POSLOVANJE.TRANSAKCIJA_ZA_KOMITENTA.ID_TRANSAKCIJA_ZA_KOMITENTA%TYPE,
                                   P_CURSOR                      OUT T_CURSOR);
END PREGLED;
/

SHOW ERRORS;


