# Use the .NET SDK image to build the app. (build environment)
# Modify the image to match your .NET version (e.g., 8.0, 7.0, 6.0).
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copy solution and project files first to leverage the NuGet restore cache.
# Adjust the project file path to match your actual structure.
COPY ["hello_with_gemini.sln", "."]
COPY ["hello_with_gemini/hello_with_gemini.csproj", "hello_with_gemini/"]
RUN dotnet restore "hello_with_gemini/hello_with_gemini.csproj"

# Copy the rest of the source code.
COPY . .
WORKDIR "/src/hello_with_gemini"
RUN dotnet build "hello_with_gemini.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "hello_with_gemini.csproj" -c Release -o /app/publish /p:UseAppHost=false

# Use the ASP.NET Core runtime image to create the final image. (runtime environment)
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final
WORKDIR /app
COPY --from=publish /app/publish .

# Specify the port the application will listen on inside the container.
# The default ASP.NET Core app uses port 8080 (HTTP).
EXPOSE 8080

ENTRYPOINT ["dotnet", "hello_with_gemini.dll"]