#!/bin/bash
set -e

IMAGE_NAME="docker-registry.miweb.fr/mdb-copilot-api"
VERSION=$(date +%Y%m%d-%H%M%S)

echo "========================================="
echo "  MDB Copilot API - Deploy"
echo "========================================="

# Vérification connexion registry
echo ""
echo "🔐 Vérification connexion au registry..."
if ! docker manifest inspect docker-registry.miweb.fr/mdb-copilot-api:latest > /dev/null 2>&1 && \
   ! docker login docker-registry.miweb.fr --get-login > /dev/null 2>&1; then
    echo "⚠️  Impossible de vérifier la connexion au registry."
    echo "   Si le push échoue, exécutez : docker login docker-registry.miweb.fr"
fi
echo "✅ Registry check terminé"

# Build
echo ""
echo "🏗️  Build de l'image Docker..."
echo "   Tags: ${VERSION}, latest"
docker build -t ${IMAGE_NAME}:${VERSION} -t ${IMAGE_NAME}:latest .

# Push
echo ""
echo "📦 Push vers le registry..."
docker push ${IMAGE_NAME}:${VERSION}
docker push ${IMAGE_NAME}:latest

# Done
echo ""
echo "========================================="
echo "✅ Deploy terminé !"
echo "   Image: ${IMAGE_NAME}:${VERSION}"
echo "   ⏳ Watchtower redéploiera automatiquement sur OVH (~5 min)"
echo "========================================="
