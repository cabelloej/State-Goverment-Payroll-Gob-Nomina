@ 04,00 clear to 16,79
@ 05,00 to 16,79
@ 04,00 SAY "  AHORRO HABITACIONAL   "
@ 06,02 SAY "GRUPO                  :"
@ 08,02 SAY "NOMINA                 :"
@ 10,02 SAY "FECHA DE CIERRE INICIAL:"
@ 12,02 SAY "FECHA DE CIERRE FINAL  :"
@ 14,02 SAY "SOLO APORTE PATRONAL ? :"
SAVE SCRE TO SCREPRI
STORE .F. TO WFLAGSCRE
STORE .T. TO WCARGANDO
DO WHILE WCARGANDO
   IF WFLAGSCRE
      @ 0,0 CLEAR
      RESTORE SCRE FROM SCREPRI
   ELSE
      STORE .T. TO WFLAGSCRE
   ENDIF
   SELECT 1
   USE APGRUPOS INDEX APGRUPOS
   STORE .T. TO WCARGANDO
   SELECT 2
   USE APNOMINA INDEX APNOMINA
   @ 06,26 GET WGRUPO
   READ
   IF WGRUPO = SPACE(2) .OR.READKEY()=12.OR.READKEY()=268
      CLOSE DATA
      CLOSE INDEX
      EXIT
   ENDIF
   SELECT 1
   FIND &WGRUPO
   IF EOF()
      STORE "GRUPO NO REGISTRADO, VERIFIQUE, OPRIMA <ENTER>" TO MES
      DO AVISO WITH MES
      LOOP
   ENDIF
   STORE DESCRI TO WGRUPODES
   @ 06,30 SAY WGRUPODES
   @ 08,26 GET WNOMINA
   READ
   IF READKEY()=12.OR.READKEY()=268
      LOOP
   ENDIF
   IF WNOMINA = SPACE(2)
       LOOP
   ELSE
      STORE .F. TO WFLAGNO
      SELECT 2
      STORE WGRUPO+WNOMINA TO WCLAVEX
      FIND &WCLAVEX
      IF EOF()
         STORE "NOMINA NO REGISTRADA. VERIFIQUE" TO MES
         DO AVISO WITH MES
         LOOP
      ELSE
         @ 08,30 SAY DESCRI
      ENDIF
      STORE APER2 TO WXAP1
      STORE APER2 TO WXAP2
      @ 10,26 SAY WXAP1
      @ 12,26 SAY WXAP2
      *READ
      IF WXAP1>WXAP2
         STORE "ERROR EN FECHAS, VERIFIQUE" TO MES
         DO AVISO WITH MES
         LOOP
      ENDIF
      STORE "SOLO APORTE PATRONAL ? (S/N)" TO TEX
      STORE "NS" TO WCH
      DO PREGUNTA
      STORE WCH TO WSOLO
      @ 14,26 SAY WSOLO
   ENDIF
   STORE "OPCIONES: (C)ONTINUAR, (R)ECHAZAR" TO TEX
   STORE "CR" TO WCH
   DO PREGUNTA
   IF WCH = "R"
      LOOP
   ENDIF
   *** DATOS A TRANSFERIR A APNOMVER
   ***
   STORE "APPAGGEN.DBF" TO QGENFIL
   STORE "APPAGGE2.IDX" TO QGENIDX
   STORE "APPAGCON.DBF" TO QCONFIL
   STORE "APPAGCO1.IDX" TO QCONIDX
   STORE WGRUPO         TO QGRUPO
   STORE WNOMINA        TO QNOMINA
   STORE WXAP1          TO QDESDE
   STORE WXAP2          TO QHASTA
   CLOSE DATA
   CLOSE INDEX
   sw=0
   DO APHABITA
   SET DEVI TO SCRE
ENDDO

