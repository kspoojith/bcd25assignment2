# Use the official .NET SDK image for building the application
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
# Set the working directory inside the container
WORKDIR /app

# Copy the solution file first
COPY leaderboard.sln ./

# Copy the entire source code (including projects)
COPY src/ ./src/

# Restore dependencies using the solution file
RUN dotnet restore "leaderboard.sln"

# Set the working directory to the source directory where the actual build happens
WORKDIR /app/src

# Build the application
RUN dotnet build --configuration Release --output /app/build


# Publish the application
RUN dotnet publish --configuration Release --output /app/publish

# Use the official .NET runtime image
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime
WORKDIR /app
COPY --from=build /app/publish .

ENTRYPOINT ["dotnet", "LeaderBoard.GameEventsProcessor.dll"]
