# Docker Usage for Family_Copilot (Flutter Mobile)

This project includes a Dockerfile for building your Flutter mobile (Android) app in a reproducible environment.

## Prerequisites
- Docker installed (https://docs.docker.com/get-docker/)

## Build the Docker Image

From the project root:

```sh
docker build -t family_copilot_mobile -f Family_Copilot/Dockerfile Family_Copilot
```

- `-t family_copilot_mobile` sets the image name.
- `-f Family_Copilot/Dockerfile` specifies the Dockerfile location.
- `Family_Copilot` is the build context (the app folder).

## What This Does
- Installs Flutter and Android SDK tools
- Installs dependencies (`flutter pub get`)
- Builds a release APK (`flutter build apk --release`)
- The APK will be in `build/app/outputs/flutter-apk/app-release.apk` inside the container

## Extracting the APK
To copy the APK from the container to your host:

```sh
docker create --name temp_apk family_copilot_mobile
# Copy APK to current directory
docker cp temp_apk:/app/build/app/outputs/flutter-apk/app-release.apk ./app-release.apk
docker rm temp_apk
```

## Running the Container
By default, the container lists the APK file:

```sh
docker run --rm family_copilot_mobile
```

## Customization
- Edit the Dockerfile to add more build targets or test steps as needed.
- For CI/CD, use the same build command in your workflow YAML.

---
For more, see the official [Flutter Docker documentation](https://docs.flutter.dev/get-started/install/linux#install-flutter-manually).
