# ids721_p2_docker_container

###  Introduction

Docker is a set of platform as a service (PaaS) products that use OS-level virtualization to deliver software in packages called containers. Containers are isolated from one another and bundle their own software, libraries and configuration files; they can communicate with each other through well-defined channels. (Wikipedia) While, Docker Hub is the world's easiest way to create, manage, and deliver your teams' container applications. This project would show how to encapsulate a python scripty into a docker container and push the image to [DockerHub](https://hub.docker.com/) so that it can be access by anyone who interested on it. 

### Python App

The python app is named Character Image. It can convert a jpg file to character image. The conversion is looks like as :

<img src=".\img\convert.png" alt="convert" style="zoom:75%;" />

### Encapsulation

We can encapsulation our python application into a docker container by the `docker build` command. The build process is configured by a build file which you can find in this repository. The builder will download the base image from Docker Hub as the start point of the target docker image. The base image for this project is python3.7. The image will automatically prepare a python 3.7 environment for us. Aside from basic python 3.7, the application needs some additional python packages recorded in requirements.txt. The docker builder would install these packages into target images according to the build file. At the end of the build file, there is a command-line to call the python application. One interesting thing is that: when we run the docker image with the command line, the docker engine would pass the arguments into the docker and give it to the python interpolator inside the docker. Hence, the python application can receive outside parameters, which makes it more flexible. Another thing to notice is that a local folder was mounted into the docker so that the python application could access the image outside the docker image. Please check the docker file for more detailed information. 

### Push Image To Docker Hub 

##### 1 Login Docker Hub in terminal 

After registering an account in Docker Hub, you can log into Docker Hub from a terminal. Log in is the first step of submitting a local docker image. 

```
docker login --username=yourhubusername --email=youremail@company.com
```

##### 2 Change tag of local image 

```
docker tag bb38976d03cf gameci/chardrawer:1.0.0
```


##### 3 Push local image to Docker Hub

```
docker push gameci/chardrawer:1.0.0
```

##### 4 Check the result on Docker Hub web page

<img src=".\img\dockerhub.png" alt="dockerhub" style="zoom:75%;" />



