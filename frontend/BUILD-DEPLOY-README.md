# 🚀 Build e Deploy de Imagem Docker Personalizada - Hi.Events Frontend

Este guia explica como criar e fazer deploy de uma imagem Docker personalizada do Hi.Events Frontend que funciona **exatamente** como a imagem oficial `daveearley/hi.events-frontend:latest`.

## 📋 Pré-requisitos

- ✅ Docker instalado e funcionando
- ✅ Conta no Docker Hub
- ✅ Git (para clonar o repositório)

## 🎯 O Que Este Processo Faz

Com base na análise do arquivo `post-release-push-images.yml` do projeto oficial, descobrimos que a imagem oficial usa:

```yaml
context: ./frontend
file: ./frontend/Dockerfile.ssr  # ← Mesmo arquivo que já existe no projeto!
```

Ou seja, **não precisamos criar Dockerfiles personalizados**! O `Dockerfile.ssr` que já existe é exatamente o mesmo usado pela imagem oficial.

## 🚀 Método Automático (Recomendado)

### Passo 1: Executar o Script Automático

```bash
# Navegar para o diretório frontend
cd /code/wande/hieventperson/Hi.Events/frontend

# Executar o script
./build-deploy.sh
```

O script irá:
1. 🔍 Verificar dependências
2. 📦 Gerar versão automaticamente
3. 🏗️ Fazer build usando `Dockerfile.ssr`
4. 🧪 Testar localmente
5. 🔐 Fazer login no Docker Hub
6. ⬆️ Upload das imagens
7. ✅ Mostrar instruções de uso

## 🛠️ Método Manual

### Passo 1: Personalizar Configurações

Edite as variáveis no script `build-deploy.sh`:

```bash
DOCKER_USERNAME="SEU_USERNAME"  # Substitua pelo seu username
IMAGE_NAME="hievents-frontend"
BASE_VERSION="1.3"  # Versão base
```

### Passo 2: Build da Imagem

```bash
cd /code/wande/hieventperson/Hi.Events/frontend

# Build usando o Dockerfile.ssr oficial
docker build -f Dockerfile.ssr -t SEU_USERNAME/hievents-frontend:v1.3.X .
```

### Passo 3: Testar Localmente

```bash
# Testar na porta 5678 (mesma da imagem oficial)
docker run -p 5678:5678 SEU_USERNAME/hievents-frontend:v1.3.X
```

### Passo 4: Upload para Docker Hub

```bash
# Login
docker login

# Upload
docker push SEU_USERNAME/hievents-frontend:v1.3.X
docker push SEU_USERNAME/hievents-frontend:latest
```

## 📝 Características da Imagem Gerada

- ✅ **Porta**: 5678 (mesma da oficial)
- ✅ **Comando**: `yarn start`
- ✅ **Tamanho**: ~3.2GB (similar à oficial)
- ✅ **Dockerfile**: `Dockerfile.ssr` (mesmo da oficial)
- ✅ **Comportamento**: Idêntico à `daveearley/hi.events-frontend:latest`

## 🔧 Como Usar no Seu Projeto

### Docker Compose

```yaml
services:
  frontend:
    image: SEU_USERNAME/hievents-frontend:v1.3.X
    ports:
      - "5678:5678"
    environment:
      # ... suas variáveis de ambiente
```

### Docker Run

```bash
docker run -p 5678:5678 \
  -e VITE_API_URL_SERVER="http://localhost/api" \
  -e VITE_API_URL_CLIENT="https://app.hi.events/api" \
  SEU_USERNAME/hievents-frontend:v1.3.X
```

## 🔍 Troubleshooting

### Problema: Erro 502

**Causa**: Usar `Dockerfile.csr` em vez do `Dockerfile.ssr`
**Solução**: Sempre use `Dockerfile.ssr` que é o oficial

### Problema: Imagem não atualiza

**Causa**: Mesma tag sendo reutilizada
**Solução**: Use versões incrementais (v1.3.0, v1.3.1, etc.)

### Problema: Container não inicia

**Verificar logs**:
```bash
docker logs CONTAINER_NAME
```

**Verificar se está na porta correta**: 5678 (não 80)

## 📚 Arquivos Importantes

- `Dockerfile.ssr` - Dockerfile oficial usado pela imagem original
- `build-deploy.sh` - Script automatizado para build e deploy
- `post-release-push-images.yml` - GitHub Actions oficial (referência)

## 🔗 Links Úteis

- [Docker Hub Official](https://hub.docker.com/r/daveearley/hi.events-frontend)
- [Hi.Events GitHub](https://github.com/HiEventsDev/Hi.Events)
- [Documentação Docker](https://docs.docker.com/)

## 📞 Suporte

Se você encontrar problemas:

1. Verifique se está usando o `Dockerfile.ssr`
2. Confirme que a porta é 5678
3. Verifique os logs do container
4. Use uma nova versão (incremente o número)

---

💡 **Dica**: A chave do sucesso é usar exatamente o mesmo `Dockerfile.ssr` que a imagem oficial usa, conforme descoberto no arquivo `post-release-push-images.yml`!
