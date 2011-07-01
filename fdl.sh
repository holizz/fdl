#!/bin/sh

set -e

[ X$1 = X ] && echo 'Usage: fdl.sh USERNAME' && exit 1

USER=$1

# End case: 302 Found
URL=http://www.flickr.com/photos/%s/page%d/
PICURL=http://www.flickr.com/photos/%s/%s/sizes/o/

N=1
while true; do
  U=`printf $URL $USER $N`
  STATUS=`curl -I $U 2>/dev/null | head -n1 | cut -d' ' -f2`
  [ $STATUS = 302 ] && break
  echo $U

  curl $U 2>/dev/null | grep '<a name="photo' | cut -d'"' -f2 | cut -b 6-

  N=`dc  -e "$N 1 + p"`
done
