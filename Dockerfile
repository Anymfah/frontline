# === builder stage ===
FROM node:24-slim AS builder
WORKDIR /app

# 1) Install dependencies and prepare the environment
COPY package*.json ./
ENV NPM_CONFIG_IGNORE_SCRIPTS=1
RUN npm ci

# 2) Copy all source files and build the app
COPY . .
RUN npm run build-prod

# === runtime stage ===
FROM node:24-slim AS runner
WORKDIR /app

# 3) Copy built files and necessary configurations from the builder stage
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/out  ./out
COPY --from=builder /app/package*.json ./

# 4) Install production dependencies only
RUN npm ci --production

# 5) Config environment variables
ENV PORT=3000
EXPOSE 3000

# 6) Launch the application
CMD ["node", "dist/server/Server.js"]
