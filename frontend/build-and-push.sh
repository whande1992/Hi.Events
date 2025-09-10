#!/bin/bash

# Script para build e upload da imagem personalizada do Hi.Events Frontend
# Usuário: whande1
# Imagem: hievents-frontend-ssr

set -e

# Configurações
DOCKER_USERNAME="whande1"
IMAGE_NAME="hievents-frontend-ssr"
VERSION=$(date +%Y%m%d-%H%M%S)  # Versão baseada em timestamp para forçar atualização
LATEST_TAG="latest"

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Função para print colorido
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Verificar se o Docker está rodando
if ! docker info >/dev/null 2>&1; then
    print_error "Docker não está rodando. Por favor, inicie o Docker."
    exit 1
fi

print_status "Iniciando build da imagem personalizada..."
print_status "Usuário Docker Hub: $DOCKER_USERNAME"
print_status "Nome da imagem: $IMAGE_NAME"
print_status "Versão: $VERSION"

# Navegar para o diretório do frontend
cd "$(dirname "$0")"

# Build da imagem
print_status "Fazendo build da imagem: ${DOCKER_USERNAME}/${IMAGE_NAME}:${VERSION}"
docker build -f Dockerfile.custom -t "${DOCKER_USERNAME}/${IMAGE_NAME}:${VERSION}" .

# Tag como latest
print_status "Criando tag latest..."
docker tag "${DOCKER_USERNAME}/${IMAGE_NAME}:${VERSION}" "${DOCKER_USERNAME}/${IMAGE_NAME}:${LATEST_TAG}"

print_status "Build concluído com sucesso!"

# Verificar se deve fazer login
read -p "Deseja fazer login no Docker Hub e fazer upload da imagem? (y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    print_status "Fazendo login no Docker Hub..."
    docker login

    print_status "Fazendo upload da imagem versão ${VERSION}..."
    docker push "${DOCKER_USERNAME}/${IMAGE_NAME}:${VERSION}"

    print_status "Fazendo upload da imagem latest..."
    docker push "${DOCKER_USERNAME}/${IMAGE_NAME}:${LATEST_TAG}"

    print_status "Upload concluído!"
    print_status "Sua imagem está disponível em: https://hub.docker.com/r/${DOCKER_USERNAME}/${IMAGE_NAME}"
    print_status "Para usar no docker-compose, use: ${DOCKER_USERNAME}/${IMAGE_NAME}:${VERSION}"
else
    print_warning "Upload cancelado. Para fazer upload manualmente, execute:"
    echo "docker login"
    echo "docker push ${DOCKER_USERNAME}/${IMAGE_NAME}:${VERSION}"
    echo "docker push ${DOCKER_USERNAME}/${IMAGE_NAME}:${LATEST_TAG}"
fi

# Mostrar informações da imagem
print_status "Informações da imagem criada:"
docker images "${DOCKER_USERNAME}/${IMAGE_NAME}"

print_status "Para testar localmente, execute:"
echo "docker run -p 5678:5678 ${DOCKER_USERNAME}/${IMAGE_NAME}:${LATEST_TAG}"

print_status "Imagem pronta para uso! Porta: 5678"
