# Stage 1 — build the app and prepare production dependencies
FROM dhi.io/node:26-dev AS build

WORKDIR /app

COPY package*.json ./

RUN npm install --legacy-peer-deps

COPY . .

RUN npm run build

# Stage 1b — install only production dependencies (minimal runtime deps)
FROM dhi.io/node:26-dev AS prod-deps

WORKDIR /app

COPY package*.json ./

RUN npm install --only=production vite@5.4.11 && \
    npm cache clean --force && \
    find node_modules -type f -name "*.md" -delete

# Stage 2 — distroless runtime (minimal, secure)
FROM dhi.io/node:26

WORKDIR /app

# Copy built files from builder
COPY --from=build /app/dist ./dist

# Copy production node_modules
COPY --from=prod-deps /app/node_modules ./node_modules
COPY vite.preview.config.js ./vite.config.js

EXPOSE 4173

# Use exec form for proper signal handling
ENTRYPOINT ["node", "--no-warnings"]
CMD ["./node_modules/.bin/vite", "preview", "--host", "0.0.0.0", "--port", "4173"]
