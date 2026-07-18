FROM jetpackio/devbox:latest

# Installing your devbox project
WORKDIR /home/${DEVBOX_USER}
USER root:root
RUN mkdir -p /home/${DEVBOX_USER} && chown ${DEVBOX_USER}:${DEVBOX_USER} /home/${DEVBOX_USER}
USER ${DEVBOX_USER}:${DEVBOX_USER}
COPY --chown=${DEVBOX_USER}:${DEVBOX_USER} devbox.json devbox.json
COPY --chown=${DEVBOX_USER}:${DEVBOX_USER} devbox.lock devbox.lock

RUN devbox run -- echo "Installed Packages."

# Automatically load the devbox environment for any shell session
RUN echo 'eval "$(devbox shellenv)"' >> /home/${DEVBOX_USER}/.bashrc && \
    echo 'eval "$(devbox shellenv)"' >> /home/${DEVBOX_USER}/.profile

CMD ["bash", "-l"]
