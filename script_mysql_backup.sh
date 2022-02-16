#!/bin/bash
MUSER="wordpressuser"
MPASS="Tfhjvfyjdtt/86"
MDATABASE="wordpress"

echo "Dumping tables for database $MDATABASE"
for table in `mysql -u $MUSER -p$MPASS -N -e "SHOW TABLES" $MDATABASE`
do
  echo -n "  Dumping table $table ... "
  mysqldump --opt -u $MUSER -p$MPASS $MDATABASE $table > $table-`date +%Y%m%d%H%M%S`.sql
  echo "done"
done
if [ "$table" = "" ]; then
  echo "No tables found in $MDATABASE"
else
  echo "Dumping completed"
fi
#http://galaober.org.ua/node/82
