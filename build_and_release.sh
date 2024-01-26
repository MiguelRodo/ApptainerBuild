#!/usr/bin/env bash


src/build/build.sh $1 $2 && src/build/release.sh $1 $2 $3
