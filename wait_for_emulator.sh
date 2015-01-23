#!/bin/bash

bootanim=""
failcounter=0
timeout_in_sec=60

until [[ "$bootanim" =~ "stopped" ]]; do
  bootanim=`adb -e shell getprop init.svc.bootanim 2>&1 &`
  if [[ "$bootanim" =~ "device not found" || "$bootanim" =~ "device offline" ]]; then
    let "failcounter += 1"
    echo "Waiting for emulator to start"
    if [[ $failcounter -gt timeout_in_sec ]]; then
      echo "Timeout ($timeout_in_sec seconds) reached; failed to start emulator"
      exit 1
    fi
  elif [[ "$bootanim" =~ "running" ]]; then
    echo "Emulator is ready"
    adb -e shell input keyevent 82
    echo "Unlocked emulator screen"
    exit 0
  fi
  sleep 1
done
