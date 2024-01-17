# ApptainerBuild

This repository houses `.def` files to create Apptainer images for `R` analyses, and makes the built images available for download.

## Downloading images

To download a previously-created image from a GitHub release, run the following:
```
wget https://github.com/MiguelRodo/ApptainerBuildR/releases/download/r<major>.<minor>.x/r<major><minor>x.sif
```

replacing <major> and <major> with the major and minor versions, respectively.

The following will download images with R versions 4.3.2, 4.2.3, 4.1.3, 4.0.5 and 3.6.3, respectively:

```
wget https://github.com/MiguelRodo/ApptainerBuildR/releases/download/r3.6.x/r36x.sif # 3.6.3
wget https://github.com/MiguelRodo/ApptainerBuildR/releases/download/r4.0.x/r40x.sif # 4.0.5
wget https://github.com/MiguelRodo/ApptainerBuildR/releases/download/r4.1.x/r41x.sif # 4.1.3
wget https://github.com/MiguelRodo/ApptainerBuildR/releases/download/r4.2.x/r42x.sif # 4.2.3
wget https://github.com/MiguelRodo/ApptainerBuildR/releases/download/r4.3.x/r43x.sif # 4.3.2
```

## Extending images

To extend an image:

- First download an image as described above.
- Then, create a new `.def` file that refers to the downloaded image and supplies extra install commands. Here is a template of such an image:

```
Bootstrap: localimage
From: <path/to/image>

%environment
    export APPTAINER_BUILD_DATE=date

%files
    # any files you want to copy into the container

%post
    # commands to install extra programs
    apt-get update
    apt-get install -y <program1> <program2>
```

Here is an example, where we've downloaded `r36x.sif` to a `sif` folder and install the `fortune` and `cowsay` packages into it:

```
Bootstrap: localimage
From: sif/r36x.sif

%environment
    export APPTAINER_BUILD_DATE=date

%files
    # any files you want to copy into the container

%post
    # commands to install extra programs
    apt-get update
    apt-get install -y fortune cowsay
```

- Build the image, running `apptainer build <path/to/new/image> <path/to/def/file>`, e.g. `apptainer build new_image.sif add_small_programs.def`.
  - The new image will be at`new_image.sif`.

## Rebuilding images

To rebuild the images in this repository, you can do the following:

- Open this repository in GitHub Codespaces.
- Run `./build.sh <version>` where `<version>` is of the form `<major>.<minor>`. Available options are 3.6, 4.0, 4.1, 4.2 and 4.3.

To rebuild all images, run the following:
```
version_vec=(36 40 41 42 43)
for version in "${version_vec[@]}"; do
  ./build.sh $version
done
```

## Building and releasing images

To build and release images, you can do the following:

- Fork this repository.
- Open the forked repository in GitHub Codespaces.
- Ensure that you have a GitHub personal access token named `GH_TOKEN` with the `repo` scope for this repository.
- Run `./build_and_release.sh <version>` where `<version>` is of the form `<major>.<minor>`. Available options are 3.6, 4.0, 4.1, 4.2 and 4.3.

To build and release all images, run the following:
```
version_vec=(36 40 41 42)
for version in "${version_vec[@]}"; do
  ./build_and_release.sh $version
done
```
