###########
# BUILDER #
###########

# pull official base image
FROM node:13.10.1-alpine as builder

# set working directory
WORKDIR /usr/src/app

# add `/usr/src/app/node_modules/.bin` to $PATH
ENV PATH /usr/src/app/node_modules/.bin:$PATH

# install and cache app dependencies
COPY package.json .
COPY package-lock.json .
RUN npm ci
RUN npm install react-scripts@4.0.2  --silent

ENV NODE_ENV production

# create build
COPY . .
RUN npm run build


#########
# FINAL #
#########

# base image
FROM nginx:latest



# copy static files
COPY --from=builder /usr/src/app/build /usr/share/nginx/html

# expose port
EXPOSE 80

# run nginx
CMD ["nginx", "-g", "daemon off;"]