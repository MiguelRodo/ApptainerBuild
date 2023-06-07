# ApptainerBuild

This repository houses `.def` files to create Singularity/Apptainer images.

The definition files end in `.def`. Here are the definition files available at present:

- `r42.def`
  - Purpose:
    - Run the latest version of `R 4.2` together with publishing tools (e.g. pandoc) in `Ubuntu 20.04`.
    - Based on the `rocker/verse` Docker image, to which it (using VSCode's R community `devcontainer.json` file)
      - Adds the `radian` terminal 
      - Pre-installs several R packages useful for using VSC (`languageserver`, `jsonlite` and `httpgd`) or setting up projects (`renv` and `devtools`). 


To create the container image, run the following:

```bash
apptainer build <container_name>.sif <definition_name>.sif
```

For example:

```bash
apptainer build ar42.sif r42.def
```

This will create a container image named `ar42.sif` based on the definition file `r42.def`. To create a container using Singularity, replace `apptainer` with `singularity`. 

Built images are available in the Google Shared drive `StoreContainer`. 

Does it work fine on a
