@echo off
chcp 65001 > nul
setlocal EnableDelayedExpansion

REM Leer el título del juego desde el archivo titulo.txt y establecerlo como título de la ventana del terminal

if exist titulo.txt (
    set /p game_title=<titulo.txt
    title !game_title!
) else (
    title Juego de Aventura
    echo Título del juego no encontrado.
)

REM Iniciar el juego en el escenario 1
call :mostrar_escenario 1
goto :eof

:establecer_ambiente
REM Cambia el color de la consola según el ambiente
if "%~1"=="Oscuro" (
    color 08
) else if "%~1"=="Muy soleado" (
    color F6
) else if "%~1"=="Poco soleado" (
    color E0
) else if "%~1"=="Victoria" (
    color 2F
    echo ¡VICTORIA!
    goto :eof
) else if "%~1"=="Derrota" (
    color 4F
    echo Has sido derrotado.
    goto :eof
) else (
    echo Ambiente no reconocido: "%~1"
)
goto :eof

:mostrar_escenario
REM Limpia la consola y muestra los detalles del escenario
cls

REM Establecer el ambiente
set "escenario_path=%~1"
if not exist "!escenario_path!\ambiente.txt" (
    echo Error: El archivo de ambiente no se encuentra en el escenario "!escenario_path!".
    goto :eof
)
set /p ambiente=<"!escenario_path!\ambiente.txt"
call :establecer_ambiente "!ambiente!"

REM Mostrar la descripción del escenario
if not exist "!escenario_path!\escenario.txt" (
    echo Error: El archivo de escenario no se encuentra en el escenario "!escenario_path!".
    goto :eof
)
type "!escenario_path!\escenario.txt"
echo.

REM Verificar si hay opciones disponibles
if not exist "!escenario_path!\opciones.txt" (
    echo Error: El archivo de opciones no se encuentra en el escenario "!escenario_path!".
    goto :eof
)

:pedir_opcion
echo Opciones disponibles:
echo.
type "!escenario_path!\opciones.txt"
echo.
echo.
echo Selecciona una opción (el número) y presiona Enter:
set /p opcion=
set "opcion_valida=false"

REM Extraer el número del escenario correspondiente a la opción seleccionada
for /f "tokens=1,* delims= " %%a in ('type "!escenario_path!\opciones.txt"') do (
    if "%%a"=="!opcion!" (
        set "escenario_siguiente=%%a"
        set "opcion_valida=true"
        goto :cargar_escenario
    )
)

if not "!opcion_valida!"=="true" (
    echo Opción no válida, intenta nuevamente.
    goto :pedir_opcion
)

:cargar_escenario
call :mostrar_escenario !escenario_siguiente!

:eof
endlocal
