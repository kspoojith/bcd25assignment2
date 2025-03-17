# Use the official .NET SDK image to build the application
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copy the project file and restore dependencies
COPY ["src/Server/Services/LeaderBoard.GameEventsProcessor/LeaderBoard.GameEventsProcessor.csproj", "./"]
WORKDIR "/src"
RUN dotnet restore

# Copy the rest of the application and build it
COPY . .
RUN dotnet build --configuration Release --output /app/build

# Publish the application
RUN dotnet publish --configuration Release --output /app/publish

# Use ASP.NET Core runtime image to run the app
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime
WORKDIR /app
COPY --from=build /app/publish .

# Set the entry point for the application
ENTRYPOINT ["dotnet", "LeaderBoard.GameEventsProcessor.dll"]
