FROM node:22.13.1-alpine3.21

WORKDIR /foo

COPY . ./
RUN pwd && ls -la && cat ./prisma/schema.prisma
RUN npm install
RUN DEBUG="*" npx prisma generate
RUN npm run build

CMD node dist/main.js
