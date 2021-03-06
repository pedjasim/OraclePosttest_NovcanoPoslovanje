CREATE TABLE IZV_PAZARI
(
  ID_IZV_PAZARI          NUMBER(7)              NOT NULL,
  ID_CPM_DAN             RAW(16)                NOT NULL,
  ID_TRANSAKCIJA         RAW(16)                NOT NULL,
  RJ                     VARCHAR2(50 CHAR)      NOT NULL,
  POSTANSKI_BROJ         VARCHAR2(5 CHAR)       NOT NULL,
  DATUM                  DATE                   NOT NULL,
  SIFRA_TRN              NUMBER(5)              NOT NULL,
  NAZIV_TRN              VARCHAR2(50 CHAR)      NOT NULL,
  SIFRA_RADNIKA          VARCHAR2(6 CHAR)       NOT NULL,
  RBR_TRANSAKCIJE        NUMBER(5)              NOT NULL,
  IZNOS                  NUMBER(18,2)           NOT NULL,
  GOTOVINSKA_POSTARINA   NUMBER(18,2),
  FAKTURISANA_POSTARINA  NUMBER(18,2),
  TEKUCI_RACUN           VARCHAR2(18 CHAR)      NOT NULL,
  POZIV_NA_BROJ          VARCHAR2(18 CHAR),
  SIFRA_PLACANJA         NUMBER(3),
  UPLATILAC              VARCHAR2(105 CHAR)     NOT NULL,
  SVRHA_UPLATE           VARCHAR2(105 CHAR)     NOT NULL,
  PRIMALAC               VARCHAR2(105 CHAR)     NOT NULL,
  ID_IZVOR_PODATAKA      NUMBER(1)              NOT NULL,
  DATUM_PUNJENJA         DATE                   NOT NULL,
  OPIS                   VARCHAR2(200 CHAR),
  OBRACUNSKI_DAN         DATE
)
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


