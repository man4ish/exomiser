#! /bin/bash

if [[ $# -lt 1 ]]; then
	echo usage: run-exomiser.sh input.yml
	exit 1
fi
YAML=$1

EXOMISER=/software/exomiser/exomiser-cli-12.1.0
JAR=${EXOMISER}/exomiser-cli-12.1.0.jar
PROPS=${EXOMISER}/b38.application.properties

JAVA=/software/java/java8/bin/java

$JAVA -Xms8g -Xmx32g -jar $JAR --analysis $YAML --spring.config.location=$PROPS
