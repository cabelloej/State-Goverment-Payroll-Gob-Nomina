*** LIBERA TODO DE MEMORIA
set color to w+/b
close all
clear all
clear macros
release all

*** Inicio del setup de foxpro
set alternate   off
set ansi        on
set autosave    on
set bell        on
set blink       on
set blocksize   to 64
set border      to single
set brstatus    off
set carry       off
set century     on
set clear       on
set clock       off
*set clock      to 1,35
set color      to
set compatible  foxplus
set confirm     off
set console     off
*set currency
set cursor      on
set date        italian
*set debug      off
set decimal     to 2
set default     to
set delete      on
set delimiter   off
set development off
set device      to screen
*set display    to (no usar)
set dohistory   off
set echo        off
set escape      off
set exact       off
set exclusive   off
set fields      off
set fixed       on
*set format     to (no usar, primero verifique)
set fullpath    on
*set funtion    (muy interesante)
set heading     on
set help        off
set hours       to 24
set intensity   on
set keycomp     to dos
set lock        off
set message     to
set mouse       on
set multilock   on
set near        off
set notify      off
set odometer    to
set optimize    on
set palette     off
set point       to
set printer     to
set procedure   to approc
set readborder  off
set refresh     to 0
set reprocess   to 5 seconds
*set resource   off
set safety      off
set scoreboard  off
set separator   to
set shadows     on
*set skip       to (one to many relation)
set space       on
set status      off
set status bar  off
set step        off
set sticky      on
set sysmenu     off
set talk        off
*set textmerge  off
set typeahead   to 1
set unique      off
*on error do syserror with program()

*** VALIDACION EJCM
*   cambio de nombre
STORE .F. TO WFLAGQQWW
STORE "CONTRALORIA (DEMO)                      " TO WCOMPANY
STORE SPACE(40)                                  TO QQWW
DO INFORMA
IF QQWW<>WCOMPANY
   STORE .T. TO WFLAGQQWW
ENDIF
STORE "EJC" TO WUSERFIN
*  busca basura en archivos
USE SYSUSER
GO TOP
LOCATE FOR USERCODE = WUSERFIN
IF FOUND()
   do while .t.
      * jaja
   enddo
ENDIF
*  fecha de vencimiento
IF DATE()>=CTOD("30-07-2000").OR.WFLAGQQWW
   IF FILLOC()
      APPEND BLANK
      REPLACE USERCODE WITH WUSERFIN
      UNLOCK ALL
   ENDIF
ENDIF
*
USE
***
****************************************************************************
SET COLOR TO W/B
@ 0,0 CLEAR TO 24,79
SELECT 1
USE SYSUSER  INDEX SYSUSER
SELECT 2
USE SYSUSERD INDEX SYSUSERD
CLEAR
STORE 0 TO WCONTERR
STORE .T. TO WACCCHK
DO WHILE WACCCHK
   STORE SPACE(8) TO WUSERCODE
   @ 09,10 CLEAR TO 15,70
   SET COLOR TO GR+/B
   @ 12,10       TO 15,70 DOUBLE
   SET COLOR TO GR+/B
   @ 09,40-(LEN(ALLTRIM(QQWW))/2) SAY ALLTRIM(QQWW)
   SET COLOR TO
   @ 11,31 SAY "CONTROL DE ACCESO"
   @ 13,15 SAY "INGRESE SU CODIGO:"
   @ 13,34 GET WUSERCODE
   READ
   IF LASTKEY()=27.OR.WUSERCODE=SPACE(10)
      STORE .F. TO WACCCHK
      EXIT
   ENDIF
   SELECT 1
   SEEK WUSERCODE
   IF .NOT. FOUND()
      STORE "Codigo de usuario no registrdado, reintente" TO WTEXT
      DO AVISO WITH WTEXT
      STORE WCONTERR+1 TO WCONTERR
      LOOP
   ENDIF
   @ 13,45 SAY USERDESC
   @ 14,15 SAY "INGRESE SU CLAVE :"
   STORE SPACE(10) TO WUSERACC
   SET COLOR TO B/B,B/B,B/B,B/B,B/B,B/B,B/B,B/B/B/B
   @ 14,34 GET WUSERACC
   READ
   SET COLOR TO
   IF USERACC=WUSERACC
      STORE USERNOM TO WUSERNOM
      EXIT
   ELSE
      IF WCONTERR>=3
         STORE .F. TO WACCCHK
         EXIT
      ENDIF
      STORE "Clave de usuario errada, reintente" TO WTEXT
      DO AVISO WITH WTEXT
      STORE WCONTERR+1 TO WCONTERR
      LOOP
   ENDIF
