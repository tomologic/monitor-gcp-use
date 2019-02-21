#!/bin/bash -e
# Sets up gcloud so the user specified credential is used
[ -z "$SERVICE_ACCOUNT" ] && {
  echo "No service account specified. Set the environment variable"
  echo "SERVICE_ACCOUNT to the service account ID to use from the mounted"
  echo "credentials file"
  exit 1
}
gcloud auth activate-service-account "$SERVICE_ACCOUNT" --key-file /credentials.json
exec /usr/local/bin/list-gcp-resource-use.sh "$@"
