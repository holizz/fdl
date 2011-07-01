#!/bin/sh

set -e

USER=$1

# End case: 302 Found
URL=http://www.flickr.com/photos/%s/page%d/
PICURL=http://www.flickr.com/photos/%s/%s/sizes/o/

N=1
while true; do
  U=`printf $URL $USER $N`
  echo $U

  STATUS=`curl -I $U 2>/dev/null | head -n1 | cut -d' ' -f2`
  [ $STATUS = 302 ] && break

  N=`dc  -e "$N 1 + p"`
done
