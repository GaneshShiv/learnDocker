FROM openjdk:11
EXPOSE 8080
ADD target/learndocker-0.0.1-SNAPSHOT.jar learndocker-0.0.1-SNAPSHOT.jar
ENTRYPOINT ["java","-jar","/learndocker-0.0.1-SNAPSHOT.jar"] 