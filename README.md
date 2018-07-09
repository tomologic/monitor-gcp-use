# monitor-gcp-use
Checks if project resources are allocated in any GCP project accessible by the
credential used to run the container and that are, and that are not on a project exempt list.

Arguments to the container is a list of GCP project IDs to exempt from
resource discovery.

If at least one resource is found in the remaining non-exempted project set,
an exit code of 1 is returned. Else exit code 0.

The container prints out which resources are found for which project, to simplify
manual resource cleanup.

## Usage

    docker run --rm \
    -v $PWD/credentials.json:/credentials.json:ro \
    -e SERVICE_ACCOUNT=<Service account ID>
    tomologic/monitor-gcp-use [list of exempted GCP project IDs]

Where Service account ID is the ID of an account credential present in the
mounted credentials file, to be used for the resource scanning.

## Caveat
Note that the extent of the scanning is limited to the entitlement of the
service account used. Specifically the scanning will be limited to only those
GCP projects that the service account has access to. Therefore ensure the
service account used has read access to all GCP projects it's meant to cover.

## Rationale
Google Cloud resources cost money. It's very easy for a developer to _forget_ to clean out a certain project, such as their personal lab projects or projects used by CI pipelines. Also, Google has some issues at the time of this writing with their Deployment Manager service, resulting in the tool failing to tear down resources created through Kubernetes signaling (e.g. load balancers and associated resources) as well as disks that have been bound to GKE using volumes and claims.

This project was created to afford us _visibility_ into what Google _compute_ resources are being used across the company, so we can get notified of the fact, and with the information can decide on a proper response.
