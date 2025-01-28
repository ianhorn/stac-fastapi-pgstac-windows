FROM ianhorn/python311-nanoserver:1.0.2 as base

# ENV GIT_INSTALLER_URL https://github.com/git-for-windows/git/releases/download/v2.47.1.windows.2/Git-2.47.1.2-64-bit.exe

WORKDIR /TEMP

# Install Git using PowerShell
RUN C:\Powershell\pwsh.exe -Command \
    Invoke-WebRequest -Uri "https://github.com/git-for-windows/git/releases/download/v2.47.1.windows.2/Git-2.47.1.2-64-bit.exe" -OutFile git-installer.exe; \
    Start-Process -FilePath .\git-installer.exe -ArgumentList '/silent', '/norestart' -NoNewWindow -Wait; \
    Remove-Item -Force .\git-installer.exe

# Add Git to PATH
ENV PATH="C:\\Python;C:\\Python\\Scripts;C:\\Users\\ContainerUser\\AppData\\Roaming\\Python\\Python311\\Scripts;C:\\Users\\ContainerUser\\AppData\\Roaming\\Python\\Python311;C:\Program Files\Git\bin;C:\Program Files\Git\cmd;%PATH%"

FROM base as builder

WORKDIR /app

COPY . /app

RUN python -m pip install -e ./stac_fastapi/types[dev] && \
    python -m pip install -e ./stac_fastapi/api[dev] && \
    python -m pip install -e ./stac_fastapi/extensions[dev]

RUN python -m pip install -e .[server]

CMD ["uvicorn", "stac_fastapi.pgstac.app:app", "--host", "0.0.0.0", "--port", "8080"]
