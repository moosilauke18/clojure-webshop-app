FROM clojure:openjdk-11-lein-slim-buster AS build
COPY . /usr/src/app
WORKDIR /usr/src/app
RUN lein uberjar
RUN apt-get update && apt-get install -y curl && curl -L https://github.com/signalfx/splunk-otel-java/releases/latest/download/splunk-otel-javaagent-all.jar \
    -o splunk-otel-javaagent.jar

FROM openjdk:11-jre-slim
WORKDIR /usr/src/app
COPY --from=build /usr/src/app/target/uberjar/*-standalone.jar ./app.jar

COPY --from=build /usr/src/app/splunk-otel-javaagent.jar ./splunk-otel-javaagent.jar

CMD ["java", "-jar", "app.jar"]
