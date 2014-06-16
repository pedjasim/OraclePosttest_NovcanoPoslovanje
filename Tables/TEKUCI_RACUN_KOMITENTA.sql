CREATE TABLE TEKUCI_RACUN_KOMITENTA
(
  ID_TEKUCI_RACUN_KOMITENTA    NUMBER(7)        NOT NULL,
  ID_TRANSAKCIJA_ZA_KOMITENTA  NUMBER(7)        NOT NULL,
  POZIV_NA_BROJ_VREDNOST       VARCHAR2(20 CHAR) NOT NULL,
  TEKUCI_RACUN                 VARCHAR2(25 CHAR) NOT NULL,
  VAZI_OD                      DATE,
  VAZI_DO                      DATE
)
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


