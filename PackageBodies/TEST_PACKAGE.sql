CREATE OR REPLACE PACKAGE BODY                    TEST_PACKAGE
AS

   PROCEDURE INSERT_TEST_OA (P_OPIS    IN VARCHAR2,
                                                 P_OPIS_I   IN VARCHAR2) IS
   BEGIN
   
      INSERT INTO TEST
      VALUES (P_OPIS, P_OPIS_I);   
 
   END INSERT_TEST_OA;

   PROCEDURE INSERT_TEST_STANDARDNO (P_OPIS     IN TEST.OPIS%TYPE,
                                                                  P_OPIS_I   IN TEST.OPIS_I%TYPE,
                                                                  P_REZULTAT OUT NUMBER,
                                                                  P_PORUKA OUT VARCHAR2)
   IS
   BEGIN
      INSERT INTO TEST (OPIS, OPIS_I)
           VALUES (P_OPIS, P_OPIS_I);

      P_REZULTAT :=  0;
       P_PORUKA   := 'OK';
   EXCEPTION
      WHEN OTHERS
      THEN
         P_REZULTAT := 1;
          P_PORUKA   := SQLERRM;
   END INSERT_TEST_STANDARDNO;

   PROCEDURE INSERT_TEST (P_PODACI   IN  CLOB,
                                               P_REZULTAT OUT NUMBER,
                                               P_PORUKA OUT VARCHAR2)
   IS
     xml XMLTYPE;
   BEGIN    
   
    xml := XMLTYPE.createXML(P_PODACI);    
    
    --raise_application_error( -20001,  'konvertovao');
           
    FOR red IN 
    (SELECT 
                 detalji.EXTRACT('//TABLE/OPIS/text()').getstringval() as opis,
                 detalji.EXTRACT('//TABLE/OPIS_I/text()').getstringval() as opis_i
     FROM 
                 TABLE (XMLSEQUENCE(xml.EXTRACT('//DS/TABLE'))) detalji
     )
     LOOP
        INSERT INTO TEST (OPIS, OPIS_I) 
        VALUES (red.opis, red.opis_i);        
     END LOOP;

       P_REZULTAT :=  0;
       P_PORUKA   := 'OK';      
  
   EXCEPTION
      WHEN OTHERS
      THEN
          P_REZULTAT := 1;
          P_PORUKA   := SQLERRM;
   END INSERT_TEST;
   
END TEST_PACKAGE;
/

SHOW ERRORS;


