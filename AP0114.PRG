STORE .T. TO TABLA
DO WHILE TABLA
   store "TABLAS DE LIQUIDACION" TO HEAD
   @ 5,1 CLEAR TO 18,50
   @ 5,1 TO 18,50 DOUBLE
   @ 5,15 SAY HEAD
   @ 6,5 SAY  "LEY DEL TRABAJO :"
   @ 7,5 SAY  "MESES CUMPLIDOS :"
   @ 8,5 SAY  "PREAVISO        :"
   @ 9,5 SAY  "ANTIGUEDAD      :"
   @ 10,5 SAY "CASANTIA        :"
   @ 11,5 SAY "VACACION        :"
   @ 12,5 SAY "BONO VACACIONAL :"
   @ 13,5 SAY "UTILIDAD        :"
   SELECT 1
   USE APLDT EXCL
   STORE 0.00 TO WMESES
   STORE "Indique el numero de meses a procesar (Ù para salir) " to mes
   do mensaje with mes
   @ 7,24 GET WMESES PICTURE "#####.##"
   READ
   if wmeses = 0
      close data
      close index
      return
   endif

   go top
   locate for meses = wmeses
   if .not. found()
      store "Numero de meses no registrado en esta tabla. Ingresar? (S/N) " to tex
      store "SN" to wch
      do pregunta
      iF wch = "N"
         loop
      endif
      append blank
      replace meses with wmeses
      @ 08,24 get preaviso     picture "#####.##"
      @ 09,24 get antiguedad   picture "#####.##"
      @ 10,24 get cesantia     picture "#####.##"
      @ 11,24 get vacacion     picture "#####.##"
      @ 12,24 get bonovac      picture "########.##"
      @ 13,24 get utilidad     picture "#####.##"

      READ
      SORT ON MESES TO APTEMP3
      DELETE ALL
      PACK
      APPEND FROM APTEMP3
      loop
   endif

   @ 8,24 say preaviso     picture "#####.##"
   @ 9,24 say antiguedad   picture "#####.##"
   @ 10,24 say cesantia    picture "#####.##"
   @ 11,24 say vacacion    picture "#####.##"
   @ 12,24 say bonovac     picture "########.##"
   @ 13,24 say utilidad    picture "#####.##"
   store "Desea (M)odificar, (E)liminar, (R)echazar" to TEX
   store "MRE" TO WCH
   DO PREGUNTA 
   IF WCH = "E"
      DELETE
      PACK
      SORT ON MESES TO APTEMP3
      ZAP
      APPEND FROM APTEMP3
      LOOP
   ENDIF

   IF WCH = "R"
      LOOP
   ENDIF

   IF WCH = "M"
      @ 08,24 get preaviso     picture "#####.##"
      @ 09,24 get antiguedad   picture "#####.##"
      @ 10,24 get cesantia     picture "#####.##"
      @ 11,24 get vacacion     picture "#####.##"
      @ 12,24 get bonovac      picture "########.##"
      @ 13,24 get utilidad     picture "#####.##"
      READ
   ENDIF
ENDDO

