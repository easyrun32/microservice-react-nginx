A microservice template!
Technologies:
React - frontend
Node - server
Nginx - proxy server basically to route the services to avoid same site cross origin
Docker - connection between the microservices
Terraform - setup the infrastructure on aws
buildspec.yml - To compile our infrastructure in the cloud

Setup:
DockerHub
Docker-repository must be named for client and server
I named my project micro-react-nginx-users
{Your_Docker_Id}/{YourProjectName}-client
{Your_Docker_Id}/{YourProjectName}-users

~ Build Client

```
docker build \
 -f client/Dockerfile.prod \
 -t {Your_Docker_Id}/{YourProjectName}-client:prod \
 --build-arg NODE_ENV=production \
 ./client
```

~Push It To Dockerhub

```
docker push {Your_Docker_Id}/{YourProjectName}-client:prod
```

~ Build User

```
docker build \
 -f services/node-server-users/Dockerfile.prod \
 -t {Your_Docker_Id}/{YourProjectName}-users:prod \
 ./services/node-server-users/
```

~ Push It To Dockerhub

```
docker push {Your_Docker_Id}/{YourProjectName}-users:prod
```
