
FROM ruby:2.5

RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -
RUN apt-get -y update \
    && apt-get install -y --no-install-recommends \
    nodejs
RUN npm install -g bower

ENV RAILS_ENV=development \
    RACK_ENV=development \
    LANG=C.UTF-8

WORKDIR /tmp
COPY .bowerrc ./
COPY bower.json ./
COPY Gemfile* ./

RUN bower install --allow-root
RUN bundle install

EXPOSE 3000
