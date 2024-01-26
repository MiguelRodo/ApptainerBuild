format_version_base() {
    # parameter validation
    version_base_orig="$1"
    if [ -z "$version_base_orig" ]; then
        echo "Error: no version provided."
        exit 1
    fi

    # Check if version_base_orig contains a dot
    if [[ "$version_base_orig" != *.* ]]; then
        # If it doesn't, add a dot between the digits
        version_base_dot="${version_base_orig:0:1}.${version_base_orig:1}"
    else
        # If it does, just use the original
        version_base_dot="$version_base_orig"
    fi

    if ! [[ "$version_base_dot" =~ ^(3\.6|4\.0|4\.1|4\.2|4\.3|3\.16|3\.17|3\.18)$ ]]; then
        echo "Version must be one of 3.6, 4.1, 4.2, 4.3 for rocker images and 3.16, 3.17, 3.18 for bioconductor images."
        echo "For rocker images, the latest patch version is used."
        echo "For example, 3.6 refers to the latest 3.6.x version, which is 3.6.3."
        echo "For Bioconductor images, the latest version of R associated with the BioConductor release version is used."
        echo "For example, 3.18 uses R4.3.2 and not R4.3.1, even though both are compatible with BioConductor 3.18."
        exit 1
    fi

    version_base_dotless="${version_base_dot//./}"
}

# get base name without any suffix (no image version, no extension)
format_base_name_suffixless() {
    # first positional parameter: base image  type
    # second positional parameter: version_base_dotless
    base_image_type="$1"
    version_base_dotless="$2"
    if [[ "$base_image_type" == "r" ]]; then
        format_base_name_suffixless_r "$version_base_dotless"
    elif [[ "$base_image_type" == "bioc" ]]; then
        format_base_name_suffixless_bioc "$version_base_dotless"
    else
        echo "Error: must specify r or bioc as base image type (first positional parameter)."
        exit 1
    fi
}

format_base_name_suffixless_r() {
  # first positional parameter: version_base_dotless
  base_name_suffixless="r${1}x"
}

format_base_name_suffixless_bioc() {
  # first positional parameter: version_base_dotless
  base_name_suffixless="bioc${1}"
}

# get version_create
format_version_create() {
    # first positional parameter: version_create
    version_create="$1"
    release_tag="$2"
    base_name_suffixless="$3"
    if [ -z "$version_create" ]; then
        echo "No image version provided"
        echo "Using dev version"
        version_create="dev"
    fi
    if [[ "$version_create" == "dev" ]]; then
        format_version_create_dev "$release_tag" "$base_name_suffixless"
    else
        format_version_create_number "$version_create"
    fi
}

format_version_create_dev() {
    echo "Image version is valid"
    # first positional parameter: release_tag
    # second positional parameter: base_name_suffixless
    release_tag="$1"
    base_name_suffixless="$2"
    # format asset name for upload
    # Check for the existence of a numbered asset
    if gh release view "$release_tag" | \
        grep -q "${base_name_suffixless}-v[0-9]*.sif"; then
        # If a numbered asset exists, get the version number
        version_number=$(gh release view "$release_tag" | \
            grep -o "${base_name_suffixless}-v\([0-9]*\)\.sif" | \
            grep -o 'v\([0-9]*\)' | \
            grep -o '[0-9]*' | \
            sort -nr | \
            head -n 1)
        # Append "-dev" to the version number
        version_create="v${version_number}-dev"
        version_create="${version_create//./}"
    else
        # If no numbered asset exists, use the base asset name
        version_create="dev"
    fi
}

format_version_create_number() {
   # format the version
   # first positional parameter: version image created
    echo "Image version created is valid"
    version_create="$1"
    # check that it's a number, possibly with a v in the front:
    if ! [[ "$version_create" =~ ^v?[0-9]+$ ]]; then
        echo "Image version created must be 'dev' or follow the format 'v[integer]', e.g. 'v1'"
        exit 1
    fi
    # prepend a v if necessary
    if ! [[ "$version_create" =~ ^v ]]; then
      version_create="v$version_create"
    fi
    # remove any dots
    version_create="${version_create//./}"
}
