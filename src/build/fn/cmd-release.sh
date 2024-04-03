# create release
# --------------------
release_create() {
    # first positional parameter: base image type
    # second positional parameter: version dot
    base_image="$1"
    version_rbioc_dot="$2"
    echo "Base image type: $base_image"
    echo "Version rbioc dot: $version_rbioc_dot"

    release_tag_get "$base_image" "$version_rbioc_dot"
    release_note_get "$base_image" "$version_rbioc_dot"

    echo "Release tag: $release_tag"
    echo "Release note: $release_note"

    if ! gh release view "$release_tag" > /dev/null 2>&1; then
        echo "Release tag does not exist: $release_tag"
        # create the release
        echo "Creating pre-release for R 4.3"
        # use pre-release flag for R 4.3
        gh release create \
            "$release_tag" \
            --title "$release_tag" \
            --notes "$release_note" \
        echo "Pre-release created with tag: $release_tag"
    else
       echo "Release tag exists: $release_tag"
    fi
}

# get tag
release_tag_get() {
    # first positional parameter: base image  type
    # second positional parameter: version dot
    base_image="$1"
    version_rbioc_dot="$2"
    if [[ "$base_image" == "r" ]]; then
        release_tag_get_r "$version_rbioc_dot"
    elif [[ "$base_image" == "bioc" ]]; then
        release_tag_get_bioc "$version_rbioc_dot"
    else
        echo "Error: must specify r or bioc as base image (first positional parameter)."
        exit 1
    fi
}


release_tag_get_r() {
    # first positional parameter: version_rbioc_dot
    release_tag="r${1}.x"
}

release_tag_get_bioc() {
    # first positional parameter: version dot
    release_tag="bioc${1}"
}

# get note
release_note_get() {
    # first positional parameter: base_image
    # second positional parameter: version_rbioc_dot
    base_image="$1"
    version_rbioc_dot="$2"
    if [[ "$base_image" == "r" ]]; then
        release_note_get_r "$version_rbioc_dot"
    elif [[ "$base_image" == "bioc" ]]; then
        release_note_get_bioc "$version_rbioc_dot"
    else
        echo "Error: must specify r or bioc as base image type (first positional parameter)."
        exit 1
    fi
}

release_note_get_r() {
    # first positional parameter: version dot
    version_rbioc_dot="$1"
    release_note="Apptainer images for R version ${version_rbioc_dot}.x."
}
release_note_get_bioc() {
    # first positional parameter: version dot
    version_rbioc_dot="$1"
    release_note="Apptainer images for BioConductor version ${version_rbioc_dot}."
}

get_path_sif() {
    # first positional parameter: file_name_suffixless
    # second positional parameter: version_image
    file_name_suffixless="$1"
    version_image="$2"
    path_sif_orig="sif/${file_name_suffixless}.sif"
    echo "Path sif orig: $path_sif_orig"
    if ! [[ -f "$path_sif_orig" ]]; then
        echo "Error: $path_sif_orig does not exist."
        exit 1
    fi
    path_sif_final="sif/${file_name_suffixless}-${version_image}.sif"
    echo "Path sif final: $path_sif_final"
}

asset_delete() {
    # first positional parameter: release_tag
    # second positional parameter: path_sif_final
    release_tag="$1"
    path_sif_final="$2"
    basename_sif_final="$(basename "$path_sif_final")"
    # delete image if it already exists
    if gh release view "$release_tag" | grep -q "$basename_sif_final"; then
        echo "Deleting previous release asset $basename_sif_final"
        if ! gh release delete-asset "$release_tag" "$basename_sif_final" -y; then
            echo "Error: Failed to delete asset $basename_sif_final"
            exit 1
        fi
    fi
}

asset_upload() {
    # first positional parameter: release_tag
    # second positional parameter: path_sif_orig
    # third positional parameter: path_sif_final
    release_tag="$1"
    path_sif_orig="$2"
    path_sif_final="$3"
    basename_sif_final="$(basename "$path_sif_final")"
    mv "$path_sif_orig" "$path_sif_final"    
    # upload the .sif file to the release
    echo "Uploading $basename_sif_final to release $release_tag"
    gh release upload "$release_tag" "$path_sif_final"
    rm -rf "$path_sif_final"
}
