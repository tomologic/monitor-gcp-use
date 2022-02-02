# https://hub.docker.com/repository/docker/tomologic/kubeadmin/tags
FROM tomologic/kubeadmin:371.0.0

COPY ./list-gcp-resource-use.sh /usr/local/bin/
COPY ./init.sh /
ENTRYPOINT ["/init.sh"]
