#see https://aka.ms/containerfastmode to understand how visual studio uses this dockerfield build

FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["NinosConValorAPI.csproj", "."]
RUN dotnet restore "./NinosConValorAPI.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "NinosConValorAPI.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "NinosConValorAPI.csproj" -c Realease -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish
ENTRYPOINT ["dotnet", "NinosConValorAPI.csproj"]
