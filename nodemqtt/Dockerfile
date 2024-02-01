FROM node:alpine3.19 AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY tsconfig*.json ./
COPY src src
RUN npm run build

FROM node:alpine3.19
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY --from=builder /app/dist/ /app/
ENTRYPOINT ["node", "/app/app.js"]