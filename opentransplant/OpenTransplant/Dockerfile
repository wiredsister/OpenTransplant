FROM buildpack-deps:bionic

RUN apt update \
    && apt install -y ocaml \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /OpenTransplant

CMD [ "/bin/bash" ]