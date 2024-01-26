
# create release
# --------------------

release_create() {
    # first positional parameter: base image type
    # second positional parameter: version dot
    base_image_type="$1"
    version_base_dot="$2"
    release_tag_get "$base_image_type" "$version_base_dot"
    release_note_get "$base_image_type" "$version_base_dot"
    if ! gh release view "$release_tag" > /dev/null 2>&1; then
        # create the release
        if [[ "$base_image_type" == "r" && "$version_base_dot" == 4.3 ]] ; then
            # use pre-release flag for R 4.3
            gh release create \
               "$release_tag" \
                --title "$release_tag" \
                --notes "$release_note" \
                --prerelease
        else
            gh release create \
                "$release_tag" \
                --title "$release_tag" \
                --notes "$release_note"
        fi
    fi
}

# get tag
release_tag_get() {
    # first positional parameter: base image  type
    # second positional parameter: version dot
    base_image_type="$1"
    version_base_dot="$2"
    if [[ "$base_image_type" == "r" ]]; then
        release_tag_get_r "$version_base_dot"
    elif [[ "$base_image_type" == "bioc" ]]; then
        release_tag_get_bioc "$version_base_dot"
    else
        echo "Error: must specify r or bioc as base image type (first positional parameter)."
        exit 1
    fi
}


release_tag_get_r() {
    # first positional parameter: version_base_dot
    release_tag="r${1}.x"
}

release_tag_get_bioc() {
    # first positional parameter: version dot
    release_tag="bioc${1}"
}

# get note
release_note_get() {
    # first positional parameter: base_image_type
    # second positional parameter: version_base_dot
    base_image_type="$1"
    version_base_dot="$2"
    if [[ "$base_image_type" == "r" ]]; then
        release_note_get_r "$version_base_dot"
    elif [[ "$base_image_type" == "bioc" ]]; then
        release_note_get_bioc "$version_base_dot"
    else
        echo "Error: must specify r or bioc as base image type (first positional parameter)."
        exit 1
    fi
}

release_note_get_r() {
    # first positional parameter: version dot
    version_base_dot="$1"
    release_note="Apptainer images for R version ${version_base_dot}.x."
}
release_note_get_bioc() {
    # first positional parameter: version dot
    version_base_dot="$1"
    release_note="Apptainer images for BioConductor version ${version_base_dot}."
}

get_path_sif() {
    # first positional parameter: base_name_suffixless
    # second positional parameter: version_create
    base_name_suffixless="$1"
    version_create="$2"
    path_sif_orig="sif/${base_name_suffixless}.sif"
    if ! [[ -f "$path_sif_orig" ]]; then
        echo "Error: $path_sif_orig does not exist."
        exit 1
    fi
    path_sif_final="sif/${base_name_suffixless}-${version_create}.sif"
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
    # rm -rf "$path_sif_final"
}