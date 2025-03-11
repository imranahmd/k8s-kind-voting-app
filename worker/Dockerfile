# Build stage
FROM --platform=${BUILDPLATFORM} mcr.microsoft.com/dotnet/sdk:7.0 AS build
ARG TARGETPLATFORM
ARG BUILDPLATFORM

RUN echo "I am running on $BUILDPLATFORM, building for $TARGETPLATFORM"

WORKDIR /source

# Copy project files and restore dependencies
COPY *.csproj ./
RUN dotnet restore --runtime linux-x64

# Copy all source files
COPY . ./

# Build and publish the application
RUN dotnet publish -c Release -o /app -r linux-x64 --self-contained false

# Application image
FROM mcr.microsoft.com/dotnet/runtime:7.0
WORKDIR /app
COPY --from=build /app ./
ENTRYPOINT ["dotnet", "Worker.dll"]
