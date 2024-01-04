FROM bluenviron/mediamtx:latest as mediamtx
WORKDIR /

FROM public.ecr.aws/docker/library/alpine:edge as alpine

WORKDIR /home/mediamtx

RUN addgroup -S mediamtx
RUN adduser -g mediamtx -G mediamtx -s /bin/sh -S -D mediamtx

RUN apk add --no-cache ffmpeg
RUN apk add --no-cache bash
RUN apk add --no-cache supervisor

COPY --from=mediamtx mediamtx /usr/bin/
COPY --from=mediamtx mediamtx.yml /home/mediamtx/

COPY supervisord.conf /etc/
COPY watch_at_the_new_url.png /home/mediamtx/

ENV MTX_PROTOCOLS tcp
EXPOSE 8554


USER mediamtx


CMD ["/usr/bin/supervisord"]
