FROM alpine:latest as builder

ADD apk-build /apk-build
RUN chmod +x /apk-build
RUN /apk-build

RUN git clone --depth 1 --branch 0.15 https://github.com/bitcoin/bitcoin \
	  && cd bitcoin \
		&& ./autogen.sh \
		&& ./configure  --disable-tests --disable-wallet \
		&& make -j 4 \
		&& make install


FROM alpine:latest as builder

COPY --from=builder /usr/local/bin/bitcoind /usr/local/bin/bitcoind

ADD create-config /create-config
RUN chmod +x /create-config
RUN /create-config

EXPOSE 8332 8333 18332 18333

ENTRYPOINT ["bitcoind"]
