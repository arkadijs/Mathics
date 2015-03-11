FROM debian:7
MAINTAINER Arkadi Shishlov <arkadi.shishlov@gmail.com>
RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y python-dev python-setuptools libsqlite3-dev libgmp3-dev wget unzip \
    && apt-get clean \
    && find /var/lib/apt/lists -type f -delete
ADD ./ /tmp/mathics
RUN cd /tmp/mathics \
    && sed -ri -e "s/('django)>=/\\1==/" setup.py \
    && python setup.py install \
    && groupadd -r mathics \
    && useradd -r -m -g mathics mathics \
    && su - mathics -c 'cd /tmp/mathics && python setup.py initialize' \
    && rm -rf /tmp/mathics
EXPOSE 8000
CMD [ "su", "-", "mathics", "-c", "exec mathicsserver --external"]
