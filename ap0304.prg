select 1
use APUBICA index APUBICA
@ 04,0 clear to 14,40
@ 04,0 to 14,40
@ 04,06 SAY " UBICACION ADMINISTRATIVA"
@ 06,1 say "DIREC/PROGR.:"
@ 08,1 say "DEPTO/MUNIC.:"
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
  * STORE 0 TO WTOTAL
   STORE SPACE(2) TO XDIRE
   STORE SPACE(2) TO XDEPA
   STORE SPACE(3) TO XSECC

   @ 06,14 GET XDIRE
   READ
   IF READKEY()=12 .OR. READKEY()=268
      EXIT
   ENDIF
   IF XDIRE = SPACE(2)
      STORE "TODOS" TO WDIREDES
   ELSE
      STORE "  "    TO WDIREDES
   ENDIF
   @ 06,20 SAY WDIREDES

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

   @ 10,14 GET XSECC
   READ
   IF READKEY()=12 .OR. READKEY()=268
      LOOP
   ENDIF
   IF XSECC = SPACE(3)
      STORE "TODOS" TO WSECCDES
   ELSE
      STORE "  "    TO WSECCDES
   ENDIF
   @ 10,20 SAY WSECCDES

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

   SELECT 1
   GO TOP
   DO WHILE .NOT. EOF()
      *** FILTROS
      IF XDIRE  <> SPACE(2) .AND. XDIRE <> DIRE
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
         @ 1,60 SAY "PAGINA:"+STR(WPAGINA,4)
         @ 2,0 SAY "LISTADO DE UBICACION ADMINISTRATIVA"
         @ 2,60 SAY "FECHA :"+DTOC(DATE())
         @ 4,00 SAY "DIR/PRO"
         @ 4,08 SAY "DEP/MUN"
         @ 4,16 SAY "SEC/UND"
         @ 4,25 SAY "DESCRIPCION"
         @ 5,00 SAY "-------"
         @ 5,08 SAY "-------"
         @ 5,16 SAY "-------"
         @ 5,25 SAY "------------------------------"
         STORE 6 TO WLINEA
      ENDIF
      @ WLINEA , 00 SAY DIRE
      @ WLINEA , 08 SAY DEPA
      @ WLINEA , 16 SAY SECC
      @ WLINEA , 25 SAY DESCRI
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