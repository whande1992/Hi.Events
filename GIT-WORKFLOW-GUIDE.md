# Guia para Configurar Fork do Hi.Events com Suas Customizações

## 🎯 Objetivo
Manter um fork do Hi.Events que permita:
- ✅ Suas customizações no seu repositório
- ✅ Receber atualizações do repositório original
- ✅ Sincronizar mudanças quando necessário

## 📋 Configuração dos Repositórios Remotos

### 1. Configurar os Remotes
Execute estes comandos no diretório do projeto:

```bash
cd /code/wande/hieventperson/Hi.Events

# Adicionar o repositório original como upstream
git remote add upstream https://github.com/HiEventsDev/Hi.Events.git

# Adicionar seu repositório como origin
git remote add origin https://github.com/whande1992/Hi.Events.git

# Verificar se os remotes foram configurados
git remote -v
```

Resultado esperado:
```
origin	https://github.com/whande1992/Hi.Events.git (fetch)
origin	https://github.com/whande1992/Hi.Events.git (push)
upstream	https://github.com/HiEventsDev/Hi.Events.git (fetch)
upstream	https://github.com/HiEventsDev/Hi.Events.git (push)
```

## 🔄 Fluxo de Trabalho Recomendado

### 2. Commit Suas Customizações Atuais
```bash
# Adicionar todos os arquivos customizados
git add .

# Commit suas alterações
git commit -m "feat: Customizações whande1 - Docker personalizado, logos, configurações PT-BR"

# Push para seu repositório
git push origin develop
```

### 3. Criar Branch para Suas Customizações
```bash
# Criar branch específico para suas customizações
git checkout -b customizations/whande1

# Push do branch customizado
git push origin customizations/whande1
```

## 🔄 Receber Atualizações do Repositório Original

### 4. Sincronizar com Upstream (Repositório Original)
```bash
# Buscar atualizações do repositório original
git fetch upstream

# Verificar diferenças
git log develop..upstream/develop --oneline

# Mergear atualizações (no branch develop)
git checkout develop
git merge upstream/develop

# Resolver conflitos se houver e commit
git push origin develop
```

### 5. Aplicar Suas Customizações nas Atualizações
```bash
# Fazer rebase das suas customizações sobre as atualizações
git checkout customizations/whande1
git rebase develop

# Resolver conflitos se houver
# Push das customizações atualizadas
git push origin customizations/whande1 --force-with-lease
```

## 🚀 Scripts Automatizados

### Script para Sincronizar com Upstream
Salvar como `sync-upstream.sh`:
```bash
#!/bin/bash
echo "🔄 Sincronizando com repositório original..."
git fetch upstream
git checkout develop
git merge upstream/develop
git push origin develop
echo "✅ Sincronização concluída!"
```

### Script para Atualizar Customizações  
Salvar como `update-customizations.sh`:
```bash
#!/bin/bash
echo "🔄 Atualizando customizações..."
git checkout customizations/whande1
git rebase develop
git push origin customizations/whande1 --force-with-lease
echo "✅ Customizações atualizadas!"
```

## 📁 Estrutura de Branches Recomendada

```
develop (branch principal)
├── upstream/develop (Hi.Events original)
└── customizations/whande1 (suas customizações)
```

## 🎯 Customizações Identificadas

### Frontend:
- ✅ Dockerfile.custom (imagem Docker personalizada)
- ✅ Logos personalizados em `/public/`
- ✅ Configurações PT-BR
- ✅ Scripts de build customizados
- ✅ Remoção de "Powered by Hi.Events"

### Backend:
- ✅ Configurações de mail customizadas
- ✅ Outras configurações regionais

## ⚠️ Pontos de Atenção

1. **Sempre faça backup** antes de sincronizar
2. **Teste suas customizações** após cada sincronização
3. **Documente suas alterações** para facilitar merges
4. **Use branches separados** para diferentes tipos de customização

## 🔧 Comandos Úteis

```bash
# Ver status das suas customizações
git status

# Ver diferenças com o original
git diff upstream/develop

# Ver commits únicos seus
git log upstream/develop..HEAD --oneline

# Criar patch das suas alterações
git format-patch upstream/develop
```

## 📈 Workflow Diário

1. **Trabalhando nas customizações**: `customizations/whande1`
2. **Sincronizar semanalmente**: Execute `sync-upstream.sh`
3. **Atualizar customizações**: Execute `update-customizations.sh`
4. **Deploy**: Use branch `customizations/whande1`
