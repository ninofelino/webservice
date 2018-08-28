#!/bin/sh
export PGPASSWORD=nuansabaru123
psql -h localhost -d felino -U deploy -p 5432 -a -q -f /var/www/html/api/script/inv.sql
