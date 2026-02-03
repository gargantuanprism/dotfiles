#!/bin/bash

conf_dir="$HOME/.wireguard"
link_name="./wg0.conf"
notify_title="WireGuard"

notify() {
  local msg="$1"
  local subtitle="$2"
  local script="display notification \"$msg\" with title \"$notify_title\""

  if [ -n "$subtitle" ]; then
    script="$script subtitle \"$subtitle\""
  fi

  osascript -e "$script"
}

wg-up() {
  if wg-check; then
    echo "already up"
    return
  fi

  if [ ! -f "$conf_dir/$conf_name.conf" ]; then
    echo "unknown conf $conf_name"
    exit 1
  fi

  ln -sf $1.conf $link_name
  sudo wg-quick up $link_name

  local interface=$(wg-check)
  notify "Tunnel up: $1" "$interface"
}

wg-down() {
  if ! wg-check -ne 0; then
    echo "already down"
    return
  fi

  local interface=$(wg-check)
  sudo wg-quick down $link_name
  rm -f $link_name
  notify "Tunnel down" "$interface"
}

wg-restart() {
  echo "restart"

  if [ ! -f "$link_name" ]; then
    echo "symlink not found, probably down"
    exit 1
  fi

  sudo wg-quick down $link_name
  sudo wg-quick up $link_name
  notify "Tunnel restarted"
}

wg-check() {
  sudo wg show | rg interface
}

action=$1
conf_name=$2

cd $conf_dir

case "$action" in
  up) wg-up $conf_name ;;
  down) wg-down ;;
  restart) wg-restart ;;
  *) echo "unknown action $action" ;;
esac

