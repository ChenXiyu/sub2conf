FROM ruby:3-slim
ARG TARGETPLATFORM

WORKDIR /app

ENV STAIRSPEEDTEST_VERSION v0.7.1

RUN apt update && apt install wget build-essential -y

# install stairspeedtest
RUN arch=$(case "$TARGETPLATFORM" in \
  'linux/arm/v7') echo 'armhf' ;; \
  'linux/amd64') echo 'linux64' ;; \
  'linux/arm64') echo 'arm64';; \
  esac) && \
  wget https://github.com/tindy2013/stairspeedtest-reborn/releases/download/${STAIRSPEEDTEST_VERSION}/stairspeedtest_reborn_${arch}.tar.gz \
  && tar -xf ./stairspeedtest_reborn_${arch}.tar.gz \
  && rm ./stairspeedtest_reborn_${arch}.tar.gz \
  && mv ./stairspeedtest /opt

COPY Gemfile ./

RUN bundle install --without development

COPY . .

ENTRYPOINT ["/usr/local/bin/ruby", "/app/lib/main.rb"]
