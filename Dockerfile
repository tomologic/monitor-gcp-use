# https://hub.docker.com/repository/docker/tomologic/kubeadmin/tags
FROM tomologic/kubeadmin:v355.0.2

COPY ./list-gcp-resource-use.sh /usr/local/bin/
COPY ./init.sh /
ENTRYPOINT ["/init.sh"]
