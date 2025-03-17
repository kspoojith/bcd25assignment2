# Use .NET SDK 9.0 for building the application
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /app

# Copy the solution and project files
COPY *.sln ./
COPY src/server/Services/LeaderBoard.SignalR/LeaderBoard.SignalR.csproj src/server/Services/LeaderBoard.SignalR/
COPY src/server/Services/LeaderBoard.GameEventsSource/LeaderBoard.GameEventsSource.csproj src/server/Services/LeaderBoard.GameEventsSource/
COPY src/server/Services/LeaderBoard.GameEventsProcessor/LeaderBoard.GameEventsProcessor.csproj src/server/Services/LeaderBoard.GameEventsProcessor/
COPY src/server/CacheStrategies/LeaderBoard.WriteBehind/LeaderBoard.WriteBehind.csproj src/server/CacheStrategies/LeaderBoard.WriteBehind/
COPY src/server/CacheStrategies/LeaderBoard.WriteThrough/LeaderBoard.WriteThrough.csproj src/server/CacheStrategies/LeaderBoard.WriteThrough/
COPY src/server/CacheStrategies/LeaderBoard.ReadThrough/LeaderBoard.ReadThrough.csproj src/server/CacheStrategies/LeaderBoard.ReadThrough/
COPY src/server/Shared/LeaderBoard.SharedKernel/LeaderBoard.SharedKernel.csproj src/server/Shared/LeaderBoard.SharedKernel/
COPY src/server/Shared/LeaderBoard.DbMigrator/LeaderBoard.DbMigrator.csproj src/server/Shared/LeaderBoard.DbMigrator/

# Restore dependencies
RUN dotnet restore

# Copy the rest of the source code
COPY . .

# Build the application
RUN dotnet publish -c Release -o /app/out

# Runtime environment
FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS runtime
WORKDIR /app
COPY --from=build /app/out .

# Expose port (adjust as needed)
EXPOSE 5000

# Run the application
ENTRYPOINT ["dotnet", "LeaderBoard.SignalR.dll"]
