FROM tomcat
RUN rm -fr /usr/local/tomcat/webapps/ROOT
COPY target/demo.war /usr/local/tomcat/webapps/ROOT.war
