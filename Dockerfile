FROM alpine:3.3
RUN apk update && apk upgrade

# Install base packages
RUN apk add curl-dev ruby-dev build-base

# Install dev packages
RUN apk add zlib-dev libxml2-dev libxslt-dev tzdata yaml-dev sqlite-dev

# Install ruby packages
RUN apk add ruby ruby-io-console ruby-json yaml nodejs

# Install gem rails
RUN gem install -N bundler && \
  gem install -N nokogiri -- --use-system-libraries && \
  gem install -N rails --version "4.2.5" && \
  echo 'gem: --no-document' >> ~/.gemrc

# Config bundle
RUN bundle config --global build.nokogiri  "--use-system-libraries"

# Clean apk cache
RUN rm -rf /var/cache/apk/*

EXPOSE 3000

RUN mkdir /usr/app
WORKDIR /usr/app

COPY src/Gemfile /usr/app/
COPY src/Gemfile.lock /usr/app/
RUN bundle install

COPY src /usr/app

CMD rails server -b 0.0.0.0
