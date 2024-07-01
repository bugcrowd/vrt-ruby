FROM ruby:3.1

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

ADD . /usr/src/app
RUN bundle install

# TODO add cops
CMD bundle exec rspec && bundle exec rubocop
