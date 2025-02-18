ARG POSTGIS=sokigo/postgis-windows:15-3.4-2022

FROM ${POSTGIS} as dbase

COPY . .

RUN setup-db.bat

CMD ["cmd", "/c", "pg_ctl", "-D", "C:/data/pgdata", "-l", "logfile", "start"]