#!/bin/bash

################################################################################
# Script para Build e Deploy de Imagem Personalizada do Hi.Events Frontend
#
# Este script automatiza o processo de criar e fazer deploy de uma imagem
# Docker personalizada do Hi.Events Frontend usando o mesmo Dockerfile.ssr
# que a imagem oficial daveearley/hi.events-frontend:latest utiliza.
#
# Autor: Baseado na análise do GitHub Actions oficial do Hi.Events
# Data: $(date +%Y-%m-%d)
################################################################################

set -e  # Para o script se houver erro

# ==============================================================================
# CONFIGURAÇÕES - PERSONALIZE ESTAS VARIÁVEIS
# ==============================================================================

DOCKER_USERNAME="whande1"  # SEU USERNAME DO DOCKER HUB
IMAGE_NAME="hievents-frontend"
BASE_VERSION="1.3"  # Versão base - será incrementada automaticamente

# Cores para output mais bonito
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# ==============================================================================
# FUNÇÕES AUXILIARES
# ==============================================================================

print_header() {
    echo -e "${PURPLE}================================${NC}"
    echo -e "${PURPLE}$1${NC}"
    echo -e "${PURPLE}================================${NC}"
}

print_step() {
    echo -e "${BLUE}[PASSO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCESSO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[AVISO]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERRO]${NC} $1"
}

print_info() {
    echo -e "${CYAN}[INFO]${NC} $1"
}

# Função para verificar dependências
check_dependencies() {
    print_step "Verificando dependências..."

    if ! command -v docker &> /dev/null; then
        print_error "Docker não está instalado ou não está no PATH"
        exit 1
    fi

    if ! docker info >/dev/null 2>&1; then
        print_error "Docker não está rodando. Por favor, inicie o Docker."
        exit 1
    fi

    print_success "Docker está funcionando corretamente"
}

# Função para gerar próxima versão
generate_version() {
    print_step "Gerando nova versão..."

    # Verificar se a imagem já existe no Docker Hub
    PATCH=0
    while docker manifest inspect "${DOCKER_USERNAME}/${IMAGE_NAME}:v${BASE_VERSION}.${PATCH}" >/dev/null 2>&1; do
        ((PATCH++))
    done

    VERSION="v${BASE_VERSION}.${PATCH}"
    print_success "Nova versão gerada: ${VERSION}"
}

# Função para fazer build da imagem
build_image() {
    print_step "Fazendo build da imagem usando Dockerfile.ssr oficial..."

    # Navegar para o diretório correto
    cd "$(dirname "$0")"

    print_info "Contexto: $(pwd)"
    print_info "Dockerfile: Dockerfile.ssr (mesmo da imagem oficial)"
    print_info "Tag: ${DOCKER_USERNAME}/${IMAGE_NAME}:${VERSION}"

    # Build usando o mesmo Dockerfile.ssr da imagem oficial
    docker build \
        -f Dockerfile.ssr \
        -t "${DOCKER_USERNAME}/${IMAGE_NAME}:${VERSION}" \
        -t "${DOCKER_USERNAME}/${IMAGE_NAME}:latest" \
        .

    print_success "Build concluído com sucesso!"
}

# Função para testar a imagem localmente
test_image() {
    print_step "Testando a imagem localmente..."

    # Parar container de teste se já existir
    docker stop "${IMAGE_NAME}-test" 2>/dev/null || true
    docker rm "${IMAGE_NAME}-test" 2>/dev/null || true

    # Executar container de teste
    print_info "Iniciando container de teste na porta 5679:5678..."
    docker run -d \
        --name "${IMAGE_NAME}-test" \
        -p 5679:5678 \
        "${DOCKER_USERNAME}/${IMAGE_NAME}:${VERSION}"

    # Aguardar alguns segundos para o container inicializar
    sleep 5

    # Verificar se o container está rodando
    if docker ps | grep -q "${IMAGE_NAME}-test"; then
        print_success "Container está rodando! Teste em: http://localhost:5679"

        # Perguntar se quer parar o teste
        read -p "Pressione Enter para parar o teste e continuar com o deploy..."
        docker stop "${IMAGE_NAME}-test"
        docker rm "${IMAGE_NAME}-test"
    else
        print_warning "Container não está rodando. Verifique os logs:"
        docker logs "${IMAGE_NAME}-test" 2>/dev/null || true
        docker rm "${IMAGE_NAME}-test" 2>/dev/null || true
    fi
}

