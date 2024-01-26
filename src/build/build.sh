#!/usr/bin/env bash
# - first position parameter: r or bioc (base image type)
# - second positional parameter: version.
# if r, specifies r version, and
# must be one of 3.6, 4.1, 4.2, 4.3 (with or without dot).
# if bioc, specific BioConductor version, and
# must be one of 3.16, 3.17, 3.18 (with or without dot). 
# In either case, latest available path version is used
# compatible with the specified version.
set -e

base_image_type="$1"
version_base="$2"

source src/build/cmd-format.sh

# get version_dot, version_dotless and image_prefix
format_version_base "$version_base"
format_base_name_suffixless "$base_image_type" "$version_base_dotless"

# build the image
# --------------------
temp_dir=/tmp/sif
mkdir -p ${temp_dir}
apptainer build -F "${temp_dir}/${base_name_suffixless}.sif" "src/def/${base_name_suffixless}.def"
final_dir=sif
mkdir -p ${final_dir}
mv "${temp_dir}/${base_name_suffixless}.sif" "${final_dir}/${base_name_suffixless}.sif"
rm -rf "${temp_dir}"
