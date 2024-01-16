# ApptainerBuild

This repository houses `.def` files to create Apptainer images.

To build an image saved to the `sif` folder, run the following command:

```
./build.sh <version>
```

where `<version>` is of the form `<major>.<minor>`. Available options are 3.6, 4.0, 4.1, 4.2 and 4.3.

To build an image and upload as a GitHub release, run the following command:

```
./build_and_release.sh <version>
```

where `<version>` is of the form `<major>.<minor>`. Available options are 3.6, 4.1, 4.2 and 4.3.