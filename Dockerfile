FROM node:alpine

# env vars
ENV HTTP_PORT=3001
ENV WS_PORT=3002
ENV CDN_PORT=3003
ENV RTC_PORT=3004
ENV ADMIN_PORT=3005

# exposed ports (only for reference, see https://docs.docker.com/engine/reference/builder/#expose)
EXPOSE ${HTTP_PORT}/tcp ${WS_PORT}/tcp ${CDN_PORT}/tcp ${RTC_PORT}/tcp ${ADMIN_PORT}/tcp

# install required apps
RUN apk add --no-cache --update git python3 py-pip make build-base g++ pkgconfig pixman-dev cairo-dev pango-dev
RUN ln -s /usr/bin/python3 /usr/bin/python
RUN npm install --global patch-package --save

# Run as non-root user
# RUN adduser -D fosscord
# USER fosscord

WORKDIR /srv/fosscord-server/bundle
COPY package.json ./
RUN npm install --omit optional
COPY . .
RUN patch-package
RUN npm run build
CMD ["npm", "run", "start:bundle"]