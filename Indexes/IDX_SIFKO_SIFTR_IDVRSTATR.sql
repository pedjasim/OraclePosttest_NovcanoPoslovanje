CREATE INDEX IDX_SIFKO_SIFTR_IDVRSTATR ON TRANSAKCIJA_ZA_KOMITENTA
(SIFRA_KOMITENTA, SIFRA_TRANSAKCIJE, ID_VRSTA_TRANSAKCIJE)
LOGGING
NOPARALLEL;


