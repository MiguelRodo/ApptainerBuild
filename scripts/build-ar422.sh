apptainer build -F r422-plain.sif r422.def \
  && apptainer build -F ar422.sif r422-add_dev.def \
  && cp ar422.sif $HOME/sif/ar422.sif \
  && cp ar422.sif "/mnt/h/Shared drives/StoreContainer/ar422.sif"

