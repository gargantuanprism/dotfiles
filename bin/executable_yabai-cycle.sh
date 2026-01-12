#!/bin/bash

# get layout of the focused space
current_layout=$(\
  yabai -m query --spaces \
  | jq -r '.[] | select(."has-focus" == true) | .type' \
)

if [[ $current_layout == 'stack' ]]; then
  yabai -m window --focus stack.next
else
  yabai -m window --focus next
fi

# last window
if [[ $? -eq 1 ]]; then
  if [[ $current_layout == 'stack' ]]; then
    yabai -m window --focus stack.first
  else
    yabai -m window --focus first
  fi
fi

