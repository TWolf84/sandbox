ARG ASTRA_LINUX
FROM $ASTRA_LINUX

# 1. Базовое ПО
ENV TZ=Europe/Moscow

COPY packages/sources.list /etc/apt/

RUN sed -i "s/^path-exclude \/usr\/share\/doc\//path-include \/usr\/share\/doc\//" /etc/dpkg/dpkg.cfg.d/docker && \
 apt-get update && \
 apt dist-upgrade -y && \
 apt-get install -y lsb-release && \
 apt-get install -y libastraevents && \
 apt-get install -y apache2 && \
 apt-get install -y unzip && \
 apt-get clean all

# 2. Дополнительное ПО: ФАП и пр.
ARG FP_RELEASE
ARG FP_PACKAGE
ARG OLD_DBA_ZIP=DBA.war
ARG OLD_DBA_DIR=fp$FP_RELEASE.x-dba_ang
ADD packages/$FP_PACKAGE/foresight-fp$FP_RELEASE.x-webserver*.deb /tmp/
ADD packages/$FP_PACKAGE/foresight-fp$FP_RELEASE.x-dba*.deb /tmp/
ADD packages/$FP_PACKAGE/$OLD_DBA_ZIP /tmp/
RUN apt-get install -y -qq /tmp/foresight-*-webserver*.deb && \
 apt-get install -y -qq /tmp/foresight-*-dba*.deb && \
 apt-get clean all && \
 unzip /tmp/$OLD_DBA_ZIP -d /opt/foresight/$OLD_DBA_DIR && \
 chown -R www-data:www-data /opt/foresight && \
 rm -f /tmp/*.deb

# 3. Настройка конфигурации
ARG WEB_APP_DIR=fp$FP_RELEASE.x-webserver
ARG WEB_ETC_DIR=apache2-fp$FP_RELEASE.x-web
ENV WEB_ETC_DIR $WEB_ETC_DIR
ARG WEB_ETC_CTL=apache2ctl-fp$FP_RELEASE.x-web
ENV WEB_ETC_CTL $WEB_ETC_CTL
ARG DBA_APP_DIR=fp$FP_RELEASE.x-dba

ADD dba/distr/webserver.conf /etc/$WEB_ETC_DIR/sites-available/webserver.conf
ADD dba/distr/PP.xml /opt/foresight/$WEB_APP_DIR/config/PP.xml
ADD dba/distr/r.config.json /opt/foresight/$WEB_APP_DIR/r/config/config.json
ADD dba/distr/dba.config.json /opt/foresight/$DBA_APP_DIR/config/config.json
ADD dba/distr/dba_ang.config.json /opt/foresight/$OLD_DBA_DIR/config/DBA.config.json
ADD dba/distr/startup.sh /usr/bin/startup.sh

ARG BI_HOST
ENV BI_HOST $BI_HOST
ARG BI_PORT
ARG BI_PORT_WS
ENV BI_PORT_WS $BI_PORT_WS
ARG BI_SERVICE=FPBI_App_v$FP_RELEASE.x/axis2/services/PP.SOM.Som
ARG FP_REPO
ARG FP_APP
ARG WEB_APP_URI=fp$FP_RELEASE.x
ENV WEB_APP_URI $WEB_APP_URI
ENV PATH_TO_WEB /opt/foresight/$WEB_APP_DIR
ENV PATH_TO_DBA /opt/foresight/$DBA_APP_DIR
ENV PATH_TO_DBA_ANG /opt/foresight/$OLD_DBA_DIR
ENV PP_SOM http://$BI_HOST:$BI_PORT/$BI_SERVICE
ARG WEB_PORT
ENV WEB_PORT $WEB_PORT
ARG WEB_PORT_WS
ENV WEB_PORT_WS $WEB_PORT_WS

RUN sed -i 's/^ *# *AstraMode on/AstraMode off/g' /etc/$WEB_ETC_DIR/apache2.conf && \
 echo 'Listen '$WEB_PORT_WS >> /etc/$WEB_ETC_DIR/ports.conf && \
 sed -i 's/^ PP_SOM=.*//g' /etc/opt/foresight/$WEB_APP_DIR/envvars && \
 echo ' PATH_TO_DBA_ANG=/opt/foresight/'$OLD_DBA_DIR >> /etc/opt/foresight/$WEB_APP_DIR/envvars && \
 echo ' PP_SOM=http://'$BI_HOST':'$BI_PORT'/'$BI_SERVICE >> /etc/opt/foresight/$WEB_APP_DIR/envvars && \
 sed -i 's/${WEB_APP_URI}/'$WEB_APP_URI'/g' /opt/foresight/$WEB_APP_DIR/r/config/config.json && \
 sed -i 's/${FP_REPO}/'$FP_REPO'/g' /opt/foresight/$WEB_APP_DIR/r/config/config.json && \
 sed -i 's/${WEB_PORT_WS}/'$WEB_PORT_WS'/g' /opt/foresight/$WEB_APP_DIR/r/config/config.json && \
 sed -i 's/${WEB_APP_URI}/'$WEB_APP_URI'/g' /opt/foresight/$WEB_APP_DIR/config/PP.xml && \
 sed -i 's/${FP_REPO}/'$FP_REPO'/g' /opt/foresight/$WEB_APP_DIR/config/PP.xml && \
 sed -i 's/${WEB_APP_URI}/'$WEB_APP_URI'/g' /opt/foresight/$DBA_APP_DIR/config/config.json && \
 sed -i 's/${FP_REPO}/'$FP_REPO'/g' /opt/foresight/$DBA_APP_DIR/config/config.json && \
 sed -i 's/${FP_APP}/'$FP_APP'/g' /opt/foresight/$DBA_APP_DIR/config/config.json && \
 sed -i 's/${WEB_PORT_WS}/'$WEB_PORT_WS'/g' /opt/foresight/$DBA_APP_DIR/config/config.json && \
 sed -i 's/${WEB_APP_URI}/'$WEB_APP_URI'/g' /opt/foresight/$OLD_DBA_DIR/config/DBA.config.json && \
 sed -i 's/${FP_REPO}/'$FP_REPO'/g' /opt/foresight/$OLD_DBA_DIR/config/DBA.config.json && \
 sed -i 's/${FP_APP}/'$FP_APP'/g' /opt/foresight/$OLD_DBA_DIR/config/DBA.config.json && \
 sed -i -e 's/\r$//' /usr/bin/startup.sh

EXPOSE $WEB_PORT
EXPOSE $WEB_PORT_WS

CMD ["/bin/bash", "-c", "/usr/bin/startup.sh"]