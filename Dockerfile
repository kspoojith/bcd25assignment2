# Use the .NET SDK to build the application
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copy the project files and restore dependencies (to leverage caching)
COPY ["src/Server/Services/LeaderBoard.GameEventsProcessor/LeaderBoard.GameEventsProcessor.csproj", "src/Server/Services/LeaderBoard.GameEventsProcessor/"]
WORKDIR "/src/Server/Services/LeaderBoard.GameEventsProcessor"
RUN dotnet restore

# Copy the entire source code and build the application
COPY . .
WORKDIR "/src/Server/Services/LeaderBoard.GameEventsProcessor"
RUN dotnet build --configuration Release --output /app/build

# Publish the application
RUN dotnet publish --configuration Release --output /app/publish

# Use the ASP.NET Core runtime image to run the app
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime
WORKDIR /app

# Copy the published application
COPY --from=build /app/publish .

# Set the entry point
ENTRYPOINT ["dotnet", "LeaderBoard.GameEventsProcessor.dll"]
