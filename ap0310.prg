select 1
use APCON    index APCON
@ 04,0 clear to 12,40
@ 04,0 to 12,40
@ 04,08 SAY " CONCEPTOS NOMINALES"
@ 06,1 say "GRUPO       :"
@ 08,1 say "SUBGRUPO    :"
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
  *STORE 0 TO WTOTAL
   STORE 0 TO Xgrupo
   STORE 0 TO Xsubgrupo
   @ 06,14 GET XGRUPO PICTURE "#"
   READ
   IF READKEY()=12 .OR. READKEY()=268
      EXIT
   ENDIF
   IF XGRUPO = 0
      STORE "TODOS" TO WGRUPODES
   ELSE
      STORE "  "    TO WGRUPODES
   ENDIF
   @ 06,20 SAY WGRUPODES

   @ 08,14 GET XSUBGRUPO PICTURE "#"
   READ
   IF READKEY()=12 .OR. READKEY()=268
      LOOP
   ENDIF
   IF XSUBGRUPO = 0
      STORE "TODOS" TO WSUBDES
   ELSE
      STORE "  "    TO WSUBDES
   ENDIF
   @ 08,20 SAY WSUBDES

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
      IF XGRUPO <> 0 .AND. XGRUPO <> GRUPO
         SELECT 1
         SKIP
         LOOP
      ENDIF
      IF XSUBGRUPO <> 0 .AND. XSUBGRUPO <> SUBGRUPO
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
         @ 2,0 SAY "LISTADO DE CONCEPTOS NOMINALES"
         @ 2,60 SAY "FECHA :"+DTOC(DATE())
         @ 4,00 SAY "COD."
         @ 4,05 SAY "DESCRIPCION"
         @ 4,31 SAY "G"
         @ 4,33 SAY "S"
         @ 4,35 SAY "UND."
         @ 4,40 SAY "Fo"
         @ 4,43 SAY "    FACTOR"
         @ 4,54 SAY "Fr"
         @ 4,57 SAY "    MINIMO"
         @ 4,68 SAY "    MAXIMO"
         @ 4,79 SAY "S"
         @ 5,00 SAY "----"
         @ 5,05 SAY "-------------------------"
         @ 5,31 SAY "-"
         @ 5,33 SAY "-"
         @ 5,35 SAY "----"
         @ 5,40 SAY "--"
         @ 5,43 SAY "----------"
         @ 5,54 SAY "--"
         @ 5,57 SAY "----------"
         @ 5,68 SAY "----------"
         @ 5,79 SAY "-"
         STORE 6 TO WLINEA
      ENDIF
      @ WLINEA , 00 SAY CODIGO
      @ WLINEA , 05 SAY DESCRI
      @ WLINEA , 31 SAY GRUPO PICTURE "#"
      @ WLINEA , 33 SAY SUBGRUPO PICTURE "#"
      @ WLINEA , 35 SAY UNIDAD
      @ WLINEA , 40 SAY FORMA
      @ WLINEA , 43 SAY FACTOR picture "#######.##"
      @ WLINEA , 54 SAY FRECUENCIA picture "#"
      @ WLINEA , 57 SAY MINIMO PICTURE "#######.##"
      @ WLINEA , 68 SAY MAXIMO PICTURE "#######.##"
      @ WLINEA , 79 SAY SALDO PICTURE "#"
      SELECT 1
      SKIP
   ENDDO
   IF WSALIDA = "M"
      STORE "OPRIMA <ENTER> PARA FINALIZAR" TO MES
      DO AVISO WITH MES
   ELSE
    * EJECT
      SET DEVI TO SCRE
   ENDIF
ENDDO
close data
close index
return
