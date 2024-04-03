format_version_rbioc() {
    # parameter validation
    version_rbioc_orig="$1"
    if [ -z "$version_rbioc_orig" ]; then
        echo "Error: no version provided."
        exit 1
    fi

    # Check if version_rbioc_orig contains a dot
    if [[ "$version_rbioc_orig" != *.* ]]; then
        # If it doesn't, add a dot between the digits
        version_rbioc_dot="${version_rbioc_orig:0:1}.${version_rbioc_orig:1}"
    else
        # If it does, just use the original
        version_rbioc_dot="$version_rbioc_orig"
    fi

    if ! [[ "$version_rbioc_dot" =~ ^(3\.6|4\.0|4\.1|4\.2|4\.3|3\.16|3\.17|3\.18)$ ]]; then
        echo "Version must be one of 3.6, 4.1, 4.2, 4.3 for rocker images and 3.16, 3.17, 3.18 for bioconductor images."
        echo "For rocker images, the latest patch version is used."
        echo "For example, 3.6 refers to the latest 3.6.x version, which is 3.6.3."
        echo "For Bioconductor images, the latest version of R associated with the BioConductor release version is used."
        echo "For example, 3.18 uses R4.3.2 and not R4.3.1, even though both are compatible with BioConductor 3.18."
        exit 1
    fi

    version_rbioc_dotless="${version_rbioc_dot//./}"
}

# get base name without any suffix (no image version, no extension)
format_file_name_suffixless() {
    # first positional parameter: base image  type
    # second positional parameter: version_rbioc_dotless
    base_image="$1"
    version_rbioc_dotless="$2"
    if [[ "$base_image" == "r" ]]; then
        format_file_name_suffixless_r "$version_rbioc_dotless"
    elif [[ "$base_image" == "bioc" ]]; then
        format_file_name_suffixless_bioc "$version_rbioc_dotless"
    else
        echo "Error: must specify r or bioc as base image type (first positional parameter)."
        exit 1
    fi
}

format_file_name_suffixless_r() {
  # first positional parameter: version_rbioc_dotless
  file_name_suffixless="r${1}x"
}

format_file_name_suffixless_bioc() {
  # first positional parameter: version_rbioc_dotless
  file_name_suffixless="bioc${1}"
}

# get version_image
format_version_image() {
    # first positional parameter: version_image
    version_image="$1"
    release_tag="$2"
    file_name_suffixless="$3"
    if [ -z "$version_image" ]; then
        echo "No image version provided"
        echo "Using dev version"
        version_image="dev"
    fi
    if [[ "$version_image" == "dev" ]]; then
        format_version_image_dev "$release_tag" "$file_name_suffixless"
    else
        format_version_image_number "$version_image"
    fi
}

format_version_image_dev() {
    echo "Image version is valid"
    # first positional parameter: release_tag
    # second positional parameter: file_name_suffixless
    release_tag="$1"
    file_name_suffixless="$2"
    # format asset name for upload
    # Check for the existence of a numbered asset
    if gh release view "$release_tag" | \
        grep -q "${file_name_suffixless}-v[0-9]*.sif"; then
        # If a numbered asset exists, get the version number
        version_number=$(gh release view "$release_tag" | \
            grep -o "${file_name_suffixless}-v\([0-9]*\)\.sif" | \
            grep -o 'v\([0-9]*\)' | \
            grep -o '[0-9]*' | \
            sort -nr | \
            head -n 1)
        # Append "-dev" to the version number
        version_image="v${version_number}-dev"
        version_image="${version_image//./}"
    else
        # If no numbered asset exists, use the base asset name
        version_image="v1-dev"
    fi
}

format_version_image_number() {
   # format the version
   # first positional parameter: version image created
    version_image="$1"
    echo "Initial image version created: $version_image"
    # check that it's a number, possibly with a v in the front:
    check_version_image "$version_image"
    # prepend a v if necessary
    if ! [[ "$version_image" =~ ^v ]]; then
        echo "Prepending 'v' to version_image"
        version_image="v$version_image"
    fi
    # remove any dots
    version_image="${version_image//./}"
    echo "Final image version: $version_image"
}

check_version_rbioc() {
    # first positional parameter: version image created
    version_rbioc="$1"
    echo "R/Bioconductor image version: $version_rbioc"

    # check that it's a number, possibly with a v in the front:
    if ! [[ "$version_rbioc" =~ ^v?[0-9]+\.?[0-9]?[0-9]?$ ]]; then
        echo "R/Bioconductor iamge version invalid"
        exit 1
    fi

    echo "R/Bioconductor version is valid"
}

check_version_image() {
    # first positional parameter: version image created
    version_image="$1"
    echo "Image version created: $version_image"

    # check that it's a number, possibly with a v in the front:
    if ! [[ "$version_image" =~ ^v?[0-9]+$ ]]; then
        echo "Image version created must be 'dev' \
              or follow the format 'v[integer]', e.g. 'v1'"
        exit 1
    else
        echo "Image version created is valid"
    fi
}
