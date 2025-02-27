FROM mcr.microsoft.com/windows/servercore:ltsc2022 as base

# Install chocolatey as package manager
RUN powershell -Command "Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))"

# Install psql-client
RUN refreshenv && \
    choco install python312 -y && \
    choco install psql -y && \
    choco install git -y && \
    refreshenv

ENV PATH="C:/Python312;C:/Python312/Scripts;C:/ProgramData/chocolatey/bin;C:/Program Files/Git/bin;C:/Program Files/Git/cmd;${PATH}"

FROM base as builder

WORKDIR /app

COPY /app .

RUN python -m pip install --upgrade pip && \
    python -m pip install stac-fastapi.types stac-fastapi.api stac-fastapi.extensions && \
    python -m pip install stac-fastapi.pgstac && \
    python -m pip install uvicorn

CMD ["uvicorn", "stac_fastapi.pgstac.app:app", "--host", "0.0.0.0", "--port", "8080"]