CREATE OR REPLACE PACKAGE BODY                    F9_PACKAGE is

  PROCEDURE UGOVOR_F9(P_DELOVODNI_BROJ UGOVOR.DELOVODNI_BROJ%TYPE,
                      P_DATUM          IN VARCHAR2,
                      P_CURSOR         OUT T_CURSOR) IS
  BEGIN
    open P_CURSOR for
      select u.id_ugovor,
             trim(u.delovodni_broj) || ' (' || pp.naziv_f9 || ')' delovodni_broj
        from poslovno_okruzenje.ugovor                    u,
             poslovno_okruzenje.ugovor_poslovnog_partnera upp,
             poslovno_okruzenje.poslovni_partner          pp
       where u.delovodni_broj like P_DELOVODNI_BROJ || '%'
         and to_date(P_DATUM, 'dd.mm.yyyy') between trunc(u.datum_primene) and
             nvl(trunc(u.datum_prestanka_vazenja),
                 to_date('31.12.2222', 'dd.mm.yyyy'))
         and upp.id_ugovor = u.id_ugovor
         and upp.id_poslovni_partner = pp.id_poslovni_partner
       order by trim(u.delovodni_broj);
  
  END UGOVOR_F9;

  PROCEDURE KOMITENT_F9(P_ID_UGOVOR IN UGOVOR_POSLOVNOG_PARTNERA.ID_UGOVOR%TYPE,
                        P_NAZIV_F9  IN POSLOVNI_PARTNER.NAZIV_F9%TYPE,
                        P_CURSOR    OUT T_CURSOR) IS
  BEGIN
  
    OPEN P_CURSOR FOR
      select pp.id_poslovni_partner,
             pp.naziv_f9 sifra_naziv_komitenta
        from poslovno_okruzenje.ugovor_poslovnog_partnera upp,
             poslovno_okruzenje.poslovni_partner          pp
       where upp.id_ugovor = P_ID_UGOVOR
         and pp.naziv_f9 like '%' || P_NAZIV_F9 || '%'
         and pp.status = 'A'
         and pp.id_poslovni_partner = upp.id_poslovni_partner;
  
  END KOMITENT_F9;

  PROCEDURE UGOVORENA_USLUGA_F9(P_ID_UGOVOR IN UGOVORENA_USLUGA.ID_UGOVOR%TYPE,
                                P_NAZIV     IN USLUGE.NAZIV%TYPE,
                                P_CURSOR    OUT T_CURSOR) IS
  BEGIN
  
    OPEN P_CURSOR FOR
      select uu.id_ugovorena_usluga, u.naziv
        from poslovno_okruzenje.ugovorena_usluga uu,
             poslovno_okruzenje.usluge           u
       where uu.id_ugovor = P_ID_UGOVOR
         and u.id_usluge = uu.id_usluga
         and u.naziv like '%' || P_NAZIV || '%'
       order by u.naziv;
  
  END UGOVORENA_USLUGA_F9;

  PROCEDURE KOMITENT_PRETRAGA_F9(P_NAZIV_F9 IN POSLOVNI_PARTNER.NAZIV_F9%TYPE,
                                 P_CURSOR   OUT T_CURSOR) IS
  BEGIN
  
    OPEN P_CURSOR FOR
      select pp.id_poslovni_partner,
             pp.naziv_f9 sifra_naziv_komitenta
        from poslovno_okruzenje.poslovni_partner pp
       where pp.naziv_f9 like P_NAZIV_F9
         and pp.status = 'A';
  
  END KOMITENT_PRETRAGA_F9;

  PROCEDURE PRIJAVA_PRETRAGA_F9(P_CURSOR OUT T_CURSOR) IS
  BEGIN
  
    OPEN P_CURSOR FOR
      select p.ID_PRIJAVA,p.NAZIV_PRIJAVE,p.VRSTA_PRIJAVE
        from novcano_poslovanje.prijava p
       where p.VRSTA_PRIJAVE like 'K';
  END PRIJAVA_PRETRAGA_F9;
  
  PROCEDURE KOMITENT_NAZIV_F9(           
            P_ID_CPM_DAN IN TRANSAKCIJA_KOMITENT.ID_CPM_DAN%TYPE,
            P_CURSOR   OUT T_CURSOR) IS
  BEGIN
  
    OPEN P_CURSOR FOR
      select distinct pp.naziv_f9 sifra_naziv_komitenta
        from poslovno_okruzenje.poslovni_partner pp,TRANSAKCIJA_KOMITENT tk
       where tk.SIFRA_KOMITENTA = pp.ID_POSLOVNI_PARTNER
       AND TK.ID_CPM_DAN=P_ID_CPM_DAN;
  
  END KOMITENT_NAZIV_F9;

END F9_PACKAGE;
/

SHOW ERRORS;


