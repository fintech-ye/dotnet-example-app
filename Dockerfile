FROM mcr.microsoft.com/dotnet/sdk:7.0-alpine AS build-env

WORKDIR /dotnet-example-app

COPY ["dotnet-example-app.csproj", "."]

# # Restore as distinct layers
RUN dotnet restore "dotnet-example-app.csproj"
COPY . .

# Build and publish a release
RUN dotnet build "dotnet-example-app.csproj" -c Release -o out
RUN dotnet publish "dotnet-example-app.csproj" -c Release -o out

# Build runtime image
FROM mcr.microsoft.com/dotnet/aspnet:7.0-alpine
WORKDIR /dotnet-example-app
COPY --from=build-env /dotnet-example-app/out .

EXPOSE 80

ENTRYPOINT ["dotnet", "dotnet-example-app.dll"]