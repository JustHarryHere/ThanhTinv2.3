
# Render deployment: use the ROOT.war that is committed in this repo (no Maven build step).
FROM tomcat:10.1-jdk21-temurin
 
RUN rm -rf /usr/local/tomcat/webapps/*
COPY ROOT.war /usr/local/tomcat/webapps/ROOT.war
 
# Let Tomcat scan the JSTL jar for TLDs (avoids "Unable to get JAR resource [/jakarta.tags.core]")
RUN printf '\ntomcat.util.scan.StandardJarScanFilter.jarsToScan=jakarta.servlet.jsp.jstl-*.jar\n' >> /usr/local/tomcat/conf/catalina.properties
 
ENV PORT=8080
EXPOSE 8080
CMD ["sh", "-c", "sed -i \"s/8080/$PORT/g\" /usr/local/tomcat/conf/server.xml && catalina.sh run"]