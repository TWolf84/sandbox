ARG ASTRA_LINUX
FROM $ASTRA_LINUX

ENV TZ=Europe/Moscow

#ADD packages/libpq5*.deb /tmp/
COPY packages/sources.list /etc/apt/

RUN sed -i "s/^path-exclude \/usr\/share\/doc\//path-include \/usr\/share\/doc\//" /etc/dpkg/dpkg.cfg.d/docker && \
 apt-get update && \
 apt dist-upgrade -y && \
 apt-get install -y lsb-release && \
 apt-get install -y locales && \
 apt-get install -y strace && \
 apt-get install -y libx11-6 && \
 #apt-get install -y libgl1-mesa-glx && \
 apt-get install -y libglu1-mesa && \
 apt-get install -y libopengl0 && \
 apt-get install -y libgomp1 && \
 apt-get install -y libxi6 && \
 apt-get install -y libxcursor1 && \
 apt-get install -y libxrandr2 && \
 apt-get install -y libxrender1 && \
 apt-get install -y libxinerama1 && \
 apt-get install -y fontconfig && \
 apt-get install -y fonts-liberation && \
 apt-get install -y xvfb && \
 apt-get install -y libastraevents && \
 apt-get install -y libcups2 && \
 apt-get install -y libqt5gui5 && \
 apt-get install -y libqt5opengl5 && \
 apt-get install -y libqt5printsupport5 && \
 apt-get install -y qt5-image-formats-plugins && \
 apt-get install -y libatomic1 && \
 apt-get install -y libtiff5 && \
 apt-get install -y libjpeg62-turbo && \
 apt-get install -y postgresql-client && \
    #apt-get install -y -qq /tmp/libpq5*.deb && \
 apt-get install -y nano && \
 apt-get install -y less && \
 apt-get install -y python3-pip && \
 apt-get clean all && \
 pip3 install PyYAML && \
 rm -f /tmp/*

ARG FP_PACKAGE
ARG FP_RELEASE
ADD packages/$FP_PACKAGE/foresight-fp$FP_RELEASE.x-biserver*.deb /tmp/
ADD packages/$FP_PACKAGE/foresight-libgit2-*.deb /tmp/

RUN sed -i "s/^path-exclude \/usr\/share\/doc\//path-include \/usr\/share\/doc\//" /etc/dpkg/dpkg.cfg.d/docker && \
 apt-get install -y apache2 && \
 apt-get install -y git && \
 apt-get install -y -qq /tmp/foresight-*-biserver*.deb && \
 apt-get install -y -qq /tmp/foresight-libgit2-*.deb && \
 apt-get clean all && \
 echo "ru_RU.UTF-8 UTF-8" >> /etc/locale.gen && \
 echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen && \
 locale-gen && \
 update-locale ru_RU.UTF-8

ADD packages/clickhouse-odbc-1.2.1-Linux.tar.gz /tmp/
ADD packages/libicudata.so.50 /usr/local/lib
ADD packages/libicuuc.so.50 /usr/local/lib
RUN apt-get install -y openssl unixodbc && \
 cp -r /tmp/clickhouse-odbc-1.2.1-Linux/* /usr/local && \
 odbcinst -i -d -f /usr/local/share/doc/clickhouse-odbc/config/odbcinst.ini.sample && \
 odbcinst -i -s -l -f /usr/local/share/doc/clickhouse-odbc/config/odbc.ini.sample && \
 rm -rf /tmp/*

ARG BI_OPT_DIR
ENV BI_OPT_DIR $BI_OPT_DIR
ARG BI_ETC_DIR
ENV BI_ETC_DIR $BI_ETC_DIR
ARG BI_ETC_CTL
ENV BI_ETC_CTL $BI_ETC_CTL
ARG BI_RM4_RES

ADD packages/$BI_RM4_RES /opt/foresight/$BI_OPT_DIR/bin/current.rm4
ADD scripts/xvfb-run /usr/bin/
ADD bi/distr/lsmon /usr/bin/lsmon

ARG BI_CFG_REG
ENV BI_CFG_REG $BI_CFG_REG
ARG FP_RELEASE
ENV FP_RELEASE $FP_RELEASE

#ADD bi/distr/registry.reg /opt/foresight/$BI_CFG_REG/registry.reg
ADD bi/distr/project.tpl /opt/foresight/$BI_CFG_REG/project.tpl
ADD bi/distr/host.tpl /opt/foresight/$BI_CFG_REG/host.tpl

RUN ln -sf /usr/lib/x86_64-linux-gnu/libpq.so.5 /opt/foresight/$BI_OPT_DIR/bin/libpq.so && \
    ln -sf /usr/lib/x86_64-linux-gnu/libodbc.so.1 /opt/foresight/$BI_OPT_DIR/bin/libodbc.so && \
    ln -sf /opt/foresight/libgit2/lib/libgit2.so /opt/foresight/$BI_OPT_DIR/bin/libgit2.so && \
#    sed -i 's/${FP_RELEASE}/'$FP_RELEASE'/g' /opt/foresight/$BI_CFG_REG/registry.reg && \
#    sed -i 's/${FP_REPO}/'$FP_REPO'/g' /opt/foresight/$BI_CFG_REG/registry.reg && \
#    sed -i 's/${FP_REPO_SCHEMA}/'$FP_REPO_SCHEMA'/g' /opt/foresight/$BI_CFG_REG/registry.reg && \
#    sed -i 's/${DB_HOST}/'$DB_HOST'/g' /opt/foresight/$BI_CFG_REG/registry.reg && \
#    sed -i 's/${SS_HOST}/'$SS_HOST'/g' /opt/foresight/$BI_CFG_REG/registry.reg && \
#    sed -i 's/${BI_PORT_WS}/'$BI_PORT_WS'/g' /opt/foresight/$BI_CFG_REG/registry.reg && \
    sed -i 's/${FP_RELEASE}/'$FP_RELEASE'/g' /opt/foresight/$BI_CFG_REG/project.tpl && \
    sed -i 's/${FP_RELEASE}/'$FP_RELEASE'/g' /opt/foresight/$BI_CFG_REG/host.tpl && \
    sed -i 's/^ *# *AstraMode on/AstraMode off/g' /etc/$BI_ETC_DIR/apache2.conf && \
    echo 'export LANG=ru_RU.UTF-8' >> /etc/$BI_ETC_DIR/envvars && \
    echo 'export LC_ALL=ru_RU.UTF-8' >> /etc/$BI_ETC_DIR/envvars && \
    chown -R www-data:www-data /opt/foresight && \
    ln -sf /proc/self/fd/1 /var/log/$BI_ETC_DIR/access.log && \
    ln -sf /proc/self/fd/1 /var/log/$BI_ETC_DIR/error.log && \
    sed -i -e 's/\r$//' /usr/bin/xvfb-run && \
    chmod +x /usr/bin/lsmon

ARG BI_CFG_XML
ENV BI_CFG_XML $BI_CFG_XML
ARG FP_USER
ENV FP_USER $FP_USER
ARG FP_REPO
ENV FP_REPO $FP_REPO
ARG FP_REPO_SCHEMA
ENV FP_REPO_SCHEMA $FP_REPO_SCHEMA
ARG DB_HOST
ENV DB_HOST $DB_HOST
ARG FP_USER_AUDIT
ENV FP_USER_AUDIT $FP_USER_AUDIT
ENV PGPASSWORD $FP_USER
ARG SS_HOST
ARG BI_PORT_WS
ENV BI_PORT_WS $BI_PORT_WS

ADD scripts/repos_to_config.py /usr/bin/
ADD bi/distr/settings.xml /opt/foresight/$BI_CFG_XML/settings.xml
ADD bi/distr/metabases.xml /opt/foresight/$BI_CFG_XML/Metabases.xml
RUN sed -i 's/${SS_HOST}/'$SS_HOST'/g' /opt/foresight/$BI_CFG_XML/settings.xml && \
    sed -i 's/${BI_PORT_WS}/'$BI_PORT_WS'/g' /opt/foresight/$BI_CFG_XML/settings.xml && \
    sed -i 's/${FP_REPO}/'$FP_REPO'/g' /opt/foresight/$BI_CFG_XML/Metabases.xml && \
    sed -i 's/${FP_REPO_SCHEMA}/'$FP_REPO_SCHEMA'/g' /opt/foresight/$BI_CFG_XML/Metabases.xml && \
    sed -i 's/${DB_HOST}/'$DB_HOST'/g' /opt/foresight/$BI_CFG_XML/Metabases.xml

ADD bi/distr/startup.sh /usr/bin/
RUN sed -i -e 's/\r$//' /usr/bin/startup.sh

ARG BI_PORT
EXPOSE $BI_PORT

# Uncomment some lines below (with export) to extend log
# Extended debug log (stderr)
ENV PP_LOG 1
ENV PP_LOGTIME 1
ENV PP_LOGDATE 1

# Not implemented calls (BREAK for SIGTRAP)
#ENV PP_NOIMPLBREAK 1
# Gdiplus debug info
#ENV PP_GDIPLUS 1
# Rtf debug info
#ENV PP_RTF 1
# COM debug info (example value: nounknown;noreturn;noconsole;noparams;@<PATH_TO_LOG>)
#ENV PP_COM_DEBUG 1
# Fore native calls
#ENV PP_TRACEFORE 1
# No check DISPLAY on start
#ENV PP_NODISPLAY 1
ENV CURLOPT_VERBOSE 1
ENV PP_RETMEM 1
ENV MALLOC_MMAP_THRESHOLD_ 8192
ENV PP_RETMEM_CO 1
ENV LANG ru_RU.UTF-8

CMD ["/bin/bash", "-c", "/usr/bin/startup.sh"]