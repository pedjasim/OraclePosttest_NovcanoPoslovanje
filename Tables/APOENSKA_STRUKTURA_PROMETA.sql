CREATE TABLE APOENSKA_STRUKTURA_PROMETA
(
  ID_PROMET  RAW(16)                            NOT NULL,
  ID_APOEN   NUMBER(5)                          NOT NULL,
  KOMADA     NUMBER(5)                          NOT NULL
)
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

