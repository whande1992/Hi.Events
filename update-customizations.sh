#!/bin/bash

# Script para Atualizar Customizações após Sincronização
# Autor: whande1
# Descrição: Aplica suas customizações sobre as atualizações do upstream

set -e

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_header() {
    echo -e "${BLUE}[UPDATE]${NC} $1"
}

# Verificar se estamos no diretório correto
if [ ! -d ".git" ]; then
    print_error "Este diretório não é um repositório Git!"
    exit 1
fi

print_header "Atualizando suas customizações..."

# Verificar se branch de customizações existe
if ! git branch | grep -q "customizations/whande1"; then
    print_warning "Branch 'customizations/whande1' não encontrado. Criando..."

    # Criar branch de customizações a partir do develop atual
    git checkout develop
    git checkout -b customizations/whande1

    # Commit das customizações atuais
    if [ -n "$(git status --porcelain)" ]; then
        print_status "Commitando suas customizações atuais..."
        git add .
        git commit -m "feat: Customizações whande1 - Docker personalizado, logos, configurações PT-BR

Customizações incluídas:
- Dockerfile.custom para imagem Docker personalizada
- Logos personalizados
- Configurações PT-BR
- Scripts de build automatizados
- Remoção do footer 'Powered by Hi.Events'
- Configurações de email personalizadas"
    fi

    print_status "Branch 'customizations/whande1' criado!"
fi

# Mudar para o branch de customizações
print_status "Mudando para branch de customizações..."
git checkout customizations/whande1

# Fazer rebase sobre o develop atualizado
print_status "Aplicando suas customizações sobre as atualizações..."
if git rebase develop; then
    print_status "Rebase realizado com sucesso!"
else
    print_error "Conflitos encontrados durante o rebase!"
    print_warning "Resolva os conflitos manualmente e execute:"
    echo "  git add <arquivos-resolvidos>"
    echo "  git rebase --continue"
    exit 1
fi

# Push das customizações atualizadas
print_status "Enviando customizações atualizadas..."
git push origin customizations/whande1 --force-with-lease

print_header "Customizações atualizadas com sucesso!"

# Informações úteis
echo ""
print_status "Informações úteis:"
echo "  - Branch principal: develop"
echo "  - Suas customizações: customizations/whande1"
echo "  - Para usar em produção: customizations/whande1"
echo ""
print_status "Próximos passos:"
echo "  1. Teste suas customizações"
echo "  2. Faça build da imagem Docker: cd frontend && ./build-and-push.sh"
echo "  3. Deploy usando o branch customizations/whande1"
