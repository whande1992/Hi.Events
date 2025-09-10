#!/bin/bash

# Script Simplificado para Build e Push da Imagem Docker
# Usuário: whande1
# Imagem: hievents-frontend-ssr

echo "🚀 Iniciando build da imagem Docker personalizada..."

# Gerar versão única
VERSION=$(date +%Y%m%d-%H%M%S)

# Navegar para diretório do frontend
cd /code/wande/hieventperson/Hi.Events/frontend

# Build da imagem
echo "📦 Building imagem whande1/hievents-frontend-ssr:$VERSION..."
docker build -f Dockerfile.custom -t whande1/hievents-frontend-ssr:$VERSION .

# Tag como latest
echo "🏷️  Criando tag latest..."
docker tag whande1/hievents-frontend-ssr:$VERSION whande1/hievents-frontend-ssr:latest

echo "✅ Build concluído!"
echo ""
echo "Para fazer upload no Docker Hub, execute:"
echo "docker login"
echo "docker push whande1/hievents-frontend-ssr:$VERSION"
echo "docker push whande1/hievents-frontend-ssr:latest"
echo ""
echo "Para testar localmente:"
echo "docker run -p 5678:5678 whande1/hievents-frontend-ssr:latest"
echo ""
echo "Versão criada: $VERSION"
