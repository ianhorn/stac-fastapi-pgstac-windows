@echo off
echo Creating database and running pgstac.sql. . . 

REM start 
pg_ctl -D C:/data/pgdata l logfile start

REM set possword
set PGPASSWORD=postgres
REM Create the postgis database
psql -U postgres -c "CREATE DATABASE postgis;"

REM Create postgis user
psql -U postgres -d postgis -c "CREATE USER postgis WITH PASSWORD 'postgis';"

REM run the sql file
psql -U postgres -d postgis -f C:/pgstac.sql

echo Database setup complete 

REM CMD ["cmd", "/c", "pg_ctl", "-D", "C:/data/pgdata", "l", "logfile", "start"]
