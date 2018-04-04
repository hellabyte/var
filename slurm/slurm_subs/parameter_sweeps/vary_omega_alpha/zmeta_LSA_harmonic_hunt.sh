#!/usr/bin/env bash

for omega in $(seq 133 148); do
  bash LSA_harmonic_hunt.sh "${omega}e-2"
done
