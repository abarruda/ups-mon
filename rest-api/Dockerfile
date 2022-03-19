FROM openjdk:11-slim

RUN apt-get update && apt-get install -y \
	git \
	maven

RUN git clone https://github.com/abarruda/jNut jnut
WORKDIR jnut
RUN git checkout feature/jnut-0.3-SNAPSHOT
RUN mvn install

# The javax.* package has been renamed to jakarta.* package since Jakarta EE version 9. This thus means that the deployed web application is actually not compatible with Jakarta EE version 9. The deployed web application is most likely developed for an older JEE version where the javax.* package is still used.
# Downgrade Tomcat to version 9.x. This is the latest available version which still uses the javax.* package.
# (https://stackoverflow.com/questions/66711660/tomcat-10-x-throws-java-lang-noclassdeffounderror-on-javax-servlet)

FROM tomcat:9-slim

COPY --from=0 /jnut/jNutWebAPI/target/jNutWebAPI-0.3-SNAPSHOT.war /usr/local/tomcat/webapps/jnut.war
	
RUN apt-get update && apt-get install -y \
	nut \
	nut-client \
	nut-server

COPY entrypoint.sh /entrypoint.sh

CMD /entrypoint.sh
