# =========================
# 🏗️ Build Stage (Flutter)
# =========================
FROM cirrusci/flutter:3.10.5 AS build
WORKDIR /app

# Copy source and get dependencies
COPY . .
RUN flutter pub get

# Build web release
RUN flutter build web --release

# Sanity check for build output
RUN test -f build/web/index.html

# =========================
# 🚀 Serve Stage (Nginx)
# =========================
FROM nginx:alpine
COPY --from=build /app/build/web /usr/share/nginx/html

# Optional: Custom 404 page
# COPY custom_404.html /usr/share/nginx/html/404.html

# Optional: Healthcheck for orchestration
HEALTHCHECK --interval=30s --timeout=5s CMD wget -qO- http://localhost || exit 1

# Expose default port
EXPOSE 80
