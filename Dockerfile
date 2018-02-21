FROM ruby:2.5

ARG ASSET_PATH=/tmp

RUN echo 'alias l="less"' >> ~/.bashrc \
    && echo 'alias ll="ls -lF"' >> ~/.bashrc \
    && echo 'alias la="ls -AlF"' >> ~/.bashrc \
    && echo 'alias ?="pwd"' >> ~/.bashrc

RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -
RUN apt-get -y update \
    && apt-get install -y --no-install-recommends \
    apt-transport-https \
    nodejs

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get install -y --no-install-recommends \
    yarn

ENV RAILS_ENV=development \
    RACK_ENV=development \
    RAILS_ASSET_PATH=${ASSET_PATH} \
    LC_ALL=C.UTF-8 \
    LANG=C.UTF-8

WORKDIR ${ASSET_PATH}
COPY Gemfile* ./
COPY package.json ./
COPY yarn.lock ./

RUN yarn install
RUN bundle install

EXPOSE 3000
