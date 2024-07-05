FROM registry.astralinux.ru/library/alse:1.7.5

ENV TZ=Europe/Moscow

ARG WEB_PACKAGE
ARG WEB_DBA_ZIP
ADD packages/$WEB_PACKAGE /tmp/
ADD packages/$WEB_DBA_ZIP /tmp/
#COPY sources.list /etc/apt/

ARG WEB_APP_DIR
ARG WEB_DBA_DIR
ARG WEB_ETC_DIR
ENV WEB_ETC_DIR $WEB_ETC_DIR
ARG WEB_ETC_CTL
ENV WEB_ETC_CTL $WEB_ETC_CTL

RUN sed -i "s/^path-exclude \/usr\/share\/doc\//path-include \/usr\/share\/doc\//" /etc/dpkg/dpkg.cfg.d/docker && \
 apt-get update && \
 apt dist-upgrade -y && \
 apt-get install -y lsb-release && \
 apt-get install -y libastraevents && \
 apt-get install -y apache2 && \
 apt-get install -y -qq /tmp/foresight-*-webserver*.deb && \
 apt-get install -y unzip && \
 apt-get clean all && \
 unzip /tmp/DBA.zip -d /opt/foresight/$WEB_DBA_DIR && \
 chown -R www-data:www-data /opt/foresight && \
 rm -f /tmp/*.deb

ADD dba/distr/webserver.conf /etc/$WEB_ETC_DIR/sites-available/webserver.conf
ADD dba/distr/PP.xml /opt/foresight/$WEB_APP_DIR/config/PP.xml
ADD dba/distr/DBA.config.json /opt/foresight/$WEB_DBA_DIR/config/DBA.config.json
ADD dba/distr/startup.sh /usr/bin/startup.sh

ARG BI_HOST
ARG BI_SERVICE
ARG FP_REPO
ARG FP_APP
ARG WEB_APP_URI
ENV WEB_APP_URI $WEB_APP_URI
ENV PATH_TO_WEB /opt/foresight/$WEB_APP_DIR
ENV PATH_TO_DBA /opt/foresight/$WEB_DBA_DIR
ENV PP_SOM http://$BI_HOST:8809/$BI_SERVICE

RUN sed -i 's/^ *# *AstraMode on/AstraMode off/g' /etc/$WEB_ETC_DIR/apache2.conf && \
 sed -i 's/^ PP_SOM=.*//g' /etc/opt/foresight/$WEB_APP_DIR/envvars && \
 echo ' PATH_TO_DBA=/opt/foresight/'$WEB_DBA_DIR >> /etc/opt/foresight/$WEB_APP_DIR/envvars && \
 echo ' PP_SOM=http://'$BI_HOST':8809/'$BI_SERVICE >> /etc/opt/foresight/$WEB_APP_DIR/envvars && \
 sed -i 's/${WEB_APP_URI}/'$WEB_APP_URI'/g' /opt/foresight/$WEB_APP_DIR/config/PP.xml && \
 sed -i 's/${BI_HOST}/'$BI_HOST'/g' /opt/foresight/$WEB_APP_DIR/config/PP.xml && \
 sed -i 's/${FP_REPO}/'$FP_REPO'/g' /opt/foresight/$WEB_APP_DIR/config/PP.xml && \
 sed -i 's/${WEB_APP_URI}/'$WEB_APP_URI'/g' /opt/foresight/$WEB_DBA_DIR/config/DBA.config.json && \
 sed -i 's/${FP_REPO}/'$FP_REPO'/g' /opt/foresight/$WEB_DBA_DIR/config/DBA.config.json && \
 sed -i 's/${FP_APP}/'$FP_APP'/g' /opt/foresight/$WEB_DBA_DIR/config/DBA.config.json

EXPOSE 8109

CMD ["/bin/bash", "-c", "/usr/bin/startup.sh"]