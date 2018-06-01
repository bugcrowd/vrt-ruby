FROM ruby:2.3-alpine

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

ADD . /usr/src/app
RUN gem install json -v '2.0.2'
RUN bundle update
RUN bundle install

# TODO add cops
CMD bundle exec rspec && bundle exec rubocop
