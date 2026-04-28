# 🌏 Lingua Backend API

API RESTful pour la plateforme d'apprentissage de langues Lingua.

## Stack technique
- **Node.js** + **Express.js**
- **MySQL 8** (données relationnelles)
- **Redis** (sessions, cache)
- **Docker Compose** (infrastructure)
- **OpenRouter AI** (GPT-4o)

## Démarrage rapide

### Prérequis
- Docker & Docker Compose
- Node.js 20+

### Avec Docker (recommandé)
```bash
cp .env.example .env
docker-compose up -d
```

### Sans Docker
```bash
cp .env.example .env
# Configurer MySQL et Redis dans .env
npm install
node src/server.js
```

## Endpoints principaux

| Méthode | Route | Description |
|---------|-------|-------------|
| POST | /api/auth/register | Inscription |
| POST | /api/auth/login | Connexion |
| GET | /api/words | Liste des mots (filter: language, level, search) |
| GET | /api/words/:id | Détail d'un mot |
| GET | /api/flashcards/decks | Mes decks |
| POST | /api/flashcards/cards/:id/review | Review SM-2 |
| GET | /api/gamification/stats | Mes stats (XP, streak, hearts) |
| POST | /api/ai/explain | Explication grammaticale |
| POST | /api/ai/sessions/:id/chat | Chat roleplay (SSE stream) |
| GET | /api/courses | Liste des cours |
| POST | /api/lessons/:id/start | Démarrer une leçon |

## Variables d'environnement
Copier `.env.example` en `.env` et configurer.
