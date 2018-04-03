#!/usr/bin/env bash
purge() {
  rm -r $HOME/Downloads/*
}

trapped() {
  purge
}

trap "trapped" 1 2 3 4 5 6 7 8 10 11 12 13 14

while true; do
  purge
  sleep 120m
done