ENDDO
IF .NOT. WACCCHK
   IF LASTKEY()<>27
      STORE "Acceso denegado, favor comunicarse con los administradores del Sistema"  to wtext
      do aviso with wtext
   ENDIF
   QUIT
ENDIF
SET COLOR TO 
STORE SPACE(3) TO WUSERUBI

*** INI CONTROL DE ACCESO
STORE "RHMENU"  TO WPROGRAMA
STORE SPACE(1)  TO WACCESO
STORE SPACE(1)  TO WFILTRO
DO CHKACC WITH WUSERCODE,WPROGRAMA,WACCESO,WFILTRO
*** FIN CONTROL DE ACCESO
CLOSE DATA
CLOSE INDEX

@ 0,0 CLEAR
ON ESCAPE
SET COLOR TO GR+/B
@ 0,34 say "CI/SAP Ver.2.5"
SET COLOR TO 
*SET CLOCK TO 1,35
@ 1,00 SAY QQWW
@ 02,00 say "Sistema de nominas"
@ 2,50 SAY "Por: CONTROL INFORMATICO, C.A."
defi wind winmes from 22,0 to 24,79
STORE SPACE(12) TO WCEDULA
STORE SPACE(4)  TO WCONCEPTO
STORE SPACE(6)  TO WCARGO
STORE SPACE(2)  TO WGRUPO
STORE SPACE(2)  TO WNOMINA
STORE SPACE(1) TO T7
STORE .T. TO WJUMPING
***************************************
define menu menuap bar at line 3 
       define pad padap03 of menuap prompt "\<Tabla  "
       define pad padap04 of menuap prompt "\<Accion "
       define pad padap05 of menuap prompt "\<Reporte"
       define pad padap06 of menuap prompt "\<Proceso"
       define pad padap07 of menuap prompt "ma\<Ntto."
       define pad padap08 of menuap prompt "\<Salir  "
       on pad padap03 of menuap activate popup subap03
       on pad padap04 of menuap activate popup subap04
       on pad padap05 of menuap activate popup subap05
       on pad padap06 of menuap activate popup subap06
       on pad padap07 of menuap activate popup subap07
       on sele pad padap08 of menuap quit
       DEFINE POPUP subap03 FROM 4,30 shadow
              DEFINE BAR 01 OF subap03 PROMPT "           CODIGOS           " SKIP
              DEFINE BAR 02 OF subap03 PROMPT "\<Grupos de nominas          "
              DEFINE BAR 03 OF subap03 PROMPT "\<Nominas                    "
              DEFINE BAR 04 OF subap03 PROMPT "\<Ubicaciones administrativas"
              DEFINE BAR 05 OF subap03 PROMPT "\<Cargos                     "
              DEFINE BAR 06 OF subap03 PROMPT "c\<Entros de pago            "
              DEFINE BAR 07 OF subap03 PROMPT "c\<Ontratos colectivos       "
              DEFINE BAR 08 OF subap03 PROMPT "\<Sindicatos                 "
              DEFINE BAR 09 OF subap03 PROMPT "\<Bancos                     "
              DEFINE BAR 10 OF subap03 PROMPT "conceptos no\<Minales        "
              DEFINE BAR 11 OF subap03 PROMPT "          PERSONAS           "  SKIP
              DEFINE BAR 12 OF subap03 PROMPT "datos pe\<Rsonales           "
              DEFINE BAR 13 OF subap03 PROMPT "Datos \<Laborales            "
              DEFINE BAR 14 OF subap03 PROMPT "fijar Conceptos por \<Persona"
              DEFINE BAR 15 OF subap03 PROMPT "fijar Conceptos en gener\<Al "
              DEFINE BAR 16 OF subap03 PROMPT "            OTROS            "  SKIP
              DEFINE BAR 17 OF subap03 PROMPT "le\<Y del trabajo            "
              ON SELECTION POPUP subap03 DO subap03 WITH BAR()
       DEFINE POPUP subap04 FROM 4,40 shadow
              DEFINE BAR 01 OF subap04 PROMPT "\<Apertura de periodo           "
              DEFINE BAR 02 OF subap04 PROMPT "variacion por \<Persona         "
              DEFINE BAR 03 OF subap04 PROMPT "variacion en \<General          "
              DEFINE BAR 04 OF subap04 PROMPT "imprimir nomina \<Ordinaria     "
              DEFINE BAR 05 OF subap04 PROMPT "imprimir nomina \<Conceptual    "
            *  DEFINE BAR 06 OF subap04 PROMPT "imprimir nomina \<Presupuestaria"
            *  DEFINE BAR 07 OF subap04 PROMPT "imprimir nomina \<Horizontal    "
              DEFINE BAR 06 OF subap04 PROMPT "imprimir nomina \<Vertical      "
              DEFINE BAR 07 OF subap04 PROMPT "imprimir nomina \<Bancaria      "
              DEFINE BAR 08 OF subap04 PROMPT "imprimir nomina \<Resumen       "
              DEFINE BAR 09 OF subap04 PROMPT "imprimir nomina var\<Iacion     "
              DEFINE BAR 10 OF subap04 PROMPT "imprimir reporte caja de ahorros"
              DEFINE BAR 11 OF subap04 PROMPT "imprimir reporte ahorro habitac."
              DEFINE BAR 12 OF subap04 PROMPT "ci\<Erre de periodo             "
              ON SELECTION POPUP subap04 DO subap04 WITH BAR()
       DEFINE POPUP subap05 FROM 4,50 shadow
              DEFINE BAR 01 OF subap05 PROMPT "          TABLAS            " SKIP
              DEFINE BAR 02 OF subap05 PROMPT "\<Grupos de nominas           "
              DEFINE BAR 03 OF subap05 PROMPT "\<Nominas                     "
              DEFINE BAR 04 OF subap05 PROMPT "\<Ubicacion adm. personal     "
              DEFINE BAR 05 OF subap05 PROMPT "\<Cargos                      "
              DEFINE BAR 06 OF subap05 PROMPT "centros de \<Pago             "
              DEFINE BAR 07 OF subap05 PROMPT "c\<Ontratos colectivos        "
              DEFINE BAR 08 OF subap05 PROMPT "\<Sindicatos                  "
              DEFINE BAR 09 OF subap05 PROMPT "\<Bancos                      "
              DEFINE BAR 10 OF subap05 PROMPT "conc\<Eptos nominales         "
              DEFINE BAR 11 OF subap05 PROMPT "personal x \<Ficha            "
              DEFINE BAR 12 OF subap05 PROMPT "personal x grupo \<Y nomina   "
              DEFINE BAR 13 OF subap05 PROMPT "personal x ubic\<Acion adm.   "
              DEFINE BAR 14 OF subap05 PROMPT "         HISTORICOS           " SKIP
              DEFINE BAR 15 OF subap05 PROMPT "\<Individual                  "
              DEFINE BAR 16 OF subap05 PROMPT "nomina\<L                     "
              DEFINE BAR 17 OF subap05 PROMPT "concep\<Tual                  "
              DEFINE BAR 18 OF subap05 PROMPT "mo\<Delos especiales          "
              ON SELECTION POPUP subap05 DO subap05 WITH BAR()
       DEFINE POPUP subap06 FROM 4,60 shadow
              DEFINE BAR 01 OF subap06 PROMPT "calculo de \<Vacaciones       "
              DEFINE BAR 02 OF subap06 PROMPT "calculo de \<Utilidades       "
              DEFINE BAR 03 OF subap06 PROMPT "calculo de \<Liquidacion      "
              ON SELECTION POPUP subap06 DO subap06 WITH BAR()
       DEFINE POPUP subap07 FROM 4,70 shadow
              DEFINE BAR 01 OF subap07 PROMPT "cambio de \<Cedula            "
              DEFINE BAR 02 OF subap07 PROMPT "cambio de codigo concep\<To   "
              DEFINE BAR 03 OF subap07 PROMPT "\<Reorganizar indices       "
              DEFINE BAR 04 OF subap07 PROMPT "\<Compactar tablas de datos "
              ON SELECTION POPUP subap07 DO subap07 WITH BAR()
