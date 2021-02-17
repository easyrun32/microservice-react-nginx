A microservice template!

<br/>
Technologies:<br/>
- React - frontend<br/>
- Node - server<br/>
- Nginx - proxy server basically to route the services to avoid same site cross origin<br/>
- Docker - connection between the microservices<br/>
- Terraform - setup the infrastructure on aws<br/>
- buildspec.yml - To compile our infrastructure in the cloud<br/>
<br/>
Setup:<br/>
DockerHub<br/>
Docker-repository must be named for client and server<br/>
I named my project micro-react-nginx-users

steps:

~ 1 Build Client

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

~ 2 Build User

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
