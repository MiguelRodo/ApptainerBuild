# ApptainerBuild

This repository houses `.def` files to create Singularity/Apptainer images.

To build an image, run the following command:

```
src/build/r<version>.sh
```

This saves the image to `sif/`.

The options of what images to create ar in `src/def`.

To upload the image as a GitHub release, run the following command:

```
src/release/r<version>.sh
``````