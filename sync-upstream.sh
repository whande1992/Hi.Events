#!/bin/bash

# Script para Sincronizar com Repositório Original Hi.Events
# Autor: whande1
# Descrição: Busca e aplica atualizações do repositório upstream

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
    echo -e "${BLUE}[SYNC]${NC} $1"
}

# Verificar se estamos no diretório correto
if [ ! -d ".git" ]; then
    print_error "Este diretório não é um repositório Git!"
    exit 1
fi

print_header "Iniciando sincronização com repositório original Hi.Events..."

# Verificar se upstream está configurado
if ! git remote | grep -q "upstream"; then
    print_warning "Remote 'upstream' não encontrado. Configurando..."
    git remote add upstream https://github.com/HiEventsDev/Hi.Events.git
    print_status "Remote 'upstream' adicionado!"
fi

# Verificar se origin está configurado
if ! git remote | grep -q "origin"; then
    print_warning "Remote 'origin' não encontrado. Configurando..."
    git remote add origin https://github.com/whande1992/Hi.Events.git
    print_status "Remote 'origin' adicionado!"
fi

# Mostrar remotes configurados
print_status "Remotes configurados:"
git remote -v

# Fazer backup do branch atual
current_branch=$(git branch --show-current)
print_status "Branch atual: $current_branch"

# Buscar atualizações do upstream
print_status "Buscando atualizações do repositório original..."
git fetch upstream

# Verificar se há atualizações
updates=$(git log HEAD..upstream/develop --oneline | wc -l)
if [ "$updates" -eq 0 ]; then
    print_status "Nenhuma atualização disponível. Seu repositório está atualizado!"
    exit 0
fi

print_warning "Encontradas $updates atualizações no repositório original."

# Mostrar o que será atualizado
echo ""
print_status "Novos commits do repositório original:"
git log HEAD..upstream/develop --oneline --color=always | head -10

# Perguntar se deve continuar
echo ""
read -p "Deseja aplicar essas atualizações? (y/n): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    print_warning "Sincronização cancelada pelo usuário."
    exit 0
fi

# Fazer checkout para develop
print_status "Mudando para branch develop..."
git checkout develop

# Fazer merge das atualizações
print_status "Aplicando atualizações do upstream..."
if git merge upstream/develop; then
    print_status "Merge realizado com sucesso!"
else
    print_error "Conflitos encontrados durante o merge!"
    print_warning "Resolva os conflitos manualmente e execute: git commit"
    exit 1
fi

# Push para origin
print_status "Enviando atualizações para seu repositório..."
git push origin develop

print_header "Sincronização concluída com sucesso!"
print_status "Para atualizar suas customizações, execute: ./update-customizations.sh"

# Voltar para o branch original se não era develop
if [ "$current_branch" != "develop" ]; then
    print_status "Voltando para branch original: $current_branch"
    git checkout "$current_branch"
fi
