FROM ianhorn/stac-fastapi-windows:servercore-ltsc2022-1.0.0

# WORKDIR C:/app

COPY stac_fastapi/pgstac stac_fastapi

RUN python -m pip install stac-fastapi.pgstac

CMD ["uvicorn", "stac_fastapi.pgstac.app:app", "--host", "0.0.0.0", "--port", "8080"]