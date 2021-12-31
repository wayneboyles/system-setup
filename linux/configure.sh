#!/bin/bash

# ===================================================
# Colors
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
# Variables
# ===================================================

SCRIPT_DIR="$(pwd)"

OS_DISTRO=''
OS_VERSION=''
OS_CODENAME=''

# ===================================================
# Functions
# ===================================================

function parse_yaml {
   local prefix=$2
   local separator=${3:-_}

   local indexfix
   # Detect awk flavor
   if awk --version 2>&1 | grep -q "GNU Awk" ; then
      # GNU Awk detected
      indexfix=-1
   elif awk -Wv 2>&1 | grep -q "mawk" ; then
      # mawk detected
      indexfix=0
   fi

   local s='[[:space:]]*' sm='[ \t]*' w='[a-zA-Z0-9_]*' fs=${fs:-$(echo @|tr @ '\034')} i=${i:-  }
   cat $1 | \
   awk -F$fs "{multi=0; 
       if(match(\$0,/$sm\|$sm$/)){multi=1; sub(/$sm\|$sm$/,\"\");}
       if(match(\$0,/$sm>$sm$/)){multi=2; sub(/$sm>$sm$/,\"\");}
       while(multi>0){
           str=\$0; gsub(/^$sm/,\"\", str);
           indent=index(\$0,str);
           indentstr=substr(\$0, 0, indent+$indexfix) \"$i\";
           obuf=\$0;
           getline;
           while(index(\$0,indentstr)){
               obuf=obuf substr(\$0, length(indentstr)+1);
               if (multi==1){obuf=obuf \"\\\\n\";}
               if (multi==2){
                   if(match(\$0,/^$sm$/))
                       obuf=obuf \"\\\\n\";
                       else obuf=obuf \" \";
               }
               getline;
           }
           sub(/$sm$/,\"\",obuf);
           print obuf;
           multi=0;
           if(match(\$0,/$sm\|$sm$/)){multi=1; sub(/$sm\|$sm$/,\"\");}
           if(match(\$0,/$sm>$sm$/)){multi=2; sub(/$sm>$sm$/,\"\");}
       }
   print}" | \
   sed  -e "s|^\($s\)?|\1-|" \
       -ne "s|^$s#.*||;s|$s#[^\"']*$||;s|^\([^\"'#]*\)#.*|\1|;t1;t;:1;s|^$s\$||;t2;p;:2;d" | \
   sed -ne "s|,$s\]$s\$|]|" \
        -e ":1;s|^\($s\)\($w\)$s:$s\(&$w\)\?$s\[$s\(.*\)$s,$s\(.*\)$s\]|\1\2: \3[\4]\n\1$i- \5|;t1" \
        -e "s|^\($s\)\($w\)$s:$s\(&$w\)\?$s\[$s\(.*\)$s\]|\1\2: \3\n\1$i- \4|;" \
        -e ":2;s|^\($s\)-$s\[$s\(.*\)$s,$s\(.*\)$s\]|\1- [\2]\n\1$i- \3|;t2" \
        -e "s|^\($s\)-$s\[$s\(.*\)$s\]|\1-\n\1$i- \2|;p" | \
   sed -ne "s|,$s}$s\$|}|" \
        -e ":1;s|^\($s\)-$s{$s\(.*\)$s,$s\($w\)$s:$s\(.*\)$s}|\1- {\2}\n\1$i\3: \4|;t1" \
        -e "s|^\($s\)-$s{$s\(.*\)$s}|\1-\n\1$i\2|;" \
        -e ":2;s|^\($s\)\($w\)$s:$s\(&$w\)\?$s{$s\(.*\)$s,$s\($w\)$s:$s\(.*\)$s}|\1\2: \3 {\4}\n\1$i\5: \6|;t2" \
        -e "s|^\($s\)\($w\)$s:$s\(&$w\)\?$s{$s\(.*\)$s}|\1\2: \3\n\1$i\4|;p" | \
   sed  -e "s|^\($s\)\($w\)$s:$s\(&$w\)\(.*\)|\1\2:\4\n\3|" \
        -e "s|^\($s\)-$s\(&$w\)\(.*\)|\1- \3\n\2|" | \
   sed -ne "s|^\($s\):|\1|" \
        -e "s|^\($s\)\(---\)\($s\)||" \
        -e "s|^\($s\)\(\.\.\.\)\($s\)||" \
        -e "s|^\($s\)-$s[\"']\(.*\)[\"']$s\$|\1$fs$fs\2|p;t" \
        -e "s|^\($s\)\($w\)$s:$s[\"']\(.*\)[\"']$s\$|\1$fs\2$fs\3|p;t" \
        -e "s|^\($s\)-$s\(.*\)$s\$|\1$fs$fs\2|" \
        -e "s|^\($s\)\($w\)$s:$s[\"']\?\(.*\)$s\$|\1$fs\2$fs\3|" \
        -e "s|^\($s\)[\"']\?\([^&][^$fs]\+\)[\"']$s\$|\1$fs$fs$fs\2|" \
        -e "s|^\($s\)[\"']\?\([^&][^$fs]\+\)$s\$|\1$fs$fs$fs\2|" \
        -e "s|$s\$||p" | \
   awk -F$fs "{
      gsub(/\t/,\"        \",\$1);
      if(NF>3){if(value!=\"\"){value = value \" \";}value = value  \$4;}
      else {
        if(match(\$1,/^&/)){anchor[substr(\$1,2)]=full_vn;getline};
        indent = length(\$1)/length(\"$i\");
        vname[indent] = \$2;
        value= \$3;
        for (i in vname) {if (i > indent) {delete vname[i]; idx[i]=0}}
        if(length(\$2)== 0){  vname[indent]= ++idx[indent] };
        vn=\"\"; for (i=0; i<indent; i++) { vn=(vn)(vname[i])(\"$separator\")}
        vn=\"$prefix\" vn;
        full_vn=vn vname[indent];
        if(vn==\"$prefix\")vn=\"$prefix$separator\";
        if(vn==\"_\")vn=\"__\";
      }
      assignment[full_vn]=value;
      if(!match(assignment[vn], full_vn))assignment[vn]=assignment[vn] \" \" full_vn;
      if(match(value,/^\*/)){
         ref=anchor[substr(value,2)];
         if(length(ref)==0){
           printf(\"%s=\\\"%s\\\"\n\", full_vn, value);
         } else {
           for(val in assignment){
              if((length(ref)>0)&&index(val, ref)==1){
                 tmpval=assignment[val];
                 sub(ref,full_vn,val);
                 if(match(val,\"$separator\$\")){
                    gsub(ref,full_vn,tmpval);
                 } else if (length(tmpval) > 0) {
                    printf(\"%s=\\\"%s\\\"\n\", val, tmpval);
                 }
                 assignment[val]=tmpval;
              }
           }
         }
      } else if (length(value) > 0) {
         printf(\"%s=\\\"%s\\\"\n\", full_vn, value);
      }
   }END{
      for(val in assignment){
         if(match(val,\"$separator\$\"))
            printf(\"%s=\\\"%s\\\"\n\", val, assignment[val]);
      }
   }"
}

function logInfo() {
  local NOW=$(date +%T)
  echo -e "${WHITE}$NOW [${CYAN}INFO${WHITE} ] $1${NC}"
}

function logWarning() {
  local NOW=$(date +%T)
  echo -e "${WHITE}$NOW [${YELLOW}WARN${WHITE} ] $1${NC}"
}

function logError() {
  local NOW=$(date +%T)
  echo -e "${WHITE}$NOW [${RED}ERROR${WHITE}] $1${NC}"
}

function printHeader() {
    clear
    echo -e "${ORANGE}=======================================${NC}"
    echo -e "${GREEN}Linux Setup Script${NC}"
    echo -e "${WHITE}A simple script to help automate common${NC}"
    echo -e "${WHITE}system setup tasks${NC}"
    echo -e "${ORANGE}=======================================${NC}"
    echo ''
    echo -e "${WHITE}Please note, the configurations here are based on my personal preference"
    echo -e "${WHITE}and may not suite your requirements.  Please review the config.yml file"
    echo -e "${WHITE}for all possible configuration values.${NC}"
    echo ''
}

printHeader


# function updateSystem() {
#     logInfo "Performing system update (this may take a few minutes)..."
#     # TODO: support multiple package managers
#     apt-get update -y > /dev/null 2>&1
#     apt-get clean all > /dev/null 2>&1
# }

# function installPackage() {
#     logInfo "Installing $1..."
#     # TODO: support multiple package managers
#     apt-get install -y $1 > /dev/null 2>&1
# }

# function installPackages() {
#     logInfo "Installing $*..."
#     # TODO: support multiple package managers
#     apt-get install -y $* > /dev/null 2>&1
# }

# function installPowerlineFonts() {
#   logInfo "Cloning powerline fonts..."
#   if [[ -d /tmp/fonts ]]
#   then
#     logWarning "Target directory (/tmp/fonts/) exists. Contents will be removed..."
#     rm -rf /tmp/fonts
#   fi
#   cd /tmp && git clone https://github.com/powerline/fonts.git --depth=1 -q > /dev/null 2>&1

#   logInfo "Installing powerline fonts..."
#   /tmp/fonts/install.sh > /dev/null 2>&1
#   rm -rf /tmp/fonts
# }

# function installVimPlug() {
#   logInfo "Installing vim-plug..."
#   curl -fLo ~/.vim/autoload/plug.vim --create-dirs --silent https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
# }

# function installVimConfig() {
#   # install custom vim settings
#   logInfo "Installing customized vim settings to ~/.vimrc ..."
#   curl -fLo ~/.vimrc --silent https://raw.githubusercontent.com/wayneboyles/system-setup/main/linux/.vimrc

#   # install the vim plugins
#   logInfo "Installing vim plugins for first use..."
#   vim -E -s -u ~/.vimrc +PlugInstall +qall
# }

# function installZsh() {
#   logInfo "Installing the ZSH shell..."
#   apt-get install -y zsh > /dev/null 2>&1

#   logInfo "Changing the default shell to zsh for the current user..."
#   local CURRENT_USER=$(whoami)
#   chsh -s /usr/bin/zsh $CURRENT_USER

#   logInfo "Installing oh-my-zsh..."
  
#   if [[ -f install.sh ]]
#   then
#     rm -f install.sh
#   fi

#   wget -q https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh
#   chmod o+x install.sh
#   ./install.sh > /dev/null 2>&1
#   rm -f install.sh

#   logInfo "Downloading customized .zshrc file..."
#   wget -q https://raw.githubusercontent.com/wayneboyles/system-setup/main/linux/.zshrc
#   mv .zshrc ~/.zshrc > /dev/null 2>&1
# }

# # ===================================================
# # Initialization
# # ===================================================

# if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  
#   # get the distribution
#   DISTRIB=$(awk -F= '/^NAME/{print $2}' /etc/os-release)
  
#   # version number
#   OS_VERSION=$(awk -F= '/^VERSION_ID/{print $2}' /etc/os-release)

#   # codename
#   OS_CODENAME=$(awk -F= '/^VERSION_CODENAME/{print $2}' /etc/os-release)
  
#   if [[ ${DISTRIB} == *Ubuntu* ]]
#   then
#     if uname -a | grep -q '^Linux.*Microsoft'
#     then
#       OS_DISTRO="Ubuntu (WSL)"
#     else
#       OS_DISTRO="Ubuntu"
#     fi
#   elif [[ ${DISTRIB} == *Debian* ]]
#   then
#     OS_DISTRO="Debian"
#   else
#     OS_DISTRO='Unsupported'
#   fi
# else
#     OS_DISTRO='Unsupported'
# fi

# if [[ $OS_DISTRO == 'Unsupported' ]]
# then
#     logError "Unsupported Distribution"
#     exit 1
# fi

# # ===================================================
# # Execution
# # ===================================================

# printHeader

# # run a system update
# updateSystem

# # install common packages
# installPackages ${COMMON_PKGS[@]}

# # install fonts
# installPowerlineFonts

# # install vim-plug and custom .vimrc
# installVimPlug
# installVimConfig

# echo ''
# while true; do
#   read -p "$(echo -e $WHITE"Install the zsh shell? (Yes/No): "$NC)" yn
#   case $yn in
#     [Yy]* ) installZsh; break;;
#     [Nn]* ) break;;
#   esac
# done

# # enable chrony
# systemctl enable chrony > /dev/null 2>&1
# systemctl restart chrony > /dev/null 2>&1

# # done
# echo -e "${CYAN}Configuration finished!  Please log out and back in for some of the changes to apply.${NC}"
# echo ''

# exit 0