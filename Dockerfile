#
# Based on https://github.com/walm/docker-pgtap/blob/master/Dockerfile
#
FROM postgres:latest
MAINTAINER Damien Clochard <damien.clochard@dalibo.com>

RUN apt-get update \
    && apt-get install -y \
		# Builds utils
		build-essential \
        gettext-base \
		git-core \
		curl \
		# required by pgtap
        libv8-dev \
 		postgresql-server-dev-$PG_MAJOR \ 
		# replace mailx by heirloom-mailx (for CI jobs)
		heirloom-mailx \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# install pg_prove
RUN curl -LO http://xrl.us/cpanm \
    && chmod +x cpanm \
    && ./cpanm TAP::Parser::SourceHandler::pgTAP

# install pgtap
RUN git clone git://github.com/theory/pgtap.git \
    && cd pgtap \
    && make \
    && make install \
    && make clean
