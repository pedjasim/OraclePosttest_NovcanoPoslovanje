CREATE INDEX TRANSAKCIJA_KOMITENT_IDX ON TRANSAKCIJA_KOMITENT
(SIFRA_KOMITENTA, SIFRA_TRANSAKCIJE, ID_VRSTA_TRANSAKCIJE)
LOGGING
NOPARALLEL;

