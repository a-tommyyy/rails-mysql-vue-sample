FROM ruby:2.5.1

RUN apt-get update -qq \
    && apt-get install -y build-essential

# Node.js
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash - \
    && apt-get install -y nodejs

# yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -\
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && apt-get update \
    && apt-get install -y yarn

ENV myapp /myapp
RUN mkdir $myapp
WORKDIR $myapp

ADD Gemfile $myapp/
ADD Gemfile.lock $myapp/
RUN gem install bundler

ENV BUNDLE_GEMFILE=$myapp/Gemfile \
    BUNDLE_PATH=$myapp/vendor/bundle
RUN bundle install
