FROM ianhorn/stac-fastapi-windows:pgtac-ltsc2022-1.0.1

WORKDIR /app

COPY . /app

RUN python -m pip install -e .[server]

CMD ["uvicorn", "stac_fastapi.pgstac.app:app", "--host", "0.0.0.0", "--port", "8080"]