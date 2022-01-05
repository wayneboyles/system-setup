#!/bin/bash

function cache_uname() {
  IFS=" " read -ra uname <<< "$(uname -srm)"

  kernel_name="${uname[0]}"
  kernel_version="${uname[1]}"
  kernel_machine="${uname[2]}"

  if [[ "$kernel_name" == "Darwin" ]]; then
    export SYSTEM_VERSION_COMPAT=0

    IFS=$'\n' read -d "" -ra sw_vers <<< "$(awk -F'<|>' '/key|string/ {print $3}' "/System/Library/CoreServices/SystemVersion.plist")"

    for ((i=0;i<${#sw_vers[@]};i+=2)) {
      case ${sw_vers[i]} in
        ProductName)          darwin_name=${sw_vers[i+1]} ;;
        ProductVersion)       osx_version=${sw_vers[i+1]} ;;
        ProductBuildVersion)  osx_build=${sw_vers[i+1]}   ;;
      esac
    }
  fi
}

function get_os() {
  case $kernel_name in
    Darwin)                   os=$darwin_name ;;
    SunOS)                    os=Solaris ;;
    Haiku)                    os=Haiku ;;
    MINIX)                    os=MINIX ;;
    AIX)                      os=AIX ;;
    IRIX*)                    os=IRIX ;;
    FreeMiNT)                 os=FreeMiNT ;;
    Linux|GNU*)               os=Linux ;;
    *BSD|DragonFly|Bitrig)    os=BSD ;;
    CYGWIN*|MSYS*|MINGW*)     os=Windows ;;
    *)                        os=Unknown ;;
  esac
}

function get_distro() {
  [[ $DISTRO ]] && return
 
  case $os in
    Linux)
      if type -p lsb_release >/dev/null; then
          DISTRO=$(lsb_release -si)
          DISTRO_VERSION=$(lsb_release -sr)
          DISTRO_CODENAME=$(lsb_release -sc)
      elif [[ -f /etc/os-release || -f /usr/lib/os-release || -f /etc/openwrt_release || -f /etc/lsb-release ]]; then
        
        for file in /etc/lsb-release /usr/lib/os-release /etc/os-release /etc/openwrt_release; do
            source "$file" && break
        done

        # Format the distro name.
        DISTRO="${PRETTY_NAME:-${DISTRIB_DESCRIPTION}} ${UBUNTU_CODENAME}"
      
      fi

      DISTRO=$(trim_quotes "$DISTRO")
      DISTRO=${DISTRO/NAME=}
    ;;
  esac

  DISTRO=${DISTRO//Enterprise Server}

  [[ $DISTRO ]] || DISTRO="$os (Unknown)"
}

function get_kernel() {
  # Since these OS are integrated systems, it's better to skip this function altogether
  [[ $os =~ (AIX|IRIX) ]] && return

  # Haiku uses 'uname -v' and not - 'uname -r'.
  [[ $os == Haiku ]] && {
      kernel=$(uname -v)
      return
  }

  # In Windows 'uname' may return the info of GNUenv thus use wmic for OS kernel.
  [[ $os == Windows ]] && {
    kernel=$(wmic os get Version)
    kernel=${kernel/Version}
    return
  }

  case $kernel_shorthand in
    on)  kernel=$kernel_version ;;
    off) kernel="$kernel_name $kernel_version" ;;
  esac

  # Hide kernel info if it's identical to the distro info.
  [[ $os =~ (BSD|MINIX) && $distro == *"$kernel_name"* ]] &&
    case $distro_shorthand in
        on|tiny) kernel=$kernel_version ;;
        *)       unset kernel ;;
    esac
}