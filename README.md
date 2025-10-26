# Catálogo de Filmes

Este projeto é uma aplicação Rails para catalogar filmes, com autenticação (Devise), envio de e-mails via SendGrid (ou API) e integração experimental com uma API de geração de conteúdo por IA (Gemini). Este README explica o projeto, como rodar localmente com Docker, como configurar variáveis de ambiente (incluindo a chave da Gemini API) e como testar as funcionalidades.

---

## Sumário

- Visão geral
- Pré-requisitos
- Rodando localmente com Docker
- Variáveis de ambiente importantes
- Como obter a chave da Gemini API (para testes de IA)

---

## Visão geral

A aplicação permite cadastrar filmes, comentar (de forma anônima ou não) e recuperar senha via Devise. Há uma classe `SendgridMailer` que envia e-mails usando a API HTTP do SendGrid, infelizmente tive algumas limitações no render pois ele estava bloqueando as portas na qual eu fazia a requisição. Existe também um ponto de integração com uma API de geração de texto (Nesse caso, o Gemini) para recursos experimentais de IA.

---

## Pré-requisitos

- Docker e Docker Compose instalados
- Ruby (apenas se for rodar fora do container)
- Conta SendGrid (para envio real de e-mails)
- Conta Google/AI Studio + chave Gemini (opcional — para testar geração por IA)

---


## Rodando localmente com Docker

1. Copie o `.env.example` para `.env` e preencha as variáveis (veja a seção a seguir).

2. Construa e suba os containers:

O container vai ser criado por padrão em modo desenvolvimento (tenho dois arquivos Dockerfile, o próprio Dockerfile é para desenvolvimento, mas há um Dockerfile.production para produção e foi o que eu usei para o render)

```bash
# na raiz do projeto
docker compose build
docker compose up
