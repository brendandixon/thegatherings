
FROM ruby:2.3

RUN echo 'alias l="less"' >> ~/.bashrc \
    && echo 'alias ll="ls -lF"' >> ~/.bashrc \
    && echo 'alias la="ls -AlF"' >> ~/.bashrc \
    && echo 'alias ?="pwd"' >> ~/.bashrc

RUN mkdir -p /var/app
COPY Gemfile /var/app/Gemfile
WORKDIR /var/app
RUN bundle install

# EXPOSE 3000
# CMD ["rails", "server", "-b", "0.0.0.0"]
