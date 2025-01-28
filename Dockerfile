FROM ianhorn/python311-nanoserver:1.0.2 as base

ENV GIT_INSTALLER_URL https://github.com/git-for-windows/git/releases/download/v2.42.0.windows.1/Git-2.42.0-64-bit.exe

# Download and silently install Git, then add to PATH
RUN curl -o git-installer.exe %GIT_INSTALLER_URL% && \
    start /wait git-installer.exe /silent /norestart /log git-install.log && \
    del git-installer.exe && \
    python -m pip install -e ./stac_fastapi/types[dev] && \
    python -m pip install -e ./stac_fastapi/api[dev] && \
    python -m pip install -e ./stac_fastapi/extensions[dev]

RUN setx PATH "%PATH%;C:\Program Files\Git\bin;C:\Program Files\Git\cmd"

FROM base as builder

WORKDIR /app

COPY . /app

RUN python -m pip install -e .[server]

CMD ["uvicorn", "stac_fastapi.pgstac.app:app", "--host", "0.0.0.0", "--port", "8080"]
