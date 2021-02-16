# pull official base image
FROM node:13.10.1-alpine
# set working directory
WORKDIR /usr/src/app

# add `/usr/src/app/node_modules/.bin` to $PATH
ENV PATH /usr/src/app/node_modules/.bin:$PATH



# install and cache app dependencies
COPY package.json .
COPY package-lock.json .
#  RUN npm ci (named after Continuous Integration) installs 
#  dependencies directly from package-lock. json and 
#  uses package. json only to validate that there are
#  no mismatched versions. If any dependencies are 
#  missing or have incompatible versions, it will throw an error.
RUN npm ci
RUN npm install react-scripts@4.0.2 prettier@2.1.1 eslint@7.13.0 -g --silent

# Pretty self explanatory XD 
CMD ["npm", "start"]