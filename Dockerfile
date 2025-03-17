# Use the official .NET SDK image
FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build

# Set the working directory inside the container
WORKDIR /app

# Copy the solution and project files first
COPY leaderboard.sln ./
COPY src/Server/Services/LeaderBoard.GameEventsProcessor/LeaderBoard.GameEventsProcessor.csproj ./

# Restore dependencies
RUN dotnet restore "leaderboard.sln"

# Copy the rest of the source code
COPY src/Server/Services/LeaderBoard.GameEventsProcessor/ ./

# Set the working directory to the project folder
WORKDIR /app

# Build the application
RUN dotnet build "LeaderBoard.GameEventsProcessor.csproj" --configuration Release --output /app/build
