FROM ruby:2.3

RUN apt-get update && apt-get -y install nodejs

WORKDIR /tmp
ADD Gemfile /tmp/Gemfile
ADD Gemfile.lock /tmp/Gemfile.lock
RUN bundle install --deployment -j4 --without development test

ADD . /app
ADD docker-entrypoint.sh /
WORKDIR /app
RUN cp -a /tmp/vendor/bundle /app/vendor/bundle && \
    bundle exec rake assets:precompile
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["bundle", "exec", "foreman", "start", "-f", "Procfile.docker"]

