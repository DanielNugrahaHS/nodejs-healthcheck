FROM node:24-alpine AS builder

RUN mkdir -p /home/node/app/node_modules && chown -R node:node /home/node/app
WORKDIR /home/node/app

COPY package*.json ./
USER node

RUN npm ci --omit=dev && npm cache clean --force
COPY --chown=node:node . .

# Multistage
FROM gcr.io/distroless/nodejs24-debian12

COPY --from=builder /home/node/app /app

WORKDIR /app
EXPOSE 8111

CMD ["hello.js"]
