FROM lokalebasen/rubies:2.1.4
MAINTAINER Martin Neiiendam mn@lokalebasen.dk
ENV REFRESHED_AT 2014-08-25

WORKDIR /var/www/errbit/release

ENV ETCD_ENV errbit
ENV RAILS_ENV production
ENV APP_PATH /var/www/errbit/release

ADD Gemfile /var/www/errbit/release/Gemfile
ADD Gemfile.lock /var/www/errbit/release/Gemfile.lock
RUN bundle install --deployment
RUN mkdir -p /var/www/errbit/shared/pids
RUN mkdir -p /var/www/errbit/shared/log
RUN mkdir -p /var/www/errbit/release/log

ENV BUNDLE_GEMFILE /var/www/errbit/release/Gemfile
ADD build.tar /var/www/errbit/release

EXPOSE 8080

ENTRYPOINT ["go-env"]

CMD ["script/dockerize/start.sh"]
