CREATE TABLE ARH_TRANSAKCIJA_BANKA
(
  ID_TRANSAKCIJA_BANKA     NUMBER(9)            NOT NULL,
  SIFRA_BANKE              VARCHAR2(5 CHAR)     NOT NULL,
  IZNOS_TRANSAKCIJE        NUMBER(18,2)         NOT NULL,
  BROJ_TEKUCEG_RACUNA      VARCHAR2(20 CHAR),
  BROJ_CEKA                VARCHAR2(20 CHAR),
  BROJ_STEDNE_KNJIZICE     VARCHAR2(20 CHAR),
  AUTORIZACIONI_BROJ       VARCHAR2(20 CHAR),
  VRSTA_PROMENE            VARCHAR2(5 CHAR),
  NACIN_REALIZACIJE        VARCHAR2(1 CHAR),
  IZVOR_TRANSAKCIJE        VARCHAR2(1 CHAR),
  NOVO_STANJE              NUMBER(18,2),
  BROJ_KARTICE             VARCHAR2(20 CHAR),
  AKCEPTANT                VARCHAR2(20 CHAR),
  ID_CPM                   NUMBER(5)            NOT NULL,
  DATUM                    DATE                 NOT NULL,
  ID_VRSTA_TRANSAKCIJE     NUMBER(5)            NOT NULL,
  ID_RADNIK                NUMBER(8)            NOT NULL,
  REDNI_BROJ_TRANSAKCIJE   VARCHAR2(5 CHAR)     NOT NULL,
  STATUS                   VARCHAR2(1 CHAR)     NOT NULL,
  ID_TRANSAKCIJA_NALOG_PP  NUMBER(9),
  ID_DNEVNIK_TRANSAKCIJA   NUMBER(9),
  DATUM_TRANSAKCIJE        DATE,
  SIFRA_TRANSAKCIJE        VARCHAR2(5 CHAR),
  VRSTA_TRANSAKCIJE        VARCHAR2(1 CHAR),
  SIFRA_RADNIKA            VARCHAR2(4 CHAR),
  ID_CPM_DAN               RAW(16),
  DOSTAVA                  VARCHAR2(1 CHAR),
  RRN                      VARCHAR2(12 CHAR),
  SALTER                   NUMBER(5)
)
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


