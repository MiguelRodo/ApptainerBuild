#!/usr/bin/env bash

# This script manages GitHub releases for a project involving R versions and
# associated images. It takes two parameters: the R version and the image version.
#
# - If the R version is not provided, it exits. If it is, it formats it.
# - If the image version is not specified, it defaults to "dev". However, if
#   in the associated GitHub release a numbered asset exists, it appends "-dev"
#   to that version number.
#
# It creates a GitHub release if it does not exist with tag
# based on the R version.
# It uploads a sif file with name a combination of the R version
# and the image version.
# 
# GitHub releases with R version 4.3 are labelled as latest.
#
# - first position parameter: r or bioc (base image type)
# - second positional parameter: version.
# if r, specifies r version, and
# must be one of 3.6, 4.1, 4.2, 4.3 (with or without dot).
# if bioc, specific BioConductor version, andE
# must be one of 3.16, 3.17, 3.18 (with or without dot). 
# In either case, latest available path version is used
# compatible with the specified version.
# - third positional parameter: image version.
# must be "dev" or follow the format "vx.y", e.g. "v1.0" (with or with dots).

set -e

base_image_type="$1"
version_base="$2"
version_create="$3"

# format input provided
# ----------------

source src/build/cmd-format.sh
source src/build/cmd-release.sh

# get version_dot and version_dotless
format_version_base "$version_base"

# get base name without any suffix (no image version, no extension)
format_base_name_suffixless "$base_image_type" "$version_base_dotless"

# create the release with the asset if it does not exist
release_create "$base_image_type" "$version_base_dot"

# get version_create
format_version_create "$version_create" \
    "$release_tag" "$base_name_suffixless"

# get path_sif_orig and path_sif_final
get_path_sif "$base_name_suffixless" "$version_create"

# delete asset if it already exists
asset_delete "$release_tag" "$path_sif_final"

# upload the asset
asset_upload "$release_tag" "$path_sif_orig" "$path_sif_final"
