FROM node:alpine3.18 AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY src src
COPY public public
COPY tsconfig*.json ./
RUN npm run build

FROM node:alpine3.18
WORKDIR /app
COPY --from=builder /app/build/ /app/
RUN npm install -g serve
EXPOSE 3000
CMD ["serve", "-s", "/app", "-l", "3000"]
