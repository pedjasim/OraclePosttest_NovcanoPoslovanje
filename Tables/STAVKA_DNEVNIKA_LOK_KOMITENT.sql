CREATE TABLE STAVKA_DNEVNIKA_LOK_KOMITENT
(
  ID_CPM_DAN  RAW(16)                           NOT NULL,
  VREDNOST    VARCHAR2(500 CHAR)                NOT NULL,
  REDNI_BROJ  NUMBER(5)                         NOT NULL,
  EKSTENZIJA  VARCHAR2(20 CHAR)                 NOT NULL,
  IZNOS       NUMBER(18,2)
)
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


