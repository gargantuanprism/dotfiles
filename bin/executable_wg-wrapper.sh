#!/bin/bash

notify() {
  osascript -e "display notification \"$1\" with title \"WireGuard\""
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
  notify "Tunnel up: $1"
}

wg-down() {
  if ! wg-check -ne 0; then
    echo "already down"
    return
  fi

  sudo wg-quick down $link_name
  rm -f $link_name
  notify "Tunnel down"
}

wg-restart() {
  echo "restart"
  sudo wg-quick down $link_name
  sudo wg-quick up $link_name
  notify "Tunnel restarted"
}

wg-check() {
  sudo wg show | rg -q interface
}

conf_dir="$HOME/.wireguard"
link_name="./wg0.conf"

action=$1
conf_name=$2

cd $conf_dir

case "$action" in
  up) wg-up $conf_name ;;
  down) wg-down ;;
  restart) wg-restart ;;
  *) echo "unknown action $action" ;;
esac

