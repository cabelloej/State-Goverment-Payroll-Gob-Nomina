******************************************************************************
*               pago de utilidades                                           *
******************************************************************************
SELECT 1
USE APPERSON INDEX APPERSO1 ALIAS PERSONAL
STORE .T. TO UTIL
DO WHILE UTIL
   @ 5,0 CLEAR TO 16,50
   @ 5,0 TO 16,50 DOUBLE
   STORE "PAGO DE UTILIDADES" TO HEADING
   @ 5,25-(LEN(HEADING)/2) SAY HEADING
   STORE SPACE(12) TO WCEDULA
   STORE "INGRESE LA CEDULA A PROCESAR" TO MES
   DO MENSAJE WITH MES
   @ 06,2 SAY "CEDULA         :"
   @ 08,2 SAY "NOMBRE         :"
   @ 10,2 SAY "FECHA DE INICIO:"
   @ 12,2 SAY "FECHA DE CIERRE:"
   @ 06,19 GET WCEDULA
   READ
   IF WCEDULA = SPACE(12)
      STORE .F. TO UTIL
      LOOP
   ENDIF
   SELECT PERSONAL
   SEEK WCEDULA
   IF EOF()
      STORE "CEDULA NO REGISTRADA" TO MES
      DO AVISO WITH MES
      LOOP
   ENDIF
   STORE SUELDOD     TO WBASICO
   STORE VENCEUTL+1  TO WINIDATE
   STORE INGRESO     TO WINGRESO
   STORE NOMBRES     TO WNOMBRE
   STORE APELLIDOS   TO WAPELLIDO
   IF WINIDATE = CTOD("  -  -  ")
      STORE WINGRESO TO WINIDATE
   ENDIF
   @ 08,19 SAY ALLTRIM(WAPELLIDO)+", "+ALLTRIM(WNOMBRE)
   STORE "FECHA INICIAL DE LAS UTILIDADES, (  -  -  ) para regresar)" TO MES
   DO MENSAJE WITH MES
   @ 10,19 GET WINIDATE
   READ
   if WINIDATE = CTOD("  -  -  ")
      loop
   endif

   store DATE() to wfindate
   STORE "FECHA DE CIERRE DE LAS UTILIDADES, (  -  -  ) para regresar)" TO MES
   DO MENSAJE WITH MES
   @ 12,19 GET WFINDATE
   READ
   if wFINDATE = CTOD("  -  -  ")
      loop
   endif
   if wfindate < Winidate
      store "ERROR, la fecha de pago de su ultima utilidad es mayor a la solicitadad" to mes
      do aviso with mes
      loop
   endif

   STORE "OPCIONES: (C)ONTINUAR,  (S)ALIR" to TEX
   store "SC" to WCH
   DO PREGUNTA
   if WCH = "S"
      close data
      close index
      return
   endif

   store "PROCESANDO INFORMACION, FAVOR ESPERAR..." to mes
   do mensaje with mes

   STORE ((WFINDATE - WINIDATE)+1)/30 TO WMESES
   STORE ROUND(WMESES,1) TO WMESES

      SELECT 4
      USE APLDT
      LOCATE FOR MESES > WMESES
      IF .NOT. FOUND()
         STORE "ERROR, NO SE ENCONTRO REGISTRO DE MESES A PAGAR" TO MES
         DO AVISO WITH MES
         LOOP
      ENDIF
      GO RECNO() - 1
      STORE UTILIDAD TO WDIASUTIL

      store WBASICO*wdiasutil               to wutilidad
      *STORE (WUTILIDAD*.5)/100             TO WINCE
      *STORE WUTILIDAD*(PERSONAL->ISLR/100) TO WISLR
      STORE 0 TO WINCE
      STORE 0 TO WISLR
      STORE 0 TO WDECSIND

      store wutilidad-wince-wislr-wdecsind to wneto

      set devi to print
      @ 00,00 SAY CHR(14)+QQWW+CHR(18)
      @ 02,60 SAY "FECHA :"+DTOC(DATE())
      @ 03,35 SAY "UTILIDADES"
      @ 04,03 SAY "NOMBRE:"+ALLTRIM(WAPELLIDO)+", "+ALLTRIM(WNOMBRE)
      @ 04,60 SAY "CEDULA:"+WCEDULA
      @ 06,03 say "DIARIO:"+str(wBASICO,10,2)
      @ 08,03 SAY "PERIODO VENCIDO : DEL "+DTOC(WINIDATE)+" AL "+DTOC(WFINDATE)
      @ 10,03 SAY "DESCRIPCION"
      @ 10,40 SAY "CANT."
      @ 10,55 SAY "MONTO"
      @ 11,03 SAY "------------------------------"
      @ 11,40 SAY "-----"
      @ 11,55 SAY "--------------"

      @ 13,03 SAY "UTILIDADES"
      @ 13,40 SAY STR(WDIASUTIL,6,2)
      @ 13,55 SAY STR(WUTILIDAD,9,2)

      *@ 15,03 SAY "INCE"
      *@ 15,54 SAY "-"+STR(WINCE,9,2)

      @ 17,03 SAY "Total Neto a Pagar:"
      @ 17,55 SAY str(wneto,9,2)
      @ 22,03 say "__________________________________"
      @ 22,40 say "__________________________________"
      @ 23,03 SAY "            Firma                 "
      @ 23,40 say "     Lugar y Fecha del Pago       "
      REPLACE PERSONAL->VENCEUTL WITH WFINDATE
   set devi to scree
   eject
ENDDO
CLOSE DATA
CLOSE INDEX
RETURN

