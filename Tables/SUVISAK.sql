CREATE TABLE SUVISAK
(
  ID_SUVISAK               NUMBER(9)            NOT NULL,
  ID_CPM                   NUMBER(5)            NOT NULL,
  ID_TRANSAKCIJA           VARCHAR2(36 CHAR)    NOT NULL,
  ID_NALOG_ZA_RAZMENU_GOT  NUMBER(9),
  ID_DOKUMENT              NUMBER(9),
  DATUM                    DATE                 NOT NULL,
  ODREDISTE                VARCHAR2(1 CHAR)     NOT NULL,
  IZNOS                    NUMBER(18,2)         NOT NULL
)
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


