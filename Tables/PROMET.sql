CREATE TABLE PROMET
(
  ID_PROMET             RAW(16)                 NOT NULL,
  ID_BLAGAJNA           RAW(16)                 NOT NULL,
  IZNOS_UPLATE          NUMBER(18,2)            NOT NULL,
  IZNOS_ISPLATE         NUMBER(18,2)            NOT NULL,
  ID_VRSTA_PROMETA      NUMBER(5)               NOT NULL,
  ID_SREDSTVO_PLACANJA  NUMBER(3),
  KOVANI_NOVAC          NUMBER(18,2),
  ID_CPM_DAN            RAW(16),
  REFERENCA             VARCHAR2(50 CHAR)
)
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

