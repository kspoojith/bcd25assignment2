# Use the official .NET SDK image for building the application
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copy everything from the source folder to the container
COPY . .

# Ensure we are in the correct directory
WORKDIR /app  # Change this to where your .sln file is

# Restore dependencies
RUN dotnet restore leaderboard.sln

# Build the application
RUN dotnet build --configuration Release --output /app/build

# Publish the application
RUN dotnet publish --configuration Release --output /app/publish

# Use the official .NET runtime image
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime
WORKDIR /app
COPY --from=build /app/publish .

ENTRYPOINT ["dotnet", "LeaderBoard.GameEventsProcessor.dll"]
