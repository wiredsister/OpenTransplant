FROM buildpack-deps:bionic

WORKDIR /OpenTransplant

RUN apt update
RUN apt install -y ocaml
RUN wget https://raw.githubusercontent.com/ocaml/opam/master/shell/install.sh \
    && echo | sh install.sh \
    && rm ./install.sh

# RUN rm -rf /var/lib/apt/lists/*
RUN useradd -ms /bin/bash otuser
USER otuser

# IMPORTANT: sandboxing with bwrap has been disabled for WSL a la https://github.com/janestreet/install-ocaml
# set this up properly for production
RUN opam init -y --disable-sandboxing
RUN opam switch create ocaml-system.4.05.0
RUN opam update -uy
RUN opam install -y js_of_ocaml js_of_ocaml-ppx merlin utop ocp-indent dune
RUN opam install -y calendar cohttp-lwt-unix fmt logs qcheck uuidm
RUN echo eval $(opam config env) > ~/.bashrc

ARG GIT_HASH=git_hash
COPY . /OpenTransplant

CMD [ "/bin/bash" ]