FROM ubuntu:latest

ENV TZ=${TZ:-Asia/Shanghai}

RUN ln -fs /usr/share/zoneinfo/$TZ /etc/localtime \
    && apt-get update && apt-get install -y tzdata

RUN apt-get install -y wget \
    && wget https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6-1/wkhtmltox_0.12.6-1.focal_amd64.deb \
    && apt-get install -y fontconfig libfreetype6 libjpeg-turbo8 libpng16-16 libx11-6 libxcb1 libxext6 libxrender1 xfonts-75dpi xfonts-base \
    && dpkg -i wkhtmltox_0.12.6-1.focal_amd64.deb

RUN apt-get clean

COPY ./fonts_zh/* /usr/share/fonts/

VOLUME /leanote

WORKDIR /leanote

ENTRYPOINT ["./bin/run.sh"]
