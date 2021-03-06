# FROM java:8-jre
FROM hypriot/rpi-java
RUN apt-get update \
  && apt-get install -y curl adduser \
  && rm -rf /var/lib/apt/lists/*

# grab gosu for easy step-down from root
RUN gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4
RUN curl -o /usr/local/bin/gosu -SL "https://github.com/tianon/gosu/releases/download/1.2/gosu-$(dpkg --print-architecture)" \
  && curl -o /usr/local/bin/gosu.asc -SL "https://github.com/tianon/gosu/releases/download/1.2/gosu-$(dpkg --print-architecture).asc" \
  && gpg --verify /usr/local/bin/gosu.asc \
  && rm /usr/local/bin/gosu.asc \
  && chmod +x /usr/local/bin/gosu

RUN apt-key adv --keyserver ha.pool.sks-keyservers.net --recv-keys 46095ACC8548582C1A2699A9D27D666CD88E42B4

ENV ELASTICSEARCH_VERSION 1.7.2

RUN curl -SOL https://download.elastic.co/elasticsearch/elasticsearch/elasticsearch-${ELASTICSEARCH_VERSION}.deb \
  && dpkg -i elasticsearch-${ELASTICSEARCH_VERSION}.deb \
  && rm elasticsearch-${ELASTICSEARCH_VERSION}.deb

ENV PATH /usr/share/elasticsearch/bin:$PATH
COPY config /usr/share/elasticsearch/config
COPY docker-entrypoint.sh /

VOLUME /usr/share/elasticsearch/data
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["elasticsearch"]
EXPOSE 9200 9300
