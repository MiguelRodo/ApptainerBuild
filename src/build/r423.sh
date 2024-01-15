#!/usr/bin/env bash
mkdir -p sif
apptainer build -F sif/r423.sif src/def/r423.def