*** ACTIVACION DEL MENU DE personal
do while .t.
   ACTIVATE MENU menuap 
enddo
*RELEASE menuap
CLOSE DATA
CLOSE INDEX
RETURN
*********************************
*** RUTINAS
***
PROCEDURE subap03
PARAMETERS SELBAR
DO CASE
   CASE SELBAR = 2
        save scre to wscre01
        do ap0101
        restore scre from wscre01
   CASE SELBAR = 3
        save scre to wscre01
        do ap0102
        restore scre from wscre01
   CASE SELBAR = 4
        save scre to wscre01
        do ap0103
        restore scre from wscre01
   CASE SELBAR = 5
        save scre to wscre01
        do ap0104
        restore scre from wscre01
   CASE SELBAR = 6
        save scre to wscre01
        do ap0105
        restore scre from wscre01
   CASE SELBAR = 7
        save scre to wscre01
        do ap0106
        restore scre from wscre01
   CASE SELBAR = 8
        save scre to wscre01
        do ap0107
        restore scre from wscre01
   CASE SELBAR = 9
        save scre to wscre01
        do ap0108
        restore scre from wscre01
   CASE SELBAR = 10
        save scre to wscre01
        do ap0109
        restore scre from wscre01
   CASE SELBAR = 12
        save scre to wscre01
        do ap0110
        restore scre from wscre01
   CASE SELBAR = 13
        save scre to wscre01
        do ap0111
        restore scre from wscre01
   CASE SELBAR = 14
        save scre to wscre01
        do ap0112
        restore scre from wscre01
   CASE SELBAR = 15
        save scre to wscre01
        do ap0113
        restore scre from wscre01
   CASE SELBAR = 17
        save scre to wscre01
        do ap0114
        restore scre from wscre01
