# =======================================================
# Stage 1 - Build/compile app using container
# =======================================================

# Use .NET 7 SDK for building the app
ARG IMAGE_BASE=7.0-alpine

FROM mcr.microsoft.com/dotnet/sdk:$IMAGE_BASE as build
WORKDIR /build

# Copy project source files
COPY src ./src

# Restore, build & publish
WORKDIR /build/src
RUN dotnet restore
RUN dotnet publish --no-restore --configuration Release -o /app/publish

# =======================================================
# Stage 2 - Assemble runtime image from previous stage
# =======================================================

# Use .NET 7 runtime-only image
FROM mcr.microsoft.com/dotnet/aspnet:$IMAGE_BASE

# Metadata in Label Schema format
LABEL org.label-schema.name    = ".NET 7 Web App" \
      org.label-schema.version = "1.5.0" \
      org.label-schema.vendor  = "cash friend" \
      org.opencontainers.image.source = "https://github.com/imranahmd/k8s-kind-voting-app"

# Set working directory
WORKDIR /app

# Copy published binaries from build stage
COPY --from=build /app/publish .

# Expose port 5000 from Kestrel webserver
EXPOSE 5000

# Tell Kestrel to listen on port 5000 and serve plain HTTP
ENV ASPNETCORE_URLS http://*:5000
ENV ASPNETCORE_ENVIRONMENT Production
ENV ASPNETCORE_FORWARDEDHEADERS_ENABLED=true

# Run the ASP.NET Core app
ENTRYPOINT ["dotnet", "dotnet-demoapp.dll"]
