#!/bin/sh

set -e

[ X$1 = X ] && echo 'Usage: fdl.sh USERNAME' && exit 1

USER=$1

# End case: 302 Found
URL=http://www.flickr.com/photos/%s/page%d/
PICURL=http://www.flickr.com/photos/%s/%s/sizes/o/

N=0
while true; do
  N=`expr $N + 1`
  U=`printf $URL $USER $N`
  STATUS=`curl -I $U 2>/dev/null | head -n1 | cut -d' ' -f2`
  [ $STATUS = 302 ] && break
  echo $U >&2

  PHOTOS=`curl $U 2>/dev/null | grep '<a name="photo' | cut -d'"' -f2 | cut -b 6-`

  for I in $PHOTOS; do
    LARGESTPAGE=`printf $PICURL $USER $I`
    echo $LARGESTPAGE >&2
    LARGESTCDN=`curl -A $I -L "$LARGESTPAGE" 2>/dev/null | grep -B1 'Download the' | head -n1 | cut -d'"' -f2`
    echo $LARGESTCDN >&2
    wget -c $LARGESTCDN
  done
done
