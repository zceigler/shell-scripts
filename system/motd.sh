#!/bin/bash
# Zac's Server MOTD

MEMAVG=`free | awk '/Mem/{printf("used: %.2f%"), $3/$2*100} /buffers\/cache/{printf(", buffers: %.2f%"), $4/($3+$4)*100} /Swap/{printf(", swap: %.2f%"), $3/$2*100}' | sed 's/used/Used/g' | sed 's/buffers/Buffers/g' | sed 's/swap/Swap/g'`
PSA=`ps -Afl | wc -l`

#System uptime
uptime=`cat /proc/uptime | cut -f1 -d.`
upDays=$((uptime/60/60/24))
upHours=$((uptime/60/60%24))
upMins=$((uptime/60%60))
upSecs=$((uptime%60))

echo "
===========================================================================
 - Hostname............: `uname -n`
 - Public IP...........: `dig +short myip.opendns.com @resolver1.opendns.com`
 - Users...............: Currently `users | wc -w` user(s) logged on
 - System Uptime.......: $upDays days, $upHours hours, $upMins minutes, $upSecs seconds
===========================================================================
 - Disk Space..........: `df -h | grep xvda | awk '{print $3 " / " $2 " (" $5 ")"}' | sed 's/G/ GB/g'`
 - Memory Usage........: $MEMAVG
 - Load Average........: `cat /proc/loadavg`
 - Processes...........: $PSA running
===========================================================================
 - CPU.................: `cat /proc/cpuinfo | grep "model name" | uniq | sed 's/.*: //g'`
 - Release.............: `cat /etc/redhat-release`
 - Kernel..............: `uname -r`
 - Architecture........: `uname -m`
===========================================================================
 -------- __@       __@       __@       __@       __@       __@       __@
 -----  _`\<,_    _`\<,_    _`\<,_    _`\<,_    _`\<,_    _`\<,_    _`\<,_
 ----  (*)/ (*)  (*)/ (*)  (*)/ (*)  (*)/ (*)  (*)/ (*)  (*)/ (*)  (*)/ (*)
===========================================================================
" > /etc/motd

