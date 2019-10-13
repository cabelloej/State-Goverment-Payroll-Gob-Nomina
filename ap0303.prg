SELECT 1
USE APNOMINA INDEX APNOMINA
@ 04,0 clear to 11,40
@ 04,0 to 11,40
@ 04,15 SAY " NOMINAS "
@ 06,1 say "GRUPO       :"
@ 08,1 say "NOMINA      :"
@ 10,1 say "SALIDA (M/I):"
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
   STORE Wgrupo  TO Xgrupo
   STORE WNOMINA TO XNOMINA
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
   @ 10,20 SAY WSALIDES

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
      IF XGRUPO <> SPACE(2) .AND. XGRUPO <> GRUPO
         SELECT 1
         SKIP
         LOOP
      ENDIF
      IF XNOMINA<> SPACE(2) .AND. XNOMINA<> NOMINA
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
         @ 2,0 SAY "LISTADO DE NOMINAS"
         @ 2,60 SAY "FECHA :"+DTOC(DATE())
         @ 4,00  SAY "GP"
         @ 4,03  SAY "NOMINA"
         @ 4,10  SAY "DESCRIPCION              "
         @ 4,36  SAY "LAPSO"
         @ 4,42  SAY "ESTADO          "
         @ 4,59  SAY "PERIODO DE PROCESO"
         @ 5,00  SAY "--"
         @ 5,03  SAY "------"
         @ 5,10  SAY "-------------------------"
         @ 5,36  SAY "-----"
         @ 5,42  SAY "----------------"
         @ 5,59  SAY "------------------"
         STORE 6 TO WLINEA
      ENDIF
      @ WLINEA , 0 SAY GRUPO
      @ WLINEA , 3 SAY NOMINA
      @ WLINEA ,10 SAY DESCRI
      @ WLINEA ,36 SAY STR(LAPSO,3)
      STORE ESTADO TO WESTADO
      STORE SPACE(16) TO WESTADODES
      DO ESTADO
      @ WLINEA ,42 SAY WESTADODES
      @ WLINEA ,59 SAY DTOC(APER1)+" AL "+DTOC(APER2)
      SELECT 1
      SKIP
      loop
   enddo
   IF WSALIDA = "M"
      STORE "OPRIMA <ENTER> PARA FINALIZAR" TO MES
      DO AVISO WITH MES
   ELSE
      EJECT
      SET DEVI TO SCRE
   ENDIF
enddo
close data
close index
return
