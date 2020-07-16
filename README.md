## 简介
用 Docker 容器服务的方式搭建多PHP版本 Laravel环境，易于维护、升级。使用前需了解 Docker 的基本概念，常用基本命令。
可以一条条命令执行docker命令来构建镜像，容器。这里推荐使用 docker-compose 来管理，执行项目，下面是使用流程。
使用了阿里云镜像加速，加快构建速度。

相关软件版本：
- PHP 7.0
- PHP 7.2
- MySQL 5.7
- Nginx 1.12
- Redis 3.2
- Zookeeper:3.4.14



## 使用
### 1.安装 Docker，Docker-compose  
- Docker，详见官方文档：https://docs.docker.com/engine/installation/linux/docker-ce/centos/
- docker-compose，文档：https://docs.docker.com/compose/install/
```
sudo pip install -U docker-compose
```


### 2.docker-compose 构建项目
进入 docker-compose.yml 所在目录,./files/：
执行命令：
```
docker-compose up 会自动构建和启动容器
``` 
当编辑了 Dockerfile 之后，执行下面命令重新构建镜像
```
docker-compose build nginx                  
``` 
如果没问题，下次启动时可以以守护模式启用，所有容器将后台运行：  
```
docker-compose up -d
```

不带缓存的构建
```
docker-compose build --no-cache nginx   
```

使用 docker-compose 基本上就这么简单，Docker 就跑起来了，用 stop，start 关闭开启容器服务。  
更多的是在于编写 dockerfile 和 docker-compose.yml 文件。 

可以这样关闭容器并删除服务：
```
docker-compose down
```
删除全部容器
```
docker system prune --volumes  
```



### 3. 使用 Composer
 项目依赖 Composer 进行构建。

我们在创建 PHP-fpm 容器时就已经将 Composer 安装在容器中，可以运行该容器进行 Composer 操作。

用 docker-compose 进行操作：
```
docker-compose run --rm -w /data/www/app php-fpm composer update
```
`-w /data/www/app`为在php-fpm的工作区域，app项目也是挂载在里面，所有我们可以直接在容器里运行composer。

或者进入宿主机（容器外部）app 目录下用 docker 命令：
```
cd dec-dockerfiles/app

docker run -it --rm -v `pwd`:/data/www/ -w /data/www/app files_php-fpm composer update
```


### 4. 使用命令行

使用php7.0执行命令
```
docker-compose run -w /data/www/XXX php70-fpm php artisan  
```
使用php7.2执行命令
```
docker-compose run -w /data/www/XXX php-fpm php artisan  

```

### 4. 常用命令

```
docker-compose up -d nginx                        构建建启动nignx容器
docker-compose exec nginx bash                    登录到nginx容器中
docker-compose down                               删除所有nginx容器,镜像
docker-compose ps                                 显示所有容器
docker-compose restart nginx                      重新启动nginx容器
docker-compose run --no-deps --rm php-fpm php -v  在php-fpm中不启动关联容器，并容器执行php -v 执行完成后删除容器
docker-compose build nginx                        构建镜像 。        
docker-compose build --no-cache nginx             不带缓存的构建。
docker-compose logs  nginx                        查看nginx的日志 
docker-compose logs -f nginx                      查看nginx的实时日志
 
docker-compose config  -q                         验证（docker-compose.yml）文件配置，当配置正确时，不输出任何内容，当文件配置错误，输出错误信息。 
docker-compose events --json nginx                以json的形式输出nginx的docker日志
docker-compose pause nginx                        暂停nignx容器
docker-compose unpause nginx                      恢复ningx容器
docker-compose rm nginx                           删除容器（删除前必须关闭容器）
docker-compose stop nginx                         停止nignx容器
docker-compose start nginx                        启动nignx容器
```

### 4. 常见问题

1.与新项目的时候数据拒绝连接：
  .env配置文件中应该把数据库配置host填成MySQL容器名称，我本地的MySQL容器名称为mysql-db，改成这样就可以连接