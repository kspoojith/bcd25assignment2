# Use the official .NET SDK image to build the application
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build

# Set the working directory
WORKDIR /src/Server/Services/LeaderBoard.GameEventsProcessor

# Copy the project file and restore dependencies
COPY ["src/Server/Services/LeaderBoard.GameEventsProcessor/LeaderBoard.GameEventsProcessor.csproj", "./"]
RUN dotnet restore

# Copy the rest of the application source code and build it
COPY ["src/Server/Services/LeaderBoard.GameEventsProcessor/", "./"]
RUN dotnet build --configuration Release --output /app/build

# Publish the application
RUN dotnet publish --configuration Release --output /app/publish

# Use ASP.NET Core runtime image to run the app
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime

# Set the working directory
WORKDIR /app

# Copy the published application from the build stage
COPY --from=build /app/publish .

# Set the entry point for the application
ENTRYPOINT ["dotnet", "LeaderBoard.GameEventsProcessor.dll"]
