# Bước 1: Build file WAR bằng Maven (JDK 21 cho build — xem lý do bên dưới)
FROM maven:3.9-eclipse-temurin-21 AS build
WORKDIR /app
COPY . .
RUN mvn clean package -DskipTests

# Bước 2: Chạy ứng dụng bằng Tomcat 10 (hỗ trợ jakarta.servlet)
FROM tomcat:10.1-jdk21-temurin

RUN rm -rf /usr/local/tomcat/webapps/*
COPY --from=build /app/target/*.war /usr/local/tomcat/webapps/ROOT.war

# Cho phép Tomcat quét TLD trong jar JSTL (tránh lỗi "Unable to get JAR resource [/jakarta.tags.core]")
RUN printf '\ntomcat.util.scan.StandardJarScanFilter.jarsToScan=jakarta.servlet.jsp.jstl-*.jar\n' >> /usr/local/tomcat/conf/catalina.properties

ENV PORT=8080
EXPOSE 8080
CMD ["sh", "-c", "sed -i \"s/8080/$PORT/g\" /usr/local/tomcat/conf/server.xml && catalina.sh run"]