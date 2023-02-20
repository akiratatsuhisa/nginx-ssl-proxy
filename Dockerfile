FROM node:alpine as builder

WORKDIR /app

COPY ./package*.json .

RUN npm ci

COPY . .

RUN npm run build

RUN npm prune --production

FROM node:alpine

WORKDIR /app

COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/dist ./dist

EXPOSE 3000

ENTRYPOINT [ "node", "dist/main.js" ]