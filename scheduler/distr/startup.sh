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
xvfb-run -l -n $XNUM -s "$XARG" $WRAP /opt/foresight/$BI_OPT_DIR/bin/PP.Util /sac /scope hklm "$DB_HOST|POSTGRES" $FP_USER_AUDIT $FP_USER_AUDIT

# Scheduler service start
echo && echo Start Scheduler...
cd /opt/foresight/$BI_OPT_DIR/bin
xvfb-run -l -n $XNUM -s "$XARG" $WRAP /opt/foresight/$BI_OPT_DIR/bin/Scheduler -p /run/scheduler