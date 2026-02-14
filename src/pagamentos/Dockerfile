FROM node:18-alpine AS deps
WORKDIR /usr/src/app
COPY package*.json ./
RUN npm ci --production

FROM node:18-alpine AS builder
WORKDIR /usr/src/app
COPY . .

FROM node:18-alpine AS runner
ARG NODE_ENV=production
ENV NODE_ENV=${NODE_ENV}
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
WORKDIR /home/appuser/app
COPY --from=deps /usr/src/app/node_modules ./node_modules
COPY --from=builder /usr/src/app .
RUN chown -R appuser:appgroup /home/appuser
USER appuser
EXPOSE 3000
HEALTHCHECK --interval=30s --timeout=5s --start-period=5s CMD wget -qO- http://localhost:3000/health || exit 1
CMD ["node", "index.js"]
