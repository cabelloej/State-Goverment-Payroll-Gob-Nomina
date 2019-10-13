**********************************************
*    PROGRAMA DE LIQUIDACION DE PERSONAL      *
***********************************************
STORE .T. TO LIQ
SELECT 1
USE APPERSON INDEX APPERSO1
STORE "LIQUIDACION DE PERSONAL" TO HEADING
DO WHILE LIQ
   @ 5,1 CLEAR TO 18,50
   @ 5,1 TO 18,50 DOUBLE
   @ 5,10 SAY HEADING
   @ 7,3 SAY "CEDULA:"
   STORE SPACE(12) TO WCEDULA
   STORE "NUMERO DE CEDULA A LIQUIDAR" to mes
   DO MENSAJE WITH MES
   @ 7,11 get WCEDULA
   READ
   IF WCEDULA = SPACE(12)
      CLOSE DATA
      CLOSE INDEX
      RETURN
   ENDIF
   SELECT 1
   SEEK WCEDULA
   IF EOF()
      STORE "CEDULA NO REGISTRADA" to mes
      do aviso with mes
      loop
   endif
   @ 9,3 say "NOMBRE:"+RTRIM(NOMBRES)+" "+APELLIDOS
   STORE "ES ESTA LA PERSONA A LIQUIDAR ? (S/N)" to TEX
   store "NS" TO WCH
   DO PREGUNTA
   IF WCH = "N"
      LOOP
   ENDIF

   STORE DATE() TO FECHALIQ
   @ 11,3 SAY "FECHA DE LIQUIDACION:" GET FECHALIQ
   READ

   @ 13,3 SAY "MOTIVO DE LA LIQUIDACION:"
   STORE "MOTIVO DE LA LIQUIDACION: (T)ERMINACION DE CONTRATO, (D)ESPIDO, (R)ENUNCIA" to TEX
   store "TDR" to WCH
   do PREGUNTA
   if WCH = "T"
      store "TERMINACION" TO WMOTIVO
   ENDIF
   if WCH = "D"
      store "DESPIDO"     TO WMOTIVO
   ENDIF
   if WCH = "R"
      store "RENUNCIA"    TO WMOTIVO
   ENDIF
   @ 13,3 SAY "MOTIVO DE LA LIQUIDACION:"+WMOTIVO

   STORE INGRESO TO FECHAINI
   STORE (FECHALIQ-FECHAINI) + 1 TO WTOTDIAS
   store int(wtotdias/30.4166667) to wmes
   store wtotdias/30 to xmes
   store wtotdias-(wmes*30) to wdias
   IF WDIAS >= 25
      store wmes+1 to wmes2
      store "Desea convertir los "+str(wmes,3)+" meses y "+str(wdias,2)+" dias en "+str(wmes2,3)+ " meses ?" to TEX
      store "NS" to WCH
      do PREGUNTA
      if WCH = "S"
         STORE WMES+1 TO WMES
         STORE WMES TO XMES
         STORE 0 TO WDIAS
      endif
   ENDIF
   STORE INT(WMES*30)+WDIAS TO WTOTDIAS

   STORE APPERSON->VENCEVAC TO FIVAC
   IF FIVAC = CTOD("  -  -  ")
      STORE APPERSON->INGRESO TO FIVAC
   ENDIF
   STORE (FECHALIQ-FIVAC) + 1 TO WTDVAC
   IF WTDVAC < 0
      STORE 0 TO WTDVAC
   ENDIF
   store int(wtDVAC/30.4166667) to wmesVAC
   store wtDVAC-(wmesVAC*30) to wdiasVAC
   IF WMESVAC < 0
      STORE 0 TO WMESVAC
   ENDIF
   IF WDIASVAC < 0
      STORE 0 TO WDIASVAC
   ENDIF
   IF WDIASVAC >= 25
      store wmesVAC+1 to wmesVAC2
      store "Desea convertir los "+str(wmesVAC,3)+" meses de vacacion y "+str(wdiasVAC,2)+" dias en "+str(wmesVAC2,3)+ " meses ?" to TEX
      store "NS" to WCH
      do PREGUNTA
      if WCH = "S"
         STORE WMESVAC2 TO WMESVAC
         STORE 0 TO WDIASVAC
      endif
   ENDIF
   STORE INT(WMESVAC*30)+WDIASVAC TO WTDVAC

   STORE NOMBRES   TO WNOMBRE
   STORE APELLIDOS TO WAPELLIDO
   STORE INGRESO   TO WINGRESO
   STORE SUELDOD   TO WSUELDO
   STORE TIPO      TO WTIPO

   store "OPCIONES: (C)ONTINUAR, (S)ALIR" to TEX
   store "SC" to WCH
   DO PREGUNTA
   if WCH = "S"
      loop
   endif
   STORE 0 TO BSBONOVAC
   STORE 0 TO BSPREAVISO
   STORE 0 TO BSANTIGUE
   STORE 0 TO BSCESANTIA
   STORE 0 TO BSVACACION
   STORE 0 TO BASICODIA

   IF WMOTIVO = "TERMINACION"
       STORE 0 TO FFPP
       STORE 1 TO FFCC
       STORE 1 TO FFAA
   ELSE
      if wmotivo = "RENUNCIA"
          STORE 1 TO FFPP
          STORE 1 TO FFCC
          STORE 1 TO FFAA
       ELSE
          STORE 2 TO FFPP
          STORE 2 TO FFCC
          STORE 2 TO FFAA
       ENDIF
   ENDIF

   STORE WSUELDO TO Wbasicodia
   store 0 to wnetovac
   SELECT 4
   USE APLDT
   GO TOP
   LOCATE FOR meses > xmes
   IF .NOT. FOUND()
      STORE "ERROR, NO ENCONTRE LOS MESES APROPIADOS" TO MES
      DO AVISO WITH MES
      USE
      RETURN
   ENDIF
   GO RECNO()-1
   STORE PREAVISO   TO WTPREAVISO
   STORE ANTIGUEDAD TO WTANTIGUE
   STORE CESANTIA   TO WTCESANTIA
   STORE VACACION   TO WTVACACION
   STORE UTILIDAD   TO WTUTILIDAD
   store bonovac    to wnetovac

   *********** BUSQUEDA DE HISTORICO ****************
   IF WTIPO = "E"
      STORE 2 TO BUSCAR
      STORE 30 TO DIVIDIR
   ELSE
      STORE 4 TO BUSCAR
      STORE 28 TO DIVIDIR
   ENDIF

   *******   CALCULO DEL TOTAL BONIFICABLE *************
   *STORE 0 TO CONTEO
   *STORE 0 TO ACUMULADO
   *STORE 10 TO ZX
   *SELECT APPAGCON
   *SORT TO IPNTEMP2 ON FECHA /D FOR CEDULA = WCEDULA .AND. FECHA <= FECHALIQ .AND. NOMINA <> "UTLDA" .AND. NOMINA <> "LIQUI"
   *SELECT 4
   *USE IPNTEMP2
   *PACK
   *DO WHILE .NOT. EOF() .AND. CONTEO < BUSCAR
   *   STORE ACUMULADO + BSTOTBON TO ACUMULADO
   *   STORE CONTEO +1 TO CONTEO
   *   SKIP
   *ENDDO
   *STORE ACUMULADO/DIVIDIR TO PROMEDIODIA
   STORE WBASICODIA         TO PROMEDIODIA


   *** PREAVISO ***
   STORE WBASICODIA*WTPREAVISO  TO BSPREAVISO
   *** ANTIGUEDAD ***
   STORE PROMEDIODIA*WTANTIGUE  TO BSANTIGUE
   *** CESANTIA ***
   STORE PROMEDIODIA*WTCESANTIA TO BSCESANTIA
   *** VACACIONES ***
   STORE WBASICODIA*WTVACACION  TO BSVACACION
   *** BONO VACACIONAL ***
   STORE WNETOVAC*WBASICODIA    TO BSBONOVAC

   STORE BSPREAVISO+BSANTIGUE+BSCESANTIA+BSVACACION+BSBONOVAC TO WTOTALPAGAR

   SET DEVI TO PRINT
   @ 00,28  SAY CHR(14)+QQWW
   @ 02,13  SAY "FINIQUITO DE INDEMNIZACION POR TERMINACION DE CONTRATO"
   @ 04,60  SAY "FECHA : "+DTOC(DATE())

   @ 06,01  SAY "   Yo, "+ALLTRIM(WAPELLIDO)+", "+ALLTRIM(WNOMBRE)+", Cedula de identidad No."+WCEDULA
   @ 08,01  SAY "Hago constar que he recibido de "+ALLTRIM(QQWW)+", la suma de"
   @ 10,01  say "(Bs. "+str(wtotalpagar,9,2)+" )"
   @ 12,01  SAY "En caracter de Indemnizacion por la terminacion de mi contrato de trabajo,"
   @ 14,01  say "segun la siguiente relacion:"
   @ 16,01  say "MOTIVO POR EL CUAL TERMINO MI CONTRATO DE TRABAJO: "+WMOTIVO
   @ 18,26  SAY "Fecha de mi Empleo  Dia:"+STR(day(wingreso),2)+"   Mes:"+STR(month(wingreso),2)+"  A¤o:"+STR(year(wingreso),4)
   @ 20,26  SAY "Fecha de mi Retiro  Dia:"+STR(day(fechaliq),2)+"   Mes:"+STR(month(fechaliq),2)+"  A¤o:"+STR(year(fechaliq),4)
   @ 22,26  say "Tiempo de servicio   "+str(wmes,4)+" Meses y "+str(wdias,2)+" Dias"
   @ 24,01  say "SALARIO BASICO : Bs. "+STR(Wbasicodia,8,2)+" DIARIO "


   @ 26,1  say "PREAVISO                     : "+STR(WBASICODIA,10,2)+" x "+STR(WTPREAVISO,4)+" x "+STR(FFPP,1)+"       Bs. "+STR(BSPREAVISO,10,2)

   @ 28,1  SAY "ANTIGUEDAD                   : "+STR(WBASICODIA,10,2)+" x "+STR(WTANTIGUE,4) +" x "+STR(FFAA,1)+"       Bs. "+STR(BSANTIGUE,10,2)

   @ 30,1  SAY "CESANTIA                     : "+STR(WBASICODIA,10,2)+" x "+STR(WTCESANTIA,4)+" x "+STR(FFCC,1)+"       Bs. "+STR(BSCESANTIA,10,2)

   @ 32,1  say "VACACIONES PARCIALES         : "+STR(WBASICODIA,10,2)+" x "+STR(WTVACACION,5,2)+"          Bs. "+STR(BSVACACION,10,2)

   @ 34,1  SAY "BONO VACACIONAL                                            Bs. "+str(BSBONOVAC,10,2)

   @ 36,1  SAY "TOTAL RECIBIDO EN ESTE ACTO .............................. Bs."+str(wtotalpagar,11,2)

   @ 38,1  SAY "OBSERVACIONES : _______________________________________________________"

   @ 40,1  SAY "_______________________________________________________________________"

   @ 44,10 SAY "____________________ "

   @ 46,10 SAY "FIRMA DEL TRABAJADOR "



   *@ 31,1  SAY "ANTIGUEDAD ART.37 L.D.T. : "+STR(ACUMULADO,10,2)+" / "+STR(DIVIDIR,2)+" x "+STR(WTANTIGUE,4)+" x "+STR(FFAA,1)+"    Bs. "+STR(BSANTIGUE,10,2)
   *@ 35,1  SAY "CESANTIA ART. 39 L.D.T.  : "+STR(ACUMULADO,10,2)+" / "+STR(DIVIDIR,2)+" x "+STR(WTCESANTIA,4)+" x "+STR(FFCC,1)+"    Bs. "+STR(BSCESANTIA,10,2)

   SET DEVI TO SCRE
   EJECT
ENDDO
