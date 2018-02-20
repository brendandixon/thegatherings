
FROM ruby:2.5

RUN apt-get -y update \
    && apt-get install -y --no-install-recommends \
    nodejs

WORKDIR /tmp
COPY Gemfile* ./

ENV RAILS_ENV=development \
    RACK_ENV=development \
    LANG=C.UTF-8

RUN bundle install


EXPOSE 3000
