FROM docker-prod.fidor.intern:5000/baseimages/ruby:2.3.1-mysql-mssql

MAINTAINER Fidor AG

USER app
WORKDIR /app

# pass optional args to the docker build
ARG DB=sqlserver

RUN rm -rf .bundle && \
    bundle install \
      --without development test \
      --with $DB \
      --jobs=4 \
      --retry=3
