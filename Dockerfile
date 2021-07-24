ARG BASE_IMAGE

FROM $BASE_IMAGE

ARG ARCH
WORKDIR /app

ENV STAIRSPEEDTEST_VERSION v0.7.1

RUN apt update && apt install wget build-essential -y

# install stairspeedtest
RUN wget https://github.com/tindy2013/stairspeedtest-reborn/releases/download/${STAIRSPEEDTEST_VERSION}/stairspeedtest_reborn_${ARCH}.tar.gz \
  && tar -xf ./stairspeedtest_reborn_${ARCH}.tar.gz \
  && rm ./stairspeedtest_reborn_${ARCH}.tar.gz \
  && mv ./stairspeedtest /opt

COPY Gemfile ./

RUN bundle install --without development

COPY . .

ENTRYPOINT ["/usr/local/bin/ruby", "/app/lib/main.rb"]