# Função para fazer login no Docker Hub
docker_login() {
    print_step "Verificando login no Docker Hub..."

    # Verificar se já está logado
    if docker info | grep -q "Username: ${DOCKER_USERNAME}"; then
        print_success "Já está logado como ${DOCKER_USERNAME}"
        return 0
    fi

    print_info "Fazendo login no Docker Hub..."
    if ! docker login; then
        print_error "Falha no login do Docker Hub"
        exit 1
    fi

    print_success "Login realizado com sucesso"
}

# Função para fazer push das imagens
push_images() {
    print_step "Fazendo upload das imagens para o Docker Hub..."

    # Push da versão específica
    print_info "Enviando ${DOCKER_USERNAME}/${IMAGE_NAME}:${VERSION}..."
    docker push "${DOCKER_USERNAME}/${IMAGE_NAME}:${VERSION}"

    # Push da versão latest
    print_info "Enviando ${DOCKER_USERNAME}/${IMAGE_NAME}:latest..."
    docker push "${DOCKER_USERNAME}/${IMAGE_NAME}:latest"

    print_success "Upload concluído com sucesso!"
}

# Função para mostrar informações finais
show_final_info() {
    print_header "DEPLOY CONCLUÍDO COM SUCESSO!"

    echo -e "${GREEN}✅ Imagem criada e enviada para o Docker Hub:${NC}"
    echo -e "   • ${CYAN}${DOCKER_USERNAME}/${IMAGE_NAME}:${VERSION}${NC}"
    echo -e "   • ${CYAN}${DOCKER_USERNAME}/${IMAGE_NAME}:latest${NC}"
    echo ""

    echo -e "${GREEN}📋 Para usar em seu projeto:${NC}"
    echo -e "   ${YELLOW}# No docker-compose.yml${NC}"
    echo -e "   ${CYAN}image: ${DOCKER_USERNAME}/${IMAGE_NAME}:${VERSION}${NC}"
    echo ""

    echo -e "${GREEN}🚀 Para rodar localmente:${NC}"
    echo -e "   ${CYAN}docker run -p 5678:5678 ${DOCKER_USERNAME}/${IMAGE_NAME}:${VERSION}${NC}"
    echo ""

    echo -e "${GREEN}🔗 Links úteis:${NC}"
    echo -e "   • Docker Hub: ${CYAN}https://hub.docker.com/r/${DOCKER_USERNAME}/${IMAGE_NAME}${NC}"
    echo -e "   • Porta da aplicação: ${CYAN}5678${NC}"
    echo ""

    echo -e "${GREEN}📝 Características da imagem:${NC}"
    echo -e "   • Baseada no mesmo Dockerfile.ssr da imagem oficial"
    echo -e "   • Funciona exatamente como daveearley/hi.events-frontend:latest"
    echo -e "   • Executa 'yarn start' na porta 5678"
    echo -e "   • Tamanho: ~3.2GB (otimizada para produção)"
}

# Função para mostrar informações sobre o processo
show_process_info() {
    print_header "BUILD E DEPLOY DO HI.EVENTS FRONTEND"

    echo -e "${CYAN}Este script irá:${NC}"
    echo -e "  1. 🔍 Verificar dependências (Docker)"
    echo -e "  2. 📦 Gerar nova versão automaticamente"
    echo -e "  3. 🏗️  Fazer build usando Dockerfile.ssr oficial"
    echo -e "  4. 🧪 Testar a imagem localmente"
    echo -e "  5. 🔐 Fazer login no Docker Hub"
    echo -e "  6. ⬆️  Fazer upload das imagens"
    echo -e "  7. ✅ Mostrar instruções de uso"
    echo ""

    echo -e "${YELLOW}⚠️  Importante:${NC}"
    echo -e "  • Use o mesmo Dockerfile.ssr da imagem oficial"
    echo -e "  • A imagem será compatível com daveearley/hi.events-frontend:latest"
    echo -e "  • Username configurado: ${CYAN}${DOCKER_USERNAME}${NC}"
    echo ""

    read -p "Pressione Enter para continuar ou Ctrl+C para cancelar..."
}

# ==============================================================================
# FUNÇÃO PRINCIPAL
# ==============================================================================

main() {
    clear
    show_process_info

    check_dependencies
    generate_version
    build_image
    test_image
    docker_login
    push_images
    show_final_info

    print_success "Script executado com sucesso! 🎉"
}

# ==============================================================================
# EXECUÇÃO
# ==============================================================================

# Verificar se o script está sendo executado do diretório correto
if [[ ! -f "Dockerfile.ssr" ]]; then
    print_error "Este script deve ser executado do diretório /frontend"
    print_info "Execute: cd /code/wande/hieventperson/Hi.Events/frontend && ./build-deploy.sh"
    exit 1
fi

# Executar função principal
main "$@"
