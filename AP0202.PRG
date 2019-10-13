SELECT 1
USE APPERSON INDEX APPERSO1
SELECT 2
USE APCON INDEX APCON
SELECT 3
USE APCONPER INDEX APCONPER
SELECT 4
USE APPAGCON INDEX APPAGCO1, APPAGCO2
SELECT 5
USE APNOMINA INDEX APNOMINA
SELECT 6
USE APGRUPOS INDEX APGRUPOS
SELECT 7
USE APPAGGEN INDEX APPAGGE1, APPAGGE2, APPAGGE3
STORE .T. TO REPORTA
DO WHILE REPORTA
   @ 4,0 CLEAR
   @ 4,1  SAY   "CEDULA:                          NOMBRE:                                      "
   @ 5,1  say   "GRUPO :                          NOMINA:                                      "
   @ 6,1  SAY   "------------------------------------------------------------------------------"
   @ 07,1 SAY   "COD. DESCRIPCION               UND.  CANTD.  ASIGNACION  DEDUCCION       SALDO"
   @ 08,1 SAY   "---- ------------------------- ----  ------  ---------- ---------- -----------"
   @ 04,08 GET WCEDULA
   READ
   STORE UPPER(WCEDULA) TO WCEDULA
   IF WCEDULA = SPACE(12) .OR. READKEY()=12 .OR. READKEY()=268
      EXIT
   ENDIF
   SELECT 1
   FIND &WCEDULA
   IF EOF()
      STORE "CEDULA NO REGISTRADA, VERIFIQUE" TO MES
      DO AVISO WITH MES
      LOOP
   ENDIF
   STORE GRUPO+NOMINA TO WCLAVENOM
   STORE GRUPO TO WGRUPO
   STORE  RTRIM(NOMBRES)+" "+RTRIM(APELLIDOS) TO WNAME
   @ 04,41 SAY RTRIM(APELLIDOS)+", "+RTRIM(NOMBRES)
   IF WGRUPO <> SPACE(2)
      SELECT 6
      FIND &WGRUPO
      IF EOF()
         STORE "GRUPO DE NOMINA NO REGISTRADO, VERIFIQUE" TO MES
         DO AVISO WITH MES
         LOOP
      ELSE 
         STORE DESCRI          TO WGRUPODES
      ENDIF
   ELSE
      STORE "NO DEFINIDO"      TO WGRUPODES
   ENDIF
   IF WCLAVENOM <> SPACE(4)
      SELECT 5
      FIND &WCLAVENOM
      IF EOF()
         STORE "CODIGO DE NOMINA NO REGISTRADO EN GRUPO "+WGRUPO+", VERIFIQUE" TO MES
         DO AVISO WITH MES
         LOOP
      ELSE
         STORE DESCRI TO WNOMIDES
         STORE APER1  TO WFECHA1
         STORE APER2  TO WFECHA2
         STORE APER2  TO WFECHAPAGO
         STORE ESTADO TO WESTADO
      ENDIF
   ELSE
      STORE "CODIGO DE GRUPO o NOMINA NO DEFINIDO, VERIFIQUE" TO MES
      DO AVISO WITH MES
      LOOP
   ENDIF
   @ 5,8  SAY WGRUPODES
   @ 5,43 SAY WNOMIDES
   STORE WCEDULA TO WCLAVEGEN
   SELECT 7
   FIND &WCLAVEGEN
   IF EOF()
      STORE "ESTA PERSONA NO TIENE PAGO PARA ESTE PERIODO" TO MES
      DO AVISO WITH MES
      LOOP
   ENDIF
   STORE .T. TO WCARGANDO
   DO WHILE WCARGANDO
      STORE 100 TO WLINE
      STORE 0   TO WPAGE
      STORE WCEDULA+STR(YEAR(WFECHAPAGO))+STR(MONTH(WFECHAPAGO))+STR(DAY(WFECHAPAGO)) TO WCLAVEPAGO
      STORE 0 TO WTOTBON
      STORE 0 TO WTOTNBON
      STORE 0 TO WTOTASI
      STORE 0 TO WTOTDEC
      STORE 0 TO WTOTLIQ
      @ 9,0 clear
      SELECT 4
      FIND &WCLAVEPAGO
      DO WHILE .NOT. EOF() .AND. CEDULA = WCEDULA .AND. FECHA2 = WFECHAPAGO
         STORE WLINE+1 TO WLINE
         IF WLINE>18
            STORE WPAGE+1 TO WPAGE
            IF WPAGE > 1
               STORE "OPRIMA <ENTER> PARA CONTINUAR, <ESC> PARA SALIR" TO MES
               DO AVISO WITH MES
               IF READKEY()=12 .OR. READKEY()=268
                  EXIT
               ENDIF
            ENDIF
            @ 9,0 CLEAR
            STORE 9 TO WLINE
         ENDIF
         STORE CONCEPTO TO WCONCEPTO
         SELECT 2
         FIND &WCONCEPTO
         IF EOF()
            STORE "NO REGISTRADO EN CONCEPTOS" TO WCONCEDES
            STORE SPACE(4)                     TO WUNIDAD
         ELSE
            STORE DESCRI                       TO WCONCEDES
            STORE UNIDAD                       TO WUNIDAD
            STORE FORMA                        TO WFORMA
            STORE GRUPO                        TO QGRUPO
            STORE SUBGRUPO                     TO QSUBGRUPO
         ENDIF
         SELECT 4
         @ WLINE,1  SAY CONCEPTO
         @ WLINE,6  SAY WCONCEDES
         @ WLINE,32 SAY WUNIDAD
         @ WLINE,38 SAY CANTIDAD PICTURE "###.##"
         IF QGRUPO = 1
            @ WLINE,46 SAY MONTO   PICTURE "#######.##"
         ELSE
            @ WLINE,57 SAY MONTO   PICTURE "#######.##"
         ENDIF
         IF SALDO > 0
            @ WLINE,69 SAY SALDO   PICTURE "#######.##"
         ENDIF
         STORE MONTO TO XMONTO
         DO TOTALIZA
         SELECT 4
         SKIP
      ENDDO
      IF WTOTASI>0 .OR. WTOTDEC>0 
         STORE WLINE + 1 TO WLINE
         @ WLINE,6  SAY "T O T A L E S   :"
         @ WLINE,45 SAY WTOTASI   PICTURE "########.##"
         @ WLINE,56 SAY WTOTDEC   PICTURE "########.##"
         @ WLINE,68 SAY WTOTLIQ   PICTURE "########.##"
      ENDIF
      *** CALCULO PARA 33% MAX. DE DEDUCCIONES
      IF WTOTDEC > (APPERSON->SUELDOP*33)/100 
         STORE "TOTAL DEDUCCIONES:"+STR(WTOTDEC,10,2)+" SOBREPASA EL 33% DEL SUELDO: "+STR(((APPERSON->SUELDOP*33)/100),12,2) TO MES
         DO AVISO WITH MES
      ENDIF 
      *** FIN 33%
      **********************************************************************
      IF APNOMINA->ESTADO > 1
         STORE "ADVERTENCIA: LA CARGA DE VARIACIONES YA FINALIZO" TO MES
         DO AVISO WITH MES
      ENDIF
      STORE "INGRESE CODIGO DE CONCEPTO A PROCESAR, <ESC> PARA SALIR" TO MES
      DO MENSAJE WITH MES
      @ 21,1
      @ 21,1 GET WCONCEPTO
      READ
      IF WCONCEPTO=SPACE(4) .OR. READKEY()=12 .OR. READKEY()=268
         EXIT
      ENDIF
      SELECT 2
      FIND &WCONCEPTO
      IF EOF()
         STORE "CODIGO NO REGISTRADO EN MAESTRO DE CONCEPTOS, VERIFIQUE." TO MES
         DO AVISO WITH MES
         LOOP
      ENDIF
      STORE DESCRI   TO WDESCRI
      STORE UNIDAD   TO WUNIDAD
      STORE FORMA    TO WFORMA
      STORE 0        TO WCANTIDAD
      STORE 0        TO WMONTO
      STORE GRUPO    TO QGRUPO
      STORE SUBGRUPO TO QSUBGRUPO
      STORE FACTOR   TO WFACTOR
      SELECT 3
      STORE WCEDULA+WCONCEPTO TO WINDICE
      FIND &WINDICE
      IF .NOT. EOF()
         STORE CANTIDAD TO WCANTIDAD
         STORE FACTOR   TO WFACTOR
      ENDIF
      IF WFORMA = 1
         STORE WFACTOR TO WMONTO
      ELSE
         STORE 0       TO WMONTO
      ENDIF    
      SELECT 4
      STORE WCLAVEPAGO+WCONCEPTO TO WINDICE
      FIND &WINDICE
      IF EOF()
         @ 21,6  SAY WDESCRI
         STORE "CONCEPTO NO REGISTRADO EN EL PAGO PARA ESTA PERSONA, INGRESAR AL PAGO ? (S/N)" TO TEX
         STORE "SN" TO WCH
         DO PREGUNTA
         IF WCH = "N"
            LOOP
         ENDIF
         STORE .T.            TO WINGRESA
         STORE .T.            TO WMODIFICA
      ELSE
         STORE .F.            TO WINGRESA
         STORE .F.            TO WMODIFICA
         STORE CANTIDAD       TO WCANTIDAD
         STORE MONTO/CANTIDAD TO WMONTO
      ENDIF
      @ 21,6  SAY WDESCRI
      @ 21,38 SAY WUNIDAD
      @ 21,45 SAY WCANTIDAD PICTURE "###.##"
      @ 21,57 SAY WMONTO    PICTURE "#######.##"
      *** VALOR INICIAL DE WRESP 
      STORE "I" TO WRESP
      ***
      IF .NOT. WMODIFICA
         STORE "OPCIONES: (V)ARIAR, (M)ODIFICAR, (E)LIMINAR, (S)ALIR" TO TEX
         STORE "VMES" TO WCH
         DO PREGUNTA
         STORE WCH TO WRESP
         IF WRESP= "S"
            LOOP
         ELSE
            IF WRESP= "V"
               STORE .T. TO WMODIFICA
            ELSE
               IF WRESP= "M"
                  IF APPAGCON->VARIACION = "S"
                     STORE .T. TO WMODIFICA
                  ELSE
                     STORE "ERROR, CONCEPTO NO PUEDE SER MODIFICADO SIN ANTES SER VARIADO" TO MES
                     DO AVISO WITH MES
                     LOOP
                  ENDIF
               ELSE
                  STORE "ESTA SEGURO QUE DESEA ELIMINAR ? (S/N)" TO TEX
                  STORE "NS" TO WCH
                  DO PREGUNTA
                  IF WCH = "N"
                     LOOP
                  ELSE
                     SELECT 4
                     DO RECLOC
                     DELETE
                     UNLOCK
                     FLUSH
                     *** RUTINA DE RECALCULO DEL SOBRE
                     STORE 0 TO WTOTBON
                     STORE 0 TO WTOTNBON
                     STORE 0 TO WTOTASI
                     STORE 0 TO WTOTDEC
                     STORE 0 TO WTOTLIQ
                     STORE WCEDULA TO XCEDULA
                     DO SOBRECAL
                     LOOP
                  ENDIF
               ENDIF
            ENDIF
         ENDIF
      ENDIF
      IF WMODIFICA
         *** CANTIDAD
         IF WRESP = "V"
            STORE 0         TO WVARICANT
         ELSE
            STORE WCANTIDAD TO WVARICANT
         ENDIF
         STORE .T. TO WACT
         DO WHILE WACT
            STORE "INGRESE LA CANTIDAD DE UNIDADES CORRESPONDIENTES" TO MES
            DO MENSAJE WITH MES
            @ 21,45 GET WVARICANT PICTURE "###.##"
            READ
            IF READKEY()=12.OR.READKEY()=268
               STORE .F. TO WCARGANDO
               EXIT
            ENDIF
            IF WVARICANT > 0 
               IF WRESP = "V"
                  STORE WCANTIDAD+WVARICANT TO WCANTIDAD
               ELSE
                  STORE WVARICANT           TO WCANTIDAD
               ENDIF
               EXIT
            ENDIF
         ENDDO
         IF .NOT. WCARGANDO
            EXIT
         ENDIF
         *** MONTO
         IF WFORMA = 1 
            STORE .T. TO WACT
            DO WHILE WACT
               STORE "INGRESE EL MONTO UNITARIO (VALOR POR CADA UNIDAD)" TO MES
               DO MENSAJE WITH MES
               @ 21,57 GET WMONTO PICTURE "#######.##"
               READ
               IF READKEY()=12.OR.READKEY()=268
                  STORE .F. TO WCARGANDO
                  EXIT
               ENDIF
               IF WMONTO > 0
                  STORE WCANTIDAD*WMONTO TO WMONTO
                  EXIT
               ENDIF
            ENDDO
            IF .NOT. WCARGANDO
               EXIT
            ENDIF
         ENDIF
      ENDIF
      STORE "CONFORME ? (S/N)" TO TEX
      STORE "SN" TO WCH
      DO PREGUNTA
      IF WCH = "N"
         LOOP
      ENDIF
      IF WINGRESA
         DO FILLOC
         APPEND BLANK
         UNLOCK
         DO RECLOC
         REPLACE CEDULA   WITH WCEDULA
         REPLACE FECHA1   WITH WFECHA1
         REPLACE FECHA2   WITH WFECHA2
         REPLACE CONCEPTO WITH WCONCEPTO
      ENDIF
      DO RECLOC
      REPLACE CANTIDAD   WITH WCANTIDAD
      REPLACE MONTO      WITH WMONTO
      REPLACE VARIACION WITH "S"
      FLUSH
      UNLOCK
      SELECT 5
      DO RECLOC
      REPLACE ESTADO WITH 1
      UNLOCK
      *** RUTINA DE RECALCULO DEL SOBRE
      STORE 0 TO WTOTBON
      STORE 0 TO WTOTNBON
      STORE 0 TO WTOTASI
      STORE 0 TO WTOTDEC
      STORE 0 TO WTOTLIQ
      STORE WCEDULA TO XCEDULA
      DO SOBRECAL
   ENDDO
ENDDO
CLOSE DATA
CLOSE INDEX
RETURN

