# Use the correct .NET SDK version (8.0)
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build

# Set the working directory inside the container
WORKDIR /app

# Copy the solution file first
COPY leaderboard.sln ./

# Copy all project files before running restore
COPY src/Server/CacheStrategies/LeaderBoard.ReadThrough/LeaderBoard.ReadThrough.csproj src/Server/CacheStrategies/LeaderBoard.ReadThrough/
COPY src/Server/CacheStrategies/LeaderBoard.WriteBehind/LeaderBoard.WriteBehind.csproj src/Server/CacheStrategies/LeaderBoard.WriteBehind/
COPY src/Server/CacheStrategies/LeaderBoard.WriteThrough/LeaderBoard.WriteThrough.csproj src/Server/CacheStrategies/LeaderBoard.WriteThrough/
COPY src/Server/Services/LeaderBoard.GameEventsProcessor/LeaderBoard.GameEventsProcessor.csproj src/Server/Services/LeaderBoard.GameEventsProcessor/
COPY src/Server/Services/LeaderBoard.GameEventsSource/LeaderBoard.GameEventsSource.csproj src/Server/Services/LeaderBoard.GameEventsSource/
COPY src/Server/Services/LeaderBoard.SignalR/LeaderBoard.SignalR.csproj src/Server/Services/LeaderBoard.SignalR/
COPY src/Server/Shared/LeaderBoard.SharedKernel/LeaderBoard.SharedKernel.csproj src/Server/Shared/LeaderBoard.SharedKernel/
COPY src/Server/Shared/LeaderBoard.DbMigrator/LeaderBoard.DbMigrator.csproj src/Server/Shared/LeaderBoard.DbMigrator/

# Restore dependencies using the solution file
RUN dotnet restore "leaderboard.sln"

# Copy the entire source code after restoring dependencies
COPY . ./

# Set the working directory to the main project directory
WORKDIR /app/src/Server/Services/LeaderBoard.GameEventsProcessor/

# Build the application
RUN dotnet build "LeaderBoard.GameEventsProcessor.csproj" --configuration Release --output /app/build
