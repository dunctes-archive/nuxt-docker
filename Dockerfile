# we need a Dabian based image in order to build sass
FROM node:14-stretch AS builder

WORKDIR /oengus-frontend

COPY package.json package-lock.json ./
RUN npm ci

COPY . .
RUN npm run build

FROM node:14-alpine

WORKDIR /oengus-frontend

COPY --from=builder /oengus-frontend/.nuxt/ ./.nuxt/
# This is all we need to run the app
RUN npm install nuxt

# set the host to 0.0.0.0 so we can access it outside of docker
ENV HOST=0.0.0.0
ENV PORT=3000

CMD ["npx", "nuxt", "start"]
