#!/bin/bash

# allow the pipeline to fail with the error code for things
# like wget, curl etc.
set -Eeuo pipefail

# import common scripts into the session
source common/common.sh
source common/environment.sh

# script initialization
trap cleanup SIGINT SIGTERM ERR EXIT
script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)

# create the temp dir and fail the script if we
# can't create it for some reason
temp_dir=$(mktemp -d)
if [[ ! "$temp_dir" || ! -d "$temp_dir" ]]; then
    die "Could not create temporary working directory" 1
fi

# check to see if the configuration file is present
if [ ! -f "${script_dir}/configure.conf" ]; then
    die "Could not find the configuration file 'configure.conf'" 1
else
    source "${script_dir}/configure.conf"
fi

logInfo $allow_root_login

# exit the script
die "Configuration Complete." 0