# escape=`

ARG WDP_SI

# take cert tool image
FROM microsoft/nanoserver:sac2016 as certoc

# Image with NET CORE installation to extract executables for final image
FROM mcr.microsoft.com/windows/servercore:1903 AS prepare

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'Continue'; $verbosePreference='Continue';"]

WORKDIR /install

# how-to-install-root-certificate-on-nanoserver https://stackoverflow.com/questions/51841132/how-to-install-root-certificate-on-nanoserver
COPY --from=certoc /Windows/System32/certoc.exe .

# copy IS package
COPY  . /install/

# Expand the package, use ARG
RUN Expand-Archive "Sitecore.IdentityServer.3.0.0-r00211.scwdp.zip" -DestinationPath /app/

FROM mcr.microsoft.com/dotnet/core/aspnet:2.2-nanoserver-1903

WORKDIR /app

COPY --from=prepare /Windows/System32/certoc.exe .
COPY --from=prepare /app/Content/Website /app/
COPY --from=prepare /install/LicenseContent/license.xml /app/sitecoreruntime/license.xml
COPY --from=prepare /install/files /app/tools/

# RUN

USER ContainerAdministrator

# TODO
# RUN certoc.exe -ImportPFX -p secret My identity.pfx

USER ContainerUser

# bind config C:\app\Config

EXPOSE 80

ENTRYPOINT ["dotnet", "Sitecore.IdentityServer.Host.dll"]

