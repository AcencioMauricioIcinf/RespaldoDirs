@Echo off
SETLOCAL ENABLEDELAYEDEXPANSION

rem El siguiente es un script que realiza respaldos de tanto directorios espec�ficos selectos por el usuario como bases de datos de MS SQL Server
rem Los respaldos se realizan en un �rbol de carpetas organizados por a�o y mes
rem Este sistema de respaldos ser� conjuntamente copiado a un servidor externo

rem ---INDICACIONES---
rem Indique aqu�, en la variable base_dir, el directorio base en donde desea almacenar los respaldos realizados
set base_dir="C:\Los respaldos"
rem IMPORTANTE: Deje siempre las comillas
rem Ahora, al ejecutar este archivo, Incluya como par�metros los nombres de las bases de datos y/o las RUTAS ABSOLUTAS de las carpetas que desea respaldar

rem ---IMPORTANTE---
rem Para el respaldo de bases de datos de SQL Server, se utiliza la utilidad sqlcmd
rem Se REQUIERE utilizar la RUTA ABSOLUTA del ejecutable de sqlcmd (almacenada en la siguiente variable por conveniencia) para el buenfuncionamiento del script
rem Si lo siguiente no coincide con la ubicaci�n de sqlcmd en su m�quina, c�mbielo por la ruta correcta 
set sqlc="C:\Program Files\Microsoft SQL Server\Client SDK\ODBC\130\Tools\Binn\SQLCMD.EXE"

rem Utiliza script VB aparte para obtener la fecha del sistema en un formato predecible y consistente.
rem Esto para evitar diferencias en formatos al llamar a la variable %date% de cmd en distintas configuraciones regionales.
For /f %%G in ('cscript /nologo getdate.vbs') do set _dtm=%%G
Set year=%_dtm:~0,4%
Set month=%_dtm:~4,2%
Set day=%_dtm:~6,2%
rem Adicionalmente, se extrae el a�o, mes y d�a de la fecha

rem Se cambia el n�mero del mes por su nombre
set month-num=%month%
IF "%month-num:~0,1%"=="0" SET month-num=%month-num:~1%
FOR /f "tokens=%month-num%" %%a in ("Enero Febrero Marzo Abril Mayo Junio Julio Agosto Septiembre Octubre Noviembre Diciembre") do set mo-name=%%a

rem Se crea el �rbol de directorios organizados seg�n a�o y mes
set path="%base_dir:~1,-1%\%year%\%mo-name%"
mkdir %path%

rem Se prepara el formato del nombre del directorio a copiar
set formato=%day%%month%%year:~2%

rem Se iteran los par�metros del script, estrayendo la ruta y nombre, en el caso de carpetas
rem Se verifica cada par�metro si es una carpeta, de no ser as�, se busca como nombre de una base de datos
FOR %%G IN (%*) DO (
    set source=%%G
    set name=%%~nG
    FOR %%i IN (!source!) DO IF EXIST %%~si\NUL set dirpath=%path%\copia_!name!_%formato% & mkdir !dirpath! & start xcopy !source! !dirpath! /s/c/y/e/i
    IF NOT EXIST !source! %sqlc% -S DESKTOP-AJG6NBE\SQLEXPRESS -i resp.sql -v database="!name!" folder="%path:~1,-1%/"
)
pause