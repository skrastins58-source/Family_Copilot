# LV: Publicē Flutter Web Docker attēlu uz GHCR
# EN: Publish Flutter Web Docker image to GHCR

param (
  [string]$Token = $env:GHCR_TOKEN
)

if (-not $Token) {
  Write-Error "❌ GHCR_TOKEN nav iestatīts. / GHCR_TOKEN is not set."
  exit 1
}

$ImageName = "ghcr.io/skrastins58-source/family_copilot_monorepo/ci-cd-symphony-web:latest"
$DockerfilePath = ".github/workflows/CI-CD-Symphony/dockerfile.web"
$ContextPath = "."

Write-Host "🔐 Logging in to GHCR..."
$Token | docker login ghcr.io -u janis --password-stdin

Write-Host "🐳 Building Docker image..."
docker build -f $DockerfilePath -t $ImageName $ContextPath

Write-Host "🚀 Pushing image to GHCR..."
docker push $ImageName

Write-Host "✅ Done. Image published: $ImageName"