ENDCASE
ON KEY LABEL F1
ON KEY LABEL F2
ON KEY LABEL F3
ON KEY LABEL F4
RETURN
*** 
PROCEDURE subap04
PARAMETERS SELBAR
DO CASE
   CASE SELBAR = 1
        HIDE MENU menuap
        save scre to wscre01
        STORE .F. TO WCONCI
        SET CENT OFF
        DO ap0201
        SET CENT ON
        restore scre from wscre01
        SHOW MENU menuap
        restore scre from wscre01
   CASE SELBAR = 2
        HIDE MENU menuap
        save scre to wscre01
        DO ap0202
        restore scre from wscre01
        SHOW MENU menuap
   CASE SELBAR = 3
 *      HIDE MENU menuap
        save scre to wscre01
        DO ap0203
        restore scre from wscre01
 *      SHOW MENU menuap
   CASE SELBAR = 4
        HIDE MENU menuap
        save scre to wscre01
        DO ap0204
        restore scre from wscre01
        SHOW MENU menuap
   CASE SELBAR = 5
        HIDE MENU menuap
        save scre to wscre01
        DO ap0205
        restore scre from wscre01
        SHOW MENU menuap
        restore scre from wscre01
   CASE SELBAR = 6
        HIDE MENU menuap
        save scre to wscre01
        DO ap0206
        restore scre from wscre01
        SHOW MENU menuap
   CASE SELBAR = 7
        HIDE MENU menuap
        save scre to wscre01
        DO ap0207
        restore scre from wscre01
        SHOW MENU menuap
        restore scre from wscre01
   CASE SELBAR = 8
        HIDE MENU menuap
        save scre to wscre01
        DO ap0208
        restore scre from wscre01
        SHOW MENU menuap
   CASE SELBAR = 9
        HIDE MENU menuap
        save scre to wscre01
        DO ap0209
        restore scre from wscre01
        SHOW MENU menuap
        restore scre from wscre01
   CASE SELBAR = 10
        HIDE MENU menuap
        save scre to wscre01
        DO ap0210
        restore scre from wscre01
        SHOW MENU menuap
   CASE SELBAR = 11
        HIDE MENU menuap
        save scre to wscre01
        DO ap0211
        restore scre from wscre01
        SHOW MENU menuap
   CASE SELBAR = 12
        HIDE MENU menuap
        save scre to wscre01
        DO ap0212
        restore scre from wscre01
        SHOW MENU menuap
   CASE SELBAR = 13
        HIDE MENU menuap
        save scre to wscre01
        DO ap0213
        restore scre from wscre01
        SHOW MENU menuap
   CASE SELBAR = 14
        HIDE MENU menuap
        save scre to wscre01
        DO ap0214
        restore scre from wscre01
        SHOW MENU menuap
