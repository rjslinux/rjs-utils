#!/usr/bin/sh

# (c) 2015 Gord Smith <rjs.linux@gmail.com>
# core functions and variable for rjs-utils
# distributed under GPL License

# define color message arguments
if [[ -t 1 && ! $COLOR = "NO" ]]; then
  WHITE='\e[1;39m'
  GREEN='\e[1;32m'
  PURPLE='\e[1;35m'
  CYAN='\e[1;36m'
  BLUE='\e[1;34m' # blue
  YELLOW='\e[1;33m' # yellow
  RED='\e[1;31m' # red
  ENDCOLOR='\e[0m' 
  S='\\'
fi
_WIDTH="$(stty size | cut -d ' ' -f 2)"

trap ctrlc INT
ctrlc() {
  echo
  exit
}

# echo message with color support with new line
eecho() {
	echo -e "$1" >&2
}
# echo message with color support with no new line
necho() {
	echo -en "$1" >&2
}

# Called whenever anything needs to be run as root ($@ is the command)
runasroot() {
  if [[ $UID -eq 0 ]]; then
    "$@"
  elif sudo -v &>/dev/null && sudo -l "$@" &>/dev/null; then
    sudo -E "$@"
  else
    necho "root "
    su -c "$(printf '%q ' "$@")"
  fi
}

# show error message
err() {
  eecho "$1"
  [[ "$warn" == 1 ]] || exit 1
}

# show invalid option error
invalid() {
  eecho "${COLOR7}error:${ENDCOLOR} invalid option \`$1'"
}

