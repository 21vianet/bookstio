# Bookstio

Bookstio是一个Docker及Istio的入门项目，帮助初学者学习认识基本的dockers使用，了解kubenetes的结构与Istio的部分功能，同时使得用户对自动化部署有一定的了解

Bookstio基于istio/sample/bookinfo所提供的productpage, reviews, ratings, details微服务。Bookstio可以从本地源代码部署项目，使用docker build在本地逐个构建镜像，使用docker-compose实现无istio的简化版的运行，对刚接触Docker的初学者更加友好。

Bookstio提供了Makefile自动化部署方案，可帮助初学者确认环境准备并快速查看效果。

Bookstio还提供了GitHub Action的线上自动化部署，在Github上设置好DockerHub相关的secrets后，进行push，无需环境即可通过Github Action线上构建镜像，并将镜像推到指定DockerHub

为进一步地了解kuberenetes与Istio，bookstio提供了基于helm chart的安装、运行方法，可在最简单的kubenetes环境下（如kind）直观地看到istio的功能

## 环境准备

1. Bookstio可以部署在任何支持Docker的Linux发行版
2. Docker运行环境	参考版本：Docker version 1.13.1
3. docker-compose	参考版本：docker-compose version 1.21.2



## 项目结构

通过git下载本项目，内含四个文件夹，一个Makefile文件及一个docker-compose.yml文件

productpage：内含productpage微服务及其Dockerfile. 该微服务展示主界面，调用 details 和 reviews 微服务填充页面. 

ratings：内含ratings微服务及其Dockerfile. 微服务包含随书评一起出现的评分信息。

details：内含details微服务及其Dockerfile. 该微服务返回书籍的详细信息。

reviews：该微服务返回书籍的评价和打分信息，展示的打分信息来自调用ratings微服务。reviews 微服务内置三个版本. 版本v1不调用 ratings 服务; 版本v2调用 ratings, 评级显示为1到5个黑色星; 版本v3调用 ratings , 评级显示为1到5个红色星。通过build时传入不同的参数，可创建不同版本镜像, 示例如下：

Makefile文件, 主要包含build, commit, run, push命令，实现了自动化构建镜像、运行服务、提交镜像到Dockerhub的功能，make命令仅能在Makefile所在目录使用。



## 本地部署



#### make部署：

```shell 
make build 
```

在本地为微服务productpage, reviews-v1, reviews-v2, reviews-v3, ratings, details分别构建出docker镜像

```shell
make run
```

通过docker-compose在本地构建镜像并创建、运行容器

```shell
make USER_ID={Dockerhub_Username} push
```

自动在本地构建docker镜像并提交到指定的Dockerhub上，须传入指定的Dockerhub用户名



#### docker build部署：

除了使用make自动化构建镜像，还可使用docker build助个构建镜像

特别地，在构建reviews服务的镜像时，须为enable_ratings和star_color赋值，示例如下

```bash
docker build -t reviews-v3 \
--build-arg enable_ratings=true \
--build-arg star_color=black .  #调用ratings微服务评级以黑色的星星展示
```



## 在线部署

1. https://hub.docker.com/settings/security注册/登录Dockerhub后，获取token

2. fork项目后在Github的settings下找到secrets，在Repository secrets新建DOCKER_HUB_NAME和DOCKER_HUB_PASS分别填入dockerhub的用户名和token
3. push项目后action自动运行，运行完成后，在dockerhub即可看见所创建的镜像



## Helm Chart部署

1. 进行helm chart部署首先需要一个完整的kubenetes环境，并安装kubectl以及istio, Makefile中提供了上述环境的安装脚本，通过执行Install_kubectl、Install_kind、Install_helm、Install_istio命令即可构建可部署的环境。
2. 进行helm chart安装，执行下述命令即可，reviews.weight.v1，reviews.weight.v2，reviews.weight.v3为istio对三个review服务进行流量分配的比例参数
```bash
helm install --set reviews.weight.v1=15 --set reviews.weight.v2=15 --set reviews.weight.v3=70 bookstio ./chart
```
3. 通过运行test.sh可以模拟调用服务1000次，观察获取到的结果分布情况
4. 上述流程均写入main.yml, 用户可在Github Action中观察到安装、运行情况
