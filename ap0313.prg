select 1
use APPERSON index APPERSO2
SELECT 2
USE APUBICA  INDEX APUBICA
@ 04,0 clear to 14,40
@ 04,0 to 14,40
@ 04,01 SAY " PERSONAL POR UBICACION ADMINISTRATIVA"
@ 06,1 say "DIREC./PROG.:"
@ 08,1 say "DEPTO./MUNI.:"
@ 10,1 say "SECC./UNIDAD:"
@ 12,1 say "SALIDA (M/I):"
SAVE SCRE TO WSCRE99
store .f. to wflagscre

store .t. to viendo
do while viendo
   if wflagscre
      @ 0,0 clear
      RESTORE SCRE FROM WSCRE99
   else
      store .t. to wflagscre
   endif
   STORE SPACE(2) TO XDIRE
   STORE SPACE(2) TO XDEPA
   STORE SPACE(3) TO XSECC
   @ 06,14 GET XDIRE
   READ
   IF READKEY()=12 .OR. READKEY()=268
      EXIT
   ENDIF
   IF XDIRE  = SPACE(2)
      STORE "TODAS" TO WDIREDES
   ELSE
      STORE "  "    TO WDIREDES
   ENDIF
   @ 06,20 SAY WDIREDES
   IF XDIRE <> SPACE(2)
      @ 08,14 GET XDEPA
      READ
      IF READKEY()=12 .OR. READKEY()=268
         LOOP
      ENDIF
      IF XDEPA = SPACE(2)
         STORE "TODOS" TO WDEPADES
      ELSE
         STORE "  "    TO WDEPADES
      ENDIF
      @ 08,20 SAY WDEPADES
      IF XDEPA <> SPACE(2)
         @ 10,14 GET XSECC
         READ
         IF READKEY()=12 .OR. READKEY()=268
            LOOP
         ENDIF
         IF XSECC = SPACE(3)
            STORE "TODAS" TO WSECCDES
         ELSE
            STORE "  "    TO WSECCDES
         ENDIF
      ELSE
         STORE "  "       TO WSECCDES
      ENDIF
      @ 10,20 SAY WSECCDES
   ENDIF

   STORE "SELECCIONE LA SALIDA: (M)ONITOR, (I)MPRESORA" TO TEX
   STORE "MI" TO WCH
   DO PREGUNTA
   IF READKEY()=12 .OR. READKEY()=268
      LOOP
   ENDIF
   STORE WCH TO WSALIDA
   STORE 0   TO WPAGINA
   STORE 100 TO WLINEA
   IF WSALIDA = "I"
      STORE 55 TO WSALTO
      STORE "IMPRESORA" TO WSALIDES
   ELSE
      STORE 22 TO WSALTO
      STORE "MONITOR" TO WSALIDES
   ENDIF
   @ 12,20 SAY WSALIDES

   STORE "OPCIONES: (C)ONTINUAR, (S)ALIR" TO TEX
   STORE "CS" TO WCH
   DO PREGUNTA
   IF WCH = "S"
      exit
   ENDIF
   IF WSALIDA = "I"
      SET DEVI TO PRINT
   ELSE
      SET DEVI TO SCRE
   ENDIF

   STORE "**"  TO WRUPDIRE
   STORE "**"  TO WRUPDEPA
   STORE "***" TO WRUPSECC
   STORE .F.   TO WFLAGDEPA
   STORE .F.   TO WFLAGSECC
   STORE 0     TO WCOUNTER
   SELECT 1
   GO TOP
   DO WHILE .NOT. EOF()
      *** FILTROS
      IF XDIRE  <> SPACE(2) .AND. XDIRE  <> DIRE
         SELECT 1
         SKIP
         LOOP
      ENDIF
      IF XDEPA  <> SPACE(2) .AND. XDEPA <> DEPA
         SELECT 1
         SKIP
         LOOP
      ENDIF
      IF XSECC  <> SPACE(3) .AND. XSECC <> SECC
         SELECT 1
         SKIP
         LOOP
      ENDIF
      *** FIN FILTROS
      STORE WLINEA+1 TO WLINEA
      IF WLINEA >=WSALTO
         STORE WPAGINA + 1 TO WPAGINA
         IF WSALIDA = "M"
            if WPAGINA <> 1
               STORE "OPRIMA <ENTER> PARA CONTINUAR o <ESC> PARA SALIR" TO MES
               DO AVISO WITH MES
               IF READKEY()=12 .OR. READKEY()=268
                  EXIT
               ENDIF
            endif
            @ 0,0 clear
         ENDIF
         IF WSALIDA = "M"
            @ 0,0 SAY QQWW
         ELSE
            @ 0,0 SAY CHR(14)+QQWW
         ENDIF
         @ 01,060 SAY "PAGINA:"+STR(WPAGINA,4)
         @ 02,000 SAY "LISTADO DEL PERSONAL POR UBICACION ADMINISTRATIVA"
         @ 02,060 SAY "FECHA :"+DTOC(DATE())
         @ 04,000 SAY "No.   CEDULA"
         @ 04,020 SAY "APELLIDOS Y NOMBRES"
         @ 04,060 SAY "GP-NM"
         @ 04,069 SAY "    SUELDO"
         @ 05,000 SAY "----- ------------"
         @ 05,020 SAY "----------------------------------------"
         @ 05,060 SAY "-----"
         @ 05,069 SAY "----------"
         STORE 6 TO WLINEA
      ENDIF
      SELECT 1
      IF DIRE <> WRUPDIRE
         STORE DIRE  TO WRUPDIRE
         STORE .T.   TO WFLAGDEPA
         STORE WRUPDIRE+"00000" TO WCLAVERUP
         IF WRUPDIRE <> SPACE(2)
            SELECT 2
            FIND &WCLAVERUP
            IF EOF()
               STORE "NO REGISTRADA" TO WDIREDES
            ELSE
               STORE DESCRI TO WDIREDES
            ENDIF
         ELSE
            STORE "NO DEFINIDO EN FICHA" TO WDIREDES
         ENDIF
         @ WLINEA,00 SAY "DIR/PRG:"+SUBSTR(WDIREDES,1,20)
      ENDIF
      SELECT 1
      IF WFLAGDEPA .OR. DEPA <> WRUPDEPA
         STORE DEPA   TO WRUPDEPA
         STORE .T.    TO WFLAGSECC
         STORE .F.    TO WFLAGDEPA
         STORE WRUPDIRE+WRUPDEPA+"000" TO WCLAVERUP
         IF WRUPDIRE <> SPACE(2)
            SELECT 2
            FIND &WCLAVERUP
            IF EOF()
               STORE "NO REG. EN DIR/PRG" TO WDEPADES
            ELSE
               STORE DESCRI TO WDEPADES
            ENDIF
         ELSE
            STORE "NO DEFINO EN FICHA" TO WDEPADES
         ENDIF
         @ WLINEA,25 SAY "DEP/MUN:"+SUBSTR(WDEPADES,1,20)
      ENDIF
      SELECT 1
      IF WFLAGSECC .OR. SECC <> WRUPSECC
         STORE SECC   TO WRUPSECC
         STORE .F.    TO WFLAGSECC
         STORE WRUPDIRE+WRUPDEPA+WRUPSECC TO WCLAVERUP
         IF WRUPDIRE <> SPACE(2)
            SELECT 2
            FIND &WCLAVERUP
            IF EOF()
               STORE "NO REG. EN DEP/MUN" TO WSECCDES
            ELSE
               STORE DESCRI TO WSECCDES
            ENDIF
         ELSE
            STORE "NO DEFINIDO EN FICHA" TO WSECCDES
         ENDIF
         @ WLINEA,50 SAY "SEC/UND:"+SUBSTR(WSECCDES,1,20)
         STORE WLINEA+1 TO WLINEA
      ENDIF
      STORE WCOUNTER + 1 TO WCOUNTER
      SELECT 1
      @ WLINEA , 00  SAY WCOUNTER PICTURE "#####"
      @ WLINEA , 07  SAY CEDULA
      @ WLINEA , 20  SAY RTRIM(APELLIDOS)+", "+NOMBRES
      @ WLINEA , 60  SAY GRUPO+"-"+NOMINA
      @ WLINEA , 69  SAY SUELDOP PICTURE "#######.##"
      SELECT 1
      SKIP
   ENDDO
   IF WSALIDA = "M"
      STORE "OPRIMA <ENTER> PARA FINALIZAR" TO MES
      DO AVISO WITH MES
   ELSE
      EJECT
      SET DEVI TO SCRE
   ENDIF
ENDDO
close data
close index
return

