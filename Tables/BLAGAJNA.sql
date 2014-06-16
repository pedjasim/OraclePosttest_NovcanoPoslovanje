CREATE TABLE BLAGAJNA
(
  ID_BLAGAJNA        RAW(16)                    NOT NULL,
  ID_VRSTA_BLAGAJNE  NUMBER(3)                  NOT NULL,
  POCETNO_STANJE     NUMBER(18,2)               NOT NULL,
  ULAZ               NUMBER(18,2)               NOT NULL,
  IZLAZ              NUMBER(18,2)               NOT NULL,
  KOVANI_NOVAC       NUMBER(18,2),
  ID_RADNIK          NUMBER(22,8),
  ID_CPM_DAN         RAW(16),
  STATUS             VARCHAR2(1 CHAR)
)
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


