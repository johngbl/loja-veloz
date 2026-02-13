FROM node:18-slim AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production
COPY . .

FROM node:18-slim
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*
RUN useradd --user-group --create-home appuser
WORKDIR /home/appuser/app
COPY --from=builder /app .
RUN chown -R appuser:appuser /home/appuser
USER appuser
ENV NODE_ENV=production
EXPOSE 3000
HEALTHCHECK --interval=30s --timeout=5s --start-period=5s CMD curl -f http://localhost:3000/health || exit 1
CMD ["node", "index.js"]
