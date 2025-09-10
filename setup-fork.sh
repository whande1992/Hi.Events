#!/bin/bash

# Script de Configuração Inicial do Fork Hi.Events
# Autor: whande1
# Descrição: Configura o repositório para manter customizações e receber atualizações

set -e

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${GREEN}[SETUP]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_header() {
    echo -e "${BLUE}=== CONFIGURAÇÃO INICIAL DO FORK HI.EVENTS ===${NC}"
}

clear
print_header
echo ""
print_status "Este script vai configurar seu repositório para:"
echo "  ✅ Manter suas customizações"
echo "  ✅ Receber atualizações do Hi.Events original"
echo "  ✅ Sincronizar mudanças facilmente"
echo ""

# Verificar se estamos no diretório correto
if [ ! -f "README.md" ] || [ ! -d "frontend" ] || [ ! -d "backend" ]; then
    print_error "Execute este script no diretório raiz do Hi.Events!"
    exit 1
fi

# Configurar remotes
print_status "1. Configurando repositórios remotos..."

# Remover remotes existentes se houver
git remote remove origin 2>/dev/null || true
git remote remove upstream 2>/dev/null || true

# Adicionar remotes corretos
git remote add upstream https://github.com/HiEventsDev/Hi.Events.git
git remote add origin https://github.com/whande1992/Hi.Events.git

print_status "Remotes configurados:"
git remote -v

# Configurar Git user se não estiver configurado
if [ -z "$(git config user.name)" ]; then
    print_status "2. Configurando informações do usuário Git..."
    git config user.name "whande1"
    git config user.email "seu-email@exemplo.com"
    print_warning "Lembre-se de atualizar o email em: git config user.email 'seu-email-real@exemplo.com'"
fi

# Commit das customizações atuais se houver arquivos não commitados
print_status "3. Salvando suas customizações atuais..."
if [ -n "$(git status --porcelain)" ]; then
    git add .
    git commit -m "feat: Customizações iniciais whande1

Customizações incluídas:
- Dockerfile.custom para imagem Docker personalizada (whande1/hievents-frontend-ssr)
- Scripts de build automatizados (build-and-push.sh, quick-build.sh)
- Logos e imagens personalizados
- Configurações PT-BR (datas, moedas, idioma)
- Remoção do footer 'Powered by Hi.Events'
- Configurações de email personalizadas
- Guias de documentação personalizados"
    print_status "Customizações commitadas!"
else
    print_status "Nenhuma alteração pendente encontrada."
fi

# Criar branch de customizações
print_status "4. Criando branch para suas customizações..."
git checkout -b customizations/whande1 2>/dev/null || git checkout customizations/whande1

# Fazer push inicial
print_status "5. Enviando para seu repositório no GitHub..."
git push origin develop --set-upstream 2>/dev/null || git push origin develop
git push origin customizations/whande1 --set-upstream

# Buscar atualizações do upstream
print_status "6. Buscando atualizações do repositório original..."
git fetch upstream

print_header
echo ""
print_status "🎉 Configuração concluída com sucesso!"
echo ""
print_status "📋 Estrutura configurada:"
echo "  - origin: https://github.com/whande1992/Hi.Events.git (seu repositório)"
echo "  - upstream: https://github.com/HiEventsDev/Hi.Events.git (repositório original)"
echo ""
print_status "🌟 Branches:"
echo "  - develop: branch principal sincronizado com upstream"
echo "  - customizations/whande1: suas customizações"
echo ""
print_status "🚀 Próximos passos:"
echo "  1. Para sincronizar com upstream: ./sync-upstream.sh"
echo "  2. Para atualizar customizações: ./update-customizations.sh"
echo "  3. Para gerar imagem Docker: cd frontend && ./build-and-push.sh"
echo ""
print_status "📚 Documentação completa: GIT-WORKFLOW-GUIDE.md"
echo ""
print_warning "⚠️  Lembre-se de configurar seu email Git:"
echo "     git config user.email 'seu-email@exemplo.com'"
