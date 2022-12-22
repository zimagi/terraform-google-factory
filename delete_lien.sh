#!/bin/bash

set -e

project_id="$1"

lien_id=$(gcloud alpha resource-manager liens list  --project ${1} --format=json)

[[ "${lien_id}" != "null" ]] && gcloud alpha resource-manager liens delete "${lien_id} --project ${1}"