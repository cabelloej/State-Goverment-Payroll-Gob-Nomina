select 1
use apgrupos index apgrupos
select 2
use apnomina index apnomina
select 3
use apcon index apcon
select 4
use apconper index apconper
select 7 
use apperson index apperso1
store space(1) to wtipper
store space(2) to wgrupo
store space(2) to wnomina
store space(4) to wqconcepto
@ 04,0 say "ELIMINACION GENERAL DE CONCEPTOS EN CONCEPTOS NOMINALES"
@ 05,0 clear to 10,60
@ 05,0 to 10,60
@ 06,01 say "TIPO DE PERSONAL  :"
@ 07,01 SAY "GRUPO DE NOMINAS  :"
@ 08,01 SAY "CODIGO DE NOMINA  :"
@ 09,01 SAY "CODIGO DE CONCEPTO:"
store .t. to wgettip
do while wgettip
   store "INDIQUE PERSONAL (O=OBRERO, E=EMPLEADO,P=PENSIONADO, J=JUBILADO)" TO MES
   do mensaje with mes
   @ 06,20 get wtipper picture "!"
   read
   if readkey()=12.or.readkey()=268.or.wtipper=space(2)
      close data
      close index
      return
   endif
   if wtipper="O".or.wtipper="E".or.wtipper="P".or.wtipper="J"
      exit
   endif
enddo
store .t. to wgetgru
do while wgetgru
   store "INDIQUE EL GRUPO DE NOMINA" TO MES
   do mensaje with mes
   @ 07,20 get wgrupo  
   read
   if readkey()=12.or.readkey()=268
      close data
      close index
      return
   endif
   if wgrupo <> space(2)
      select 1
      find &wgrupo
      if eof()
         store "GRUPO NO REGISTRADO, VERIFIQUE" to mes
         do aviso with mes
         loop
      else
         store descri to wdesgrupo
         @ 07,26 say wdesgrupo
         @ 08,20 get wnomina
         read
         if readkey()=12.or.readkey()=268
            loop
         endif
         if wnomina <> space(2)
            store wgrupo+wnomina to wclave
            select 2
            find &wclave
            if eof()
               store "NOMINA NO REGISTRADA PARA ESTE GRUPO, VERIFIQUE" to mes
               do aviso with mes
               loop
            else
               store descri to wdesnomi
               @ 08,26 say wdesnomi
               exit
            endif
         else
            store "TODAS LAS NOMINAS DEL GRUPO" to wdesnomi
            @ 08,26 say wdesnomi
            exit
         endif
      endif 
   else
      store "TODOS LOS GRUPOS"  to wdesgrupo
      store "TODAS LAS NOMINAS DE LOS GRUPOS" to wdesnomi  
      @ 07,26 say wdesgrupo
      @ 08,26 say wdesnomi
      exit
   endif
enddo
store .t. to wgetcon
do while wgetcon
   store "INDIQUE EL CODIGO DE CONCEPTO" TO MES
   do mensaje with mes
   @ 09,20 get wqconcepto           
   read
   if readkey()=12.or.readkey()=268.or.wqconcepto=space(4)
      close data
      close index
      return      
   endif
   select 3
   find &wqconcepto
   if eof()
      store "CONCEPTO NO REGISTRADO, VERIFIQUE" to mes
      do aviso with mes
      loop
   else
      @ 09,26 say descri
      exit
   endif
enddo
store "OPCIONES: (C)ONTINUAR, (S)ALIR" to tex
store "SC" to wch
do pregunta
if wch = "S"
   close data
   close index
   return
endif
select 7
go top
do while .not. eof()
   if tipo <> wtipper
      select 7
      skip
      loop
   endif
   if wgrupo <> space(2).and.wgrupo<>grupo
      select 7
      skip
      loop
   endif
   if wnomina<>space(2).and.wnomina<>nomina 
      select 7
      skip
      loop
   endif
   store cedula  to xcedula
   store xcedula+wqconcepto to wclavecon
   select 4
   find &wclavecon
   if .not. eof()
      do recloc
      DELETE 
      unlock 
   endif
   select 7
   skip
enddo
close data
close index
return
