FROM ubuntu:22.04

RUN echo "#################################################"
RUN echo "Get the latest APT packages"
RUN echo "apt-get update"
RUN apt-get update

RUN echo "#################################################"
RUN echo "Install prerequisites"
RUN echo "Partially based on https://gist.github.com/jhonnymoreira/777555ea809fd2f7c2ddf71540090526"
RUN apt-get -y install \
    git \
    curl \
    autoconf \
    bison \
    build-essential \
    libssl-dev \
    libyaml-dev \
    libreadline6-dev \
    zlib1g-dev \
    libncurses5-dev \
    libffi-dev \
    libgdbm6 \
    libgdbm-dev \
    libdb-dev \
    apt-utils
    
ENV RBENV_ROOT /usr/local/src/rbenv
ENV RUBY_VERSION 3.1.2
ENV PATH ${RBENV_ROOT}/bin:${RBENV_ROOT}/shims:$PATH

RUN echo "#################################################"
RUN echo "Install rbenv to manage Ruby versions"
RUN git clone https://github.com/rbenv/rbenv.git ${RBENV_ROOT} \
  && git clone https://github.com/rbenv/ruby-build.git \
    ${RBENV_ROOT}/plugins/ruby-build \
  && ${RBENV_ROOT}/plugins/ruby-build/install.sh \
  && echo 'eval "$(rbenv init -)"' >> /etc/profile.d/rbenv.sh

RUN echo "#################################################"
RUN echo "Install ruby and set the global version"
RUN rbenv install ${RUBY_VERSION} \
  && rbenv global ${RUBY_VERSION}

RUN echo "#################################################"
RUN echo "Install Jekyll 3.9.x and include GitHub Pages as a dependency"
RUN gem install jekyll -v '~>3.9.0'
RUN gem install bundler
RUN bundle init
RUN bundle add "github-pages" --version "228" --group "jekyll_plugins"
RUN bundle add webrick