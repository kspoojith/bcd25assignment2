# Use the official .NET SDK image to build the application
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copy only the project file and restore dependencies (leveraging caching)
COPY src/Server/Services/LeaderBoard.GameEventsProcessor/LeaderBoard.GameEventsProcessor.csproj ./LeaderBoard.GameEventsProcessor/
WORKDIR /src/LeaderBoard.GameEventsProcessor
RUN dotnet restore

# Copy the entire source code and build the application
COPY src/Server/Services/LeaderBoard.GameEventsProcessor/ ./ 
RUN dotnet build --configuration Release --output /app/build

# Publish the application
RUN dotnet publish --configuration Release --output /app/publish

# Use the .NET runtime image to run the app
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime
WORKDIR /app
COPY --from=build /app/publish .

# Set the entry point
ENTRYPOINT ["dotnet", "LeaderBoard.GameEventsProcessor.dll"]
