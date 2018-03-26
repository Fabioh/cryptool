FROM microsoft/dotnet:2.1-sdk AS build-env
WORKDIR /app

# Copy csproj and restore as distinct layers
# COPY *.csproj ./
# RUN dotnet restore

# Copy everything else and build
COPY . ./
RUN dotnet pack . -c Release -o nupkg

# Build runtime image
FROM ubuntu:16.04
RUN sed -i 's/archive.ubuntu.com/br.archive.ubuntu.com/g' /etc/apt/sources.list && \
	sed -i 's/security.ubuntu.com/br.archive.ubuntu.com/g' /etc/apt/sources.list
#install dotnet core 2.1 sdk
RUN apt-get update && apt-get -y upgrade && apt-get install -y curl gpgv2 apt-transport-https &&\
	curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > /etc/apt/trusted.gpg.d/microsoft.gpg && \
	sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/microsoft-ubuntu-xenial-prod xenial main" > /etc/apt/sources.list.d/dotnetdev.list' && \
	apt-get update && \
	apt-get install -y dotnet-sdk-2.1.300-preview1-008174

WORKDIR /app/nupkg
COPY --from=build-env /app/nupkg .
# ENTRYPOINT ["dotnet", "aspnetapp.dll"]