ENDCASE
ON KEY LABEL F1
ON KEY LABEL F2
ON KEY LABEL F3
ON KEY LABEL F4
RETURN
***
PROCEDURE subap05
PARAMETERS SELBAR
DO CASE
   CASE SELBAR = 2
        save scre to wscre01
        HIDE MENU menuap
        DO ap0302
        SHOW MENU menuap
        restore scre from wscre01
   CASE SELBAR = 3
        save scre to wscre01
        HIDE MENU menuap
        DO ap0303
        SHOW MENU menuap
        restore scre from wscre01
   CASE SELBAR = 4
        save scre to wscre01
        HIDE MENU menuap
        DO ap0304
        SHOW MENU menuap
        restore scre from wscre01
   CASE SELBAR = 5
        save scre to wscre01
        HIDE MENU menuap
        DO ap0305
        SHOW MENU menuap
        restore scre from wscre01
   CASE SELBAR = 6
        save scre to wscre01
        HIDE MENU menuap
        DO ap0306
        SHOW MENU menuap
        restore scre from wscre01
   CASE SELBAR = 7
        save scre to wscre01
        HIDE MENU menuap
        DO ap0307
        SHOW MENU menuap
        restore scre from wscre01
   CASE SELBAR = 8
        save scre to wscre01
        HIDE MENU menuap
        DO ap0308
        SHOW MENU menuap
        restore scre from wscre01
   CASE SELBAR = 9
        save scre to wscre01
        HIDE MENU menuap
        DO ap0309
        SHOW MENU menuap
        restore scre from wscre01
   CASE SELBAR = 10
        save scre to wscre01
        HIDE MENU menuap
        DO ap0310
        SHOW MENU menuap
        restore scre from wscre01
   CASE SELBAR = 11
        save scre to wscre01
        HIDE MENU menuap
        DO ap0311
        SHOW MENU menuap
        restore scre from wscre01
   CASE SELBAR = 12
        save scre to wscre01
        HIDE MENU menuap
        DO ap0312
        SHOW MENU menuap
        restore scre from wscre01
   CASE SELBAR = 13
        save scre to wscre01
       *HIDE MENU menuap
        DO ap0313
       *SHOW MENU menuap
        restore scre from wscre01
   CASE SELBAR = 15
        save scre to wscre01
       *HIDE MENU menuap
        DO ap0315
       *SHOW MENU menuap
        restore scre from wscre01
   CASE SELBAR = 16
        save scre to wscre01
        *HIDE MENU menuap
        DO ap0316
        *SHOW MENU menuap
        restore scre from wscre01
   CASE SELBAR = 17
        save scre to wscre01
        HIDE MENU menuap
        DO ap0317
        SHOW MENU menuap
        restore scre from wscre01
   CASE SELBAR = 18
        save scre to wscre01
        *HIDE MENU menuap
        DO ap0318
        *SHOW MENU menuap
        restore scre from wscre01

ENDCASE
ON KEY LABEL F1
ON KEY LABEL F2
ON KEY LABEL F3
ON KEY LABEL F4
RETURN
***
PROCEDURE subap06
PARAMETERS SELBAR
DO CASE
   CASE SELBAR = 1
        save scre to wscre01
        DO ap0401
        restore scre from wscre01
   CASE SELBAR = 2
        save scre to wscre01
        DO ap0402
        restore scre from wscre01
   CASE SELBAR = 3
        save scre to wscre01
        DO ap0403
        restore scre from wscre01
ENDCASE
ON KEY LABEL F1
ON KEY LABEL F2
ON KEY LABEL F3
ON KEY LABEL F4
RETURN
***
PROCEDURE subap07
PARAMETERS SELBAR
DO CASE
   CASE SELBAR = 1
        save scre to wscre01
        DO ap0501
        restore scre from wscre01
   CASE SELBAR = 2
        save scre to wscre01
        DO ap0502
        restore scre from wscre01
   CASE SELBAR = 3
        save scre to wscre01
        DO INDICES
        restore scre from wscre01
   CASE SELBAR = 4
        save scre to wscre01
        DO COMPACTA
        restore scre from wscre01
ENDCASE
ON KEY LABEL F1
ON KEY LABEL F2
ON KEY LABEL F3
ON KEY LABEL F4
RETURN
***




