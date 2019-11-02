# https://cloud.docker.com/u/tomologic/repository/docker/tomologic/kubeadmin/tags
FROM tomologic/kubeadmin:v269.0.0

COPY ./list-gcp-resource-use.sh /usr/local/bin/
COPY ./init.sh /
ENTRYPOINT ["/init.sh"]
