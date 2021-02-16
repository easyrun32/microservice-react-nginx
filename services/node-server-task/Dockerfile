FROM node:14-alpine

COPY . /src

WORKDIR /src

ENV NODE_ENV development

RUN npm install --production

EXPOSE 5000

CMD npm start