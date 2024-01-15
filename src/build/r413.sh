#!/usr/bin/env bash
mkdir -p sif
apptainer build -F sif/r413.sif src/def/r413.def
