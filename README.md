# Catálogo de Filmes

Este projeto é uma aplicação Rails para catalogar filmes, com autenticação (Devise), envio de e-mails via SendGrid (ou API) e integração experimental com uma API de geração de conteúdo por IA (Gemini). Este README explica o projeto, como rodar localmente com Docker, como configurar variáveis de ambiente (incluindo a chave da Gemini API) e como testar as funcionalidades.

---

# 🚀 Funcionalidades Implementadas

✅ Funcionalidades Obrigatórias
Área Pública (sem login):

    ✅ Listagem de filmes ordenados do mais novo para o mais antigo

    ✅ Paginação (6 filmes por página)

    ✅ Visualização de detalhes dos filmes (título, sinopse, ano, duração, diretor)

    ✅ Comentários anônimos (com nome e conteúdo)

    ✅ Comentários ordenados do mais recente para o mais antigo

    ✅ Cadastro de novos usuários

Área Autenticada (com login):

    ✅ Sistema de logout

    ✅ Cadastro, edição e exclusão de filmes (apenas os criados pelo usuário)

    ✅ Comentários com nome do usuário automaticamente vinculado

    ✅ Edição de perfil e alteração de senha

    ✅ Funcionalidades Opcionais Implementadas
    ✅ Categorias de filmes: Cadastro e atribuição de múltiplas categorias

    ✅ Busca e filtros: Busca por título, diretor e ano + filtros por categoria

    ✅ Upload de imagens: Integração com Active Storage para posters dos filmes

    ✅ Internacionalização (I18n): Suporte a português e inglês

    ✅ Testes automatizados: Testes básicos para models e controllers

🧠 Super Diferencial 2 - Integração com IA

    ✅ Busca automática por IA: Integração com Google Gemini API

    ✅ Preenchimento automático: Busca pelo título preenche automaticamente sinopse, ano, duração e diretor

    ✅ Tratamento de erros: Feedback claro em caso de problemas na integração

---

# ⚠️ Observações Importantes
🔐 Recuperação de Senha

    Status: Implementada mas com limitações no deploy

    Problema: O Render bloqueia portas de e-mail em planos gratuitos

    Localmente: Funciona corretamente com configuração do SendGrid

    Em produção: A funcionalidade pode não operar conforme esperado

🖼️ Upload de Imagens (Active Storage)

    Status: Implementada mas com limitações no deploy

    Problema: O Render não oferece armazenamento persistente em planos gratuitos

    Localmente: Uploads funcionam perfeitamente

    Em produção: Imagens podem ser perdidas entre deploys

---

## Testar localmente

- Docker e Docker Compose instalados
- Ruby (apenas se for rodar fora do container)
- Conta SendGrid (para envio real de e-mails)
- Chave Gemini (opcional — para testar geração por IA)

# 1. Clone o repositório
```bash
git clone [url-do-repositorio]
cd catalogo-filmes
```

# 2. Configure a chave do Gemini (só se você quiser testar a função de gerar atributos do filme localmente)
- Acesse o site https://aistudio.google.com/api-keys?project=gen-lang-client-0621940042 
- crie uma chave de API nova, ou use a que vem por padrão na tela inicial. 
- Depois disso, crie um arquivo .env na raiz do projeto, crie uma variável chamada GEMINI_API_KEY e atribua a ela a chave criada por você.

# 3. Execute com o Docker
 ```bash
docker compose build
docker compose up
```

# Acesse a aplicação no http://localhost:3000
```bash
http://localhost:3000
```

---

# 🧪 Testes Unitários

Para executar testes automatizados faça:

```bash
docker compose exec web bundle exec rspec
```

# 🌐 Deploy

A aplicação está disponível em: https://catalogo-de-filmes-rz92.onrender.com

---

Stack utilizada no deploy:

- Ruby on Rails

- PostgreSQL

- Render (plano free)

🔧 Tecnologias Utilizadas

- Backend: Ruby on Rails 7+

- Banco de dados: PostgreSQL

- Autenticação: Devise

- Internacionalização: Rails I18n

- Testes: RSpec

- Upload de arquivos: Active Storage

- Containerização: Docker

- Deploy: Render

# 👤 Desenvolvido por
Paulo Henrique Araújo Bento - paulohab2004@gmail.com

https://www.linkedin.com/in/paulo-henrique-araujo-bento/