CREATE TABLE TREBOVANJE
(
  ID_TREBOVANJE     NUMBER(9),
  ID_CPM            NUMBER(5)                   NOT NULL,
  ZA_DATUM          DATE                        NOT NULL,
  IZNOS             NUMBER(18,2)                NOT NULL,
  DATUM_TREBOVANJA  DATE                        NOT NULL,
  KOVANI_NOVAC      NUMBER(18,2),
  STATUS            VARCHAR2(1 CHAR)            DEFAULT 'E'                   NOT NULL
)
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


