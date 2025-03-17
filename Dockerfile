# Use the .NET 9.0 SDK
FROM mcr.microsoft.com/dotnet/sdk:9.0

# Set the working directory inside the container
WORKDIR /app

# Copy the solution file first
COPY leaderboard.sln ./

# Copy all project files before running restore
COPY src/server/CacheStrategies/LeaderBoard.ReadThrough/LeaderBoard.ReadThrough.csproj src/server/CacheStrategies/LeaderBoard.ReadThrough/
COPY src/server/CacheStrategies/LeaderBoard.WriteBehind/LeaderBoard.WriteBehind.csproj src/server/CacheStrategies/LeaderBoard.WriteBehind/
COPY src/server/CacheStrategies/LeaderBoard.WriteThrough/LeaderBoard.WriteThrough.csproj src/server/CacheStrategies/LeaderBoard.WriteThrough/
COPY src/server/Services/LeaderBoard.GameEventsProcessor/LeaderBoard.GameEventsProcessor.csproj src/server/Services/LeaderBoard.GameEventsProcessor/
COPY src/server/Services/LeaderBoard.GameEventsSource/LeaderBoard.GameEventsSource.csproj src/server/Services/LeaderBoard.GameEventsSource/
COPY src/server/Services/LeaderBoard.SignalR/LeaderBoard.SignalR.csproj src/server/Services/LeaderBoard.SignalR/
COPY src/server/Shared/LeaderBoard.SharedKernel/LeaderBoard.SharedKernel.csproj src/server/Shared/LeaderBoard.SharedKernel/
COPY src/server/Shared/LeaderBoard.DbMigrator/LeaderBoard.DbMigrator.csproj src/server/Shared/LeaderBoard.DbMigrator/

# Debugging step to verify files before restoring dependencies
RUN ls -R /app/src/server/shared

# Restore dependencies using the solution file
RUN dotnet restore "leaderboard.sln"

# Copy the entire source code after restoring dependencies
COPY . ./

# Set the working directory to the main project directory
WORKDIR /app/src/server/Services/LeaderBoard.GameEventsProcessor/

# Build the application
RUN dotnet build "LeaderBoard.GameEventsProcessor.csproj" --configuration Release --output /app/build
