FROM node:16-alpine AS builder
ENV HOME=/app
WORKDIR $HOME/

RUN apk add --update --no-cache curl net-tools

COPY package*.json  $HOME/

RUN npm install

COPY . $HOME/

RUN npm run build

RUN npm prune --production

# ---------------------------------------------------------------
FROM node:16-alpine AS runtime

RUN apk add --update --no-cache tzdata

ENV HOME=/app
WORKDIR $HOME

COPY --from=build /app/node_modules /app/node_modules
COPY --from=build /app/package.json /app/package.json
COPY --from=build /app/dist /app/dist

CMD npm run start:prod