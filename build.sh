#!/usr/bin/env bash

set -e

format_version() {
    if [ -z "$1" ]; then
        echo "Error: no version provided."
        exit 1
    fi
    # parameter validation
    version_orig="$1"

    # Check if version_orig contains a dot
    if [[ "$version_orig" != *.* ]]; then
        # If it doesn't, add a dot between the digits
        version_dot="${version_orig:0:1}.${version_orig:1}"
    else
        # If it does, just use the original
        version_dot="$version_orig"
    fi

    if ! [[ "$version_dot" =~ ^(3\.6|4\.0|4\.1|4\.2|4\.3|3\.16|3\.17|3\.18)$ ]]; then
        echo "Version must be one of 3.6, 4.1, 4.2, 4.3 for rocker images and 3.16, 3.17, 3.18 for bioconductor images."
        echo "For rocker images, the latest patch version is used."
        echo "For example, 3.6 refers to the latest 3.6.x version, which is 3.6.3."
        echo "For Bioconductor images, the latest version of R associated with the BioConductor release version is used."
        echo "For example, 3.18 uses R4.3.2 and not R4.3.1, even though both are compatible with BioConductor 3.18."
        exit 1
    fi

    version_dotless="${version_dot//./}"

    if [[ "$version_dot" =~ ^(3\.6|4\.0|4\.1|4\.2|4\.3)$ ]]; then
       base_name_suffixless="r${version_dotless}x"
    else
       base_name_suffixless="bioc${version_dotless}"
    fi
}

# get version_dot, version_dotless and image_prefix
format_version "$1"

# build the image
# --------------------
temp_dir=/tmp/sif
mkdir -p ${temp_dir}
apptainer build -F "${temp_dir}/${base_name_suffixless}.sif" "src/def/${base_name_suffixless}.def"
final_dir=sif
mkdir -p ${final_dir}
mv "${temp_dir}/${base_name_suffixless}.sif" "${final_dir}/${base_name_suffixless}.sif"
rm -rf "${temp_dir}"
