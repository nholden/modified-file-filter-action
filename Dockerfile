FROM ruby:2.6.0

LABEL "com.github.actions.name"="Modified File Filter"
LABEL "com.github.actions.description"="Stops a workflow unless a specified file has been modified."
LABEL "com.github.actions.icon"="filter"
LABEL "com.github.actions.color"="orange"

ADD bin /bin
ADD lib /lib

ENTRYPOINT ["entrypoint"]
