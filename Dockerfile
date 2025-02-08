FROM ianhorn/stac-fastapi-windows:servercore-ltsc2022-1.0.1

# WORKDIR C:/app

COPY stac_fastapi/pgstac/ C:/app/stac_fastapi/

RUN python -m pip install uvicorn

RUN python -m pip install stac-fastapi.pgstac

ENV POSTGRES_USER=postgres \
    POSTGRES_PASS=postgres \
    POSTGRES_HOST_READER=localhost \
    POSTGRES_HOST_WRITER=localhost \
    POSTGRES_PORT=5432 \
    POSTGRES_DBNAME=postgis

CMD ["uvicorn", "stac_fastapi.pgstac.app:app", "--host", "0.0.0.0", "--port", "8080"]