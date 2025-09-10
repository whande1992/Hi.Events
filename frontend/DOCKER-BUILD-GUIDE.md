# Guia para Build e Deploy da Imagem Docker Personalizada

## 📋 Informações da Imagem
- **Usuário Docker Hub**: `whande1`
- **Nome da Imagem**: `hievents-frontend-ssr`
- **Porta**: `5678`
- **Dockerfile**: `Dockerfile.custom`

## 🚀 Como Fazer o Build e Upload

### 1. Método Automático (Recomendado)
```bash
cd frontend
./build-and-push.sh
```

### 2. Método Manual
```bash
cd frontend

# Build da imagem
docker build -f Dockerfile.custom -t whande1/hievents-frontend-ssr:$(date +%Y%m%d-%H%M%S) .

# Tag como latest
docker tag whande1/hievents-frontend-ssr:$(date +%Y%m%d-%H%M%S) whande1/hievents-frontend-ssr:latest

# Login no Docker Hub
docker login

# Push das imagens
docker push whande1/hievents-frontend-ssr:$(date +%Y%m%d-%H%M%S)
docker push whande1/hievents-frontend-ssr:latest
```

## 🔧 Testando Localmente
```bash
# Testar a imagem localmente
docker run -p 5678:5678 whande1/hievents-frontend-ssr:latest
```

## 📦 Usando no Docker Compose
```yaml
services:
  frontend:
    image: whande1/hievents-frontend-ssr:latest
    ports:
      - "5678:5678"
    environment:
      # Suas variáveis de ambiente aqui
```

## 📝 Notas Importantes
- A versão é gerada automaticamente com timestamp para forçar atualizações
- A imagem usa multi-stage build para otimização de tamanho
- Porta padrão é 5678 (mesma da imagem oficial)
- O script pergunta se você quer fazer upload automático

## 🔄 Atualizando a Imagem
Sempre que fizer alterações no código:
1. Execute o script novamente: `./build-and-push.sh`
2. Use a nova versão gerada no seu docker-compose ou deployment
