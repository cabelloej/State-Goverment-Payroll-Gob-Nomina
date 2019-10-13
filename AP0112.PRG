SELECT 1
USE APCONPER INDEX APCONPER
SELECT 2
USE APCON INDEX APCON
SELECT 3
USE APPERSON INDEX APPERSO1,APPERSO2,APPERSO3,APPERSO4
SELECT 4
USE APPAGCON INDEX APPAGCO1
SELECT 5
USE APGRUPOS INDEX APGRUPOS
SELECT 6
USE APNOMINA INDEX APNOMINA
STORE .T. TO REPORTA
DO WHILE REPORTA
   @ 4,0 CLEAR
   @ 4,1  SAY   "CEDULA:                            NOMBRE: "
   @ 5,1  SAY   "GRUPO :                            NOMINA: "
   @ 04,08 GET WCEDULA
   READ
   STORE UPPER(WCEDULA) TO WCEDULA
   IF WCEDULA = SPACE(12) .OR. READKEY()=12 .OR. READKEY()=268
      EXIT
   ENDIF
   SELECT 3
   FIND &WCEDULA
   IF EOF()
      STORE "CEDULA NO REGISTRADA, VERIFIQUE" TO MES
      DO AVISO WITH MES
      LOOP
   ENDIF
   STORE  RTRIM(APELLIDOS)+", "+RTRIM(NOMBRES) TO WNAME
   STORE GRUPO  TO WZGRUPO
   STORE NOMINA TO WZNOMINA
   IF WZGRUPO <> SPACE(2)
      SELECT 5
      FIND &WZGRUPO
      IF EOF()
         STORE "NO REGISTRADA" TO WGRUPODES
      ELSE
         STORE DESCRI          TO WGRUPODES
      ENDIF
   ELSE
      STORE "NO DEFINIDO"      TO WGRUPODES
   ENDIF
   STORE WZGRUPO+WZNOMINA TO WZCLAVE
   IF WZNOMINA <> SPACE(2)
      SELECT 6
      FIND &WZCLAVE
      IF EOF()
         STORE "NO REGISTRADA" TO WNOMIDES
      ELSE
         STORE DESCRI          TO WNOMIDES
      ENDIF
   ELSE
      STORE "NO DEFINIDA"      TO WNOMIDES
   ENDIF
   STORE .T. TO WCARGANDO
   DO WHILE WCARGANDO
      @ 04,00 CLEAR
      @ 04,01 SAY  "CEDULA:                          NOMBRE:                                      "
      @ 05,01 SAY  "GRUPO :                          NOMINA:                                      "
      @ 06,01 SAY  "------------------------------------------------------------------------------"
      @ 07,01 SAY  "COD. DESCRIPCION               UND.  CANTD.  ASIGNACION  DEDUCCION       SALDO"
      @ 08,01 SAY  "---- ------------------------- ----  ------  ---------- ---------- -----------"
      @ 04,08 SAY  WCEDULA
      @ 04,43 SAY  WNAME
      @ 05,08 SAY  WGRUPODES
      @ 05,43 SAY  WNOMIDES
      STORE 100 TO WLINE
      STORE 0   TO WPAGE
      STORE 0 TO WTOTBON
      STORE 0 TO WTOTNBON
      STORE 0 TO WTOTASI
      STORE 0 TO WTOTDEC
      STORE 0 TO WTOTLIQ
      SELECT 1
      FIND &WCEDULA
      DO WHILE .NOT. EOF() .AND. CEDULA = WCEDULA
         STORE WLINE+1 TO WLINE
         IF WLINE>20
            STORE WPAGE+1 TO WPAGE
            IF WPAGE > 1
               STORE "OPRIMA <ENTER> PARA CONTINUAR, <ESC> PARA SALIR" TO MES
               DO AVISO WITH MES
               IF READKEY()=12 .OR. READKEY()=268
                  EXIT
               ENDIF
               @ 9,0 CLEAR
            ENDIF
            STORE 9 TO WLINE
         ENDIF
         STORE CONCEPTO TO WCONCEPTO
         SELECT 2
         FIND &WCONCEPTO
         IF EOF()
            STORE "NO REGISTRADO EN CONCEPTOS" TO WCONCEDES
            STORE SPACE(4)                     TO WUNIDAD
            STORE 0                            TO XSALDOTIPO 
            STORE 0                            TO QGRUPO
         ELSE
            STORE DESCRI                       TO WCONCEDES
            STORE UNIDAD                       TO WUNIDAD
            STORE SALDO                        TO XSALDOTIPO
            STORE GRUPO                        TO QGRUPO
         ENDIF
         SELECT 1
         STORE MONTOINI  TO XMONTOINI
         STORE MONTOPRO  TO XMONTOPRO
         @ WLINE,1  SAY CONCEPTO
         @ WLINE,6  SAY WCONCEDES
         @ WLINE,32 SAY WUNIDAD
         @ WLINE,38 SAY CANTIDAD PICTURE "###.##"
         IF QGRUPO = 1
            @ WLINE,46 SAY MONTO   PICTURE "#######.##"
         ELSE
            @ WLINE,57 SAY MONTO   PICTURE "#######.##"
         ENDIF
         IF XSALDOTIPO > 0
            STORE 0 TO XMONTO
            STORE 0 TO XSALDO
            DO SALDOCAL
            @ WLINE,69 SAY XSALDO   PICTURE "#######.##"
         ENDIF
         SELECT 1
         STORE MONTO TO XMONTO
         DO TOTALIZA  
         SELECT 1
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
         STORE "NO REGISTRADO EN CONCEPTOS, VERIFIQUE" TO MES
         DO AVISO WITH MES
         LOOP
      ELSE
         STORE DESCRI                       TO WCONCEDES
         STORE UNIDAD                       TO WUNIDAD
         STORE FORMA                        TO WFORMA
         STORE FACTOR                       TO WFACTOR
         STORE MINIMO                       TO WMINIMO
         STORE MAXIMO                       TO WMAXIMO
         STORE SPACE(25)                    TO WREFER
         STORE 0                            TO WCANTIDAD
         STORE 0                            TO WMONTOINI
         STORE 0                            TO WMONTOPRO
         @ 21,10 SAY DESCRI
      ENDIF
      STORE WCEDULA+WCONCEPTO TO WCLAVE
      SELECT 1
      FIND &WCLAVE
      IF EOF()
         STORE "CONCEPTO NO REGISTRADO PARA ESTA PERSONA, INGRESAR ? (S/N)" TO TEX
         STORE "SN" TO WCH
         DO PREGUNTA
         IF WCH = "N"
            LOOP
         ENDIF
         STORE .T.      TO WINGRESA
         STORE .T.      TO WMODIFICA
      ELSE
         STORE .F.      TO WINGRESA
         STORE .F.      TO WMODIFICA
         STORE REFER    TO WREFER
         STORE FACTOR   TO WFACTOR
         STORE MINIMO   TO WMINIMO
         STORE MAXIMO   TO WMAXIMO
         STORE CANTIDAD TO WCANTIDAD
         STORE MONTOINI TO WMONTOINI
         STORE MONTOPRO TO WMONTOPRO
      ENDIF
      *** RUTINA PARA DEFINIR LA FORMA DEL CALCULO
      STORE WFORMA    TO WFORMANUM
      STORE SPACE(30) TO WFORMADES
      DO FORMADES
      ***
      @ 3,0 CLEAR
      @ 3,0 TO 21,79

      @ 04,01 SAY "CONCEPTO       :"+WCONCEPTO+"  "+WCONCEDES
      @ 06,01 SAY "UNIDAD         :"+WUNIDAD
      @ 08,01 SAY "REFERENCIA     :"+WREFER
      @ 10,01 SAY "CANTIDAD       :"+STR(WCANTIDAD,6,2)
      @ 12,01 SAY "FORMA  CALCULO :"+STR(WFORMA,1)+" - "+WFORMADES
      @ 14,01 SAY "FACTOR CALCULO :"+STR(WFACTOR,11,3)
      @ 16,01 SAY "MIN. y MAX.    :"
      @ 16,18 SAY WMINIMO   PICTURE "#######.##"
      @ 16,30 SAY WMAXIMO   PICTURE "#######.##"
      @ 18,01 SAY "MONTO INICIAL  :"+STR(WMONTOINI,11,2)
      @ 20,01 SAY "MONTO PROCESADO:"+STR(WMONTOPRO,11,2)
      IF .NOT. WMODIFICA
         STORE "OPCIONES: (M)ODIFICAR, (E)LIMINAR, (S)ALIR" TO TEX
         STORE "SME" TO WCH
         DO PREGUNTA
         STORE WCH TO WRESP
         IF WRESP= "S"
            LOOP
         ELSE
            IF WRESP= "M"
               STORE .T. TO WMODIFICA
            ELSE
               STORE "ESTA SEGURO QUE DESEA ELIMINAR ? (S/N)" TO TEX
               STORE "NS" TO WCH
               DO PREGUNTA
               IF WCH = "N"
                  LOOP
               ELSE
                  *** CHEQUEAR QUE EL CONCEPTO ESTE SIN CONEXIONES EN PERIODO.DBF
                  SELECT 1
                  DO RECLOC
                  DELETE
                  FLUSH
                  UNLOCK
                  LOOP
               ENDIF
            ENDIF
         ENDIF
      ENDIF
      IF WMODIFICA
         *** REFERENCIA
         STORE .T. TO WACT
         DO WHILE WACT
            STORE "INGRESE LA REFERENCIA DE CREACION DEL CONCEPTO" TO MES
            DO MENSAJE WITH MES
            @ 08,17 GET WREFER
            READ
            IF READKEY()=12.OR.READKEY()=268
               STORE .F. TO WCARGANDO
               EXIT
            ENDIF
            EXIT
         ENDDO
         IF .NOT. WCARGANDO
            EXIT
         ENDIF

         *** CANTIDAD
         STORE .T. TO WACT
         DO WHILE WACT
            STORE "INGRESE LA CANTIDAD DE UNIDADES CORRESPONDIENTES" TO MES
            DO MENSAJE WITH MES
            @ 10,18 GET WCANTIDAD PICTURE "###.##"
            READ
            IF READKEY()=12.OR.READKEY()=268
               STORE .F. TO WCARGANDO
               EXIT
            ENDIF
            IF WCANTIDAD > 0
               EXIT
            ENDIF
         ENDDO
         IF .NOT. WCARGANDO
            EXIT
         ENDIF
         *** FACTOR
         STORE .T. TO WACT
         DO WHILE WACT
            STORE "INGRESE EL FACTOR DE CALCULO CORRESPONDIENTES" TO MES
            DO MENSAJE WITH MES
            @ 14,18 GET WFACTOR   PICTURE "#######.###"
            READ
            IF READKEY()=12.OR.READKEY()=268
               STORE .F. TO WCARGANDO
               EXIT
            ENDIF
            IF WFACTOR > 0
               EXIT
            ENDIF
         ENDDO

         *** MINIMO Y MAXIMO
         STORE .T. TO WACT
         DO WHILE WACT
            STORE "INGRESE EL MONTO MINIMO Y MAXIMO A CALCULAR EN EL CONCEPTO" TO MES
            DO MENSAJE WITH MES
            @ 16,18 GET WMINIMO   PICTURE "#######.##"
            @ 16,30 GET WMAXIMO   PICTURE "#######.##"
            READ
            IF READKEY()=12.OR.READKEY()=268
               STORE .F. TO WACT
               EXIT
            ENDIF
            IF WMAXIMO >= WMINIMO
               EXIT
            ENDIF
         ENDDO
         IF .NOT. WACT
            LOOP
         ENDIF
         *** MONTO INICIAL
         STORE .T. TO WACT
         DO WHILE WACT
            STORE "INGRESE EL MONTO INICIAL DEL CONCEPTO" TO MES
            DO MENSAJE WITH MES
            @ 18,18 GET WMONTOINI PICTURE "#######.##"
            READ
            IF READKEY()=12.OR.READKEY()=268
               STORE .F. TO WCARGANDO
               EXIT
            ENDIF
            EXIT
         ENDDO
         *** MONTO TOTAL PROCESADO
         STORE .T. TO WACT
         DO WHILE WACT
            STORE "INGRESE EL MONTO PROCESADO ACUMULADO DEL CONCEPTO" TO MES
            DO MENSAJE WITH MES
            @ 20,18 GET WMONTOPRO PICTURE "#######.##"
            READ
            IF READKEY()=12.OR.READKEY()=268
               STORE .F. TO WCARGANDO
               EXIT
            ENDIF
            EXIT
         ENDDO
         IF .NOT. WCARGANDO
            EXIT
         ENDIF
      ENDIF
      STORE "CONFORME ? (S/N)" TO TEX
      STORE "SN" TO WCH
      DO PREGUNTA
      IF WCH = "N"
         LOOP
      ENDIF
      IF WINGRESA
         SELECT 1
         DO FILLOC
         APPEND BLANK
         UNLOCK
         DO RECLOC
         REPLACE CEDULA   WITH WCEDULA
         REPLACE CONCEPTO WITH WCONCEPTO
      ENDIF
      DO RECLOC
      REPLACE REFER      WITH WREFER
      REPLACE CANTIDAD   WITH WCANTIDAD
      REPLACE FACTOR     WITH WFACTOR
      REPLACE MINIMO     WITH WMINIMO
      REPLACE MAXIMO     WITH WMAXIMO
      REPLACE MONTOINI   WITH WMONTOINI
      REPLACE MONTOPRO   WITH WMONTOPRO
      FLUSH
      UNLOCK
      *** RUTINA DE RECALCULO DEL SOBRE
      STORE 0 TO WTOTBON
      STORE 0 TO WTOTNBON
      STORE 0 TO WTOTASI
      STORE 0 TO WTOTDEC
      STORE 0 TO WTOTLIQ
      STORE WCEDULA TO XCEDULA
      DO SOBRECAL
      DO CONCECAL
   ENDDO
ENDDO
CLOSE DATA
CLOSE INDEX
RETURN
