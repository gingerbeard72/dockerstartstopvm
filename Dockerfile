FROM mcr.microsoft.com/azure-powershell:latest

ENV rg=resourcegroupname

COPY script.ps1 /script.ps1

COPY docker1.pfx /docker1.pfx
ENTRYPOINT [ "pwsh", "-Command", "/script.ps1" ]