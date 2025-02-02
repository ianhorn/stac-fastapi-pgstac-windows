FROM ianhorn/nanoserver:1.0.0

RUN python -m pip install --no-cache-dir --user --upgrade pip && \
    python -m pip install pypgstac[psycopg]  && \
    python -m pip install -e ./stac_fastapi/types[dev] && \
    python -m pip install -e ./stac_fastapi/api[dev] && \
    python -m pip install -e ./stac_fastapi/extensions[dev]
