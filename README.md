# Bookstio

## Introduction

Bookstio is a introduction project for docker, which helps beginners learn to understand the basic use of docker and have glimpse understanding of automated deployment. 

Bookstio is based on the micro services of *product page*, *reviews*, *ratings* and *details* provided by *istio/sample/bookinfo*. Original project pull the existing micro service image from dockerhub, and use kubernetes + istio to build the service mesh. Bookstio deploys the project from the local source code, using basic docker commands to build images one by one locally. And Bookstio uses docker compose to run a simplified version of bookinfo without istio, which is more friendly to beginners who have just contacted docker.

Bookstio provides a Makefile automated deployment solution, which can help beginners confirm the environment preparation and quickly view the effect.

Bookstio also provides online automatic deployment of GitHub action. After setting the related secrets on GitHub, the image can be built online without environment and pushed to the specified dockerhub



## Environmental preparation

1. Bookstio can be deployed in any Linux distribution that supports docker

2. Docker running environment 

   Reference version: docker version 1.13.1

3. docker-compose 

   Reference version: docker compose version 1.21.2



## Project structure

Download Bookstio through git, including four folders, a makefile file and a docker-compose.yml.

**Productpage**: contains the productpage microservice and its Dockerfile. The microservice displays the main interface and invokes the details and reviews microservice to fill in the page

**Ratings**:  contains ratings microservice and dockerfile. The microservice contains rating information that appears with book reviews.

**Details**: contains the details micro service and its dockerfile. The micro service returns the detailed information of the book.

**Reviews**: the microservice returns the book evaluation and ratings information, and the ratings information displayed comes from invoking the ratings microservice. Reviews microservice has three built-in versions. Version 1 does not invoke ratings service; Version 2 invokes ratings, and the rating shows in black stars; Version 3 invokes ratings, which shows in red stars. Different versions of images can be created by passing in different parameters during build. 

**Makefile**:  Mainly includes *build, commit, run and push* commands. It can automatically build image, run service and submit image to dockerhub. Make command can only be used in the directory with Makefile.



## Local deployment



#### Deploy by Make:

```shell
make build
```

Build docker images for microservices productpage, reviews-v1, reviews-v2, reviews-v3, ratings and details locally

```shell
make run
```

Build image locally through docker compose and create and run container

```shell
make USER_ ID={Dockerhub_ Username} push
```

Automatically build a docker image locally and submit it to the specified dockerhub. The specified dockerhub user name must be passed in



#### Deploy by Docker build :

In addition to using make to automatically build images, you can also use docker build to help build images

In particular, when building a mirror of the reviews service, it must be enabled_ Ratings and star_ Color assignment, for example

```bash
docker build -t reviews-v3 \
--build-arg enable_ ratings=true \
--build-arg star_ Color = black. 
#use ratings microservice and display it with black stars
```



## On-line deployment

1.  https://hub.docker.com/settings/security Registering / logging into dockerhub then obtain the token.

2. After fork project, find secrets under GitHub settings and create new repository secrets named **DOCKER_ HUB_ NAME** and **DOCKER_ HUB_ PASS** fills with the user name and token of dockerhub respectively.
3. After pushing the project, the Git Action will run automatically. After running, the created image can  seen in the dockerhub.

