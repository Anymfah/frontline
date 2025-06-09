# Use an official Node runtime as the base image
FROM node:24-slim
ENV GAME_ENV=Dev

# 1) Installer Git pour que build-prod (webpack) puisse faire git rev-parse
RUN apt-get update \
 && apt-get install -y git \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# 2) Installer TOUTES les dépendances (y compris ts-node pour start:server)
COPY package*.json ./
RUN npm ci

# 3) Copier le code et builder le front
COPY . .
RUN npm run build-dev

# 4) Ouvrir le port exposé par Fly
EXPOSE 3000

# 5) Lancer le server via ton script "start:server" (ts-node)
CMD ["npm", "run", "start:server"]
