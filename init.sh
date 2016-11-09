#!/bin/bash -e
# Sets up gcloud so the user specified credential is used
[ -z "$SERVICE_ACCOUNT" ] && {
  echo "No service account specified. Set the environment variable"
  echo "SERVICE_ACCOUNT to the service account ID to use from the mounted"
  echo "credentials file"
  exit 1
}
# gcloud panics unless the credentials file is writable, thus the copy
cp /root/.config/gcloud/credentials_mounted /root/.config/gcloud/credentials
gcloud config set account $SERVICE_ACCOUNT
exec /usr/local/bin/list-gcp-resource-use.sh
