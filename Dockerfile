FROM ubuntu:precise
MAINTAINER Martin Neiiendam mn@lokalebasen.dk
ENV REFRESHED_AT 2014-05-22

RUN sed -i.bak 's/main$/main universe/' /etc/apt/sources.list

RUN apt-get update -y
RUN apt-get install -y python-software-properties
RUN apt-add-repository ppa:brightbox/ruby-ng

RUN apt-get update
RUN apt-get install -y ruby2.1 ruby2.1-dev ruby2.1-doc build-essential git libxml2-dev libxslt1-dev curl zlib1g-dev libssl-dev
RUN gem install bundler --no-rdoc --no-ri
RUN gem install etcd -v=0.0.5
RUN gem install systemu -v=2.6.2
RUN bundle config build.nokogiri --use-system-libraries

RUN locale-gen da_DK.UTF-8
RUN update-locale

RUN curl -L -o /bin/etcdenv "https://gist.github.com/fracklen/56cd1440ed3785aadfdf/raw/92d168d931fe5c4132e7bbbd774177cdce0d9ad9/with_etcd_environment"
RUN chmod +x /bin/etcdenv

ADD Gemfile /var/www/errbit/release/Gemfile
ADD Gemfile.lock /var/www/errbit/release/Gemfile.lock
RUN cd /var/www/errbit/release && bundle install --deployment
RUN mkdir -p /var/www/errbit/shared/pids
RUN mkdir -p /var/www/errbit/shared/log
RUN mkdir -p /var/www/errbit/release/log

ENV BUNDLE_GEMFILE /var/www/errbit/release/Gemfile
ADD build.tar /var/www/errbit/release

ENV ETCD_ENV errbit
ENV RAILS_ENV production
ENV APP_PATH /var/www/errbit/release
ENV PORT 8080
ENV LANG en_US.UTF-8
ENV LC_ALL da_DK.UTF-8
ENV LC_CTYPE da_DK.UTF-8

WORKDIR /var/www/errbit/release

EXPOSE 8080

ENTRYPOINT ["etcdenv"]

CMD ["script/dockerize/start.sh"]
