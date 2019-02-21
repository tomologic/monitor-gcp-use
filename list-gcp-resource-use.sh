#!/usr/bin/env bash
# Lists resources allocated in non-exempted GCP projects
# Arguments is a set of projects to exempt from resource discovery

EXEMPTED_PROJECTS="$*"
RESOURCE_FOUND=0
COMPUTE_RESOURCE_TYPES="
  backend-services
  disks
  forwarding-rules
  health-checks
  http-health-checks
  https-health-checks
  instance-groups
  instance-templates
  instances
  snapshots
  ssl-certificates
  target-http-proxies
  target-https-proxies
  target-instances
  target-pools
  target-ssl-proxies
  target-vpn-gateways
  url-maps
  vpn-tunnels
"

main() {
    # Ensure gcloud is configured correctly, else need developer attention
    gcloud -q projects list > /dev/null || exit 1
    projects=$(gcloud -q projects list --format 'value(project_id)')
    for project in $projects; do
        contains $project $EXEMPTED_PROJECTS
        if [ $? -ne 0 ];then
            echo "Checking project: $project"
            find_resources $project
        else
            echo "Skipping exempted project: $project"
        fi
    done
    exit $RESOURCE_FOUND
}

find_resources() {
    project=$1
    for type in $COMPUTE_RESOURCE_TYPES;do
        find_resource_instances $project compute $type
    done
    find_resource_instances $project deployment-manager deployments
}

find_resource_instances() {
    project=$1
    resource_type="${@:2}"
    resources=$(gcloud -q --project $project $resource_type list --format="value(name)")
    if [ $? -ne 0 ];then
      RESOURCE_FOUND=1
    elif [ ! -z "$resources" ];then
      RESOURCE_FOUND=1
      echo "  * found '$resource_type':" $resources
    fi
}

contains() {
    local e
    for e in "${@:2}"; do [[ "$e" == "$1" ]] && return 0; done
    return 1
}

main
