# https://hub.docker.com/repository/docker/tomologic/kubeadmin/tags
FROM tomologic/kubeadmin:v285.0.1

COPY ./list-gcp-resource-use.sh /usr/local/bin/
COPY ./init.sh /
ENTRYPOINT ["/init.sh"]
