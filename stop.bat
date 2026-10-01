@echo off
echo Stopping Apache Tomcat Server...
set "JAVA_HOME=C:\Program Files\Java\jdk-25.0.2"
set "CATALINA_HOME=C:\Program Files\apache-tomcat-11.0.26"
call "C:\Program Files\apache-tomcat-11.0.26\bin\shutdown.bat"
echo Server stopped.
