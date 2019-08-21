# TO-DO

- Using docker variables
- Import certificates
- Set localhost config in config folder

# build

create certificates using Generate-Certificates.ps1 
create identityserver:latest using build.ps1

# test

docker-compose .\tests\9.2.0 rev. 002893\windowsservercore\docker-compose.xm-is.yml

# test docker

docker run -d -p 80:80 identityserver:latest

# explore docker image
docker exec -it <CONTAINER_ID> cmd