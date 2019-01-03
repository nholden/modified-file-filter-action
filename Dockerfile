FROM ruby:2.6.0

ADD bin /bin
ADD lib /lib

ENTRYPOINT ["entrypoint"]
