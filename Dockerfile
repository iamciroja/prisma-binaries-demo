FROM repo.dev002.local/ukd-dwh-dg-docker-dev/node:22.13.1-alpine3.21

WORKDIR /foo

ARG NPM_REGISTRY_DEV
ARG NPM_REGISTRY_REMOTE

RUN npm set registry $NPM_REGISTRY_REMOTE && \ 
    npm set @sibur-data-office:registry $NPM_REGISTRY_DEV && \
    npm config set strict-ssl false


COPY . ./
RUN pwd && ls -la && cat ./prisma/schema.prisma
RUN npm install
RUN DEBUG="*" npx prisma generate
RUN npm run build

CMD node dist/main.js
