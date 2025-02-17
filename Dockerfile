FROM mcr.microsoft.com/windows-cssc/python:3.11-nanoserver-ltsc2022 as base

USER "NT Authority\System"

WORKDIR /app

COPY /app .

RUN python -m pip install --upgrade pip && \
    python -m pip install stac-fastapi.types stac-fastapi.api stac-fastapi.extensions && \
    python -m pip install stac-fastapi.pgstac && \
    python -m pip install uvicorn

CMD ["uvicorn", "stac_fastapi.pgstac.app:app", "--host", "0.0.0.0", "--port", "8080"]