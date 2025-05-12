FROM maven:3.8.6-openjdk-8-slim AS builder

WORKDIR /app

COPY pom.xml .
COPY src ./src

RUN mvn clean package -DskipTests

FROM ghcr.io/socks-factory/openjdk-base-container:main

ENV	SERVICE_USER=myuser \
	SERVICE_UID=10001 \
	SERVICE_GROUP=mygroup \
	SERVICE_GID=10001

WORKDIR /usr/src/app
COPY --from=builder /app/target/*.jar app.jar

RUN chown -R ${SERVICE_USER}:${SERVICE_GROUP} ./app.jar

USER ${SERVICE_USER}
EXPOSE 80
ENTRYPOINT ["java", "-jar", "./app.jar", "--port=80"]
