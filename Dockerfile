FROM mcr.microsoft.com/playwright:bionic

MAINTAINER Yiqiu Jia <yiqiujia@hotmail.com>

RUN apt-get update && apt-get upgrade -y && \
	apt-get install -y net-tools iputils-ping vim curl wget unzip screen openssh-server git subversion locales software-properties-common lsof nmon iftop sysstat netcat-traditional pciutils kmod uuid-runtime && \
	apt-get clean
#iostat 1
#vmstat 1
#nmon

ENV DEBIAN_FRONTEND noninteractive

## Set LOCALE to UTF8
RUN echo "zh_CN.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen zh_CN.UTF-8 && \
    dpkg-reconfigure locales && \
    /usr/sbin/update-locale LANG=zh_CN.UTF-8
ENV LC_ALL zh_CN.UTF-8
RUN apt-get install -y --force-yes --no-install-recommends fonts-wqy-microhei ttf-wqy-zenhei
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone && \
	apt-get install -y tzdata
ADD *.sh /
RUN sed -i 's/\r$//' /*.sh ; chmod +x /*.sh && \
	echo $(date "+%Y-%m-%d_%H:%M:%S") >> /.image_times && \
	echo $(date "+%Y-%m-%d_%H:%M:%S") > /.image_time && \
	echo "land007/playwright" >> /.image_names && \
	echo "land007/playwright" > /.image_name

RUN cd / && npm i playwright playwright-video @ffmpeg-installer/ffmpeg
RUN cd / && npm install -g node-gyp supervisor http-server && npm install socket.io ws express http-proxy bagpipe eventproxy chokidar request nodemailer await-signal log4js moment
ADD test5.js /home/pwuser/

ENV FFMPEG_PATH /node_modules/@ffmpeg-installer/linux-x64/ffmpeg

CMD /task.sh ; /start.sh ; bash

#docker build -t land007/playwright:latest .
#docker run -it --rm --ipc=host --user pwuser --security-opt seccomp=seccomp_profile.json --name playwright land007/playwright:latest
#docker cp playwright:/home/pwuser/example.png ./Desktop


