ALTER TABLE SUVISAK ADD (
  CONSTRAINT SUVISAK_NALOG_ZA_RAZMENU_FK 
 FOREIGN KEY (ID_NALOG_ZA_RAZMENU_GOT) 
 REFERENCES NALOG_ZA_RAZMENU_GOT (ID_NALOG_ZA_RAZMENU_GOT));
