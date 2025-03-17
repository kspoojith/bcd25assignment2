# Use the official .NET SDK image
FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build

# Set the working directory inside the container
WORKDIR /app

# Copy the solution file
COPY leaderboard.sln ./

# Copy only the necessary project files to restore dependencies
COPY src/Server/Services/LeaderBoard.GameEventsProcessor/LeaderBoard.GameEventsProcessor.csproj src/Server/Services/LeaderBoard.GameEventsProcessor/

# Restore dependencies using the solution file
RUN dotnet restore "leaderboard.sln"

# Copy the entire source code
COPY . ./

# Set the working directory to the project folder
WORKDIR /app/src/Server/Services/LeaderBoard.GameEventsProcessor/

# Build the application
RUN dotnet build "LeaderBoard.GameEventsProcessor.csproj" --configuration Release --output /app/build
