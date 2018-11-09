FROM ruby:2.5.3

ADD bin /bin
ADD lib /lib

ENTRYPOINT ["entrypoint"]
