FROM jetpackio/devbox:latest

# Installing your devbox project
WORKDIR /workspace
USER root:root
RUN mkdir -p /workspace && chown ${DEVBOX_USER}:${DEVBOX_USER} /workspace
USER ${DEVBOX_USER}:${DEVBOX_USER}
COPY --chown=${DEVBOX_USER}:${DEVBOX_USER} devbox.json devbox.json
COPY --chown=${DEVBOX_USER}:${DEVBOX_USER} devbox.lock devbox.lock

RUN devbox shell --init --config /workspace/devbox.json \
  echo 'source /workspace/.devbox/bin/activate' >> /workspace/.bashrc

RUN devbox run -- echo "Installed Packages."

CMD ["bash"]
