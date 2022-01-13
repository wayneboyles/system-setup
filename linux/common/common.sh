#!/bin/bash

# ===================================================
# colors
# ===================================================

NC='\033[0m'
RED='\033[0;31m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
LIGHTGRAY='\033[0;37m'
DARKGRAY='\033[1;30m'
LIGHTRED='\033[1;31m'
LIGHTGREEN='\033[1;32m'
YELLOW='\033[1;33m'
LIGHTBLUE='\033[1;34m'
LIGHTPURPLE='\033[1;35m'
LIGHTCYAN='\033[1;36m'
WHITE='\033[1;37m'

# ===================================================
# emojis (unicode)
# ===================================================

INF_CIRCLE='\U1F7E2'
WRN_CIRCLE='\U1F7E1'
ERR_CIRCLE='\U1F534'
CHECK_MARK='\U2705'
CROSS_MARK='\U274C'

# ===================================================
# options / variables
# ===================================================

log_verbose=false

# ===================================================
# functions
# ===================================================

function cleanup() {
   trap - SIGINT SIGTERM ERR EXIT
   if [ -n "${temp_dir+x}" ]; then
      rm -rf "$temp_dir"
   fi
}

function die() {
   local message=$1
   local code=${2-1}
   
   if [ $code -eq 0 ]; then
      logInfo "$message"
   else
      logError "$message"
   fi

   exit "$code"
}

function _log() {
   local now=$(date +"%Y-%m-%d %H:%M:%S")
   echo >&2 -e "[$now] ${1-}"
}

function logInfo() {
   _log "[${WHITE}INFO${NC} ] $1"
}

function logWarning() {
   _log "[${YELLOW}WARN${NC} ] $1"
}

function logError() {
   _log "[${LIGHTRED}ERROR${NC}] $1"
}

function logVerbose() {
   if [ "$log_verbose" = true ]; then
      _log "[${LIGHTCYAN}VERB${NC} ] $1"
   fi
}