CREATE TABLE NALOG_ZA_RAZMENU_GOT
(
  ID_NALOG_ZA_RAZMENU_GOT  NUMBER(9)            NOT NULL,
  ID_CPM_NALOGODAVAC       NUMBER(5)            NOT NULL,
  ID_CPM_DOTACIJA          NUMBER(5)            NOT NULL,
  ID_CPM_SUVISAK           NUMBER(5),
  DATUM                    DATE                 NOT NULL,
  DATUM_RAZMENE            DATE                 NOT NULL,
  IZNOS                    NUMBER(18,2)         NOT NULL,
  ID_RADNIK                NUMBER(5)            NOT NULL,
  STATUS                   VARCHAR2(1 CHAR)     NOT NULL
)
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


