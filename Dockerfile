FROM ianhorn/servercore:ltsc2022-python3.12.8

RUN python -m pip install --upgrade pip && \
    python -m pip install pypgstac[psycopg]  && \
    python -m pip install -e ./stac_fastapi/types[dev] && \
    python -m pip install -e ./stac_fastapi/api[dev] && \
    python -m pip install -e ./stac_fastapi/extensions[dev]

RUN choco install psql
    
WORKDIR /app

CMD ["uvicorn", "stac_fastapi.pgstac.app:app", "--host", "0.0.0.0", "--port", "8080"]