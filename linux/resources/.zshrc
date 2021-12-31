# Path to your oh-my-zsh installation.
export ZSH="/root/.oh-my-zsh"

# Theme name
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="afowler"

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
plugins=()

source $ZSH/oh-my-zsh.sh

# Preferred editor
export EDITOR='vim'

# Aliases

alias zshrc='${=EDITOR} ${ZDOTDIR:-$HOME}/.zshrc' # Quick access to the .zshrc file

alias grep='grep --color'
alias sgrep='grep -R -n -H -C 5 --exclude-dir={.git,.svn,CVS} '

alias t='tail -f -n 40'

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

alias l='ls -lFh --color'       # size,show type,human readable
alias la='ls -lAFh --color'     # long list,show almost all,show type,human readable
alias lr='ls -tRFh --color'     # sorted by date,recursive,show type,human readable
alias lt='ls -ltFh --color'     # long list,sorted by date,show type,human readable
alias ll='ls -l --color'        # long list
alias ldot='ls -ld .* --color'  # list dot files as long list
alias lS='ls -1FSsh --color'    # list files showing only size and name sorted by size
alias lart='ls -1Fcart --color' # list all files sorted in reverse of create/modification time (oldest first)
alias lrt='ls -1Fcrt --color'   # list files sorted in reverse of create/modification time(oldest first)
