FROM buildpack-deps:bionic

WORKDIR /OpenTransplant

RUN apt update \
    && apt install -y ocaml \
    && rm -rf /var/lib/apt/lists/*

CMD [ "/bin/bash" ]