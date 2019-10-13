select 1
use APPERSON index APPERSO2,APPERSO4
SELECT 2
USE APGRUPOS INDEX APGRUPOS
SELECT 3
USE APNOMINA INDEX APNOMINA
SELECT 4
USE APCARGOS INDEX APCARGOS
@ 04,0 clear to 16,40
@ 04,0 to 16,40
@ 04,07 SAY " PERSONAL POR NOMINAS"
@ 06,1 say "GRUPO       :"
@ 08,1 say "NOMINA      :"
@ 10,1 SAY "ORDEN       :"
@ 12,1 SAY "ESTATUS     :"
@ 14,1 say "SALIDA (M/I):"
SAVE SCRE TO SCREPRI
STORE .F. TO WFLAGSCRE
store .t. to viendo
do while viendo
   IF WFLAGSCRE
      @ 0,0 CLEAR
      RESTORE SCRE FROM SCREPRI
   ELSE
      STORE .T. TO WFLAGSCRE
   ENDIF
   STORE SPACE(2) TO XGRUPO
   STORE SPACE(2) TO XNOMINA
   STORE SPACE(1) TO XESTATUS
   @ 06,14 GET XGRUPO
   READ
   IF READKEY()=12 .OR. READKEY()=268
      EXIT
   ENDIF
   IF XGRUPO = SPACE(2)
      STORE "TODOS" TO WGRUPODES
   ELSE
      STORE "  "    TO WGRUPODES
   ENDIF
   @ 06,20 SAY WGRUPODES

   IF XGRUPO <> SPACE(2)
      @ 08,14 GET XNOMINA
      READ
      IF READKEY()=12 .OR. READKEY()=268
         LOOP
      ENDIF
      IF XNOMINA = SPACE(2)
         STORE "TODAS" TO WNOMIDES
      ELSE
         STORE "  "    TO WNOMIDES
      ENDIF
      @ 08,20 SAY WNOMIDES
   ENDIF

   STORE "SELECCIONE ORDEN DE SALIDA: 1=ALFANUMERICO, 2=ALFABETICO" TO TEX
   STORE "12" TO WCH
   DO PREGUNTA
   IF WCH = "1"
      SELECT 1
      SET ORDER TO 1
      STORE "ALFANUMERICO" TO WORDENDES
   ELSE
      SELECT 1
      SET ORDER TO 2
      STORE "ALFABETICO" TO WORDENDES
   ENDIF   
   @ 10,20 SAY WORDENDES   

   STORE "SELECCIONE EL ESTATUS (A)CTIVOS, (I)NACTIVOS, (V)ACACION" TO TEX
      @ 23,05 SAY TEX
      @ 12,14 GET XESTATUS PICT '@!'
      READ
      IF READKEY()=12 .OR. READKEY()=268
         LOOP
      ENDIF
      IF XESTATUS = SPACE(1)
         STORE "TODAS" TO WESTATUS
      ELSE
         STORE " "    TO WESTATUS
      ENDIF
      @ 12,20 SAY WESTATUS

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
   @ 14,20 SAY WSALIDES

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
   STORE 0    TO WCONTADOR
   STORE "**" TO WRUPGRU
   STORE "**" TO WRUPNOM
   STORE .F.  TO WFLAGNOM
   SELECT 1
   GO TOP
   DO WHILE .NOT. EOF()
      *** FILTROS
      IF XGRUPO <> SPACE(2) .AND. XGRUPO <> GRUPO
         SELECT 1
         SKIP
         LOOP
      ENDIF
      IF XNOMINA <> SPACE(2) .AND. XNOMINA <> NOMINA
         SELECT 1
         SKIP
         LOOP
      ENDIF
      IF XESTATUS<> SPACE(1) .AND. XESTATUS <> ESTATUS
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
         @ 02,000 SAY "LISTADO DEL PERSONAL POR NOMINA"
         @ 02,060 SAY "FECHA :"+DTOC(DATE())
         @ 04,000 SAY "No.   CEDULA"
         @ 04,020 SAY "APELLIDOS Y NOMBRES"
         @ 04,060 SAY "UBIC.ADM."
         @ 04,070 SAY "   SUELDO"
         IF WSALIDA = "I"
            @ 04,85 SAY "CARGO"
         ENDIF
         @ 05,000 SAY "----- ------------"
         @ 05,020 SAY "----------------------------------------"
         @ 05,060 SAY "---------"
         @ 05,070 SAY "----------"
         IF WSALIDA = "I"
            @ 05,85 SAY "-------------------------"
         ENDIF
         STORE 6 TO WLINEA
      ENDIF
      SELECT 1
      IF GRUPO <> WRUPGRU
         STORE GRUPO TO WRUPGRU
         STORE .T.   TO WFLAGNOM
         IF WRUPGRU <> SPACE(2)
            SELECT 2
            FIND &WRUPGRU
            IF EOF()
               STORE "NO REGISTRADO" TO WGRUDES
            ELSE
               STORE DESCRI TO WGRUDES
            ENDIF
         ELSE
            STORE "NO DEFINIDO" TO WGRUDES
         ENDIF
         @ WLINEA,00 SAY "GRUPO :"+WRUPGRU+"-"+WGRUDES
      ENDIF
      SELECT 1
      IF WFLAGNOM .OR. NOMINA <> WRUPNOM
         STORE NOMINA TO WRUPNOM
         STORE .F.    TO WFLAGNOM
         STORE WRUPGRU+WRUPNOM TO WCLAVENOM
         IF WCLAVENOM <> SPACE(4)
            SELECT 3
            FIND &WCLAVENOM
            IF EOF()
               STORE "NO REGISTRADA EN EL GRUPO" TO WNOMDES
            ELSE
               STORE DESCRI TO WNOMDES
            ENDIF
         ELSE
            STORE "NO DEFINIDA" TO WNOMDES
         ENDIF
         @ WLINEA,40 SAY "NOMINA:"+WRUPNOM+"-"+WNOMDES
         STORE WLINEA+1 TO WLINEA
      ENDIF
      SELECT 1
      STORE WCONTADOR + 1 TO WCONTADOR
      @ WLINEA , 0   SAY WCONTADOR PICTURE "#####"
      @ WLINEA , 7   SAY CEDULA
      @ WLINEA , 20  SAY RTRIM(APELLIDOS)+", "+rtrim(NOMBRES)
      @ WLINEA , 60  SAY DIRE+"-"+DEPA+"-"+SECC
      IF APPERSON->TIPO = "E"
         STORE APPERSON->SUELDOP TO WSUELDO
      ELSE
         IF APPERSON->TIPO = "O"
            STORE APPERSON->SUELDOD TO WSUELDO
         ELSE
            STORE 0 TO WSUELDO
         ENDIF
      ENDIF
      @ WLINEA , 70 SAY WSUELDO PICTURE "#######.##"
      IF WSALIDA = "I"
         STORE CARGO TO WCARGO
         IF WCARGO <> SPACE(6)
            SELECT 4
            FIND &WCARGO
            IF EOF()
               STORE "NO REGISTRADO" TO WCARGODES
            ELSE
               STORE DESCRI          TO WCARGODES
            ENDIF
         ELSE
            STORE "NO DEFINIDO"      TO WCARGODES
         ENDIF
         @ WLINEA, 85 SAY WCARGODES
      ENDIF    
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