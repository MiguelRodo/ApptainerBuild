#!/usr/bin/env bash
# - first position parameter: r or bioc (base image type)
# - second positional parameter: version.
# if r, specifies r version, and
# must be one of 3.6, 4.1, 4.2, 4.3 (with or without dot).
# if bioc, specific BioConductor version, and
# must be one of 3.16, 3.17, 3.18 (with or without dot). 
# In either case, latest available path version is used
# compatible with the specified version.
echo "---------------------------------"
echo "Script build.sh started"

set -e

base_image="$1"
version_rbioc="$2"

echo "Base image type: $base_image"
echo "Version base: $version_rbioc"

echo "Sourcing build command format script"
source src/build/fn/cmd-format.sh

# get base version (R/Bioc version)
format_version_rbioc "$version_rbioc"
check_version_rbioc "$version_rbioc_dot"
check_version_rbioc "$version_rbioc_dotless"

# get image name (i.e. file name) without any suffix
format_file_name_suffixless \
    "$base_image" \
    "$version_rbioc_dotless"

echo "Version rbioc dotless: $version_rbioc_dotless"
echo "File name suffixless: $file_name_suffixless"

# build the image
# --------------------
temp_dir=/tmp/sif
mkdir -p ${temp_dir}
echo "Temporary directory created: ${temp_dir}"

temp_path="${temp_dir}/${file_name_suffixless}.sif"
echo "Temporary path: ${temp_path}"

def_path="src/def/${file_name_suffixless}.def"
echo "Definition file path: ${def_path}"

sudo apptainer build -F "$temp_path" "$def_path"
echo "Apptainer build command executed"

final_dir=sif
echo "Final directory: ${final_dir}"
if ! [ -d "$final_dir" ]; then
    mkdir -p ${final_dir}
    echo "Final directory created"
fi

final_path="${final_dir}/${file_name_suffixless}.sif"
echo "Final path: ${final_path}"

if [ -f "${final_path}" ]; then
    echo "File already exists: ${final_path}"
    echo "Removing existing file"
    rm -f "${final_path}"
    echo "Existing file removed"
fi

mv "$temp_path" "$final_path"
echo "File moved to final directory"

echo "Script build.sh finished"
echo "---------------------------------"
