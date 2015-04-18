#~/bin/bash

echo $1 | awk '{print strftime("%c",$1)}'
