#!/bin/bash

XNUM=987
XARG="-screen 0 1920x1080x24 -ac -dpi 96 +extension GLX +render"

if [ "$1" == "-g" ]; then
  WRAP="gdb"
elif [ "$1" == "-s" ]; then
  WRAP="strace -f -o strace.log"
elif [ "$1" == "-vmem" ]; then
  WRAP="valgrind -v --tool=memcheck --log-file=valgrind.log --error-limit=no --track-origins=yes --leak-check=no --show-reachable=yes --trace-signals=yes --track-fds=yes --malloc-fill=0x99 --free-fill=0x77"
elif [ "$1" == "-vhg" ]; then
  WRAP="valgrind -v --tool=helgrind --log-file=helgrind.log --error-limit=no --num-callers=40"
elif [ "$1" == "-vdrd" ]; then
  WRAP="valgrind -v --tool=drd --log-file=drd.log"
elif [ "$1" == "-vmas" ]; then
  WRAP="valgrind -v --tool=massif --log-file=massif.log --depth=30 --threshold=1.0 --ignore-fn='QByteArray::resize(int)'"
fi

# BI audit user
echo && echo Set BI audit user...
if [ "$FP_RELEASE" == "10" ]; then
  xvfb-run -l -n $XNUM -s "$XARG" $WRAP /opt/foresight/$BI_OPT_DIR/bin/PP.Util /cau $FP_REPO $FP_USER $FP_USER $FP_USER_AUDIT $FP_USER_AUDIT
elif [ "$FP_RELEASE" == "9" ]; then
  psql -h $DB_HOST -d $FP_REPO -U $FP_USER -w -c "GRANT SELECT ON TABLE $FP_REPO_SCHEMA.b_jlo TO \"$FP_USER_AUDIT\";"
  psql -h $DB_HOST -d $FP_REPO -U $FP_USER -w -c "insert into md.b_sec_dat (vs, dat, id) values('$FP_USER_AUDIT', 1, 'AUDITOR');"
fi
xvfb-run -l -n $XNUM -s "$XARG" $WRAP /opt/foresight/$BI_OPT_DIR/bin/PP.Util /sac /DC $FP_USER_AUDIT $FP_USER_AUDIT

# BI cache tables user
echo && echo Set BI cache tables user...
xvfb-run -l -n $XNUM -s "$XARG" $WRAP /opt/foresight/$BI_OPT_DIR/bin/PP.Util /sc $FP_REPO $FP_USER $FP_USER "MBCACHE"

# BI repository
echo && echo Set BI repositories...
xvfb-run -l -n $XNUM -s "$XARG" $WRAP /opt/foresight/$BI_OPT_DIR/bin/RepoManager -ocreate-repo -tpostgres -s$DB_HOST -d$FP_REPO -m$FP_REPO_SCHEMA -u$FP_USER -w$FP_USER -f/opt/foresight/$BI_OPT_DIR/bin/current.rm4 -i
cd /usr/bin
python3 -m repos_to_config "/repositories" "/opt/foresight/"$BI_CFG_DIR"/registry.reg" "/opt/foresight/"$BI_CFG_DIR

# BI-server start
echo && echo Start BI...
xvfb-run -l -n $XNUM -s "$XARG" $WRAP /usr/local/sbin/$BI_ETC_CTL -D FOREGROUND -d /etc/$BI_ETC_DIR/
