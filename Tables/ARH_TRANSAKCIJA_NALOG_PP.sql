CREATE TABLE ARH_TRANSAKCIJA_NALOG_PP
(
  ID_TRANSAKCIJA_NALOG_PP  NUMBER(9)            NOT NULL,
  NAZIV_UPLATIOCA          VARCHAR2(35 CHAR)    NOT NULL,
  ADRESA_UPLATIOCA         VARCHAR2(35 CHAR),
  POSTA_UPLATIOCA          VARCHAR2(35 CHAR),
  NAZIV_PRIMAOCA           VARCHAR2(35 CHAR)    NOT NULL,
  ADRESA_PRIMAOCA          VARCHAR2(35 CHAR),
  POSTA_PRIMAOCA           VARCHAR2(35 CHAR),
  TEKUCI_RACUN_PRIMAOCA    VARCHAR2(20 CHAR),
  POZIV_NA_BROJ            VARCHAR2(22 CHAR),
  IZNOS                    NUMBER(18,2)         NOT NULL,
  SVRHA_UPLATE             VARCHAR2(105 CHAR)   NOT NULL,
  SIFRA_PLACANJA           VARCHAR2(3 CHAR)     NOT NULL,
  VRSTA_NALOGA             VARCHAR2(1 CHAR)     NOT NULL,
  VRSTA_PROMENE            VARCHAR2(3 CHAR)     NOT NULL,
  OZNAKA_PROMENE           VARCHAR2(1 CHAR)     NOT NULL,
  ID_RADNIK                NUMBER(8)            NOT NULL,
  REDNI_BROJ_TRANSAKCIJE   VARCHAR2(5 CHAR),
  ID_CPM                   NUMBER(5)            NOT NULL,
  DATUM                    DATE                 NOT NULL,
  STATUS                   VARCHAR2(1 CHAR)     NOT NULL,
  ID_DNEVNIK_TRANSAKCIJA   NUMBER(9),
  DATUM_TRANSAKCIJE        DATE,
  SIFRA_RADNIKA            VARCHAR2(4 CHAR),
  MODEL_POZIVA_NA_BROJ     VARCHAR2(2 CHAR),
  ID_PRIJAVA               NUMBER(3),
  ID_CPM_DAN               RAW(16),
  DOSTAVA                  VARCHAR2(1 CHAR),
  HITAN_PAZAR              VARCHAR2(1 CHAR),
  REFERENCA_NALOGA         RAW(16),
  NACIN_REALIZACIJE        VARCHAR2(2 CHAR),
  DALJA_REALIZACIJA        VARCHAR2(1 CHAR),
  SALTER                   NUMBER(5)
)
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


