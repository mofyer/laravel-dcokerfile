FROM php:7.0-fpm
LABEL maintainer="zhanyafan163@163.com"


# set timezome
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
#更新apt-get源 使用aliyun的源 
RUN mv /etc/apt/sources.list /etc/apt/sources.list.bak && \     
echo "deb http://mirrors.aliyun.com/debian/ stretch main non-free contrib" >/etc/apt/sources.list && \     
echo "deb http://mirrors.aliyun.com/debian-security stretch/updates main" >>/etc/apt/sources.list && \     
echo "deb http://mirrors.aliyun.com/debian/ stretch-updates main non-free contrib" >>/etc/apt/sources.list && \     
echo "deb http://mirrors.aliyun.com/debian/ stretch-backports main non-free contrib" >>/etc/apt/sources.list && \     
echo "deb-src http://mirrors.aliyun.com/debian/ stretch main non-free contrib" >>/etc/apt/sources.list && \     
echo "deb-src http://mirrors.aliyun.com/debian-security stretch/updates main" >>/etc/apt/sources.list && \     
echo "deb-src http://mirrors.aliyun.com/debian/ stretch-updates main non-free contrib" >>/etc/apt/sources.list && \     
echo "deb-src http://mirrors.aliyun.com/debian/ stretch-backports main non-free contrib" >>/etc/apt/sources.list 

# Install package and PHP Core extensions
RUN apt-get update && apt-get install -y \
        git \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
        libzookeeper-mt-dev \
	&& docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
	&& docker-php-ext-install -j$(nproc) gd \
        && docker-php-ext-install zip \
        && docker-php-ext-install pdo_mysql \
        && docker-php-ext-install opcache \
        && docker-php-ext-install mysqli \
        && docker-php-ext-install bcmath \
        && rm -r /var/lib/apt/lists/*

# Copy extensions had downloaded
#COPY ./pkg/redis.tgz /home/redis.tgz
#COPY ./pkg/cphalcon.tar.gz /home/cphalcon.tar.gz

# Install PECL extensions (Redis)
RUN pecl install pecl  redis && echo "extension=redis.so" > /usr/local/etc/php/conf.d/redis.ini

#Install PECL extensions (zookeeper)
RUN pecl install zookeeper && echo "extension=zookeeper.so" > /usr/local/etc/php/conf.d/zookeeper.ini

# Install zookeeper extensions
#RUN cd /home \
#    && tar -zxvf zookeeper-0.7.2.tgz \
#    && mv zookeeper-* zookeeper \
#    && cd zookeeper-0.7.2 \
#    && phpize \
#    && ./configure \
#    && make  \
#    && make install \
#    && echo "extension=zookeeper.so" > /usr/local/etc/php/php.ini

# Install Composer
ENV COMPOSER_HOME /root/composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
ENV PATH $COMPOSER_HOME/vendor/bin:$PATH

#RUN rm -f /home/redis.tgz \
        

WORKDIR /data

# Write Permission
RUN usermod -u 1000 www-data
