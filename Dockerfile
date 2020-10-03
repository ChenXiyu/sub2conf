FROM ruby:alpine

WORKDIR /app

ENV STAIRSPEEDTEST_VERSION=v0.7.1

RUN apk add wget build-base

# install stairspeedtest
RUN wget https://github.com/tindy2013/stairspeedtest-reborn/releases/download/${STAIRSPEEDTEST_VERSION}/stairspeedtest_reborn_linux64.tar.gz \
  && tar -xf ./stairspeedtest_reborn_linux64.tar.gz \
  && rm ./stairspeedtest_reborn_linux64.tar.gz \
  && mv ./stairspeedtest /opt

COPY Gemfile Gemfile.lock ./

RUN bundle install --without development

COPY . .

ENTRYPOINT ["/usr/local/bin/ruby", "/app/lib/main.rb"]
