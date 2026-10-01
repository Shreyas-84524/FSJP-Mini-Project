@echo off
echo ========================================================
echo       Syntra Job Portal — Live Application Launcher
echo ========================================================
echo.

:: 1. Verify MySQL Service
echo [1/4] Checking MySQL Service...
sc query MySQL80 | find "RUNNING" >nul
if %ERRORLEVEL% neq 0 (
    echo Starting MySQL80 service...
    net start MySQL80
) else (
    echo MySQL80 service is already running.
)

:: 2. Build WAR with Maven
echo.
echo [2/4] Building WAR package with Maven...
call mvn clean package -DskipTests
if %ERRORLEVEL% neq 0 (
    echo [ERROR] Maven build failed. Please check the logs.
    pause
    exit /b %ERRORLEVEL%
)

:: 3. Deploy WAR to Tomcat
echo.
echo [3/4] Deploying to Apache Tomcat 11...
copy /Y "target\JobPortal.war" "C:\Program Files\apache-tomcat-11.0.26\webapps\JobPortal.war"

:: 4. Start Tomcat
echo.
echo [4/4] Starting Apache Tomcat Server...
set "JAVA_HOME=C:\Program Files\Java\jdk-25.0.2"
set "CATALINA_HOME=C:\Program Files\apache-tomcat-11.0.26"
start "Apache Tomcat - Syntra Job Portal" "C:\Program Files\apache-tomcat-11.0.26\bin\catalina.bat" run

:: 5. Open in default browser
echo.
echo ========================================================
echo  Live URL: http://localhost:8080/JobPortal/
echo ========================================================
timeout /t 3 >nul
start http://localhost:8080/JobPortal/
