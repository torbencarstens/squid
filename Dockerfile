ARG ALPINE_VERSION=3.13.6
FROM alpine:${ALPINE_VERSION}

ARG VERSION=5.2

WORKDIR /app
RUN apk add build-base perl
RUN wget -O squid-$VERSION.tar.gz http://www.squid-cache.org/Versions/v5/squid-$VERSION.tar.gz
RUN tar xzf squid-$VERSION.tar.gz

ENV CFLAGS="-Wno-error"
ENV CXXFLAGS="-Wno-error"
RUN cd squid-$VERSION \
    && ./configure \
    && make \
    && make install

COPY squid.conf /etc/squid/
RUN chmod 777 -R /usr/local/squid

EXPOSE 3128

CMD ["/usr/local/squid/sbin/squid", "--foreground", "-sYC"]
