#!/bin/bash

ACTION=$1
export VLAN_TO_PUSH=100

echoerr() { echo "$@" 1>&2; }

function get_local_interfaces() {
  LOCAL_INTERFACES=$(ip --json a show | jq -r '.[] | select((.operstate == "UP") and ((.addr_info?[0].local|tostring)|test("^192.*"))) | .ifname+"\t"+.addr_info?[0].local')
  echo -n "$LOCAL_INTERFACES"
}

function get_local_network(){
  local interface=$1
  NETWORK=$(ip --json route show | jq -r '.[]| select(.dev == "'$interface'" and .dst != "default")| .dst')
  echo -n "$NETWORK"
}

function disable_4g {
  local interface=$1
  echoerr "Disable 4G connection"
  sudo tc qdisc del dev $interface root
}

function enable_4g {
  local interface=$1
  echoerr "Enable 4G connection"
  sudo tc qdisc add dev $interface handle 1: root prio
  sudo tc filter add dev $interface parent 1: protocol ip matchall action vlan push id $VLAN_TO_PUSH
  for network in $(get_local_network $interface); do
    echoerr "Clean VLAN for network: $network for interface $interface"
    sudo tc filter add dev $interface parent 1: protocol ip prio 3 u32 match ip dst $network action vlan pop
  done
}

function is_interface_on_4g {
  local interface=$1
  sudo tc filter show dev $interface parent 1: | grep "^filter" 1>&2
  if [[ $? -eq 1 ]]; then
    # echoerr "Inferface '${interface}' does not have tc filter"
    false
  else
    # echoerr "Inferface '${interface}' contains tc filter"
    true
  fi

}

function toogle_interface() {
  local interface=$1
  if is_interface_on_4g $interface; then
    disable_4g $interface
  else
    enable_4g $interface
  fi
}

function toogle() {
  IFS=$'\n'; for line in $(get_local_interfaces); do
    local interface=$(echo -n $line | awk '{print $1}')
    toogle_interface $interface
  done
}

function list() {
  local RESULT=""
  IFS=$'\n'; for line in $(get_local_interfaces); do
    local interface=$(echo -n $line | awk '{print $1}')
    DEFAULT_MODE="DSL"
    if is_interface_on_4g $interface; then
      RESULT="${RESULT}${interface}=4G "
    else
      RESULT="${RESULT}${interface}=DSL "
    fi
  done
  echo $RESULT
}

if [[ $ACTION == "toogle" ]]; then
  toogle
else
  list
fi
