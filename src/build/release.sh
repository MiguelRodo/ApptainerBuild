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

echo "---------------------------------"
echo "Script release.sh started"

base_image="$1"
version_rbioc="$2"
version_image="$3"

echo "Base image type: $base_image"
echo "Version base: $version_rbioc"
echo "Version image: $version_image"

source src/build/fn/cmd-format.sh
source src/build/fn/cmd-release.sh

# get base version (R/Bioc version)
# as $version_rbioc_dotless
format_version_rbioc "$version_rbioc"
check_version_rbioc "$version_rbioc_dot"
check_version_rbioc "$version_rbioc_dotless"

# get image name (i.e. file name) without any suffix
format_file_name_suffixless \
    "$base_image" \
    "$version_rbioc_dotless"

echo "Version rbioc dotless: $version_rbioc_dotless"
echo "File name suffixless: $file_name_suffixless"

# create the release
release_create "$base_image" "$version_rbioc_dot"

# get version_image
format_version_image "$version_image" \
    "$release_tag" "$file_name_suffixless"

# get path_sif_orig and path_sif_final
get_path_sif "$file_name_suffixless" "$version_image"

# delete asset if it already exists
asset_delete "$release_tag" "$path_sif_final"

# upload the asset
asset_upload "$release_tag" "$path_sif_orig" "$path_sif_final"

echo "Script release.sh finished"
echo "---------------------------------"
