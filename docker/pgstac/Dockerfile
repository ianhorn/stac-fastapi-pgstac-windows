FROM sokigo/postgis-windows:15-3.4-2022 as base

# # initialize db
RUN initdb -D C:/pgsql/data

# Set environment variables for PostgreSQL
ENV POSTGRES_DB=postgis \
    POSTGRES_USER=postgres \
    POSTGRES_PASSWORD=postgres

# Copy initialization scripts
COPY init.sql /docker-entrypoint-initdb.d/init.sql
COPY pgstac.sql /docker-entrypoint-initdb.d/pgstac.sql


CMD ["cmd", "/c", "pg_ctl start -D C:/pgsql/data && timeout /t 10 && psql -U postgres -d postgis]