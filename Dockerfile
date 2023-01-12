FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["DotnetKubernetesExample.Api/DotnetKubernetesExample.Api.csproj", "DotnetKubernetesExample.Api/"]
RUN dotnet restore "DotnetKubernetesExample.Api/DotnetKubernetesExample.Api.csproj"
COPY . .
WORKDIR "/src/DotnetKubernetesExample.Api"
RUN dotnet build "DotnetKubernetesExample.Api.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "DotnetKubernetesExample.Api.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "DotnetKubernetesExample.Api.dll"]