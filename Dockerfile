# Flutter web build Dockerfile
# Flutter web būves Dockerfile
FROM cirrusci/flutter:3.22.0 AS build

# Install Node.js for npm support required by CI
# Instalēt Node.js npm atbalstam, kas nepieciešams CI
RUN apt-get update && apt-get install -y curl && \
    curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs

# Set working directory / Iestatīt darba direktoriju
WORKDIR /app

# Copy all project files / Kopēt visus projekta failus
COPY . .

# Install npm dependencies (minimal) / Instalēt npm atkarības (minimālas)
RUN npm install || echo "No npm dependencies to install"

# Install Flutter dependencies / Instalēt Flutter atkarības
RUN flutter pub get

# Enable web support / Iespējot web atbalstu
RUN flutter config --enable-web

# Build Flutter web app for production / Būvēt Flutter web aplikāciju produkcijai
RUN flutter build web --release --web-renderer html

# Nginx static server for built web assets
# Nginx serveris statiskajiem izveidotajiem resursiem  
FROM nginx:alpine

# Copy built web assets to nginx / Kopēt izveidotos web resursus uz nginx
COPY --from=build /app/build/web /usr/share/nginx/html

# Create custom nginx config for SPA / Izveidot pielāgotu nginx konfigurāciju SPA
RUN echo 'server { \
    listen 80; \
    location / { \
        root /usr/share/nginx/html; \
        index index.html; \
        try_files $uri $uri/ /index.html; \
    } \
}' > /etc/nginx/conf.d/default.conf

# Expose port 80 / Atvērt portu 80
EXPOSE 80

# Start nginx / Palaist nginx
CMD ["nginx", "-g", "daemon off;"]
