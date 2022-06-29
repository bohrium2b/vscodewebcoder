FROM codercom/code-server:latest AS code


FROM cs50/codespace:latest AS cli
USER root
COPY --from=code /usr/lib/code-server /usr/lib/code-server

COPY --from=code /usr/bin/code-server /usr/bin/code-server 
COPY --from=code /usr/bin/entrypoint.sh /usr/bin/entrypoint.sh
# Allow users to have scripts run on container startup to prepare workspace.
# https://github.com/coder/code-server/issues/5177
ENV ENTRYPOINTD=${HOME}/entrypoint.d

RUN apt-get update && apt-get install -y supervisor 

# COPY ./entrypoint.sh /usr/bin/entrypoint.sh
# Set user
USER ubuntu
WORKDIR /workspaces/ubuntu/
ENV WORKDIR=/workspaces/ubuntu/
ENV REPOSITORYNAME=ubuntu
COPY ./config.yaml /home/ubuntu/.config/code-server/config.yaml
# COPY /opt/cs50/extensions/ /home/ubuntu/.local/share/code-server/extensions/
# COPY ./opt/cs50/extensions/ /opt/extensions/
COPY ./settings.json /home/ubuntu/.local/share/code-server/User/settings.json
RUN sudo chown -hR ubuntu /home/ubuntu
# RUN find /opt/cs50/extensions/ -iname '*.vsix' -maxdepth 1 -exec code-server --install-extension {} ';'
# RUN find /opt/extensions/ -iname '*.vsix' -maxdepth 1 -exec code-server --install-extension {} ';'
ENTRYPOINT ["/usr/bin/entrypoint.sh", "--bind-addr", "0.0.0.0:13337", "/workspaces/ubuntu"]
EXPOSE 13337 8080 8081 8082 5900 6081
