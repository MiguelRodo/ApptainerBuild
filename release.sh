#!/usr/bin/env bash

set -e

# parameter validation
version_r_orig="$1"
version_image="$2"

# check input provided
# ----------------

# check if R version is provided
if [ -z "$version_r_orig" ]; then
    echo "Error: no r version provided."
    exit 1
fi

# use dev version of image if not specified
if [ -z "$version_image" ]; then
    echo "No image version provided"
    echo "Using dev version"
    version_image="dev"
fi

# format r version
# ----------------

# add a dot if necessary
if [[ "$version_r_orig" != *.* ]]; then
    # If it doesn't, add a dot between the digits
    version_r_dot="${version_r_orig:0:1}.${version_r_orig:1}"
else
    # If it does, just use the original
    version_r_dot="$version_r_orig"
fi

# check that the version is valid
if ! [[ "$version_r_dot" =~ ^(3.6|4.0|4.1|4.2|4.3)$ ]]; then
    echo "Version must be one of 3.6, 4.1, 4.2, 4.3 (with or without dot)."
    echo "For each of these, the latest patch version is used."
    echo "For example, 3.6 refers to the latest 3.6.x version, which is 3.6.3."
fi

# get version without dot
version_r_dotless="${version_r_dot//./}"

# format image version
# ---------------- 


# create the release with the asset if it does not exist
release_tag=r"$version_r_dot".x

if ! gh release view "$release_tag" > /dev/null 2>&1; then
    # create the release
    if [[ version_r_dotless == 43 ]] ; then
        # use pre-release flag for R 4.3
        gh release create \
        "$release_tag" \
        --title "$release_tag" \
        --notes "Apptainer images for R version ${version_r_dot}x." \
        --prerelease
    else
        gh release create \
        "$release_tag" \
        --title "$release_tag" \
        --notes "Apptainer images for R version ${version_r_dot}x."
    fi
fi

# Check if tag_release is "dev" or follows the format "v1.0"
asset_name_base_suffixless="r${version_r_dotless}x" # without version or extension
asset_path_orig="sif/${asset_name_base_suffixless}.sif"
if [[ "$version_image" == "dev" ]]; then
    echo "Image version is valid"
    # format asset name for upload
    # Check for the existence of a numbered asset
    if gh release view "$release_tag" | grep -q "${asset_name_base_suffixless}-v[0-9]*.sif"; then
        # If a numbered asset exists, get the version number
        version_number=$(gh release view "$release_tag" | grep -o "${asset_name_base_suffixless}-v\([0-9]*\)\.sif" | grep -o '[0-9]*' | tail -n 1)
        # Append "-dev" to the version number
        version_image_dot="v${version_number}-dev"
    else
        # If no numbered asset exists, use the base asset name
        version_image_dot="dev"
    fi
elif [[ "$version_image" =~ ^v?[0-9]+\.?[0-9]+$ ]]; then
   # format the version
    echo "Image version is valid"
    version_image_dot="$version_image"
    # prepend a v if necessary
    if ! [[ "$version_image_dot" =~ ^v ]]; then
      version_image_dot="v$version_image_dot"
    fi
    # add a full stop if necessary
    if ! [[ "$version_image_dot" =~ ^v?[0-9]+\.[0-9]+$ ]]; then
      version_image_dot="${version_image_dot:0:2}.${version_image_dot:2}"
    fi

else
    echo "Image version must be 'dev' or follow the format 'vx.y', e.g. 'v1.0'"
fi

# remove any full stops
version_image_dotless="${version_image_dot//./}"

# get final asset name:
asset_path_final="sif/r${version_r_dotless}x-${version_image_dotless}.sif"
cp "$asset_path_orig" "$asset_path_final"

asset_name_base="$(basename "$asset_path_final")"
# delete image if it already exists
if gh release view "$release_tag" | grep -q "$asset_name_base"; then
    echo "Deleting previous release asset $asset_name_base"
    gh release delete-asset "$release_tag" "$asset_name_base" -y
fi

# upload the .sif file to the release
echo "Uploading $(basename $asset_path_final) to release $release_tag"
gh release upload "$release_tag" "$asset_path_final"

rm -rf "$asset_path_final"
