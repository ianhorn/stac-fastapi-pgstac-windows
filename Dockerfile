FROM ianhorn/nanoserver:ltsc2022-1.0.2

RUN python -m pip install --no-cache-dir --user --upgrade pip && \
    python -m pip install pypgstac[psycopg]  && \
    python -m pip install -e ./stac_fastapi/types[dev] && \
    python -m pip install -e ./stac_fastapi/api[dev] && \
    python -m pip install -e ./stac_fastapi/extensions[dev]

# Commenting out to just copy folder instead.
    # RUN mkdir C:\pgsql && \
#     C:\Powershell\pwsh.exe -Command \
#     "Invoke-WebRequest -Uri "https://get.enterprisedb.com/postgresql/postgresql-16.1-1-windows-x64-binaries.zip" -OutFile "C:\temp\psql.zip; \
#     Expand-Archive -Path C:\temp\psql.zip -Destination pgsql; \
#     Move-Item C:\pgsql\pgsql -Destination C:\pgsql; \
#     Remove-Item C:\Temp\psql.zip"

ENV PATH="c:/pgsql/bin:${PATH}"
WORKDIR /app

CMD ["uvicorn", "stac_fastapi.pgstac.app:app", "--host", "0.0.0.0", "--port", "8080"]