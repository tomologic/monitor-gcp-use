#!/usr/bin/env bash
# Lists resources allocated in non-exempted GCP projects
# Arguments is a set of projects to exempt from resource discovery

EXEMPTED_PROJECTS=("$@")
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
        if ! contains "$project" "${EXEMPTED_PROJECTS[@]}"; then
            echo "Checking project: $project"
            find_resources "$project"
        else
            echo "Skipping exempted project: $project"
        fi
    done
    exit $RESOURCE_FOUND
}

find_resources() {
    project=$1
    for type in $COMPUTE_RESOURCE_TYPES;do
        find_resource_instances "$project" compute "$type"
    done
    find_resource_instances "$project" deployment-manager deployments
}

find_resource_instances() {
    project=$1
    resource_type=("${@:2}")
    resources=$(gcloud -q --project "$project" "${resource_type[@]}" list --format="value(name)")
    if [ $? -ne 0 ];then
      RESOURCE_FOUND=1
    elif [ -n "$resources" ];then
      RESOURCE_FOUND=1
      echo "  * found '${resource_type[*]}':"
      echo "$resources"
    fi
}

contains() {
    # Source: https://stackoverflow.com/questions/14366390/check-if-an-element-is-present-in-a-bash-array/14367368
    # Put all function arguments after the first one into the array
    local array=("${@:2}")
    local seeking=$1
    for element in "${array[@]}"; do
        if [[ $element == "$seeking" ]]; then
            return 0
        fi
    done
    return 1
}

main
