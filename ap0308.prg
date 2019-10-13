select 1
use APSINDIC index APSINDIC
@ 04,0 clear to 10,40
@ 04,0 to 10,40
@ 04,10 SAY " SINDICATOS "
@ 06,1 say "CODIGO      :"
@ 08,1 say "SALIDA (M/I):"
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
   STORE space(2) TO XCODIGO
   @ 06,14 GET XCODIGO
   READ
   IF READKEY()=12 .OR. READKEY()=268
      EXIT
   ENDIF
   IF XCODIGO= SPACE(2)
      STORE "TODOS" TO WCODIGODES
   ELSE
      STORE "  "    TO WCODIGODES
   ENDIF
   @ 06,20 SAY WCODIGODES

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
   @ 08,20 SAY WSALIDES

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
      IF XCODIGO <> SPACE(2) .AND. XCODIGO <> CODIGO
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
         @ 2,0 SAY "LISTADO DE SINDICATOS"
         @ 2,60 SAY "FECHA :"+DTOC(DATE())
         @ 4,0 SAY "CODIGO "
         @ 4,8 SAY "DESCRIPCION"
         @ 5,0 SAY "------"
         @ 5,8 SAY "------------------------------"
         STORE 6 TO WLINEA
      ENDIF
      @ WLINEA , 0 SAY CODIGO
      @ WLINEA , 8 SAY DESCRI
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