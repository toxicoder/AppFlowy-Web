# ---- Base Stage ----
FROM node:18-alpine AS base
WORKDIR /app
COPY package*.json ./
COPY pnpm-lock.yaml ./

# ---- Dependencies Stage ----
FROM base AS deps
RUN npm install -g pnpm
RUN pnpm fetch

# ---- Build Stage ----
FROM base AS build
RUN npm install -g pnpm
COPY . .
RUN pnpm install --offline
RUN pnpm build

# ---- Production Stage ----
FROM node:18-alpine AS production
WORKDIR /app

# Copy production dependencies
COPY --from=build /app/node_modules ./node_modules
# Copy application code
COPY --from=build /app/dist ./dist
COPY --from=build /app/deploy/server.ts ./deploy/server.ts
COPY --from=build /app/package.json .

# Install ts-node to run the server
RUN npm install -g ts-node

# Expose the application port
EXPOSE 8080

# Set the default command to start the server
CMD ["ts-node", "deploy/server.ts"]
